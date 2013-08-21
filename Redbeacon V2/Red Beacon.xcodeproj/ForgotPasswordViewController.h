//
//  ForgotPasswordViewController.h
//  Red Beacon
//
//  Created by Nithin George on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBSignUpHandler.h"
#import "Red_BeaconAppDelegate.h"
#import "RBLoadingOverlay.h"

@interface ForgotPasswordViewController : UIViewController {
    
    RBSignUpHandler *forgotPasswordAPIHandler;
}

@property (nonatomic, retain) IBOutlet UIImageView *logoImage; 
@property (nonatomic, retain) IBOutlet UILabel *tittle; 
@property (nonatomic, retain) IBOutlet UIImage *emailImage; 
@property (nonatomic, retain) IBOutlet UITextField *emailAddressText; 
@property (nonatomic, retain) IBOutlet UIButton *sendButton; 

@property (nonatomic, retain) RBLoadingOverlay * overlay;

- (IBAction)sendButtonClicked:(id)sender;
@end
