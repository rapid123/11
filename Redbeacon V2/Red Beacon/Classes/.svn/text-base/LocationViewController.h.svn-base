//
//  LocationViewController.h
//  Red Beacon
//
//  Created by Nithin George on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBLoadingOverlay.h"
#import "Red_BeaconAppDelegate.h"

@interface LocationViewController : UIViewController<RBLocationDelegate> {
    
    UITextField     * zipCodeTextField;
    UIView          * locationContainer;
    UIButton        * gpsModeButton;
    UIButton        * customZipcodeButton;
    RBLoadingOverlay * overlay;
    
    BOOL isGPSMode;
}

@property (nonatomic, retain) IBOutlet UIView       * locationContainer;
@property (nonatomic, retain) IBOutlet UITextField  * zipCodeTextField;
@property (nonatomic, retain) IBOutlet UIButton     * gpsModeButton;
@property (nonatomic, retain) IBOutlet UIButton     * customZipcodeButton;
@property (nonatomic, retain) RBLoadingOverlay      * overlay;

@end
