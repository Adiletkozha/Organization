//
//  MenuViewController.m
//  M13InfiniteTabBar
//
//  Created by Brandon McQuilkin on 3/2/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"
#import "UIViewController+M13InfiniteTabBarExtension.h"
#import "PulsingRequiresAttentionView.h"
#import "RecentView.h"
#import "SettingsView.h"
#import "PeopleView.h"
#import "GroupsView.h"
#import "NavigationController.h"
#import "TasksView.h"
#import "MeetingsTableViewController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController
{
    NSString *display;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self someMethod];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)someMethod {
    [self performSegueWithIdentifier:@"GreaterThan5TabsSegue" sender:self];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
    
    if ([segue.identifier isEqualToString:@"LessThan5TabsSegue"]) {
        display = @"LessThan5Tabs";
        M13InfiniteTabBarController *vc = segue.destinationViewController;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"GreaterThan5TabsSegue"]) {
        display = @"GreaterThan5Tabs";
        M13InfiniteTabBarController *vc = segue.destinationViewController;
        vc.delegate = self;
        
        //Set the requires user attention background
     
        vc.requiresAttentionBackgroundView = [[PulsingRequiresAttentionView alloc] init];
        //A view controller requires user attention
        [vc viewControllerAtIndex:3 requiresUserAttentionWithImportanceLevel:1];
    } else if ([segue.identifier isEqualToString:@"InfiniteDisabledSegue"]) {
        M13InfiniteTabBarController *vc = segue.destinationViewController;
        display = @"InfiniteDisabledSegue";
        vc.delegate = self;
        vc.enableInfiniteScrolling = NO;
        //Set the requires user attention background
        vc.requiresAttentionBackgroundView = [[PulsingRequiresAttentionView alloc] init];
        //A view controller requires user attention
        [vc viewControllerAtIndex:6 requiresUserAttentionWithImportanceLevel:1];
    } else if ([segue.identifier isEqualToString:@"PinnedToTopSegue"]) {
        display = @"GreaterThan5Tabs";
        M13InfiniteTabBarController *vc = segue.destinationViewController;
        vc.tabBarPosition = M13InfiniteTabBarPositionTop;
        vc.delegate = self;
        //Set the requires user attention background

        vc.requiresAttentionBackgroundView = [[PulsingRequiresAttentionView alloc] init];
        //A view controller requires user attention
        [vc viewControllerAtIndex:6 requiresUserAttentionWithImportanceLevel:1];
    }
}

#pragma mark - M13InfiniteTabBarDelegate

- (NSArray *)infiniteTabBarControllerRequestingViewControllersToDisplay:(M13InfiniteTabBarController *)tabBarController
{
    //Load the view controllers from the storyboard and add them to the array.
 
    RecentView *vcc = [[RecentView alloc] init];
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:vcc];
    nav1.delegate=tabBarController;
    
    GroupsView *groupView=[[GroupsView alloc]init];
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:groupView];
     nav2.delegate=tabBarController;
    PeopleView *peopleView=[[PeopleView alloc]init];
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:peopleView];
     nav3.delegate=tabBarController;
    SettingsView *settingsView=[[SettingsView alloc]init];
    UINavigationController *nav4=[[UINavigationController alloc] initWithRootViewController:settingsView];
     nav4.delegate=tabBarController;
    TasksView *tasksView=[[TasksView alloc]init];
    UINavigationController *nav5=[[UINavigationController alloc]initWithRootViewController:tasksView];
    //nav5.delegate=tabBarController;
    MeetingsTableViewController *meetingsView=[[MeetingsTableViewController alloc]init];
    UINavigationController *nav6=[[UINavigationController alloc]initWithRootViewController:meetingsView];
    

    //------- setSelectedIndex: test --------
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setTitle:@"Goto World Tab" forState:UIControlStateNormal];
//    button.frame = CGRectMake(20, ([UIScreen mainScreen].bounds.size.height / 2.0) - 15, [UIScreen mainScreen].bounds.size.width - 40, 30);
//    button.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
//    [button addTarget:vc1 action:@selector(gotoWorld:) forControlEvents:UIControlEventTouchUpInside];
//    [vc1.view addSubview:button];
//    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button1 setTitle:@"Goto Trash Tab" forState:UIControlStateNormal];
//    button1.frame = CGRectMake(20, button.frame.origin.y + button.frame.size.height, [UIScreen mainScreen].bounds.size.width - 40, 30);
//    button1.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
//    [button1 addTarget:vc1 action:@selector(gotoTrash:) forControlEvents:UIControlEventTouchUpInside];
//    [vc1.view addSubview:button1];
//    
  
    vcc.infiniteTabBarController=tabBarController;
    
 
    
    
    //------- end test ----------------------
    
    //You probably want to set this on the UIViewController initalization, from within the UIViewController subclass. I'm just doing it here since each tab inherits from the same subclass.
  
      [nav1 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Недавние" selectedIconMask:[UIImage imageNamed:@"tab1Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab1Line.png"]]];
      [nav2 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Группы" selectedIconMask:[UIImage imageNamed:@"tab2Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab2Line.png"]]];
      [nav3 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Сотрудники" selectedIconMask:[UIImage imageNamed:@"tab3Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab3Line.png"]]];
      [nav4 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Настройки" selectedIconMask:[UIImage imageNamed:@"tab4Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab3Line.png"]]];
    
      [nav5 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Задачи" selectedIconMask:[UIImage imageNamed:@"tab5Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab5Line.png"]]];
    
      [nav6 setInfiniteTabBarItem:[[M13InfiniteTabBarItem alloc] initWithTitle:@"Собрания" selectedIconMask:[UIImage imageNamed:@"tab6Solid.png"] unselectedIconMask:[UIImage imageNamed:@"tab6Line.png"]]];
    

    //Done
    if ([display isEqualToString:@"LessThan5Tabs"]) {
        return @[nav1, nav2, nav3];
    } else if ([display isEqualToString:@"GreaterThan5Tabs"] || [display isEqualToString:@"InfiniteDisabledSegue"]) {
        return @[nav1, nav2, nav3, nav4, nav5, nav6];
    }
    return nil;
}

//Delegate Protocol
- (BOOL)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController shouldSelectViewContoller:(UIViewController *)viewController
{
    if ([viewController.title isEqualToString:@"Search"]) { //Prevent selection of first view controller
        return NO;
    } else {
        return YES;
    }
}

- (void)infiniteTabBarController:(M13InfiniteTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //Do nothing
    
}

@end
