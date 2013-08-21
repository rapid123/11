//
//  ScheduleAppointmentViewController.h
//  Red Beacon
//
//  Created by Nithin George on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobResponseDetails.h"
#import "RBJobBidAndProviderDetailHandler.h"
#import "JobBids.h"
#import "Red_BeaconAppDelegate.h"
#import "RBLoadingOverlay.h"
#import "ConversationViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface ScheduleAppointmentViewController : UIViewController <UIActionSheetDelegate,EKEventEditViewDelegate>{
    
    id delegate;
    JobResponseDetails *jobDetail;
    JobBids *bidDetails;
    UIViewController *viewController;
    RBJobBidAndProviderDetailHandler *cancelORAcceptAppointmentResponse;
    ConversationViewController *conversationViewController;
    NSArray *address;
    NSString *flatRate;
    
    EKEventViewController *detailViewController;
	EKEventStore *eventStore;
	EKCalendar *defaultCalendar;
    
}
@property (nonatomic, retain) JobResponseDetails *jobDetail;
@property (nonatomic, retain) IBOutlet UIView *unScheduledContainer;

@property (nonatomic, retain) IBOutlet UIView *buttonUnSheduledContainer;
@property (nonatomic, retain) IBOutlet UIView *buttonScheduledContainer;
@property (nonatomic, retain) IBOutlet UIView *scheduleDetailContainer;
@property (nonatomic, retain) IBOutlet UIView *unScheduleDetailContainer;
@property (nonatomic, retain) IBOutlet UIView *callButtonContainer;



@property (nonatomic, retain) IBOutlet UIImageView *UnScheduleBackgroundImageview;
@property (nonatomic, retain) IBOutlet UIImageView *ScheduleBackgroundImageview;
@property (nonatomic, retain) IBOutlet UIImageView *ConfirmAppointmentBackgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView *UnConfirmAppointmentBackgroundImage;

@property (nonatomic, retain) IBOutlet UILabel *txtUnScheduleTittle;
@property (nonatomic, retain) IBOutlet UILabel *txtScheduleTittle;
 
@property (nonatomic, retain) IBOutlet UILabel *txtUnScheduleProviderName;
@property (nonatomic, retain) IBOutlet UILabel *txtUnScheduleFlatRate;
@property (nonatomic, retain) IBOutlet UILabel *txtUnScheduleMainAddress;
@property (nonatomic, retain) IBOutlet UILabel *txtUnScheduleSubAdress;
@property (nonatomic, retain) IBOutlet UILabel *txtUnScheduleZipcode;
@property (nonatomic, retain) IBOutlet UILabel *txtUnScheduleDateAndTime;

@property (nonatomic, retain) IBOutlet UILabel *txtScheduleDate;
@property (nonatomic, retain) IBOutlet UILabel *txtScheduleProviderName;
@property (nonatomic, retain) IBOutlet UILabel *txtScheduleFlatRate;
@property (nonatomic, retain) IBOutlet UILabel *txtScheduleMainAddress;
@property (nonatomic, retain) IBOutlet UILabel *txtScheduleSubAdress;
@property (nonatomic, retain) IBOutlet UILabel *txtScheduleZipcode;

@property (nonatomic, retain) IBOutlet UIButton *UnConformedAppointmentButton;

@property (nonatomic, retain) IBOutlet UIButton *UnConformedCallButton;
@property (nonatomic, retain) IBOutlet UIButton *ConformedCallButton;

@property (nonatomic, retain) RBLoadingOverlay * overlay;
@property (nonatomic, retain) id delegate;


@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) EKEventViewController *detailViewController;

-(IBAction)conformAppointmentButtonClicked:(id)sender ;
-(IBAction)conversationButtonClicked:(id)sender ;
-(IBAction)callButtonClicked:(id)sender ;
//-(IBAction)calenderButtonClicked:(id)sender ;
-(IBAction)serviceProviderCallButtonClicked:(id)sender ;
@end
