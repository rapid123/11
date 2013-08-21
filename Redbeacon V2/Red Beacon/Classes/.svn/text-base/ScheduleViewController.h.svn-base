//
//  ScheduleViewController.h
//  Red Beacon
//
//  Created by Nithin George on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RBSavedStateController.h"
#import "RBJobSchedule.h"


@interface ScheduleViewController : UIViewController
{
    
    int oldRowSelectValue;
    
    UILabel *flexbleTitle;
    UILabel *flexSubTitle;
    
    UILabel *urgentTitle;
    UILabel *urgentSubTitle;
    
    UILabel *pickerTitle;
    UILabel *pickerSubTitle;
	NSIndexPath *lastIndex;
	UIDatePicker *datePickr;
    UITableView * scheduleTableView;
    RBJobSchedule * schedule;
    
    NSString * scheduleType;
    NSString * scheduleDate;
    
}

@property (nonatomic, retain) IBOutlet UITableView * scheduleTableView;
@property (nonatomic, retain) RBJobSchedule * schedule;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePickr;
@property (nonatomic, retain) NSString * scheduleType;
@property (nonatomic, retain) NSString * scheduleDate;
@property (nonatomic, retain) NSIndexPath *lastIndex;

-(UILabel *)setTitleLabes;

-(IBAction)doneButtonClicked:(id)sender;
-(IBAction)cancelButtonClicked:(id)sender;
- (IBAction)didPickerValueChanged:(id)sender;

@end
