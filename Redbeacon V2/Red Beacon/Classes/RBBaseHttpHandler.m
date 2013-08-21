//
//  RBBaseAsyncHttpHandler.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBBaseHttpHandler.h"
#import "Reachability.h"
#import "FlurryAnalytics.h"

@implementation RBBaseHttpHandler

@synthesize delegate;
@synthesize clearCurrentQueue;
//@synthesize requestType;

// cookie code begin
// RB cookie 
static NSHTTPCookie *rbCookie;
static NSRecursiveLock *sessionLock;

#pragma mark Success Key Value
NSString * const kSuccessKeyValue = @"success";
#pragma mark -

- (void)dealloc
{
    [delegate release];
    [super dealloc];
}
+ (void)setSessionCookie: (NSHTTPCookie *)cookie
{
	[sessionLock lock];
	rbCookie = [cookie retain];
	[sessionLock unlock];
}

+ (NSHTTPCookie *)getSessionCookie
{
	NSHTTPCookie *cookie;
	[sessionLock lock];
	cookie = rbCookie;
	[sessionLock unlock];
	if (cookie == nil)
	{
		// If it is not in memory get it from storage
		NSDictionary* cookieDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"MCDSKEY"];
		NSDictionary* cookieProperties = [cookieDictionary valueForKey:@"sessionid"];
		if (cookieProperties != nil) {
			cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
			rbCookie = [cookie retain];
		}
	}
	return rbCookie;
}

+ (void) saveSession
{
	NSLog(@"Saving session to disk");
	[sessionLock lock];
	NSHTTPCookie *cookie = rbCookie;
	NSMutableDictionary* cookieDictionary = [[NSMutableDictionary alloc] init];
	[cookieDictionary setValue:cookie.properties forKey:@"sessionid"];
	[[NSUserDefaults standardUserDefaults] setObject:cookieDictionary forKey:@"MCDSKEY"];
	[[NSUserDefaults standardUserDefaults]synchronize];
	[cookieDictionary release];
	rbCookie = nil;
	[sessionLock unlock];
}

+ (void) clearSession
{
	NSLog(@"Clearing session");
	[sessionLock lock];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MCDSKEY"];
	[[NSUserDefaults standardUserDefaults]synchronize];	
	rbCookie = nil;
	[sessionLock unlock];
}

+ (BOOL) isSessionInfoAvailable
{
	if ([RBBaseHttpHandler getSessionCookie] == nil)
	{
		return NO;
	}
	return YES;
}
// cookie code end

- (void)postRequest:(NSString*)apiName RequestBody:(NSString*)strRequest withRequestType:(RBHTTPRequestType)requestType
{
	NSString *requestToSend=[NSString stringWithFormat:@"%@%@", 
                             [RBURLHandler RBWEBSERVERURL:requestType], 
                             apiName];
    
    NSLog(@"POST - Sending URL: %@ with body: %@", requestToSend, strRequest);
    NSURL * url = [[NSURL alloc] initWithString:requestToSend];
    
    // cookie code begin
    if (!sessionLock) 
	{
		sessionLock = [[NSRecursiveLock alloc] init];
	}
    // cookie code end
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [url release];
    [request appendPostData:[strRequest dataUsingEncoding:NSUTF8StringEncoding]];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"]; 
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setShouldRedirect:NO];
    [request setResponseEncoding:NSUTF8StringEncoding];
    

    RBRequestInfo * requestInfo = [[RBRequestInfo alloc] init];
    requestInfo.requestType = requestType;
    
    request.userInfo = [NSDictionary dictionaryWithObject:requestInfo forKey:@"RequestInfo"];
    
    [requestInfo release];
    requestInfo = nil;
    
    // cookie code begin
    [request setUseCookiePersistence:NO];
    
    if (requestType == kLogin  || 
        requestType == kSignUp || 
        requestType == kFacebookLogin)
    {
        [RBBaseHttpHandler clearSession];
    }
    else
    {
        // Add the session cookie if it exists
        NSHTTPCookie *cookie = [RBBaseHttpHandler getSessionCookie];
        if (cookie != nil)
        {
            [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
        }
        // cookie code end
    }

    if ([self connected]) {
        
        NSLog(@"reachabilityForInternetConnection"); 
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No network connectivity"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        [alert release];
        
        [delegate requestCompletedWithErrors:nil];
    }
    
}

