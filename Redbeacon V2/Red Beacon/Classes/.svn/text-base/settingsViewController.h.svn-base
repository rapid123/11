//
//  settingsViewController.h
//  Red Beacon
//
//  Created by Runi Kovoor on 15/08/11.
//  Copyright 2011 Rapid Value Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoPage.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface settingsViewController : UIViewController <MFMailComposeViewControllerDelegate> {

    UILabel * titleLabel;
}

@property(nonatomic, retain) IBOutlet UILabel * titleLabel;

- (void)createCustomNavigationRightButton;

- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)onTouchUpInfoButton:(id)sender;

- (void)mailComposer;

@end
