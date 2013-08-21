//
//  RBBaseHttpHandler.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBURLHandler.h"
#import "ASIHTTPRequest.h"
#import "RBJobRequest.h"
#import "ASIFormDataRequest.h"
#import "RBRequestInfo.h"
#include "SBJson.h"

@protocol RBBaseHttpHandlerDelegate <NSObject>
@required
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request;
- (void)requestCompletedWithErrors:(ASIHTTPRequest *)theRequest;
@optional
- (void)sessionValid:(BOOL)status;
@end


@interface RBBaseHttpHandler : NSObject
{
    id <RBBaseHttpHandlerDelegate> delegate;
  //  RBHTTPRequestType requestType;
    BOOL clearCurrentQueue;

}

@property (nonatomic, retain) id delegate;
//@property (nonatomic, assign) RBHTTPRequestType requestType;
@property (nonatomic, assign) BOOL clearCurrentQueue;

+ (void)setSessionCookie: (NSHTTPCookie *)cookie;
+ (NSHTTPCookie *)getSessionCookie;
+ (void)saveSession;
+ (void)clearSession;
+ (BOOL)isSessionInfoAvailable;
- (void)saveTheCookie:(ASIHTTPRequest*)request;
- (BOOL)extractSuccessKeyValue:(NSDictionary*)responseDictionary;
- (BOOL)connected;
+ (RBHTTPRequestType)getRequestType:(ASIHTTPRequest*)request;
- (void)trackRequestError:(ASIHTTPRequest*)request;

- (void)postRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestType:(RBHTTPRequestType)requestType;
- (void)postRequest:(NSString*)apiName RequestBody:(NSString*)strRequest withRequestType:(RBHTTPRequestType)requestType;
- (void)getRequest:(NSString*)apiName withRequestType:(RBHTTPRequestType)requestType;
- (void)getRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestType:(RBHTTPRequestType)requestType;

// Functions to be overridden
- (void)sendLoginRequestWithUsername:(NSString*)username andPassword:(NSString*)password;
- (void)sendLogoutRequest;
- (void)sendSessionExpiryRequest;
- (void)sendSignUpRequestWithUsername:(NSString*)email andPassword:(NSString*)password:(NSString*)telephoneNumber;
- (void)sendEmailNotTakenRequest:(NSString*)email;
- (void)sendUsernameNotTakenRequest:(NSString*)username;
- (void)sendContentRequest;
- (void)sendHashRequest;
- (BOOL)queueUploadRequests:(NSString *)fullPath ofMediaType:(RBMediaType)type;
- (void)prepareJobRequestPart1:(RBJobRequest*)jobRequest;
- (void)prepareJobRequestPart2;
- (void)sendAllJobsAndStatusRequest;
- (void)sendJobDetailsRequestWithJobId:(NSString*)jobId andDetails:(NSString*)details;
- (void)askOrAnswerPrivetQuestionRequestWithBidId:(NSString*)bidId andMessage:(NSString*)message;
- (void)answerPublicQuestionRequestWithJobId:(NSString*)jobId questionId:(NSString*)questionId andAnswer:(NSString*)answer;
- (void)getBidDetailsWithJobId:(NSString*)jobId andBidId:(NSString*)bidId;
- (void) cancelJobRequestWithJobId:(NSString*)jobId reasonOfRejection:(NSString*)rejectionReason andOther:(NSString*)other;
- (void)getJobDetailsOfJobWithId:(NSString*)jobId;
- (void)AcceptQuoteForJob:(NSMutableDictionary *)result;
- (void)sendKAcceptORCancelAppointmentWithBidId:(NSString*)bidId jobID:(NSString*)jobID actionType:(NSString *)actionType rejectReason:(NSString*)reason;
- (void)sendSetAnAppointmentTime:(NSString *)bidID:(NSString*)date :(NSString *)time;
- (void)markPrivetConversationWithBidId:(NSString *)bidID andMessageId:(NSString*)messageId asRead:(NSString *)status;
- (void)markPublicConversationWithJobId:(NSString *)jobID andQuestionId:(NSString*)questionId asRead:(NSString *)status;
- (void)resetPasswordViaEmail:(NSString*)email;
- (void)sendKConfirmAppointmentWithBidId:(NSString*)bidId ;
@end
