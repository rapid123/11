//
//  QuotesViewController.h
//  Red Beacon
//
//  Created by sudeep on 03/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobResponseDetails.h"

@interface QuotesViewController : UIViewController {
    
    NSArray *tableContent;
    JobResponseDetails *jobDetail;
    NSIndexPath *indexPathToJump ;

}
@property(nonatomic, retain) JobResponseDetails *jobDetail;
@property(nonatomic, retain) IBOutlet UITableView *quotesTable;
@property(nonatomic, retain) IBOutlet UIImageView *noQuotesToDisplayImg;
@property(nonatomic, retain) IBOutlet UIImageView *notServicedImg;
@property(nonatomic, retain) IBOutlet UIButton *giveUsFeedbackButton;
@property(nonatomic, retain) NSArray *tableContent;
@property (nonatomic, retain)  NSIndexPath *indexPathToJump;


-(void)selectTableIndex:(int)index;
-(IBAction)sendUsFeedbackClick:(id)sender;
@end
