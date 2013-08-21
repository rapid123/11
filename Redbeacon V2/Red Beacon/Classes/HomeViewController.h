//
//  HomeViewController.h
//  Red Beacon
//
//  Created by sudeep on 30/09/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Red_BeaconAppDelegate.h"
#import "RBJobBidAndProviderDetailHandler.h"
#import "JobResponseDetails.h"
#import "RBLoadingOverlay.h"
#import "JobBids.h"

@class Red_BeaconAppDelegate;

@interface HomeViewController : UIViewController {
    
    UIBarButtonItem *barLoginButton;
    UIBarButtonItem *spacebuttonItem;
    
    //used for storing the jobrequest response data 
    NSMutableArray * tableData;
        
    RBJobBidAndProviderDetailHandler *jobRequestResponse;
    JobResponseDetails               *jobResponse;
    
    //For selected job details
    JobResponseDetails *selectedJobDetails;
    
    NSIndexPath *lastSelectedIndexpath;
    JobBids *jobBids;
    
    NSMutableArray *reviewsJobsArray ;
    BOOL settingsViewed;
    
    NSString *lastUserLogged;
}

@property(nonatomic, retain) UIBarButtonItem *barLoginButton;
@property(nonatomic, retain) UIBarButtonItem *spacebuttonItem;

@property(nonatomic, retain) IBOutlet UIImageView *defaultImage;
@property(nonatomic, retain) IBOutlet UITableView *jobResponseTable;

@property (nonatomic, retain) RBLoadingOverlay * overlay;
@property(nonatomic, retain) NSIndexPath *lastSelectedIndexpath; 

- (NSMutableArray *)pareseBidDetails:(NSArray *)jobDetails;

@end
