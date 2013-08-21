//
//  ScheduleDateAndTimeController.h
//  Red Beacon
//
//  Created by sudeep on 12/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Red_BeaconAppDelegate.h"
#import "RBLoadingOverlay.h"
#import "RBJobBidAndProviderDetailHandler.h"
#import "JobResponseDetails.h"


@interface ScheduleDateAndTimeController : UIViewController {
    
    UIDatePicker *datePickr;
    JobResponseDetails *jobDetail;
    RBJobBidAndProviderDetailHandler *jobSetAppointmentTimeResponse;
    BOOL userFlow; //If YES its from locking View If NO its from TabBar view(from action sheet)
}

@property (nonatomic) BOOL userFlow;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePickr;
@property (nonatomic, retain) RBLoadingOverlay * overlay;

@property (nonatomic, retain) NSString * occupationName;

- (IBAction)didPickerValueChanged:(id)sender;
@end
