//
//  RBOperationQueueWrapper.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

@protocol NetworkQueueDelegate <NSObject>
-(void)queueFinished:(ASIHTTPRequest *)request;
@end

/////////////////////////////////////////////////////////////////////
// This class is a singleton wrapper around the ASINetwork Queue
// for sharing the queue among requests
/////////////////////////////////////////////////////////////////////
@interface RBOperationQueueWrapper : NSObject 
{
    // Indicates if you want to clear the queue and then add to it
    // YES: removes all current operations from the queue and adds the request as the first item
    // NO:  appends the request to the end of the queue
    BOOL clearCurrentQueue; // Default: NO
    
    // Indicates the maximum concurrent operations that should take place
    // For Red Beacon we do not want any concurrency. So the calling class
    // need not set a value for this. 
    int maxConcurrentOperations; // Default: 1
    
    // The encapsulated network queue
    ASINetworkQueue *queue;
    
    //id<ASIHTTPRequestDelegate> delegate;
    id delegate;
   // id <NetworkQueueDelegate> nqdelegate; 
}

@property (nonatomic, assign) BOOL clearCurrentQueue;
@property (nonatomic, assign) int maxConcurrentOperations;
@property (nonatomic, assign) id delegate;
//@property (nonatomic, assign) id nqdelegate;

+(RBOperationQueueWrapper *)sharedInstance;
- (void)addRequestToQueue:(id)request;
- (void)cancelAllQueuedOperations;
- (BOOL)isQueueEmpty;
- (int)getQueuedRequestsCount;

@end
