//
//  RBOperationQueueWrapper.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBOperationQueueWrapper.h"


@implementation RBOperationQueueWrapper

@synthesize clearCurrentQueue;
@synthesize maxConcurrentOperations;
@synthesize delegate;

static RBOperationQueueWrapper * operationQueueStore;

#pragma mark Init code
- (id)init
{   
    self = [super init];
    
    if (self)
    {
        clearCurrentQueue = NO;
        maxConcurrentOperations = 1;
    }
    return self;
}
#pragma mark -

#pragma mark shared Instance
+(RBOperationQueueWrapper *)sharedInstance 
{    
    if(!operationQueueStore)
    {        
        operationQueueStore = [[RBOperationQueueWrapper alloc] init];
    }    
    return operationQueueStore;    
}
#pragma mark -

#pragma mark RBOperationQueueWrapper Methods
- (void)addRequestToQueue:(id)request
{
    do 
    {
        if (!queue) 
        {
            queue = [[ASINetworkQueue alloc] init];
            queue.delegate = self;
            [queue setMaxConcurrentOperationCount:1];
            [queue setQueueDidFinishSelector:@selector(contentQueueFinished:)];
            [queue addOperation:request];
            [queue go];
            break;
        }
        
        if (queue && clearCurrentQueue)
        {
            [queue cancelAllOperations];
            [queue release];
            queue = nil;
            queue = [[ASINetworkQueue alloc] init];
            [queue setQueueDidFinishSelector:@selector(contentQueueFinished:)];
            queue.delegate = self;
            [queue setMaxConcurrentOperationCount:1]; 
            [queue addOperation:request];
            [queue go];
            break;
        }
        
        [queue addOperation:request];
        
    } while (0);
}

- (BOOL)isQueueEmpty
{
    BOOL empty = NO;
    
    if  (queue.requestsCount <= 0)
    {
        empty = YES;
    }
    
    return empty;
}

- (void)cancelAllQueuedOperations
{
    [queue cancelAllOperations];
    [queue release];
    queue = nil;
}

- (int)getQueuedRequestsCount
{
    return queue.requestsCount;
}

-(void)contentQueueFinished:(ASIHTTPRequest *)request
{
    [delegate queueFinished:request];
}

#pragma mark -

@end
