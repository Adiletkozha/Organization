//
//  AboutMeetingViewController.h
//  app
//
//  Created by Suleymen Adilet on 6/16/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "PFUser+Util.h"

#import "AppConstant.h"
#import "common.h"

@interface AboutTaskViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UITextView *desctiptionText;
@property (weak, nonatomic) IBOutlet UILabel *deadlineText;
@property (weak,nonatomic)PFObject *task;
- (IBAction)doneButton:(id)sender;
@end
