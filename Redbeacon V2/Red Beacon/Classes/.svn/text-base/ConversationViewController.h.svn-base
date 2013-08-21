//
//  ConversationViewController.h
//  Red Beacon
//
//  Created by Nithin George on 13/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobBids.h"
#import "JobResponseDetails.h"
#import "Red_BeaconAppDelegate.h"
#import "RBLoadingOverlay.h"
#import "RBJobBidAndProviderDetailHandler.h"

@interface ConversationViewController : UIViewController<UITextFieldDelegate> {
    
    NSMutableArray *conversationContent;
    int icontentsize;
    BOOL position;
	BOOL bcontentflag;
    
    //UITextField *chatTxt;
    JobBids *jobBid;
    NSArray *jobQAS;
    
    RBJobBidAndProviderDetailHandler *conversationTextResponse;
    RBJobBidAndProviderDetailHandler *jobRequestResponse;
    
    BOOL isFromScheduleView;
}
@property (nonatomic) BOOL isFromScheduleView;

@property(nonatomic,retain) NSMutableArray *conversationContent;
@property(nonatomic,retain) IBOutlet UIScrollView *conversationScrollView;
@property(nonatomic,retain) IBOutlet UITableView *conversationTable;
@property(nonatomic,retain) IBOutlet UITextField *txtConversation;
@property(nonatomic,retain) IBOutlet UIButton *sendButton;
@property(nonatomic,retain) JobBids *jobBid;
@property(nonatomic,retain) NSArray *jobQAS;
@property (nonatomic, retain) RBLoadingOverlay * overlay;
@property(nonatomic, retain) RBJobBidAndProviderDetailHandler *jobRequestResponse;

- (IBAction)callButtonClicked:(id)sender;
- (IBAction)viewQuatesButtonClicked:(id)sender;
- (IBAction)conversationSendButtonClicked:(id)sender;
- (void)setQASChat:(JOBQAS *)qas;
-(void)parsingCompleted;
@end

