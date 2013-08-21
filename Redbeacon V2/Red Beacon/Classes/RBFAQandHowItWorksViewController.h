//
//  RBFAQandHowItWorksViewController.h
//  Red Beacon
//
//  Created by Jai Raj on 01/11/11.
//  Copyright (c) 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationItem + RedBeacon.h"

@interface RBFAQandHowItWorksViewController : UIViewController {

    
}

@property (nonatomic, retain) IBOutlet UIWebView *FAQwebview;
@property (nonatomic, retain) IBOutlet UIView *FAQView;
@property (nonatomic, retain) IBOutlet UIView *howItWorksView;

@property (nonatomic) BOOL isFAQ;
@end
