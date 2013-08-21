//
//  DetailQuotesViewController.h
//  Red Beacon
//
//  Created by sudeep on 04/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobBids.h"
#import "JobResponseDetails.h"
#import "RBJobBidAndProviderDetailHandler.h"
#import "RBLoadingOverlay.h"

@interface DetailQuotesViewController : UIViewController {
    
    JobBids *jobBid;
    JobResponseDetails *jobDetail;
    
    int selectedBidIndex;
    
    UIButton *backwordBtn;
    UIButton *forwordBtn;
    
    RBJobBidAndProviderDetailHandler *jobRequestResponse;
    RBLoadingOverlay *overlay;
    
    int selectedIndex;

}


@property(nonatomic,retain) JobBids *jobBid;
@property(nonatomic, retain) JobResponseDetails *jobDetail;

@property(nonatomic) int selectedBidIndex;
@property(nonatomic, retain) RBLoadingOverlay *overlay;

@property(nonatomic, retain) IBOutlet UIView *reviewView;
@property(nonatomic, retain) IBOutlet UITableView *detailQuoteTable;
@property(nonatomic, retain) IBOutlet UIImageView *viewBackground;
@property(nonatomic, retain) IBOutlet UIImageView *whiteBackground;
@property(nonatomic, retain) IBOutlet UIView *quoteImageView;
@property(nonatomic, retain) IBOutlet UIImageView *quoteImage;
@property(nonatomic, retain) IBOutlet UILabel *quoteServiceName;

-(IBAction)bidDetailCallButtonClicked:(id)sender ;
-(IBAction)profileImageClick:(id)sender;

@end