- (void)getRequest:(NSString*)apiName withRequestType:(RBHTTPRequestType)requestType
{
    NSString *requestToSend=[NSString stringWithFormat:@"%@%@", 
                             [RBURLHandler RBWEBSERVERURL:requestType], 
                             apiName];
    
    NSLog(@"GET - Sending URL: %@", requestToSend);
    NSURL * url = [[NSURL alloc] initWithString:requestToSend];
    
    // cookie code begin
    if (!sessionLock) 
	{
		sessionLock = [[NSRecursiveLock alloc] init];
	}
    // cookie code end
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [url release];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"]; 
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setShouldRedirect:NO];
    [ASIHTTPRequest setDefaultTimeOutSeconds:20];
    [request setResponseEncoding:NSUTF8StringEncoding];
    
    // cookie code begin
    [request setUseCookiePersistence:NO];
    
	// Add the session cookie if it exists
	NSHTTPCookie *cookie = [RBBaseHttpHandler getSessionCookie];
	if (cookie != nil)
	{
		[request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
	}
    // cookie code end
    
    RBRequestInfo * requestInfo = [[RBRequestInfo alloc] init];
    requestInfo.requestType = requestType;
    
    request.userInfo = [NSDictionary dictionaryWithObject:requestInfo forKey:@"RequestInfo"];
    
    [requestInfo release];
    requestInfo = nil;
    
    if ([self connected]) {
        
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"No network connectivity"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        [alert release];
        
        [delegate requestCompletedWithErrors:nil];
    }

}

- (BOOL)connected 
{
	//return NO; // force for offline testing
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];	
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];	
	return !(netStatus == NotReachable);
}

- (void)postRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestType:(RBHTTPRequestType)requestType
{
	NSMutableString *requestString = [[NSMutableString alloc] init];
	
	//build encoded string from params dictionary.
	for (NSString *key in [params keyEnumerator])
    {
		if (requestString.length > 0)
        {
			[requestString appendString:@"&"];
		}
        
		[requestString appendFormat:@"%@=%@", key,[params valueForKey:key]];
	}
    
	[self postRequest:strAPIName RequestBody:requestString withRequestType:requestType];
    
	[requestString release];
}

- (void)getRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestType:(RBHTTPRequestType)requestType
{
	NSMutableString *requestString = [[NSMutableString alloc] initWithString:strAPIName];
    [requestString appendString:@"?"];
	
	//build encoded string from params dictionary.
	for (NSString *key in [params keyEnumerator])
    {
		[requestString appendFormat:@"%@=%@", key,[params valueForKey:key]];
        
		if ([params count]>1)//requestString.length > 1)
        {
			[requestString appendString:@"&"];
		}        
	}
    
	[self getRequest:requestString withRequestType:requestType];
    
	[requestString release];    
    
}

// cookie code begin
- (void)saveTheCookie:(ASIHTTPRequest*)request
{
    // Save the MCDS cookie 
	NSArray *newCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[request responseHeaders] forURL:[request url]];
	NSHTTPCookie *cookie;
	for (cookie in newCookies)
    {
        NSLog(@"Cookie Name: %@", cookie.name);
		//if ([cookie.name isEqualToString:@"MCDS"]) 
        if ([cookie.name isEqualToString:@"sessionid"])
		{ 
			[RBBaseHttpHandler setSessionCookie:cookie];
            [RBBaseHttpHandler saveSession];
		}
	}
}
// cookie code end

- (BOOL)extractSuccessKeyValue:(NSDictionary*)responseDictionary
{
    BOOL isSuccess = [[responseDictionary objectForKey:kSuccessKeyValue] boolValue];
  //  BOOL isSuccess = ([successString isEqualToString:@"true"] ? YES : NO);
    
    return isSuccess;
}


