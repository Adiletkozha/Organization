//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "camera.h"
#import "common.h"
#import "image.h"
#import "push.h"

#import "SettingsView.h"
#import "BlockedView.h"
#import "PrivacyView.h"
#import "TermsView.h"
#import "NavigationController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"News";
    
    
   UIView *menu = [[UIView alloc] initWithFrame:CGRectMake(10,10,50,150)];
    [menu setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:menu];
    [self.view setBackgroundColor:[UIColor whiteColor]];
     PFUser *user=[PFUser currentUser];
    
    PFImageView* imageUser =[[PFImageView alloc]initWithFrame:CGRectMake(90, 20, 200, 200)];
    imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
    imageUser.layer.masksToBounds = YES;
    [imageUser setFile:user[PF_USER_PICTURE]];
    [imageUser loadInBackground];
    
    [self.view addSubview:imageUser];
    
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 300, 20)];
    yourLabel.text = user[PF_USER_FULLNAME];
    [yourLabel setTextColor:[UIColor blackColor]];
    [yourLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [menu addSubview:yourLabel];
    
    UILabel *yourLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 290, 300, 20)];
    yourLabel1.text = user[PF_USER_EMAIL];
    [yourLabel1 setTextColor:[UIColor blackColor]];
    [yourLabel1 setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
    [menu addSubview:yourLabel1];
    
    
  
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_FULLNAME equalTo:@"Baglan Shanasurov"];
    
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
         if(!error) {
            PFFile *file = [object objectForKey:@"picture"];
            // file has not been downloaded yet, we just have a handle on this file
            
            // Tell the PFImageView about your file
            imageUser.file = file;
            
            // Now tell PFImageView to download the file asynchronously
            [imageUser
             loadInBackground];
        }
    }];
    
    
    
    
    
    
    
    // Change button color

    // Set the gesture
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
