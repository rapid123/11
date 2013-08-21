//
//  RBFileUploader.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBBaseHttpHandler.h"
#import "RBURLHandler.h"
#import "RBOperationQueueWrapper.h"
#import "RBRequestInfo.h"
#import "RBNetworkQueueDelegate.h"
#import "RBSavedStateController.h"
#import "RBMediaStatusTracker.h"

@interface RBFileUploader : RBBaseHttpHandler <RBNetworkQueueDelegate>
{
    NSString* filePath;
    NSString* fileName;
//    ASINetworkQueue *currentQueue;
 //   id <NetworkQueueDelegate> nqdelegate;
    NSDate* startDate;
    NSDate* endDate;
}

@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) NSString* fileName;
@property (nonatomic, retain) NSDate* startDate;
@property (nonatomic, retain) NSDate* endDate;
//@property (nonatomic, assign) id nqdelegate;
//@property (nonatomic, retain) NSOperationQueue *currentQueue;


- (BOOL)queueUploadRequests:(NSString *)fullPath ofMediaType:(RBMediaType)type;
+ (void)cancelAllUploadRequests;
+ (BOOL)areQueuedRequestsAvailable;


@end
