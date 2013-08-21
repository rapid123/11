//
//  RBAsyncImage.h
//  Red Beacon
//
//  Created by sudeep on 06/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobResponseDetails.h"

@interface RBAsyncImage : UIView {
    
    
	NSURLConnection* connection;
	NSMutableData* data;
	SEL onReady;
	id target;
	
    JobResponseDetails *jobResponseDetail;
}

@property (assign) SEL onReady;
@property (assign) id target;

@property (nonatomic, retain) JobResponseDetails *jobResponseDetail;

-(void)showVideoIcon;
- (void)loadImageFromURL:(NSURL*)url isFromHome:(BOOL)isHome;
-(void)loadExistingImage:(UIImage *)image;
@end
