
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "PFUser+Util.h"

#import "AppConstant.h"
#import "common.h"
#import "group.h"
#import "recent.h"

#import "TasksView.h"
#import "CreateTaskView.h"
#import "TaskSettingsView.h"
#import "NavigationController.h"



@interface TasksView()
{
	NSMutableArray *groups;
}
@end

@implementation TasksView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		[self.tabBarItem setImage:[UIImage imageNamed:@"tab_groups"]];
		self.tabBarItem.title = @"Tasks";
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Tasks";
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
																						   action:@selector(actionNew)];
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(loadGroups) forControlEvents:UIControlEventValueChanged];
	
    groups = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if ([PFUser currentUser] != nil)
	{
		[self loadGroups];
	}
	else LoginUser(self);
}

- (void)loadGroups
{
	PFUser *user = [PFUser currentUser];

	PFQuery *query = [PFQuery queryWithClassName:PF_TASK_CLASS_NAME];
	[query whereKey:PF_TASK_WORKERS equalTo:user.objectId];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			[groups removeAllObjects];
			[groups addObjectsFromArray:objects];
			[self.tableView reloadData];
		}
		else [ProgressHUD showError:@"Network error."];
		[self.refreshControl endRefreshing];
	}];
}

- (void)actionNew
{
	CreateTaskView *createGroupView = [[CreateTaskView alloc] init];
	NavigationController *navController = [[NavigationController alloc] initWithRootViewController:createGroupView];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)actionCleanup
{
	[groups removeAllObjects];
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

	PFObject *group = groups[indexPath.row];
	cell.textLabel.text = group[PF_TASK_NAME];

	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d workers", (int) [group[PF_TASK_WORKERS] count]];
	cell.detailTextLabel.textColor = [UIColor lightGrayColor];

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	PFObject *group = groups[indexPath.row];
	[groups removeObject:group];

    PFUser *user1 = [PFUser currentUser];
	PFUser *user2 = group[PF_TASK_USER];
	
    if ([user1 isEqualTo:user2]) RemoveGroupItem(group); else RemoveGroupMember(group, user1);
	
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    TaskSettingsView *groupSettingsView = [[TaskSettingsView alloc] initWith:groups[indexPath.row]];
	groupSettingsView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:groupSettingsView animated:YES];
}

@end
