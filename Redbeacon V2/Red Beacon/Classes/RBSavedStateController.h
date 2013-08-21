//
//  MMSavedStateController.h
//  Redbeacon
//
//  Created by RapidValue Solutions on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBMediaStatusTracker.h"
#import "JobRequest.h"
#import "JobResponseDetails.h"

extern NSString * const kRBSavedDataKey;	 //key for savedData data from NSUserDefaults

@interface RBSavedStateController : NSObject 
{
    NSMutableDictionary *savedData;
}

@property (nonatomic, readonly) NSMutableDictionary *savedData;

+ (RBSavedStateController *)sharedInstance;  //access the singleton instance of this class.
+ (NSString *)persistancePath;
- (BOOL)persistToDisk;

#pragma mark JobRequest
- (JobRequest*)jobRequest;
- (void)saveJobRequest:(JobRequest*)jobRequest;
- (void)clearJobRequest; 

#pragma mark JobResponse
- (void)saveJobResponse:(JobResponseDetails *)jobResponse;
- (JobResponseDetails*)jobResponse;
- (void)clearJobResponse;

/*- (void)saveMediaObject:(RBMediaStatusTracker*)statusTracker;
- (void)updateStatusOfMediaObject:(RBMediaStatusTracker*)statusTracker;
- (BOOL)areAllMediaSuccessfullyUploaded;

- (NSString*)getMediaIdString;
- (void)saveTextMessage:(NSString*)textMessage;
- (NSString*)getTextMessage;
- (BOOL)isSufficientDataForJobRequestAvailable;
- (void)addJobRequestWithName:(NSString*)jobName;
- (void)purgeJobRequestInformation;
- (void)saveScheduleWithType:(NSString*)scheduleType andDate:(NSString*)scheduleDate;
- (void)saveLocationCode:(NSString*)zipCode;
- (NSString*)getLocationCode;
- (NSString*)getScheduleDate;
- (NSString*)getScheduleType;
- (void)saveJobRequest:(JobRequest*)jobRequest;
- (BOOL)purgeState;
- (void)purgeStateForLocation:(int)location;

- (void)purgeStateOfMediaForKey:(NSString*)key;*/
@end
