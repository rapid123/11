//
//  JobViewController.h
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBLoginHandler.h"
#import "RBJobRequestHandler.h"
#import "RBMobileContentHandler.h"
#import "RBJobRequestHandler.h"
#import "OccupationModel.h"
#import "RBAlertMessageHandler.h"

@protocol JobViewControllerDelegate <NSObject>
@required
- (void)jobViewDidUnload:(NSString*)jobName;
@end

@interface JobViewController : UIViewController<RBBaseHttpHandlerDelegate> 
{
    
    NSMutableArray *job;
    UITableView *jobTable;
    RBHTTPRequestType requestType;
    RBBaseHttpHandler * mobileContent;
    id <JobViewControllerDelegate> delegate;
    UIView * defaultScreen;
}

@property (nonatomic, retain) IBOutlet UITableView *jobTable;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) IBOutlet UIView * defaultScreen;

- (NSMutableArray *)readHomeSectionItems:(int)index;
- (void)showJobRequestViewWithTitle:(NSString*)title;
//button Action
- (void)showInfoView:(id)sender;
//- (void)cancelButtonClicked:(id)sender;
- (IBAction)callButtonClick:(id)sender;


@end