+ (RBHTTPRequestType)getRequestType:(ASIHTTPRequest*)request
{
    RBHTTPRequestType reqType = kUnknownType;
    if (request.userInfo)
    {
        RBRequestInfo * reqInfo = [request.userInfo objectForKey:@"RequestInfo"];
        
        if (reqInfo && reqInfo.requestType)
        {
            reqType = reqInfo.requestType;
        }
    }
    
    return reqType;
}

- (void)trackRequestError:(ASIHTTPRequest*)request
{
    [FlurryAnalytics logError:@"Request Failed"
                      message:[NSString stringWithFormat:@"%@", request.url]
                        error:request.error];
}

#pragma To Override
- (void)sendLoginRequestWithUsername:(NSString*)username andPassword:(NSString*)password
{
    // Should be overridden in derived class
}

- (void)sendLogoutRequest
{
    // Should be overridden in derived class
}

- (BOOL)queueUploadRequests:(NSString *)fullPath ofMediaType:(RBMediaType)type
{
    return NO;
}

- (void)prepareJobRequestPart1:(RBJobRequest*)jobRequest
{
    // Should be overridden in derived class
}

- (void)prepareJobRequestPart2
{
    // Should be overridden in derived class
}

- (void)sendSignUpRequestWithUsername:(NSString*)email andPassword:(NSString*)password:(NSString*)telephoneNumber
{
   // Should be overridden in derived class
}

- (void)sendEmailNotTakenRequest:(NSString*)email
{
   // Should be overridden in derived class    
}

- (void)sendUsernameNotTakenRequest:(NSString*)username
{
   // Should be overridden in derived class 
}

-(void)sendContentRequest
{
   // Should be overridden in derived class     
}

-(void)sendHashRequest
{
   // Should be overridden in derived class 
}

- (void)sendLocationRequest:(NSString*)zipcode
{
   // Should be overridden in derived class
}

- (void)sendSessionExpiryRequest
{
   // Should be overridden in derived class
}

- (void)sendAllJobsAndStatusRequest
{
   // Should be overridden in derived class
}

- (void)sendJobDetailsRequestWithJobId:(NSString*)jobId andDetails:(NSString*)details
{
   // Should be overridden in derived class    
}

- (void)askOrAnswerPrivetQuestionRequestWithBidId:(NSString*)bidId andMessage:(NSString*)message
{
    // Should be overridden in derived class    
}

- (void)answerPublicQuestionRequestWithJobId:(NSString*)jobId questionId:(NSString*)questionId andAnswer:(NSString*)answer
{
    // Should be overridden in derived class    
}

- (void)getBidDetailsWithJobId:(NSString*)jobId andBidId:(NSString*)bidId
{
    // Should be overridden in derived class    
}

- (void) cancelJobRequestWithJobId:(NSString*)jobId reasonOfRejection:(NSString*)rejectionReason andOther:(NSString*)other
{
    // Should be overridden in derived class    
}

- (void)getJobDetailsOfJobWithId:(NSString*)jobId
{
    // Should be overridden in derived class    
}
- (void)AcceptQuoteForJob:(NSMutableDictionary *)result
{
    
}
- (void)sendKAcceptORCancelAppointmentWithBidId:(NSString*)bidId jobID:(NSString*)jobID actionType:(NSString *)actionType rejectReason:(NSString*)reason
{
    
}
- (void)sendSetAnAppointmentTime:(NSString *)bidID:(NSString*)date :(NSString *)time
{
    
}

- (void)markPrivetConversationWithBidId:(NSString *)bidID andMessageId:(NSString*)messageId asRead:(NSString *)status
{

}

- (void)markPublicConversationWithJobId:(NSString *)jobID andQuestionId:(NSString*)questionId asRead:(NSString *)status
{
    
}

- (void)resetPasswordViaEmail:(NSString*)email
{
    
}
- (void)sendKConfirmAppointmentWithBidId:(NSString*)bidId 
{
    
}
#pragma mark -

@end
