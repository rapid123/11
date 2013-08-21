//
//  RBJobRequestHandler.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBJobRequestHandler.h"
#import "UIDeviceHardware.h"
#import "FlurryAnalytics.h"

@implementation RBJobRequestHandler

#pragma mark JobRequest APIs
NSString * const kJobReq1Api = @"/request_services";
NSString * const kJobReq2Api = @"/jobsdone/job_confirm/";
#pragma mark -

#pragma mark JobRequest API Params
NSString * const kOccupationNameKey = @"occupation_name";
NSString * const kJobTimeSelectorKey = @"job_time_selector";
NSString * const kApproxLocationKey = @"approx_location";
NSString * const kDetailsKey = @"details";
NSString * const kJobImgIDsKey = @"job_image_ids";
NSString * const kFlexibleOptionKey = @"flexible_option";
NSString * const kDateKey = @"date";
NSString * const kHrMinTimeBegKey = @"hour_min_time_begin";
NSString * const kHrMinTimeEndKey = @"hour_min_time_end";
NSString * const kAltDateKey = @"alt_date";
NSString * const kAltHrMinTimeBegKey = @"alt_hour_min_time_begin";
NSString * const kAltHrMinTimeEndKey = @"alt_hour_min_time_end";
NSString * const kSourceKey = @"source";
NSString * const kSkipJobBlockKey = @"skip_job_block";

#pragma mark -

#pragma mark RBJobRequestHandler Methods

- (void)prepareUploadMediaRequest
{

}

- (void)prepareJobRequestPart1:(RBJobRequest*)jobRequest
{
    NSString *apiName = kJobReq1Api;
    
    [jobRequest doURLEncode];
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    [postParams setObject:jobRequest.occupationName forKey:kOccupationNameKey];
    [postParams setObject:jobRequest.jobTimeSelector forKey:kJobTimeSelectorKey];
    [postParams setObject:jobRequest.approxLocation forKey:kApproxLocationKey];
    [postParams setObject:jobRequest.details forKey:kDetailsKey];
    [postParams setObject:jobRequest.jobImageIDs forKey:kJobImgIDsKey];
    [postParams setObject:jobRequest.flexibleOption forKey:kFlexibleOptionKey];
    [postParams setObject:jobRequest.date forKey:kDateKey];
    [postParams setObject:jobRequest.hrMinTimeBegin forKey:kHrMinTimeBegKey];
    [postParams setObject:jobRequest.hrMinTimeEnd forKey:kHrMinTimeEndKey];
    [postParams setObject:jobRequest.altDate forKey:kAltDateKey];
    [postParams setObject:jobRequest.altHrMinTimeBegin forKey:kAltHrMinTimeBegKey];
    [postParams setObject:jobRequest.altHrMinTimeEnd forKey:kAltHrMinTimeEndKey];
    
    // Always allow job submissions regardless of job location.
    [postParams setObject:[NSNumber numberWithBool:YES] forKey:kSkipJobBlockKey];
     
    [self postRequest:apiName withParams:postParams withRequestType:kJobRequestP1];
    
    [postParams release];
    postParams = nil;

}

- (void)prepareJobRequestPart2
{
    //[FlurryAnalytics logEvent:@"Submit Job Request"];
    NSString *apiName = kJobReq2Api;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    // Add the source field in the format "mobile/<device>-<version>", like "mobile/iPhone4-4.3.2".
    UIDeviceHardware *hardware = [[[UIDeviceHardware alloc] init] autorelease];
    NSString *deviceName = [[[hardware platformString] stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *source = [NSString stringWithFormat:@"mobile/%@-%@", deviceName, version];
    NSLog(@"Source = '%@'", source);
    [postParams setObject:source forKey:kSourceKey];
    
    [self postRequest:apiName withParams:postParams withRequestType:kJobRequestP2];
    
    [postParams release];
}

#pragma mark -

#pragma mark ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"jobRequestFinished:Response %d : %@", 
          request.responseStatusCode, 
          [request responseStatusMessage]);
    
    
    NSLog(@"jobRequestFinished:Response Message: %@", 
          request.responseString);

    NSLog(@"X-Rb-Success: %@", [[request responseHeaders] objectForKey:@"X-Rb-Success"]);
    NSLog(@"X-Rb-Error: %@", [[request responseHeaders] objectForKey:@"X-Rb-Error"]);

    // Use when fetching text data
    // NSString *responseString = [request responseString];
    
    // Use when fetching binary data
    // NSData *responseData = [request responseData];
    
    // cookie code begin
    [self saveTheCookie:request];
    // cookie code end
    RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
    if(requestType == kJobRequestP2)
    {
        [FlurryAnalytics logEvent:@"Submit Job Request"];   
    }
    
    [delegate requestCompletedSuccessfully:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
}
#pragma mark -

@end
