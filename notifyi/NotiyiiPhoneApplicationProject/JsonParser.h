//
//  JsonParser.h
//  EducatedPatient
//
//  Created by Joseph on 26/12/11.
//  Copyright (c) 2011 Intellisphere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotifyiConstants.h"

//Operation type
typedef enum ParseServiseType 
{
    LoginAPI = 1,
    InboxAPI = 2,
    ReadMessageAPI = 3,
    ReadCommentAPI = 4,
    DeleteMsgAPI = 5,
    RestoreMsgAPI = 6, 
    ComposeAPI = 7, 
    TouchBaseAPI = 8, 
    RemoveMeAPI = 9,
    AddParticipantAPI = 10,
    StartDiscussionAPI = 11,
    DirectoryAPI = 12,
    DeletePhysicianAPI = 13,
    MyProfileAPI = 14, 
    CoverageCalendarAPI = 15,
    pushNotificationAPI = 16, 
    SenderResolutionAPI = 17,
    NewCommentsAPI = 18,
    SingleDirectoryDetail = 19,
    ReadDiscussionAPI = 20,
} ParseServiseType;

typedef enum APITypes 
{
    AllInboxAPI = 1,
    SearchInboxAPI = 2,
    AllDirectoryAPI = 3, 
    SearchDirectoryAPI = 4 
    
} APITypes;

@protocol JsonParserDelegate <NSObject>

-(void)parseCompleteSuccessfully:(ParseServiseType)eparseType :(NSArray *)result;
-(void)parseFailedWithError:(ParseServiseType)eparseType :(NSError *)error :(int)errorCode;
-(void)parseWithInvalidMessage:(NSArray *)result;
-(void)netWorkNotReachable;
@end

@interface JsonParser : NSObject{
    
    NSMutableData   * responseData;
    NSMutableArray  * resultData;
    ParseServiseType eparseTypess;
    
    APITypes APIType;
    
     id<JsonParserDelegate>delegate;
}
@property(nonatomic,strong)id<JsonParserDelegate>delegate;
@property(nonatomic,assign)APITypes APIType;

-(void)parseJson:(ParseServiseType) eparseType:(NSString *)jsonRequest;
-(void) touchBaseDataInsertion:(NSDictionary *)results;
-(void) directoryDataInsertion:(NSDictionary *)results;
-(void)inboxDataInsertion:(NSDictionary *)results;
-(void)cacheImages:(NSString *)imgUrl;

@end
