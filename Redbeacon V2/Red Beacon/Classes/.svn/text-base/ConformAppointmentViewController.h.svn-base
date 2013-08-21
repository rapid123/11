//
//  ConformAppointmentViewController.h
//  Red Beacon
//
//  Created by Nithin George on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobBids.h"
#import "RBJobBidAndProviderDetailHandler.h"
#import "RBLoadingOverlay.h"
#import "RBLoginHandler.h"
#import "UserInformation.h"
@interface ConformAppointmentViewController : UIViewController {
    
    NSString *zipCode;
    NSString *jobID;
    int icontentsize;
	BOOL bcontentflag;
    
    JobBids *jobBid;
    RBBaseHttpHandler * loginHandler;
    RBJobBidAndProviderDetailHandler *jobRequestResponse;
    RBLoadingOverlay * overlay;
}

@property(nonatomic, retain) JobBids *jobBid;
@property(nonatomic, retain) RBJobBidAndProviderDetailHandler *jobRequestResponse;
@property(nonatomic,retain) NSString *zipCode;
@property(nonatomic,retain) NSString *jobID;
@property(nonatomic,retain) IBOutlet UIScrollView *conformAppointmentScrollView;

@property(nonatomic,retain) IBOutlet UILabel *scheduleQuoteLabel;
@property(nonatomic,retain) IBOutlet UILabel *scheduleRateLabel;
@property(nonatomic,retain) IBOutlet UILabel *scheduleTimeLabel;

@property(nonatomic,retain) IBOutlet UITextField *txtFirstname;
@property(nonatomic,retain) IBOutlet UITextField *txtLastname;
@property(nonatomic,retain) IBOutlet UITextField *txtPhoneNumber;
@property(nonatomic,retain) IBOutlet UITextField *txtStreetAddress;
@property(nonatomic,retain) IBOutlet UITextField *txtZipAddress;

@property (nonatomic, retain) RBLoadingOverlay * overlay;

@end
