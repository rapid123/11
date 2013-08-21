//
//  NotificationsViewController.h
//  Red Beacon
//
//  Created by sudeep on 30/09/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JobResponseDetails.h"
#import "RBJobBidAndProviderDetailHandler.h"
#import "RBLoadingOverlay.h"

@interface NotificationsViewController : UIViewController {
    
    NSMutableArray *tableContent;
    BOOL isConversation;
    
    JobResponseDetails *jobDetail;
    NSDictionary *contentToDisplay;
    RBJobBidAndProviderDetailHandler *jobRequestResponse;
}

@property(nonatomic, retain) JobResponseDetails *jobDetail;
@property(nonatomic, retain) IBOutlet UITableView *notificationTable;
@property(nonatomic, retain) IBOutlet UIImageView *defaultImage;

@property(nonatomic, retain) IBOutlet UIImageView *noConversationsToDisplayImg;

@property(nonatomic, retain) NSMutableArray *tableContent;
@property(nonatomic) BOOL isConversation;
@property(nonatomic, retain) RBJobBidAndProviderDetailHandler *jobRequestResponse;
@property (nonatomic, retain) RBLoadingOverlay * overlay;


-(void)refreshTheConversationContents;
-(void)parsingCompleted;

@end
