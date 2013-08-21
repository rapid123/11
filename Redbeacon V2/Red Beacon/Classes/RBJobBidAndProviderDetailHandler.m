//
//  RBJobBidAndProviderDetailHandler.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBJobBidAndProviderDetailHandler.h"
#import "FlurryAnalytics.h"


@implementation RBJobBidAndProviderDetailHandler

#pragma mark -

NSString * const kAllJobsAndStatusApi = @"/jobsdone/rpc/all_jobs";
NSString * const kJobDetailsApi = @"/jobsdone/rpc/get_job_details";
NSString * const kAddJobDetailsApi = @"/jobsdone/add_job_update/";
NSString * const kAskPrivetQuestionApi = @"/jobsdone/private_mesg/";
NSString * const kPublicQuestionAnswerApi = @"/jobsdone/ajax_answer/";
NSString * const kGetBidDetailsApi = @"/jobsdone/rpc/get_bid_details";
NSString * const kCancelJobApi = @"/jobsdone/cancel_op/";
NSString * const KAcceptQuotes = @"/jobsdone/accept_job/";
NSString * const KAcceptORCancelAppointment = @"/jobsdone/reject_quote/";
NSString * const KConfirmAppointment = @"/jobsdone/accept_appointment/";
NSString * const KSetAnAppointmentDateTime = @"/jobsdone/ajax_update_bid/";
NSString * const KMarkPrivetConverStatus = @"/jobsdone/rpc/mark_messages_as_read_by_consumer";
NSString * const KMarkPublicConverStatus = @"/jobsdone/rpc/mark_qas_as_read_by_consumer";


#pragma mark - API Params
NSString * const kJobId = @"job_id";
NSString * const kDetails = @"details";
NSString * const kMessage = @"message";
NSString * const kQuestionId = @"question_id";
NSString * const kAnswer = @"answer";
NSString * const kFirstName = @"first_name";
NSString * const kLastName = @"last_name";
NSString * const kPhoneNo = @"phone";
NSString * const kAddress = @"address";
NSString * const kCity = @"city";
NSString * const kZipcode = @"zipcode";
NSString * const kFlexDate = @"flexible_date";
NSString * const kFlexTime = @"flexible_time";
NSString * const kRejectionReason = @"rejection_reason";
NSString * const kOther = @"other";
NSString * const kBidId = @"bid_id";
NSString * const kMessageId = @"message_ids";
NSString * const kIsRead = @"is_read";
NSString * const kQuestionIds = @"question_ids";

//Accept a quote for a job
NSString * const kFirst_name = @"first_name";
NSString * const kLast_name = @"last_name";
NSString * const kPhone = @"phone";
//NSString * const kAddress = @"address";
//NSString * const kCity = @"city";
NSString * const kzipcode = @"zipcode";
NSString * const kFlexible_date = @"flexible_date";
NSString * const kFlexible_time = @"flexible_time";

NSString * const KConfirmAction = @"action";
#pragma mark -

#pragma mark RBJobBidAndProviderDetailHandler Methods
- (void)sendAllJobsAndStatusRequest
{
    //[FlurryAnalytics logEvent:@"Get All Jobs"];
    NSString *apiName = kAllJobsAndStatusApi;    
    [self getRequest:apiName withRequestType:kAllJobsAndStatus];
}

- (void)getJobDetailsOfJobWithId:(NSString*)jobId
{
    //[FlurryAnalytics logEvent:@"Get Job Details"];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = kJobDetailsApi;
    
    NSMutableDictionary * getParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kJobId];
    NSString * value = [RBConstants urlEncodedParamStringFromString:jobId];
    [getParams setObject:value forKey:key];
    
    [self getRequest:apiName withParams:getParams withRequestType:kJobDetails];
    
    [getParams release];
    getParams = nil;    
    
    if(pool)
        [pool drain];
}

- (void)sendJobDetailsRequestWithJobId:(NSString*)jobId andDetails:(NSString*)details
{
    //[FlurryAnalytics logEvent:@"Append Job Description"];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = [kAddJobDetailsApi stringByAppendingString:[jobId stringByAppendingString:@"/"]];
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kDetails];
    NSString * value = [RBConstants urlEncodedParamStringFromString:details];
    [postParams setObject:value forKey:key];
    
    [self postRequest:apiName withParams:postParams withRequestType:kSendJobDetails];
    
    [postParams release];
    postParams = nil; 
    
    if(pool)
        [pool drain];
    
}

- (void)askOrAnswerPrivetQuestionRequestWithBidId:(NSString*)bidId andMessage:(NSString*)message
{
    [FlurryAnalytics logEvent:@"Ask/Answer Private Question"];
    NSString *apiName = [kAskPrivetQuestionApi stringByAppendingString:bidId];
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kMessage];
    NSString * value = [RBConstants urlEncodedParamStringFromString:message];
    [postParams setObject:value forKey:key];
    
    [self postRequest:apiName withParams:postParams withRequestType:kAskAnswerQuestion];
    
    [postParams release];
    postParams = nil;    
}

