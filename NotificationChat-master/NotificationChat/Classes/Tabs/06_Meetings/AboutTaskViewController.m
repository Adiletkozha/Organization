//
//  AboutMeetingViewController.m
//  app
//
//  Created by Suleymen Adilet on 6/16/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "AboutTaskViewController.h"

@interface AboutTaskViewController (){

}
@end

@implementation AboutTaskViewController





- (void)viewDidLoad {
    [super viewDidLoad];

   // self.taskName.text=taskId;
  //  NSLog(@"%@",taskId[PF_TASK_NAME]);
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.taskName.text=self.task[PF_TASK_NAME];
    self.desctiptionText.text=self.task[PF_TASK_DESCRIPTION];
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString *formatedDate = [dateFormatter stringFromDate:self.task[@"deadline"]];
    
    self.deadlineText.text =formatedDate;
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneButton:(id)sender {
    
}

@end
