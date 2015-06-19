
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "PFUser+Util.h"

#import "AppConstant.h"
#import "recent.h"

#import "TaskSettingsView.h"
#import "ChatView.h"
#import "AboutTaskViewController.h"

@interface TaskSettingsView()
{
	PFObject *group;
	NSMutableArray *users;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *cellName;

@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UITableViewCell *creatorName;

@end

@implementation TaskSettingsView

@synthesize cellName;
@synthesize labelName;
@synthesize creatorName;
- (id)initWith:(PFObject *)group_
{
	self = [super init];
	group = group_;
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Task Settings";

    users = [[NSMutableArray alloc] init];
	
    [self loadGroup];
	[self loadUsers];
}

- (void)loadGroup
{
	labelName.text = group[PF_TASK_NAME];
}

- (void)loadUsers
{
	PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
	[query whereKey:PF_USER_OBJECTID containedIn:group[PF_TASK_WORKERS]];
	[query orderByAscending:PF_USER_FULLNAME];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			[users removeAllObjects];
			[users addObjectsFromArray:objects];
			[self.tableView reloadData];
		}
		else [ProgressHUD showError:@"Network error."];
	}];
}

- (void)actionChat:(PFObject *)taskID
{
//	NSString *groupId = group.objectId;
//
//    CreateRecentItem([PFUser currentUser], groupId, group[PF_TASK_WORKERS], group[PF_TASK_NAME]);
//	
//    ChatView *chatView = [[ChatView alloc] initWith:groupId];
//	[self.navigationController pushViewController:chatView animated:YES];

    
    
    NSString * storyboardName = @"MainStoryboard";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    AboutTaskViewController * vc = (AboutTaskViewController *)[storyboard instantiateViewControllerWithIdentifier:@"aboutview"];
    
    vc.task=group;
    vc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) return 1;
    if (section == 1) return 1;
	if (section == 2) return [users count];
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Подробнее";
    if (section == 1) return @"Создатель";
	if (section == 2) return @"Сотрудники";
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ((indexPath.section == 0) && (indexPath.row == 0)) return cellName;

    if ((indexPath.section == 1) && (indexPath.row == 0)) return creatorName;
    
    
    if (indexPath.section == 2)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
		if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

		PFUser *user = users[indexPath.row];
		cell.textLabel.text = user[PF_USER_FULLNAME];
       // NSLog(@"%@",user[PF_USER_FULLNAME]);

		return cell;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        NSLog(@"%@",group[PF_TASK_OBJECTID]);
        [self actionChat:group];
        
    }
}

@end
