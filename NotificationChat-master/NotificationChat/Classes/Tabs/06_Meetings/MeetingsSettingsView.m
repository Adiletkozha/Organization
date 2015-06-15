#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "PFUser+Util.h"

#import "AppConstant.h"
#import "recent.h"

#import "MeetingsSettingsView.h"
#import "ChatView.h"

@interface MeetingsSettingsView()
{
	PFObject *group;
	NSMutableArray *users;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *cellName;
@property (strong, nonatomic) IBOutlet UILabel *labelName;

@end

@implementation MeetingsSettingsView

@synthesize cellName;
@synthesize labelName;

- (id)initWith:(PFObject *)group_
{
	self = [super init];
	group = group_;
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Meetings Settings";

    users = [[NSMutableArray alloc] init];
	
    [self loadGroup];
	[self loadUsers];
}

- (void)loadGroup
{
	labelName.text = group[PF_MEETINGS_MSG_MEETING];
}

- (void)loadUsers
{
	PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
	[query whereKey:PF_USER_OBJECTID containedIn:group[PF_MEETINGS_WORKERS]];
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

- (void)actionChat
{
	NSString *groupId = group.objectId;
	CreateRecentItem([PFUser currentUser], groupId, group[PF_MEETINGS_WORKERS], group[PF_MEETINGS_MSG_MEETING]);
	ChatView *chatView = [[ChatView alloc] initWith:groupId];
	[self.navigationController pushViewController:chatView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) return 1;
	if (section == 1) return [users count];
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 1) return @"Meetings List";
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ((indexPath.section == 0) && (indexPath.row == 0)) return cellName;
	if (indexPath.section == 1)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
		if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

		PFUser *user = users[indexPath.row];
		cell.textLabel.text = user[PF_USER_FULLNAME];

		return cell;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ((indexPath.section == 0) && (indexPath.row == 0)) [self actionChat];
}

@end
