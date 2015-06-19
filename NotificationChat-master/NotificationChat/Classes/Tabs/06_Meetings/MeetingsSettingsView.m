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
@property (strong, nonatomic) IBOutlet UITableViewCell *creatorName;
@property (strong, nonatomic) IBOutlet UITableViewCell *deadlineCell;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MeetingsSettingsView

@synthesize cellName;
@synthesize labelName;
@synthesize deadlineCell;
@synthesize creatorName;
@synthesize creatorLabel;
@synthesize timeLabel;

- (id)initWith:(PFObject *)group_
{
	self = [super init];
	group = group_;
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"о Собрании";

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
            PFQuery *query2 = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
            [query2 whereKey:@"user" equalTo:group[PF_MEETINGS_USER]];
            [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects2, NSError *error){
                PFObject *obj=objects2.firstObject;
                NSLog(@"%lu",(unsigned long)objects.count);
                self.creatorLabel.text=obj[PF_USER_FULLNAME];
                NSLog(@"%@",obj[PF_USER_FULLNAME]);
            }];
            }
            
		
		else [ProgressHUD showError:@"Network error."];
	}];
}








- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) return 1;
    if (section == 1) return 1;
    if (section == 2) return 1;
	if (section == 3) return [users count];
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 3) return @"Сотрудники";
    if (section == 2) return @"Время";
    if (section == 1) return @"Собиратель";
    if (section == 0) return @"Тема собрания";
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ((indexPath.section == 0) && (indexPath.row == 0)) return cellName;
    
    if ((indexPath.section == 1) && (indexPath.row == 0)) return creatorName;
    if ((indexPath.section == 2) && (indexPath.row == 0)) return deadlineCell;
    
	if (indexPath.section == 3)
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

   // if ((indexPath.section == 0) && (indexPath.row == 0)) [self actionChat];
}

@end
