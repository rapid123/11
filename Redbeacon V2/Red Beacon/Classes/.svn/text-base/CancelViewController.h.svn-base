//
//  CancelViewController.h
//  Red Beacon
//
//  Created by Nithin George on 17/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBJobBidAndProviderDetailHandler.h"
#import "JobResponseDetails.h"
#import "Red_BeaconAppDelegate.h"
#import "RBLoadingOverlay.h"

@interface CancelViewController : UIViewController {
    
    NSIndexPath *lastIndex;
    NSMutableArray *contentData;
        
    UIBarButtonItem *barCancelButton;
    RBJobBidAndProviderDetailHandler *jobCancelRequestResponse;
    
    JobResponseDetails *jobDetail;
    
    id parentView;
}

@property(nonatomic,retain) IBOutlet UITableView *contentTable;

@property(nonatomic) BOOL flowStatus;//If YES from detailed view, If NO from confirmed appointent view

@property(nonatomic, retain) JobResponseDetails *jobDetail;
@property (nonatomic, retain) RBLoadingOverlay * overlay;
@property (nonatomic, retain) NSIndexPath *lastIndex;
@property (nonatomic, retain) id parentView;

@end
