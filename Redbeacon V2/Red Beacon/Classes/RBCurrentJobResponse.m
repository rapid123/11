//
//  RBCurrentJobResponse.m
//  Red Beacon
//
//  Created by sudeep on 13/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "RBCurrentJobResponse.h"
#import "RBJobBidAndProviderDetailHandler.h"
#import "HomeViewController.h"
#import "JobResponseDetails.h"

@class HomeViewController;

@implementation RBCurrentJobResponse

@synthesize jobResponse;
@synthesize delegate;

-(JobResponseDetails *)jobResponse {
    
    if(jobResponse)
        return jobResponse;
    return nil;
}

-(void)retrieveJobQAS:(NSDictionary *)qasMessageDict {
    
    JOBQAS *qas = [[JOBQAS alloc] init];
    qas.question = [qasMessageDict  valueForKey:@"question"];
    qas.has_been_read_by_consumer = [[qasMessageDict  valueForKey:@"has_been_read_by_consumer"] boolValue];
    qas.question_id = [[qasMessageDict  valueForKey:@"question_id"] intValue];
    qas.answer = [qasMessageDict  valueForKey:@"answer"];
    
    if ([qasMessageDict valueForKey:@"time_created"] != [NSNull null]) {
        
        int timeCreated = [[qasMessageDict valueForKey:@"time_created"] intValue];
        qas.time_created = [NSDate dateWithTimeIntervalSince1970:timeCreated];
    }
    if ([qasMessageDict valueForKey:@"time_answered"] != [NSNull null]) {
        
        int timeAnswered = [[qasMessageDict valueForKey:@"time_answered"] intValue];
        qas.time_answered = [NSDate dateWithTimeIntervalSince1970:timeAnswered];
    }
    
    [jobResponse.jobQAS addObject:qas];
    [qas release];
    qas=nil;
}

- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request {
    
    RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
    if (requestType == kJobDetails) 
    {
        // Use when fetching text data
       NSString *responseString = [request responseString];
       NSDictionary * responseDictionary = [responseString JSONValue];
       NSArray *bidDetails =[responseDictionary objectForKey:@"bids"];
       HomeViewController *homeViewController = LOCATE(HomeViewController);
        
       NSArray *bidsInfo = [homeViewController pareseBidDetails:bidDetails];
       jobResponse.jobBids = bidsInfo;
        
       id qas = [responseDictionary objectForKey:@"qas"];
       if(qas){
           NSMutableArray *qasArray = [[NSMutableArray alloc] init];
           jobResponse.jobQAS = qasArray;
           [qasArray release];
           qasArray = nil;
           
           if([qas isKindOfClass:[NSArray class]]){
               for (int i=0; i<[qas count]; i++) {
                   [self retrieveJobQAS:[qas objectAtIndex:i] ];
               }
           }
           else
               [self retrieveJobQAS:qas];
       }
    }
    if([delegate respondsToSelector:@selector(parsingCompleted)])
        [delegate parsingCompleted];
    
}

-(void)dealloc {
    
    //self.jobResponse = nil;
    [super dealloc];
}

@end
