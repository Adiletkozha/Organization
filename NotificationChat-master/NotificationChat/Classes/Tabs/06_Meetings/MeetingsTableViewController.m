//
//  MeetingsTableViewController.m
//  app
//
//  Created by abc soft on 10.06.15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "PFUser+Util.h"

#import "AppConstant.h"
#import "common.h"
#import "group.h"
#import "recent.h"
#import "NavigationController.h"
#import "CreateMeetingsView.h"
#import "MeetingsTableViewController.h"
#import "MeetingsSettingsView.h"

@interface MeetingsTableViewController ()
{
    NSMutableArray *meetings;
}

@end

@implementation MeetingsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_groups"]];
        self.tabBarItem.title = @"Meetings";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Meetings";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionNew)];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMeetings) forControlEvents:UIControlEventValueChanged];
    
    meetings = [[NSMutableArray alloc] init];
}

- (void)actionCleanup
{
    [meetings removeAllObjects];
    [self.tableView reloadData];
//    [self updateTabCounter];
}

//- (void)updateTabCounter
//{
//    int total = 0;
//    for (PFObject *recent in meetings)
//    {
//        total += [recent[PF_RECENT_COUNTER] intValue];
//    }
//    UITabBarItem *item = self.tabBarController.tabBar.items[0];
//    item.badgeValue = (total == 0) ? nil : [NSString stringWithFormat:@"%d", total];
//}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PFUser currentUser] != nil)
    {
        [self loadMeetings];
    }
    else LoginUser(self);
}

- (void)actionNew
{
    CreateMeetingsView *createGroupView = [[CreateMeetingsView alloc] init];
    NavigationController *navController = [[NavigationController alloc] initWithRootViewController:createGroupView];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)loadMeetings
{
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_MEETINGS_CLASS_NAME];
//    [query whereKey:PF_MEETINGS_WORKERS equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [meetings removeAllObjects];
             [meetings addObjectsFromArray:objects];
             [self.tableView reloadData];
         }
         else [ProgressHUD showError:@"Network error."];
         [self.refreshControl endRefreshing];
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [meetings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    PFObject *group = meetings[indexPath.row];
    cell.textLabel.text = group[PF_MEETINGS_MSG_MEETING];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d workers", (int) [group[PF_MEETINGS_WORKERS] count]];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *group = meetings[indexPath.row];
    [meetings removeObject:group];
    
    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = group[PF_MEETINGS_USER];
    
    if ([user1 isEqualTo:user2]) RemoveGroupItem(group); else RemoveGroupMember(group, user1);
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MeetingsSettingsView *groupSettingsView = [[MeetingsSettingsView alloc] initWith:meetings[indexPath.row]];
    groupSettingsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupSettingsView animated:YES];
}


@end
