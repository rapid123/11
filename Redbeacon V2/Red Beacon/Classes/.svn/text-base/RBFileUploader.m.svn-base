//
//  RBFileUploader.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBFileUploader.h"
#import "FlurryAnalytics.h"


@implementation RBFileUploader

@synthesize fileName;
@synthesize filePath;
@synthesize startDate;
@synthesize endDate;

#pragma mark -

#pragma mark Upload Media API
NSString * const kUploadMediaApi = @"/jobsdone/upload_job_image";
#pragma mark -

#pragma mark Upload Media API Params
NSString * const kUploadApiKey = @"username";
#pragma mark -


#pragma mark RBFileUploader Methods
- (BOOL)queueUploadRequests:(NSString *)fullPath ofMediaType:(RBMediaType)type
{
    BOOL startedUpload = NO;
    NSURL * url = nil;

    do 
    {
        RBOperationQueueWrapper * sharedQueue = [RBOperationQueueWrapper sharedInstance];
        sharedQueue.delegate = self;

        if (clearCurrentQueue)
        {
            sharedQueue.clearCurrentQueue = clearCurrentQueue;
        }
        
        NSString *requestToSend = [NSString stringWithFormat:@"%@%@", 
                                   [RBURLHandler RBWEBSERVERURL:0], 
                                  kUploadMediaApi];
        
        NSLog(@"startUpload: POST - Sending URL: %@", requestToSend);
        
        url = [[NSURL alloc] initWithString:requestToSend];
        
        self.filePath = fullPath;
        self.fileName = [fullPath lastPathComponent];
        
        NSString *contentType = [NSString stringWithString:@"multipart/form-data"]; 

        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
        request.delegate = self;
        [request setRequestMethod:@"POST"];
        [request addRequestHeader:@"Content-Type" value:contentType]; 
        
        NSString * mimeType = nil;
        
        if (type == kImage)
        {
            mimeType = [RBConstants getImageMimeTypeFromName:fileName];
            NSLog(@"Uploading image: %@ with mimeType: %@", 
                   fileName, mimeType);
            [FlurryAnalytics logEvent:@"Media Upload - Image" timed:YES];
        }
        else if (type == kAudio)
        {
            mimeType = [RBConstants getAudioMimeTypeFromName:fileName];
            NSLog(@"Uploading audio: %@ with mimeType: %@", 
                   fileName, mimeType);
            [FlurryAnalytics logEvent:@"Media Upload - Audio" timed:YES];
        }
        else // type = kVideo
        {
            mimeType = [RBConstants getVideoMimeTypeFromName:fileName];
            NSLog(@"Uploading video: %@ with mimeType: %@", 
                   fileName, mimeType);
            [FlurryAnalytics logEvent:@"Media Upload - Video" timed:YES];
       }
        
        if (mimeType == nil)
        {
            NSLog(@"ERROR: Cannot start upload. Unable to determine mime type of: %@", 
                  fileName);
            [request release];
            break;
        }
        
        RBRequestInfo * requestInfo = [[RBRequestInfo alloc] init];
        requestInfo.mediaFilename = filePath;
        requestInfo.mediaType = type;
        requestInfo.requestType = kUploadMediaRequest;
        
        request.userInfo = [NSDictionary dictionaryWithObject:requestInfo forKey:@"RequestInfo"];
        
        [requestInfo release];
        requestInfo = nil;
        
        NSData *uploadData = [NSData dataWithContentsOfFile:self.filePath];
        [request setPostFormat:ASIMultipartFormDataPostFormat];
        [request setData:uploadData withFileName:fileName andContentType:mimeType forKey:@"image"];
        
        startedUpload = YES;
        self.startDate = [NSDate date];
        [sharedQueue addRequestToQueue:request];
        
        [request release];
        request = nil;
       
    } while (0);
    
    [url release];
    url = nil;
    
    return startedUpload;
}

- (void)queueFinished:(ASIHTTPRequest *)request
{
    [self.delegate queueFinished:request];
}

+ (void)cancelAllUploadRequests
{
    RBOperationQueueWrapper * sharedQueue = [RBOperationQueueWrapper sharedInstance];
    [sharedQueue cancelAllQueuedOperations];
}

+ (BOOL)areQueuedRequestsAvailable
{
    RBOperationQueueWrapper * sharedQueue = [RBOperationQueueWrapper sharedInstance];
    return [sharedQueue isQueueEmpty];
}

#pragma mark -

#pragma mark - ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)theRequest
{
    self.endDate = [NSDate date];
    NSLog(@"MediaUpload Time elapsed: %f", [endDate timeIntervalSinceDate:startDate]);

    do 
    {
       NSLog(@"uploadMediaRequestFinished:Response Code %d : %@", 
          theRequest.responseStatusCode, 
          [theRequest responseStatusMessage]);
        
        NSData * theData = [theRequest responseData];
        NSString * responseString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
        
        NSLog(@"uploadMediaRequestFinished:Response Data %@", responseString);
        
        NSDictionary * responseDictionary = [responseString JSONValue];
        BOOL isSuccess = [self extractSuccessKeyValue:responseDictionary];
        
        if (!isSuccess || theRequest.userInfo == nil)
        {
            [delegate requestCompletedWithErrors:theRequest];
            break;
        }
        
        JobRequest *jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
        RBRequestInfo * reqInfo = [theRequest.userInfo objectForKey:@"RequestInfo"];
        NSLog(@"---Upload Media request finished for %@", reqInfo.mediaFilename);
        
        NSNumber *mediaId = [responseDictionary valueForKey:@"image_id"];
        NSString *thumbnailUrl = [responseDictionary valueForKey:@"thumbnail_url"];
        
        if (reqInfo.mediaType == kImage)
        {
            [jobRequest updateImageStatus:kUploadSuccess 
                             forImagePath:reqInfo.mediaFilename 
                              withMediaId:mediaId 
                             andthumbnail:thumbnailUrl];
            [FlurryAnalytics endTimedEvent:@"Media Upload - Image" withParameters:nil];
        }
        else  if (reqInfo.mediaType == kAudio)
        {
            [jobRequest updateAudioStatus:kUploadSuccess 
                              withMediaId:mediaId 
                             andthumbnail:thumbnailUrl];
            [FlurryAnalytics endTimedEvent:@"Media Upload - Audio" withParameters:nil];
        }
        else
        {
            [jobRequest updateVideoStatus:kUploadSuccess 
                              withMediaId:mediaId 
                             andthumbnail:thumbnailUrl];
            [FlurryAnalytics endTimedEvent:@"Media Upload - Video" withParameters:nil];
        }
        
        [delegate requestCompletedSuccessfully:theRequest];
        
        thumbnailUrl = nil;
        mediaId = nil;
        
        
    } while (0);
}

- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
    NSLog(@"uploadMediaRequestFailed:Response %d : %@", 
          theRequest.responseStatusCode, 
          [theRequest responseStatusMessage]);
    
    RBOperationQueueWrapper * sharedQueue = [RBOperationQueueWrapper sharedInstance];
    NSLog(@"FAILURE: Queued requests count: %d", [sharedQueue getQueuedRequestsCount]);

    [self trackRequestError:theRequest];
    [delegate requestCompletedWithErrors:theRequest];
}
#pragma mark -



#pragma mark Memory Management
- (void)dealloc
{
    [filePath release];
    [fileName release];
    [startDate release];
    [endDate release];
    
    [super dealloc];
}
#pragma mark -

@end
