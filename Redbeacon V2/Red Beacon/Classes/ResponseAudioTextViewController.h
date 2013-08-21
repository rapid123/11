//
//  ResponseAudioTextViewController.h
//  Red Beacon
//
//  Created by sudeep on 17/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioTextViewController.h"
#import "RBJobBidAndProviderDetailHandler.h"
#import "Red_BeaconAppDelegate.h"
#import "RBLoadingOverlay.h"

@interface ResponseAudioTextViewController : AudioTextViewController {
    
    RBJobBidAndProviderDetailHandler *jobEditRequestResponse;
}

@property (nonatomic, retain) RBLoadingOverlay * overlay;

@end