- (void)answerPublicQuestionRequestWithJobId:(NSString*)jobId questionId:(NSString*)questionId andAnswer:(NSString*)answer
{
    [FlurryAnalytics logEvent:@"Ask/Answer Public Question"];
    NSString *apiName = kPublicQuestionAnswerApi;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kJobId];
    NSString * value = [RBConstants urlEncodedParamStringFromString:jobId];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kQuestionId];
    value = [RBConstants urlEncodedParamStringFromString:questionId];
    [postParams setObject:value forKey:key]; 
    
    key = [RBConstants urlEncodedParamStringFromString:kAnswer];
    value = [RBConstants urlEncodedParamStringFromString:answer];
    [postParams setObject:value forKey:key];     
    
    [self postRequest:apiName withParams:postParams withRequestType:kAskAnswerQuestion];//kPublicQuestionAnswer
    
    [postParams release];
    postParams = nil;    
}

- (void) cancelJobRequestWithJobId:(NSString*)jobId reasonOfRejection:(NSString*)rejectionReason andOther:(NSString*)other
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = [kCancelJobApi stringByAppendingString:[jobId stringByAppendingString:@"/"]];
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kRejectionReason];
    NSString * value = [RBConstants urlEncodedParamStringFromString:rejectionReason];
    [postParams setObject:value forKey:key];
        
    [FlurryAnalytics logEvent:@"Cancel Job" withParameters:postParams];
    
    key = [RBConstants urlEncodedParamStringFromString:kOther];
    value = [RBConstants urlEncodedParamStringFromString:other];
    [postParams setObject:value forKey:key];      
    
    [self postRequest:apiName withParams:postParams withRequestType:kCancelJob];
    
    [postParams release];
    postParams = nil; 
    
    if(pool)
        [pool drain];
}

- (void)getBidDetailsWithJobId:(NSString*)jobId andBidId:(NSString*)bidId
{
    //[FlurryAnalytics logEvent:@"Get Bid Details"];
    NSString *apiName = kGetBidDetailsApi;

    NSMutableDictionary * getParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kJobId];
    NSString * value = [RBConstants urlEncodedParamStringFromString:jobId];
    [getParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kBidId];
    value = [RBConstants urlEncodedParamStringFromString:bidId];
    [getParams setObject:value forKey:key];
    
    [self getRequest:apiName withParams:getParams withRequestType:kBidDetails];
    
    [getParams release];
    getParams = nil;      

}



- (void)AcceptQuoteForJob:(NSMutableDictionary *)result
{
    [FlurryAnalytics logEvent:@"Accept Bid"];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName =  [KAcceptQuotes stringByAppendingString:[[result valueForKey:kJobId] stringByAppendingString:@"/"]];
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kBidId];
    NSString * value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kBidId]];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kFirst_name];
    value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kFirst_name]];
    [postParams setObject:value forKey:key];      
    
    key = [RBConstants urlEncodedParamStringFromString:kLast_name];
    value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kLast_name]];
    [postParams setObject:value forKey:key]; 
    
    key = [RBConstants urlEncodedParamStringFromString:kPhone];
    value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kPhone]];
    [postParams setObject:value forKey:key]; 
   
    key = [RBConstants urlEncodedParamStringFromString:kAddress];
    value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kAddress]];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kCity];
    value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kCity]];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kzipcode];
    value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kzipcode]];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kFlexible_date];
    value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kFlexible_date]];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kFlexible_time];
    value = [RBConstants urlEncodedParamStringFromString:[result valueForKey:kFlexible_time]];
    [postParams setObject:value forKey:key];
    
    [self postRequest:apiName withParams:postParams withRequestType:KScheduleAppointment];
    
    [postParams release];
    postParams = nil; 
    
    if (pool) {
        
        [pool drain];
    }
    
}

- (void)sendKAcceptORCancelAppointmentWithBidId:(NSString*)bidId jobID:(NSString*)jobID actionType:(NSString *)actionType rejectReason:(NSString*)reason
{
    //rejection_reason jobid and bid id
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *apiName = [KAcceptORCancelAppointment stringByAppendingFormat:@"%@/%@",jobID,bidId];
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kRejectionReason];
    NSString * value = [RBConstants urlEncodedParamStringFromString:reason];
    [postParams setObject:value forKey:key];
    
    NSString * key2 = [RBConstants urlEncodedParamStringFromString:kOther];
    NSString * value2 = [RBConstants urlEncodedParamStringFromString:actionType];
    [postParams setObject:value2 forKey:key2];
    
    if (value == @"accept") {
        [FlurryAnalytics logEvent:@"Accept Appointment"];
    } else if (value == @"reject") {
        [FlurryAnalytics logEvent:@"Reject Appointment"];
    }
    
    [self postRequest:apiName withParams:postParams withRequestType:kCancelORAcceptAppointment];
    
    [postParams release];
    postParams = nil; 
    
    if(pool)
        [pool drain];
    
}

- (void)sendKConfirmAppointmentWithBidId:(NSString*)bidId 
{
    //rejection_reason jobid and bid id
    NSString *acceptType = @"accept";
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = [KConfirmAppointment stringByAppendingString:[bidId stringByAppendingString:@"/"]];
    
    NSMutableDictionary  *postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:KConfirmAction];
    NSString * value = [RBConstants urlEncodedParamStringFromString:acceptType];
    [postParams setObject:value forKey:key];
    
    if (value == @"accept") {
        [FlurryAnalytics logEvent:@"Accept Appointment"];
    } else if (value == @"reject") {
        [FlurryAnalytics logEvent:@"Reject Appointment"];
    }
    
    [self postRequest:apiName withParams:postParams withRequestType:KConfrmAppointment];
    
    [postParams release];
    postParams = nil; 
    
    if(pool)
        [pool drain];
}

- (void)sendSetAnAppointmentTime:(NSString *)bidID:(NSString*)date :(NSString *)time
{
    [FlurryAnalytics logEvent:@"Set Appointment Time"];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = [KSetAnAppointmentDateTime stringByAppendingString:[bidID stringByAppendingString:@"/"]];
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kFlexDate];
    NSString * value = [RBConstants urlEncodedParamStringFromString:date];
    [postParams setObject:value forKey:key];
    
    NSString * timekey = [RBConstants urlEncodedParamStringFromString:kFlexTime];
    NSString * timevalue = [RBConstants urlEncodedParamStringFromString:time];
    [postParams setObject:timevalue forKey:timekey];
    
    [self postRequest:apiName withParams:postParams withRequestType:KSetAnAppointmentTime];
    
    [postParams release];
    postParams = nil; 
    
    if(pool)
        [pool drain];
    
}

- (void)markPrivetConversationWithBidId:(NSString *)bidID andMessageId:(NSString*)messageId asRead:(NSString *)status
{
    [FlurryAnalytics logEvent:@"Mark Private Conversation Read"];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = KMarkPrivetConverStatus;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kBidId];
    NSString * value = [RBConstants urlEncodedParamStringFromString:bidID];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kMessageId];
    value = [RBConstants urlEncodedParamStringFromString:messageId];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kIsRead];
    value = [RBConstants urlEncodedParamStringFromString:status];
    [postParams setObject:value forKey:key];    
    
    [self postRequest:apiName withParams:postParams withRequestType:KMarkPrivetConStatus];
    
    [postParams release];
    postParams = nil; 
    
    if(pool)
        [pool drain];
    
}

- (void)markPublicConversationWithJobId:(NSString *)jobID andQuestionId:(NSString*)questionId asRead:(NSString *)status
{
    [FlurryAnalytics logEvent:@"Mark Public Conversation Read"];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = KMarkPublicConverStatus;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kJobId];
    NSString * value = [RBConstants urlEncodedParamStringFromString:jobID];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kQuestionIds];
    value = [RBConstants urlEncodedParamStringFromString:questionId];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kIsRead];
    value = [RBConstants urlEncodedParamStringFromString:status];
    [postParams setObject:value forKey:key];    
    
    [self postRequest:apiName withParams:postParams withRequestType:KMarkPublicConStatus];
    
    [postParams release];
    postParams = nil; 
    
    if(pool)
        [pool drain];
    
}

#pragma mark - ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"AllJobBidAndProviderDetailRequestFinished:Response %d : %@", 
          request.responseStatusCode, 
          [request responseStatusMessage]);
    
    RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
    
    NSLog(@"Value:%@",[request responseString]);
    
    if (requestType == kAllJobsAndStatus)
    {
       [FlurryAnalytics logEvent:@"Get All Jobs"];
    }
    
    if(requestType == kSendJobDetails)
    {
       [FlurryAnalytics logEvent:@"Append Job Description"];    
    }

    if(requestType == kAskAnswerQuestion)
    {
        
    }
    
    if(requestType == kPublicQuestionAnswer)
    {
        
    }
    
    if(requestType == kBidDetails)
    {
      [FlurryAnalytics logEvent:@"Get Bid Details"];   
    }
    
    if(requestType == kCancelJob)
    {
        
    }
    
    if(requestType == kJobDetails)
    {
       [FlurryAnalytics logEvent:@"Get Job Details"];  
    }
    if (requestType == KScheduleAppointment) {
        
    }
    if (requestType == kCancelORAcceptAppointment) {
        
    }
    if (requestType == KSetAnAppointmentTime) {
        
    } 
    
    if(requestType == KMarkPrivetConStatus)
    {
    
    }
    
    if(requestType == KMarkPublicConStatus)
    {
        
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
