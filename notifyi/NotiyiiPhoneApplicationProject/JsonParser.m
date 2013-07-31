
//
//  JsonParser.m
//  EducatedPatient
//
//  Created by Joseph on 26/12/11.
//  Copyright (c) 2011 Intellisphere. All rights reserved.
//

#import "JsonParser.h"
#import "TouchBaseViewController.h"
#import "SBJSON.h"
#import "JSON.h"
#import "TouchBase.h"
#import "Comments.h"
#import "DiscussionParticipants.h"
#import "DataManager.h"
#import "Utilities.h"
#import "Inbox.h"
#import "MsgRecipient.h"
#import "Directory.h"
#import "Reachability.h"
#import "MyProfile.h"
#import "CoverageCalendar.h"
#import "TimeStamp.h"
#import "DateFormatter.h"

@interface JsonParser ()
{
    BOOL isExistingDirectoryObj;
}
-(NSString *)setInboxParameters:(ParseServiseType)eparseType;
-(NSString *)setReadMessageParameters:(ParseServiseType)eparseType;
-(NSString *)setDirectoryParameters:(ParseServiseType)eparseType;
-(NSString *)setMyprofileParameters:(ParseServiseType)eparseType;
-(NSString *)setCoverageCalenderParameters:(ParseServiseType)eparseType;
-(NSString *)setTouchBaseParameters:(ParseServiseType)eparseType;
-(NSString *)getPathDocAppendedBy:(NSString *)_appString;
-(BOOL)existImage:(NSString *)name;

-(void)loginDataInsertion:(NSDictionary *)results;
-(void)inboxDataInsertion:(NSDictionary *)results;
-(void)touchBaseDataInsertion:(NSDictionary *)results;
-(void)directoryDataInsertion:(NSDictionary *)results;
-(void)profileDataInsertion:(NSDictionary *)results;
-(void)coverageCalenderDataInsertion:(NSDictionary *)results;
-(void)readMessageUpdation:(NSDictionary *)results;
-(void)composeMessageUpdation:(NSDictionary *)results;
-(void)startDiscussionUpdation:(NSDictionary *)results;
-(void)newCommentsUpdation:(NSDictionary *)results;
-(void)addParticipantsUpdation:(NSDictionary *)results;
-(void)removeParticipantsUpdation:(NSDictionary *)results;
-(void)readPushNotificationDeviceTockenResponse:(NSDictionary *)results;
-(void)readCommentUpdation:(NSDictionary *)results;
-(void)deleteMessageUpdation:(NSDictionary *)results;
-(void)singleDirectoryDataInsertion:(NSDictionary *)results;

- (NSString *)lastUpdateddateFromTimeStamp :(ParseServiseType)eparseType;

-(MsgRecipient*)fetchEntityObjectForMsgRecipient:(NSString *)entityName selectBy:(int)recipientID;
-(id)fetchEntityObjectForDirectory:(NSString *)entityName selectBy:(int)physicianID;
-(DiscussionParticipants *)fetchEntityObjectForDiscussionParticipents:(NSString *)entityName selectBy:(int)participentID;
-(id)fetchEntityObjectForComments:(NSString *)entityName selectBy:(int)commentsID;

-(void)errorHandler;

- (BOOL)updateTimeStampEntity:(NSString *)date operatioTypeValue:(int)operationType;

@end

@implementation JsonParser

@synthesize delegate;
@synthesize APIType;

#pragma mark- NSURLConnection delegate methods

-(void)parseJson:(ParseServiseType)eparseType :(NSString *)jsonRequest
{
    if ([Reachability connected])
    {
        NSLog(@"******* %@",jsonRequest);
        NSMutableURLRequest        *request;
        NSURLConnection            *theConnection;
        NSString                   *requestDataLengthString;
        NSData                     *requestData;
        NSData                     *requestBody;
        
        eparseTypess=eparseType;
        
        responseData = [NSMutableData data];
        
        switch (eparseType) {
                
            case LoginAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@&operationType=%d",LOGIN_FETCH_URL,jsonRequest,eparseType];
                
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLWithParameters]];
                NSLog(@"request==%@",request);
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
            case InboxAPI:
            {
                
                NSString *URLWithParameters = [self setInboxParameters:eparseType];
                URLWithParameters = [URLWithParameters stringByAppendingFormat:@"%@",jsonRequest];
                NSLog(@"%@",URLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case TouchBaseAPI:
            {
                NSString *touchBaseURLWithParameters = [self setTouchBaseParameters:eparseType];
                touchBaseURLWithParameters = [touchBaseURLWithParameters stringByAppendingFormat:@"%@",jsonRequest];
                NSLog(@"%@",touchBaseURLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:touchBaseURLWithParameters]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
                
            case DirectoryAPI:
            {
                NSString *directoryURLWithParameters = [self setDirectoryParameters:eparseType];
                directoryURLWithParameters = [directoryURLWithParameters stringByAppendingFormat:@"%@",jsonRequest];
                NSLog(@"%@",directoryURLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[directoryURLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case MyProfileAPI:
            {
                NSString *profileURLWithParameters = [self setMyprofileParameters:eparseType];
                NSLog(@"%@",profileURLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:profileURLWithParameters]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
            case CoverageCalendarAPI:
            {
                NSString *coverageCalenderURLWithParameters = [self setCoverageCalenderParameters:eparseType];
                NSLog(@"%@",coverageCalenderURLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:coverageCalenderURLWithParameters]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
            case ReadMessageAPI:
            {
                NSString *readMailURLWithParameters = [self setReadMessageParameters:eparseType];
                readMailURLWithParameters = [readMailURLWithParameters stringByAppendingFormat:@"%@",jsonRequest];
                NSLog(@"%@",readMailURLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[readMailURLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case ReadDiscussionAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",READ_DISCUSSION_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
                
            }
                break;
           
            case ReadCommentAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",READ_COMMENT_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
                
            }
                break;

            case DeleteMsgAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",DELETE_MESSAGE_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case ComposeAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",COMPOSE_MESSAGE_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case StartDiscussionAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",START_DISCUSSION_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case NewCommentsAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",NEW_COMMENTS_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
            case AddParticipantAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",ADD_PARTICIPANT_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case RemoveMeAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",REMOVE_PARTICIPANT_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
                requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLWithParameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case pushNotificationAPI:
            {
                NSString *URLWithParameters = [NSString stringWithFormat:@"%@%@",PUSHNOTIFICATION_URL,jsonRequest];
                NSLog(@"%@",URLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLWithParameters]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            case SingleDirectoryDetail:
            {
                NSString *singleDirectoryURLWithParameters = [NSString stringWithFormat:@"%@%@",SINGLE_DIRECTORYDETAIL_URL,jsonRequest];
                NSLog(@"%@",singleDirectoryURLWithParameters);
                request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:singleDirectoryURLWithParameters]];
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestBody];
                [request setTimeoutInterval:45.0];
                theConnection = [NSURLConnection connectionWithRequest:request  delegate:self];
            }
                break;
                
            default:
                
                NSLog(@"fail");
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(netWorkNotReachable)])
        {
            [self.delegate netWorkNotReachable];
        }
    }
}


#pragma mark- parser Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //    NSLog(@"didReceiveResponse");
    NSLog(@"didReceiveResponse===%@",response);
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //    NSLog(@"didReceiveData");
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    int errorCode = 605;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(parseFailedWithError:::)])
    {
        [self.delegate parseFailedWithError:eparseTypess:(NSError *)error:(int)errorCode];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"response String==%@",responseString);
    NSDictionary *results = [responseString JSONValue];
    responseString = nil;
    
    if (eparseTypess == LoginAPI)
    {
        [self loginDataInsertion:results];
    }
    else if( eparseTypess == InboxAPI)
    {
        [self inboxDataInsertion:results];
    }
    else if(eparseTypess==TouchBaseAPI)
    {
        [self touchBaseDataInsertion:results];
    }
    else if(eparseTypess==DirectoryAPI)
    {
        [self directoryDataInsertion:results];
    }
    else if(eparseTypess==MyProfileAPI)
    {
        [self profileDataInsertion:results];
    }
    else if(eparseTypess==CoverageCalendarAPI)
    {
        [self coverageCalenderDataInsertion:results];
    }
    else if(eparseTypess==ReadMessageAPI)
    {
        [self readMessageUpdation:results];
    }
    else if(eparseTypess==DeleteMsgAPI)
    {
        [self deleteMessageUpdation:results];
    }
    else if(eparseTypess==ComposeAPI)
    {
        [self composeMessageUpdation:results];
    }
    else if(eparseTypess==StartDiscussionAPI)
    {
        [self startDiscussionUpdation:results];
    }
    else if(eparseTypess==NewCommentsAPI)
    {
        [self newCommentsUpdation:results];
    }
    else if(eparseTypess==AddParticipantAPI)
    {
        [self addParticipantsUpdation:results];
    }
    else if(eparseTypess==RemoveMeAPI)
    {
        [self removeParticipantsUpdation:results];
    }
    else if(eparseTypess==pushNotificationAPI)
    {
        [self readPushNotificationDeviceTockenResponse:results];
    }
    else if(eparseTypess==SingleDirectoryDetail)
    {
        [self singleDirectoryDataInsertion:results];
    }
    else if(eparseTypess==ReadCommentAPI)
    {
        [self readCommentUpdation:results];
    }
    else if (eparseTypess==ReadDiscussionAPI)
    {
        [self readDiscussionUpdation:results];
    }
}

-(void)errorHandler
{
    int errorCode = 605;
    NSError *error;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(parseFailedWithError:::)])
    {
        [self.delegate parseFailedWithError:eparseTypess:(NSError *)error:(int)errorCode];
    }
    
}

#pragma mark- Parsing

-(void)loginDataInsertion:(NSDictionary *)results
{
    NSLog(@"loginDataInsertion==%@",results);
    if (results)
    {
        NSArray *loginResponse = [results  objectForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        
        if ([loginResponse count])
        {
            NSString *resultResponseCode = [loginResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [loginResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *loginDetails = [results  objectForKey:@"Details"];
                
                if ([loginDetails count])
                {
                    // New Locat DB Sync
                    NSString * userName = [loginDetails valueForKey:@"UserName"];
                    
                    NSString  * oldUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
                    
                    if ([userName isEqualToString:oldUserID])
                    {
                        // keep only the latest 30 records
                        
                        //1. Get today's date
                        NSDate *today =  [DateFormatter getDateInGMTFormat:[NSDate date]];
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                        [gregorian setTimeZone:[NSTimeZone defaultTimeZone]];
                        NSLog(@"1 Today %@", today);
                        
                        
                        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                        [offsetComponents setDay:-30];
                        NSDate *thirtyDaybackDate = [gregorian dateByAddingComponents:offsetComponents toDate: today options:0];
                        NSLog(@"30 day back %@", thirtyDaybackDate);
                        
                        
                        NSArray * latestMessages = [DataManager getInboxDetails:0 startDate:today endDate:thirtyDaybackDate];
                        
                        int latestMessagesCount = [latestMessages count];
                        if (latestMessagesCount > 30)//For keeping the latest 30 messages in Local DB
                        {
                            for (int i = 31;i < latestMessagesCount; i ++)
                            {
                                Inbox *inbox = [latestMessages objectAtIndex:i];
                                [DataManager deleteMangedObject:inbox];
                            }
                        }
                    }
                    else
                    {
                        [[CoreDataHandler sharedHandler] resetPersistentStoreCoordinator];
                        
                        
                        [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
                    }
                    
                    //local saving
                    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"USERNAME"];
                    NSString * userID = [loginDetails valueForKey:@"UserId"];
                    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"USERID"];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FirstLoginDirectory"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLoginCoverageCalender"];
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                    {
                        [self.delegate parseCompleteSuccessfully:eparseTypess :[results objectForKey:@"service response"]];
                    }
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:loginResponse];
                }
            }
        }
        
        else
        {
            int errorCode = 605;
            NSError *error;
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(parseFailedWithError:::)]){
                [self.delegate parseFailedWithError:eparseTypess:(NSError *)error:(int)errorCode];
            }
        }
    }
}

-(void)inboxDataInsertion:(NSDictionary *)results
{
    NSLog(@"inboxDataInsertion==%@",results);

    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    NSMutableArray *inboxResponse = [results  objectForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
    NSMutableDictionary *inboxDict;
    NSMutableDictionary *recipientDict;
    NSArray *recipentDatas;
    
    if ([inboxResponse count]>0)
    {
        NSString *resultResponseCode = [inboxResponse valueForKey:@"response code"];
        NSString *operationTypeFromServer = [inboxResponse valueForKey:@"operationType"];
        NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
        NSArray *deletedMessages = [inboxResponse valueForKey:@"DeletedRecordsID"];
        int deletedMesgCount = [deletedMessages count];
        for (int i = 0; i < deletedMesgCount; i ++)
        {
            int deletedMesssageID = [[deletedMessages objectAtIndex:i] intValue];
            NSArray *result = [DataManager fetchExistingDeletedServerInboxEntityObject:INBOX messageID:deletedMesssageID];
            int resultCount = [result count];
            for (int k = 0; k < resultCount; k ++)
            {
                Inbox *inbox = [result objectAtIndex:k];
                
                [DataManager deleteMangedObject:inbox];
            }
            
        }
        if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
        {
            NSArray *inboxDetails = [results  objectForKey:@"Details"];
            if ([inboxDetails count])
            {
                int inboxCount = [inboxDetails count];
                int recipientsCount = 0;
                int directoryRecipentCount = 0;
                NSArray *existingInboxRecipentListArray;
                NSArray *existingDirectoryRecipentListArray;
                
                BOOL isSaved;
                
                for (int i = 0; i < inboxCount; i ++)
                {
                    inboxDict = [inboxDetails objectAtIndex:i];
                    NSLog(@"InboxDict==%@",inboxDict);
                    Inbox *inbox = [DataManager fetchExistingInboxEntityObject:INBOX messageID:[[inboxDict objectForKey:@"MessageId"] intValue] messageType:[[inboxDict objectForKey:@"MessageType"] intValue]];
                    
                    
                    if (!inbox)
                    {
                        inbox = [DataManager createEntityObject:@"Inbox"];
                    }
                    else
                    {
                        //its an updation in the inbox list
                        existingInboxRecipentListArray = [inbox.recipientmessageID allObjects];
                        recipientsCount                = [existingInboxRecipentListArray count];
                        
                        existingDirectoryRecipentListArray = [inbox.recipientContacts allObjects];
                        directoryRecipentCount = [existingDirectoryRecipentListArray count];
                    }
                    
                    NSString *senderName = [inboxDict objectForKey:@"senderName"];
                    senderName = [senderName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    inbox.senderName = senderName;
                    
                    int senderID = [[inboxDict objectForKey:@"senderID"] intValue];
                    inbox.senderID = [NSNumber numberWithInt:senderID];
                    
                    
                    inbox. messageId   = [NSNumber  numberWithInt:[[inboxDict objectForKey:@"MessageId"] intValue]];
                    inbox. messageType   = [NSNumber  numberWithInt:[[inboxDict objectForKey:@"MessageType"] intValue]];
                    inbox.readStatus   = [inboxDict objectForKey:@"ReadStatu"];
                    
                    if(![[inboxDict objectForKey:@"Subject"] isEqual:[NSNull null]])
                    {
                        NSLog(@"Subject not null");
                        NSLog(@"%@",[inboxDict objectForKey:@"Subject"]);
                        NSString *subject = [inboxDict objectForKey:@"Subject"];
                        subject = [subject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        inbox.subject = subject;
                    }
                    else
                    {
                        NSLog(@"Subject null");
                        inbox.subject =@"";
                    }
                    
                    if(![[inboxDict objectForKey:@"deleteFrom"] isEqual:[NSNull null]])
                    {
                        NSLog(@"deleteFrom not null");
                        inbox. deleteFrom   = [NSNumber  numberWithInt:[[inboxDict objectForKey:@"deleteFrom"] intValue]];
                    }
                    else
                    {
                        NSLog(@"deleteFrom null");
                    }
                    
                    
                    if(![[inboxDict objectForKey:@"Date"] isEqual:[NSNull null]])
                    {
                        NSLog(@"not null");
                        NSDate *inboxDate = [DateFormatter getDateFromDateString:[inboxDict objectForKey:@"Date"] forFormat:@"MM/dd/yyyy hh:mm a"];
                        inbox. date  = inboxDate;
                    }
                    
                    if(![[inboxDict objectForKey:@"patientDOB"] isEqual:[NSNull null]])
                    {
                        NSLog(@"not null");
                        NSDate *inboxPatientDOB = [DateFormatter getDateFromDateString:[inboxDict objectForKey:@"patientDOB"] forFormat:@"MM/dd/yyyy"];
                        inbox. patientDOB  = inboxPatientDOB;
                    }
                    else
                    {
                        NSLog(@"null");
                    }
                    
                    if(![[inboxDict objectForKey:@"patientFirstName"] isEqual:[NSNull null]])
                    {
                        inbox. patientFirstName   = [inboxDict objectForKey:@"patientFirstName"];
                    }
                    else
                    {
                        inbox. patientFirstName   = @"";
                    }
                    if(![[inboxDict objectForKey:@"patientLastName"] isEqual:[NSNull null]])
                    {
                        inbox. patientLastName   = [inboxDict objectForKey:@"patientLastName"];
                    }
                    else
                    {
                        inbox. patientLastName   = @"";
                    }
                    if(![[inboxDict objectForKey:@"patientFirstName"] isEqual:[NSNull null]])
                    {
                        inbox. textMessageBody   = [inboxDict objectForKey:@"TextMessageBody"];
                    }
                    else
                    {
                        inbox. textMessageBody   = @"";
                    }
                    
                    //Handling mail Recipients
                    recipentDatas = [inboxDict objectForKey:@"Recipients"];
                    
                    if ([recipentDatas count]>0)
                    {
                        int recipientArrayCount = [recipentDatas count];
                        for (int j = 0; j < recipientArrayCount; j ++)
                        {
                            BOOL  isExistingRecipientObj = NO;
                            isExistingDirectoryObj = NO;
                            
                            MsgRecipient *msgRecipient;
                            Directory *directory;
                            
                            recipientDict = [recipentDatas objectAtIndex:j];
                            int recipientID = [[recipientDict objectForKey:@"RecipientId"] intValue];
                            
                            NSLog(@"recipientDict###\n%@",recipientDict);
                            NSLog(@"RecipentID ####\n %d",recipientID);
                            
                            if (recipientsCount > 0)
                            {
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.recipientId = %d",recipientID];
                                NSArray *recipientEntityObject = [existingInboxRecipentListArray filteredArrayUsingPredicate:predicate];
                                
                                if ([recipientEntityObject count] == 0)
                                {
                                    //no existing object
                                    msgRecipient = [self fetchEntityObjectForMsgRecipient:@"MsgRecipient" selectBy:recipientID];
                                }
                                else
                                {
                                    //using the same object
                                    isExistingRecipientObj = YES;
                                    msgRecipient = [recipientEntityObject objectAtIndex:0];
                                }
                            }
                            else
                            {
                                msgRecipient = [self fetchEntityObjectForMsgRecipient:@"MsgRecipient" selectBy:recipientID];
                                
                            }
                            NSString *docterName = [recipientDict objectForKey:@"RecipientName"];
                            docterName = [docterName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            msgRecipient.docterName = docterName;
                           
                            msgRecipient.isCC = [NSNumber numberWithInt:[[recipientDict objectForKey:@"isCC"] intValue]];
                            msgRecipient.recipientId = [NSNumber numberWithInt:[[recipientDict objectForKey:@"RecipientId"] intValue]];
                            
                            if(!isExistingRecipientObj)
                            {
                                [inbox addRecipientmessageIDObject:msgRecipient];
                                
                            }
                            else
                            {
                                NSLog(@"Existing obj");
                            }
                            
                            
                            if (directoryRecipentCount>0)
                            {
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.physicianId = %d",[[recipientDict objectForKey:@"RecipientId"] intValue]];
                                NSArray *recipientEntityObject = [existingDirectoryRecipentListArray filteredArrayUsingPredicate:predicate];
                                
                                if ([recipientEntityObject count] == 0)
                                {
                                    //no existing object
                                    directory = [self fetchEntityObjectForDirectory:@"Directory" selectBy:[[recipientDict objectForKey:@"RecipientId"] intValue]];
                                }
                                else
                                {
                                    //using the same object
                                    isExistingDirectoryObj = YES;
                                    directory = [recipientEntityObject objectAtIndex:0];
                                }
                            }
                            else
                            {
                                directory = [self fetchEntityObjectForDirectory:@"Directory" selectBy:[[recipientDict objectForKey:@"RecipientId"] intValue]];
                                
                            }
                            
                            directory.physicianId = [NSNumber numberWithInt:[[recipientDict objectForKey:@"RecipientId"] intValue]];
                            NSString *physicianName = [recipientDict objectForKey:@"RecipientName"];
                            physicianName = [physicianName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            
                            directory.physicianName = physicianName;
                            
                            if(!isExistingDirectoryObj)
                            {
                                directory.physicianImage = @"NoImage";
                                directory.city = @"";
                                directory.state = @"NULL";
                                directory.phone = @"";
                                directory.faxNumber = @"";
                                [inbox addRecipientContactsObject:directory];
                                
                            }
                            else
                            {
                                NSLog(@"Existing obj");
                            }
                            
                            [DataManager saveContext];
                        }
                        
                    }
                    
                    isSaved = [DataManager saveContext];
                    
                    if(inbox)
                        [resultArray addObject:inbox];
                    
                    inbox = nil;
                    
                }
                if(isSaved)
                {
                    if (APIType == AllInboxAPI)
                    {
                        int pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"InboxPageNumber"] intValue];
                        pageNumber = pageNumber + 1;
                        [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"InboxPageNumber"];
                                                
                    }
                    else if(APIType == SearchInboxAPI)
                    {
                        int pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"InboxSearchPageNumber"] intValue];
                        pageNumber = pageNumber + 1;
                        [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"InboxSearchPageNumber"];
                                                
                    }
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                    {
                        [self.delegate parseCompleteSuccessfully:eparseTypess :resultArray];
                    }
                    
                }
            }
            else
            {
                if (APIType == AllInboxAPI)
                {
                    int balanceCount = [[inboxResponse valueForKey:@"balanceCount"]intValue];
                    
                    if (balanceCount == 0)
                    {
                        NSString *stringAsDate = [inboxResponse valueForKey:@"lastUpdatedDate"];
                        int operatioTypeValue = [[inboxResponse valueForKey:@"operationType"] intValue];
                        
                        [self updateTimeStampEntity:stringAsDate operatioTypeValue:operatioTypeValue];
                        
                    }
                    
                }
                else if(APIType == SearchDirectoryAPI)
                {
                    int resetPageNumber = 0;
                    [[NSUserDefaults standardUserDefaults] setInteger:resetPageNumber forKey:@"InboxSearchPageNumber"];
                }
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                {
                    [self.delegate parseCompleteSuccessfully:eparseTypess :nil];
                }
            }
            
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
            {
                [self.delegate parseWithInvalidMessage:inboxResponse];
            }
        }
    }
    else
    {
        [self errorHandler];
    }
    
}

-(void) touchBaseDataInsertion:(NSDictionary *)results
{
    NSLog(@"touchBaseDataInsertion==%@",results);

    if ([results count]>0)
    {
        NSLog(@"touchbaseDetails==%@",results);
        NSMutableArray * resultArray = [[NSMutableArray alloc] init];
        
        NSArray* touchBaseResponse = [results valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        NSString *resultResponseCode = [touchBaseResponse valueForKey:@"response code"];
        NSString *operationTypeFromServer = [touchBaseResponse valueForKey:@"operationType"];
        NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
        
        if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
        {
            NSMutableArray * touchBaseDetails = [results  objectForKey:@"details"];
            
            int commentCount = 0;
            NSArray *commentListArray;
            
            NSMutableDictionary *touchBaseDict;
            int discussionParticipantsCount = 0;
            NSArray *discussionParticipantsListArray;
            int touchBaseCount = [touchBaseDetails count];
            
            int directoryRecipentCount = 0;
            NSArray *existingDirectoryRecipentListArray;
            
            BOOL isSaved;
            
            for (int i=0; i<touchBaseCount; i++)
            {
                touchBaseDict = [touchBaseDetails objectAtIndex:i];
                
                TouchBase  * touchBase = [DataManager fetchExistingEntityTouchBaseObject:TOUCHBASE discussionId:[touchBaseDict objectForKey:DISCUSSIONID]];
                if (!touchBase)
                {
                    touchBase = [DataManager createEntityObject:TOUCHBASE];
                }
                else
                {
                    commentListArray = [touchBase.commentID allObjects];
                    commentCount = [commentListArray count];
                    
                    discussionParticipantsListArray = [touchBase.participantsID allObjects];
                    discussionParticipantsCount = [discussionParticipantsListArray count];
                    
                    existingDirectoryRecipentListArray = [touchBase.participantsID allObjects];
                    directoryRecipentCount = [existingDirectoryRecipentListArray count];
                    
                }
                touchBase.discussionId = [NSString stringWithFormat:@"%@", [[touchBaseDict objectForKey:DISCUSSIONID] stringValue]];
                touchBase.textDiscussion = [NSString stringWithFormat:@"%@",[touchBaseDict objectForKey:TEXTDISCUSSION]];
                touchBase.subject = [touchBaseDict objectForKey:SUBJECT];
                
                NSString *discussionOwner = [touchBaseDict objectForKey:@"senderName"];
                discussionOwner = [discussionOwner stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                touchBase.discussionOwner = discussionOwner;
                
                //***************
                
                NSString *postedDate = [touchBaseDict objectForKey:@"PostedOn"];
                touchBase.discussionDate = [DateFormatter getDateFromDateString:postedDate forFormat:@"MM/dd/yyyy hh:mm a"];
                NSLog(@"discussionDate : %@",touchBase.discussionDate);
                
                //**************
                
                int touchBaseCommentsCount = [[touchBaseDict objectForKey:COMMENTS] count];
                for (int j=0; j<touchBaseCommentsCount; j++)
                {
                    Comments *commentsObj;
                    int commetID = [[[[touchBaseDict objectForKey:COMMENTS] objectAtIndex:j] objectForKey:COMMENTID] intValue];
                    if (commentCount > 0)
                    {
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.commentsId = %d",commetID];
                        
                        NSArray *commentEntityObject = [commentListArray filteredArrayUsingPredicate:predicate];
                        if ([commentEntityObject count] == 0)
                        {
                            //no existing object
                            commentsObj = [self fetchEntityObjectForComments:@"Comments" selectBy:commetID];
                        }
                        else
                        {
                            //using the same object
                            commentsObj = [commentEntityObject objectAtIndex:0];
                        }
                    }
                    else
                    {
                        commentsObj = [self fetchEntityObjectForComments:@"Comments" selectBy:commetID];
                    }
                    
                    commentsObj.commentsId = [NSNumber numberWithInt:[[[[touchBaseDict objectForKey:COMMENTS] objectAtIndex:j] objectForKey:COMMENTID] intValue]];
                    commentsObj.comments = [[[touchBaseDict objectForKey:COMMENTS] objectAtIndex:j] objectForKey:COMMENTDESCRIPTION];
                    
                    NSString * commentStatusString = [[[touchBaseDict objectForKey:COMMENTS] objectAtIndex:j] objectForKey:COMMENTSTATUS];
                    if(![commentStatusString isEqual:[NSNull null]])
                    {
                        commentsObj.commentStatus = [[[[touchBaseDict objectForKey:COMMENTS] objectAtIndex:j] objectForKey:COMMENTSTATUS] stringValue];;
                    }
                    else
                    {
                        commentsObj.commentStatus = @"";
                    }
                    NSLog(@"commentsObj.commentsId==%@",commentsObj.commentsId);
                    NSLog(@"commentsObj.comments==%@",commentsObj.comments);
                    NSLog(@"commentsObj.commentStatus==%@",commentsObj.commentStatus); 
                    
                    commentsObj.commentDate = [DateFormatter getDateFromDateString:[[[touchBaseDict objectForKey:COMMENTS] objectAtIndex:j] objectForKey:COMMENTDATE] forFormat:@"MM/dd/yyyy hh:mm a"];
                    
                    NSLog(@"commentDate : %@",commentsObj.commentDate);
                    
                    NSString *commentPersonName = [[[touchBaseDict objectForKey:COMMENTS] objectAtIndex:j] objectForKey:COMMENTPERSONNAME];
                    commentPersonName = [commentPersonName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    commentsObj.commentPersonName = commentPersonName;

                    
                    commentsObj.commentPersonId = [NSNumber numberWithInt:[[[[touchBaseDict objectForKey:COMMENTS] objectAtIndex:j] objectForKey:COMMENTPERSONID] intValue]];
                    [touchBase addCommentIDObject:commentsObj];
                }
                int touchBaseParticipantsCount = [[touchBaseDict objectForKey:PARTICIPANTS] count];
                for (int j=0; j<touchBaseParticipantsCount; j++)
                {
                    
                    
                    DiscussionParticipants *discussionParticipantsObj;
                    Directory *directory;
                    int discussionID = [[[[touchBaseDict objectForKey:PARTICIPANTS] objectAtIndex:j] objectForKey:PARTICIPANTID] intValue];
                    
                    if (discussionParticipantsCount > 0)
                    {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.participantId = %d",discussionID];
                        
                        NSArray *commentEntityObject = [discussionParticipantsListArray filteredArrayUsingPredicate:predicate];
                        if ([commentEntityObject count] == 0)
                        {
                            //no existing object
                            discussionParticipantsObj = [self fetchEntityObjectForDiscussionParticipents:DISCUSSIONPARTICIPANTS selectBy:discussionID];
                        }
                        else
                        {
                            //using the same object
                            discussionParticipantsObj = [commentEntityObject objectAtIndex:0];
                        }
                    }
                    else
                    {
                        discussionParticipantsObj = [self fetchEntityObjectForDiscussionParticipents:DISCUSSIONPARTICIPANTS selectBy:discussionID];
                        
                    }
                    
                    
                    discussionParticipantsObj.participantId = [NSNumber numberWithInt:[[[[touchBaseDict objectForKey:PARTICIPANTS] objectAtIndex:j] objectForKey:PARTICIPANTID] intValue]];
                    
                    NSString *participantName = [[[touchBaseDict objectForKey:PARTICIPANTS] objectAtIndex:j] objectForKey:PARTICIPANTNAME];
                    participantName = [participantName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    discussionParticipantsObj.participantName = participantName;

                    NSLog(@"discussionParticipantsObj.participantId==%@",discussionParticipantsObj.participantId);
                    NSLog(@"discussionParticipantsObj.participantName==%@",discussionParticipantsObj.participantName);
                    
                    
                    [touchBase addParticipantsIDObject:discussionParticipantsObj];
                    [DataManager saveContext];
                    
                    directory = [self fetchEntityObjectForDirectory:@"Directory" selectBy:[discussionParticipantsObj.participantId intValue]];
                    
                    NSLog(@"[NSNumber numberWithInt:[discussionParticipantsObj.participantId intValue]]===%d",[discussionParticipantsObj.participantId intValue]);
                    directory.physicianId = [NSNumber numberWithInt:[discussionParticipantsObj.participantId intValue]];
                    
                    NSString *physicianName = discussionParticipantsObj.participantName;
                    physicianName = [physicianName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    directory.physicianName = physicianName;
                    
                    if(!isExistingDirectoryObj)
                    {
                        directory.physicianImage = @"NoImage";
                        directory.city = @"";
                        directory.state = @"NULL";
                        directory.phone = @"";
                        directory.faxNumber = @"";
                        
                        //saving to directory entity
                        [DataManager saveContext];
                    }
                    else
                    {
                        NSLog(@"Existing obj");
                    }
                    
                    [DataManager saveContext];
                    //***************
                }
                
                if(touchBase)
                    [resultArray addObject:touchBase];
                
                isSaved = [DataManager saveContext];
                
            }
            if(isSaved)
            {
                int pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"TouchBasePageNumber"] intValue];
                pageNumber = pageNumber + 1;
                [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"TouchBasePageNumber"];
                                
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                {
                    [self.delegate parseCompleteSuccessfully:eparseTypess :resultArray];
                }
                
            }
            int balanceCount = [[touchBaseResponse  valueForKey:@"balanceCount"] integerValue];
            if (balanceCount == 0)// completed
            {
                int resetPageNumber = 0;
                [[NSUserDefaults standardUserDefaults] setInteger:resetPageNumber forKey:@"TouchBasePageNumber"];
                
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                {
                    [self.delegate parseCompleteSuccessfully:eparseTypess :nil];
                }
            }
            
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
            {
                [self.delegate parseWithInvalidMessage:touchBaseResponse];
            }
        }
    }
    else
    {
        [self errorHandler];
    }
    
}

-(void) singleDirectoryDataInsertion:(NSDictionary *)results
{
    NSLog(@"SingleDirectoryDetails==%@",results);
    if(results)
    {
        NSArray *singleDirectoryResponse = [results  objectForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([singleDirectoryResponse count])
        {
            NSString *resultResponseCode = [singleDirectoryResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [singleDirectoryResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *singleDirectoryDetails = [results  objectForKey:@"Details"];
                
                BOOL isSaved;
                
                if ([singleDirectoryDetails count])
                {
                    Directory  * directory;
                    DataManager *dataManager;
                    NSMutableDictionary *singleDirectoryDictionary;
                    if(dataManager)
                    {
                        dataManager = nil;
                    }
                    dataManager = [[DataManager alloc]init];
                    singleDirectoryDictionary = [singleDirectoryDetails objectAtIndex:0];
                    int physicianId = [[singleDirectoryDictionary objectForKey:PHYSICIANID]intValue ];
                    directory = [DataManager fetchExistingEntityObject:@"Directory" attributeName:@"physicianId" selectBy:physicianId];
                    if (!directory)
                    {
                        directory = [DataManager createEntityObject:@"Directory"];
                    }
                    
                    directory.physicianId = [NSNumber numberWithInt:physicianId];
                    
                    NSString *physicianName = [singleDirectoryDictionary objectForKey:PHYSICIANNAME];
                    physicianName = [physicianName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    directory.physicianName = physicianName;
                    directory.practice = [singleDirectoryDictionary objectForKey:PRACTICE];
                    directory.speciality = [singleDirectoryDictionary objectForKey:SPECIALITY];
                    directory.phone = [singleDirectoryDictionary objectForKey:PHONE];
                    directory.city = [singleDirectoryDictionary objectForKey:CITY];
                    directory.contactInfo = [singleDirectoryDictionary objectForKey:@"contactInfo"];
                    directory.faxStatus = [NSNumber numberWithInt:[[singleDirectoryDictionary objectForKey:@"faxStatus"] intValue]];
                    directory.inboxStatus = [NSNumber numberWithInt:[[singleDirectoryDictionary objectForKey:@"InboxStatus"] intValue]];
                    directory.coverageStatus = [NSNumber numberWithInt:[[singleDirectoryDictionary objectForKey:@"coverageStatus"] intValue]];
                    directory.faxNumber = [singleDirectoryDictionary objectForKey:@"faxNumber"];
                    NSLog(@"communicationPreference==%@",[singleDirectoryDictionary objectForKey:@"communicationPreference"]);
                    NSString *communicationPreference = [singleDirectoryDictionary objectForKey:@"communicationPreference"];
                    
                    if(![communicationPreference isEqual:[NSNull null]])
                    {
                        directory.communicationPreference = [singleDirectoryDictionary objectForKey:@"communicationPreference"];
                    }
                    else
                    {
                        directory.communicationPreference = @"";
                    }
                    
                    directory.state = [singleDirectoryDictionary objectForKey:@"state"];
                    
                    NSLog(@"directory.statedirectory.statedirectory.statedirectory.state%@",[singleDirectoryDictionary objectForKey:@"state"]);
                    
                    directory.status = [NSString stringWithFormat:@"%@",[singleDirectoryDictionary objectForKey:STATUS]];
                    
                    
                    NSString *imageName = [NSString stringWithFormat:@"%@_%@.png",directory.physicianName,directory.physicianId];
                    
                    NSString *imageURL = [singleDirectoryDictionary objectForKey:PHYSICIANTHUMBNAIL];
                    if([imageURL length])
                    {
                        directory.physicianImage = [singleDirectoryDictionary objectForKey:PHYSICIANTHUMBNAIL];
                        
                        NSArray * arrayOfThingsIWantToPassAlong = [NSArray arrayWithObjects:[singleDirectoryDictionary objectForKey:PHYSICIANTHUMBNAIL],imageName, nil];
                        
                        [NSThread detachNewThreadSelector:@selector(cacheImages:) toTarget:self withObject:arrayOfThingsIWantToPassAlong];
                        
                    }
                    else
                    {
                        directory.physicianImage = NULL;
                        
                        NSArray * arrayOfThingsIWantToPassAlong = [NSArray arrayWithObjects:[singleDirectoryDictionary objectForKey:PHYSICIANTHUMBNAIL],imageName, nil];
                        
                        [NSThread detachNewThreadSelector:@selector(cacheImages:) toTarget:self withObject:arrayOfThingsIWantToPassAlong];
                        
                    }
                    
                    if(directory)
                        isSaved = [DataManager saveContext];
                }
                else
                {
                    [self errorHandler];
                }
                if(isSaved)
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                    {
                        [self.delegate parseCompleteSuccessfully:eparseTypess :singleDirectoryDetails];
                    }
                }
                else
                {
                    NSLog(@"fail");
                }
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    [self.delegate parseWithInvalidMessage:singleDirectoryResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
}
-(void) directoryDataInsertion:(NSDictionary *)results
{
    NSLog(@"directoryDataInsertion==%@",results);

    if (results)
    {
        NSArray *directoryResponse = [results  objectForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        
        if ([directoryResponse count])
        {
            NSString *resultResponseCode = [directoryResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [directoryResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *directoryDetails = [results  objectForKey:@"Details"];
                
                if ([directoryDetails count])
                {
                    NSMutableArray * directoryArray = [[NSMutableArray alloc] init];
                    Directory  * directory;
                    NSMutableDictionary *directoryDictionary;
                    BOOL isSaved;
                    DataManager *dataManager;
                    if(dataManager)
                    {
                        dataManager = nil;
                    }
                    dataManager = [[DataManager alloc]init];
                    int directoryDetailsCount = [directoryDetails count];
                    for (int i=0; i<directoryDetailsCount; i++)
                    {
                        directoryDictionary = [directoryDetails objectAtIndex:i];
                        
                        directory = [DataManager fetchExistingEntityObject:@"Directory" attributeName:@"physicianId" selectBy:[[directoryDictionary objectForKey:PHYSICIANID] intValue]];
                        if (!directory)
                        {
                            directory = [DataManager createEntityObject:@"Directory"];
                        }
                        
                        directory.physicianId = [directoryDictionary objectForKey:PHYSICIANID];
                        
                        NSString *physicianName = [directoryDictionary objectForKey:PHYSICIANNAME];
                        physicianName = [physicianName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        directory.physicianName = physicianName;
                        directory.practice = [directoryDictionary objectForKey:PRACTICE];
                        directory.speciality = [directoryDictionary objectForKey:SPECIALITY];
                        directory.phone = [directoryDictionary objectForKey:PHONE];
                        directory.city = [directoryDictionary objectForKey:CITY];
                        directory.contactInfo = [directoryDictionary objectForKey:@"contactInfo"];
                        directory.faxStatus = [directoryDictionary objectForKey:@"faxStatus"];
                        directory.inboxStatus = [directoryDictionary objectForKey:@"InboxStatus"];
                        directory.coverageStatus = [directoryDictionary objectForKey:@"coverageStatus"];
                        directory.faxNumber = [directoryDictionary objectForKey:@"faxNumber"];
                        NSLog(@"communicationPreference==%@",[directoryDictionary objectForKey:@"communicationPreference"]);
                        NSString *communicationPreference = [directoryDictionary objectForKey:@"communicationPreference"];
                        
                        if(![communicationPreference isEqual:[NSNull null]])
                        {
                            directory.communicationPreference = [directoryDictionary objectForKey:@"communicationPreference"];
                        }
                        else
                        {
                            directory.communicationPreference = @"";
                        }
                        
                        directory.state = [directoryDictionary objectForKey:@"state"];
                        NSLog(@"directory.statedirectory.statedirectory.statedirectory.state%@",[directoryDictionary objectForKey:@"state"]);
                        
                        directory.status = [NSString stringWithFormat:@"%@",[directoryDictionary objectForKey:STATUS]];
                        
                        NSString *imageName = [NSString stringWithFormat:@"%@_%@.jpg",directory.physicianName,directory.physicianId];
                        
                        NSString *imageURL = [directoryDictionary objectForKey:PHYSICIANTHUMBNAIL];
                        NSLog(@"imageURL==%@",imageURL);

                        if([imageURL length])
                        {
                            directory.physicianImage = [directoryDictionary objectForKey:PHYSICIANTHUMBNAIL];
                            
                            NSArray * arrayOfThingsIWantToPassAlong = [NSArray arrayWithObjects:[directoryDictionary objectForKey:PHYSICIANTHUMBNAIL],imageName, nil];
                                                     
                            /*****************************/
                            
                            NSString *imgName = [NSString stringWithFormat:@"%@_%@.jpg",directory.physicianName,directory.physicianId];
                            BOOL imgExist = [self existImage:imgName];
                            if(imgExist){
                                NSLog(@"Existing Physician Image");
                            }
                            else{
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                NSString *cachePath = [paths objectAtIndex:0];
                                NSString *dataPath = [cachePath stringByAppendingPathComponent:@"IMAGES"];
                                BOOL isDir = NO;
                                NSError *error;
                                if (! [[NSFileManager defaultManager] fileExistsAtPath:dataPath isDirectory:&isDir] && isDir == NO)
                                {
                                    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
                                }
                                
                                cachePath =  [dataPath stringByAppendingPathComponent:imageName];
                                
                                NSURL *imageURL = [NSURL URLWithString:[arrayOfThingsIWantToPassAlong objectAtIndex:0]];
                                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                                [imageData writeToFile:cachePath atomically:YES];
                            }                            
                            /*****************************/                            
                            //[NSThread detachNewThreadSelector:@selector(cacheImages:) toTarget:self withObject:arrayOfThingsIWantToPassAlong];
                        }
                        else
                        {
                            directory.physicianImage = NULL;
                        }
                        if(directory)
                            [directoryArray addObject:directory];
                        
                        isSaved = [DataManager saveContext];
                    }
                    if(isSaved)
                    {
                        if (APIType == AllDirectoryAPI)
                        {
                            int pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DirectoryPageNumber"] intValue];
                            pageNumber = pageNumber + 1;
                            [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"DirectoryPageNumber"];
                        }
                        else if(APIType == SearchDirectoryAPI)
                        {
                            int pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DirectorySearchPageNumber"] intValue];
                            pageNumber = pageNumber + 1;
                            [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"DirectorySearchPageNumber"];
                        }
                        
                        if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                        {
                            [self.delegate parseCompleteSuccessfully:eparseTypess :directoryArray];
                        }
                    }
                    
                }
                else
                {
                    if (APIType == AllDirectoryAPI)
                    {
                        int balanceCount = [[directoryResponse valueForKey:@"balanceCount"]intValue];
                        
                        if (balanceCount == 0)
                        {
                            NSString *stringAsDate = [directoryResponse valueForKey:@"lastUpdatedDate"];
                            int operatioTypeValue = [[directoryResponse valueForKey:@"operationType"] intValue];
                            
                            int resetPageNumber = 0;
                            [[NSUserDefaults standardUserDefaults] setInteger:resetPageNumber forKey:@"DirectoryPageNumber"];

                            [self updateTimeStampEntity:stringAsDate operatioTypeValue:operatioTypeValue];
                            
                        }
                        
                    }
                    else if(APIType == SearchDirectoryAPI)
                    {
                        int resetPageNumber = 0;
                        [[NSUserDefaults standardUserDefaults] setInteger:resetPageNumber forKey:@"DirectorySearchPageNumber"];
                    }
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                    {
                        [self.delegate parseCompleteSuccessfully:eparseTypess :nil];
                    }
                }
                
            }
            else
            {
                //Show alert view
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:directoryResponse];
                }
                
            }
        }
    }
    else
    {
        [self errorHandler];
    }
}

-(void)profileDataInsertion:(NSDictionary *)results
{
    NSLog(@"profileDataInsertion==%@",results);

    if(results)
    {
        NSArray *profileResponse = [results  objectForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([profileResponse count])
        {
            NSString *resultResponseCode = [profileResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [profileResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *profileDetails = [results  objectForKey:@"Details"];
                
                if ([profileDetails count])
                {
                    MyProfile *myProfile = [DataManager createEntityObject:@"MyProfile"];
                    
                    NSString *userName = [profileDetails valueForKey:@"username"];
                    userName = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    myProfile.userName = userName;
                    myProfile.hospital = [profileDetails valueForKey:@"hospital"];
                    myProfile.speciality = [profileDetails valueForKey:@"speciality"];
                    myProfile.practice = [profileDetails valueForKey:@"practice"];
                    myProfile.contactInfo = [profileDetails valueForKey:@"contactInfo"];
                    myProfile.state = [profileDetails valueForKey:@"state"];
                    NSString *communicationPreference = [profileDetails valueForKey:@"CommunicationPreference"];
                    if(![communicationPreference isEqual:[NSNull null]])
                    {
                        myProfile.communicationPreference = [profileDetails valueForKey:@"CommunicationPreference"];
                    }
                    else
                    {
                        myProfile.communicationPreference = @"";
                    }
                    myProfile.imagepath = [profileDetails valueForKey:@"ImagePath"];
                    myProfile.inboxStatus = [NSNumber numberWithInt:[[profileDetails valueForKey:@"InboxStatus"] intValue]];
                    myProfile.coverageStatus = [NSNumber numberWithInt:[[profileDetails valueForKey:@"CoverageStatus"] intValue]];
                    myProfile.faxStatus = [NSNumber numberWithInt:[[profileDetails valueForKey:@"faxStatus"] intValue]];
                    BOOL isSaved = [DataManager saveContext];
                    if(isSaved)
                    {
                        if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                        {
                            [self.delegate parseCompleteSuccessfully:eparseTypess :profileDetails];
                        }
                        
                    }
                    else
                    {
                        NSLog(@"fail");
                    }
                }
                else
                {
                    [self errorHandler];
                    
                }
                
            }
            else
            {
                [self errorHandler];
            }
            
        }
        else
        {
            [self errorHandler];
        }
        
    }
    else
    {
        [self errorHandler];
    }
}

-(void)coverageCalenderDataInsertion:(NSDictionary *)results
{
    NSLog(@"CoverageCalenderDetails==%@",results);
    if(results)
    {
        NSArray *coverageCalenderResponse = [results  objectForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        
        if([coverageCalenderResponse count])
        {
            NSString *resultResponseCode = [coverageCalenderResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [coverageCalenderResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *coverageCalenderDetails = [results  objectForKey:@"Details"];
                
                if ([coverageCalenderDetails count])
                {
                    NSMutableDictionary *CoverageCalenderDictionary;
                    NSDateFormatter *dateFormatterToDate = [[NSDateFormatter alloc] init];
                    [dateFormatterToDate setDateFormat:@"MM/dd/yyyy"];
                    NSDateFormatter *dateFormatterToString = [[NSDateFormatter alloc] init];
                    [dateFormatterToString setDateFormat:@"hh:mm a"];
                    
                    int detailsCount = [coverageCalenderDetails count];
                    for (int i=0; i<detailsCount; i++)
                    {
                        CoverageCalenderDictionary = [coverageCalenderDetails objectAtIndex:i];
                        NSLog(@"CoverageCalenderDictionary==%@",CoverageCalenderDictionary);
                        CoverageCalendar *coveragecalender = [DataManager createEntityObject:@"CoverageCalendar"];
                        
                        NSDate *datefromString = [dateFormatterToDate dateFromString:[CoverageCalenderDictionary objectForKey:@"date"]];
                        coveragecalender.date = datefromString;
                        NSLog(@"coveragecalender.date==%@",coveragecalender.date);
                        coveragecalender.details = [CoverageCalenderDictionary objectForKey:@"details"];
                        
                        NSDate *startDate = [dateFormatterToString dateFromString: [CoverageCalenderDictionary objectForKey:@"startTime"]];
                        NSString* startDateString = [dateFormatterToString stringFromDate:startDate];
                        coveragecalender.startTime = startDateString;
                        NSLog(@"coveragecalender.startTime==%@",coveragecalender.startTime);
                        coveragecalender.title = [CoverageCalenderDictionary objectForKey:@"title"];
                        
                        NSDate *endDate = [dateFormatterToString dateFromString: [CoverageCalenderDictionary objectForKey:@"endTime"]];
                        NSString* endDateString = [dateFormatterToString stringFromDate:endDate];
                        coveragecalender.endTime = endDateString;
                        NSLog(@"coveragecalender.endTime==%@",coveragecalender.endTime);
                    }
                    dateFormatterToDate = nil;
                    dateFormatterToString = nil;
                    BOOL isSaved = [DataManager saveContext];
                    if(isSaved)
                    {
                        if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                        {
                            [self.delegate parseCompleteSuccessfully:eparseTypess :coverageCalenderDetails];
                        }
                        
                    }
                    else
                    {
                        NSLog(@"fail");
                    }
                    
                }
                else
                {
                    //                    [self errorHandler];
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                    {
                        [self.delegate parseCompleteSuccessfully:eparseTypess :coverageCalenderDetails];
                    }
                    
                }
            }
            else
            {
                // show the failed reson
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:coverageCalenderResponse];
                }
                
            }
            
        }
        else
        {
            [self errorHandler];
        }
        
    }
    else
    {
        [self errorHandler];
    }
}
- (void)readMessageUpdation:(NSDictionary *)results
{
    // call delegate to inbox details
    NSLog(@"readMessage==%@",results);
    if(results)
    {
        NSArray *readMessageResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([readMessageResponse count])
        {
            NSString *resultResponseCode = [readMessageResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [readMessageResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *readMessageDetails = [results valueForKey:@"Details"];
                if([readMessageDetails count])
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                    {
                        [self.delegate parseCompleteSuccessfully:eparseTypess :readMessageDetails];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:readMessageResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
}
-(void)readCommentUpdation:(NSDictionary *)results
{
    // call delegate to inbox details
    NSLog(@"readComment==%@",results);
    if(results)
    {
        NSArray *readCommentResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([readCommentResponse count])
        {
            NSString *resultResponseCode = [readCommentResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [readCommentResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *readCommentDetails = [results valueForKey:@"Details"];
                if([readCommentDetails count])
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                    {
                        [self.delegate parseCompleteSuccessfully:eparseTypess :readCommentDetails];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:readCommentResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
    
}
- (void)deleteMessageUpdation:(NSDictionary *)results
{
    NSLog(@"deleteMessage==%@",results);
    if(results)
    {
        NSArray *deleteMessageResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([deleteMessageResponse count])
        {
            NSString *resultResponseCode = [deleteMessageResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [deleteMessageResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *deleteMessageDetails = [results valueForKey:@"Details"];
                if([deleteMessageDetails count])
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                    {
                        [self.delegate parseCompleteSuccessfully:eparseTypess :deleteMessageDetails];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:deleteMessageResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
}
-(void)composeMessageUpdation:(NSDictionary *)results
{
    NSLog(@"composeMessage==%@",results);
    if(results)
    {
        NSArray *composeMessageResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([composeMessageResponse count])
        {
            NSString *resultResponseCode = [composeMessageResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [composeMessageResponse valueForKey:@"operationType"];
            NSString *lastDate = [composeMessageResponse valueForKey:@"lastUpdatedDate"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *composeMessageDetails = [results valueForKey:@"Details"];
                NSString *messageID = [composeMessageDetails valueForKey:@"messageId"];
                NSString *messageType = [composeMessageDetails valueForKey:@"MessageType"];
                if([composeMessageDetails count])
                {
                    
                    NSDictionary *composeMessageDict = [[NSDictionary alloc]initWithObjectsAndKeys:messageID,@"messageId",lastDate,@"lastUpdatedDate",messageType,@"MessageType", nil];
                    
                    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
                    [resultArray addObject:composeMessageDict];
                    
                    NSLog(@"resultArray==%@",resultArray);
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)]){
                        [self.delegate parseCompleteSuccessfully:eparseTypess :resultArray];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:composeMessageResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
    
}
-(void)startDiscussionUpdation:(NSDictionary *)results
{
    NSLog(@"startDiscussion==%@",results);
    if(results)
    {
        NSArray *startDiscussionResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([startDiscussionResponse count])
        {
            NSString *resultResponseCode = [startDiscussionResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [startDiscussionResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *startDiscussionDetails = [results valueForKey:@"Details"];
                if([startDiscussionDetails count])
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)]){
                        [self.delegate parseCompleteSuccessfully:eparseTypess :startDiscussionDetails];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:startDiscussionResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
}
-(void)newCommentsUpdation:(NSDictionary *)results
{
    NSLog(@"newComments==%@",results);
    if(results)
    {
        NSArray *newCommentsResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([newCommentsResponse count])
        {
            NSString *resultResponseCode = [newCommentsResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [newCommentsResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *newCommentsDetails = [results valueForKey:@"Details"];
                if([newCommentsDetails count])
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)]){
                        [self.delegate parseCompleteSuccessfully:eparseTypess :newCommentsDetails];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:newCommentsResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
    
}
-(void)addParticipantsUpdation:(NSDictionary *)results
{
    NSLog(@"addParticipants==%@",results);
    if(results)
    {
        NSArray *addParticipantsResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([addParticipantsResponse count])
        {
            NSString *resultResponseCode = [addParticipantsResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [addParticipantsResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *addParticipantsDetails = [results valueForKey:@"Details"];
                if([addParticipantsDetails count])
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)]){
                        [self.delegate parseCompleteSuccessfully:eparseTypess :addParticipantsDetails];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:addParticipantsResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
}

-(void)removeParticipantsUpdation:(NSDictionary *)results
{
    NSLog(@"removeParticipants==%@",results);
    if(results)
    {
        NSArray *removeParticipantsResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([removeParticipantsResponse count])
        {
            NSString *resultResponseCode = [removeParticipantsResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [removeParticipantsResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *removeParticipantsDetails = [results valueForKey:@"Details"];
                if([removeParticipantsDetails count])
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)]){
                        [self.delegate parseCompleteSuccessfully:eparseTypess :removeParticipantsDetails];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:removeParticipantsResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
}

-(void)readPushNotificationDeviceTockenResponse:(NSDictionary *)results
{
    NSLog(@"readPushNotificationDeviceTockenResponse==%@",results);
    if (results)
    {
        NSArray *pushNotificationResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        
        if ([pushNotificationResponse count])
        {
            NSString *resultResponseCode = [pushNotificationResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [pushNotificationResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)])
                {
                    [self.delegate parseCompleteSuccessfully:eparseTypess :pushNotificationResponse];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:pushNotificationResponse];
                }
            }
        }
        
        else
        {
            int errorCode = 605;
            NSError *error;
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(parseFailedWithError:::)]){
                [self.delegate parseFailedWithError:eparseTypess:(NSError *)error:(int)errorCode];
            }
        }
    }
}
-(void)readDiscussionUpdation:(NSDictionary *)results
{
    NSLog(@"readDiscussionUpdation==%@",results);
    if(results)
    {
        NSArray *readDiscussionResponse = [results  valueForKey:NSLocalizedString(@"API RESPONSE KEY VALUE", nil)];
        if([readDiscussionResponse count])
        {
            NSString *resultResponseCode = [readDiscussionResponse valueForKey:@"response code"];
            NSString *operationTypeFromServer = [readDiscussionResponse valueForKey:@"operationType"];
            NSString *operationType = [NSString stringWithFormat:@"%d",eparseTypess];
            if ([resultResponseCode isEqualToString:@"600"] && [operationTypeFromServer isEqualToString:operationType])
            {
                NSArray *addParticipantsDetails = [results valueForKey:@"Details"];
                if([addParticipantsDetails count])
                {
                    if(self.delegate && [self.delegate respondsToSelector:@selector(parseCompleteSuccessfully::)]){
                        [self.delegate parseCompleteSuccessfully:eparseTypess :addParticipantsDetails];
                    }
                    
                }
                else
                {
                    [self errorHandler];
                }
                
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(parseWithInvalidMessage:)])
                {
                    //show error msg
                    [self.delegate parseWithInvalidMessage:readDiscussionResponse];
                }
                
            }
        }
        else
        {
            [self errorHandler];
        }
    }
    else
    {
        [self errorHandler];
    }
}

#pragma mark- attach API parameters
-(NSString *)setInboxParameters:(ParseServiseType)eparseType
{
    NSString *lastUpdateDate = [self lastUpdateddateFromTimeStamp:eparseType];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    
    NSString *URLWithParameters = [NSString stringWithFormat:@"%@?userId=%@&operationType=%d&LastUpdatedDate=%@",INBOX_FETCH_URL,userID,eparseType,lastUpdateDate];
    
    return URLWithParameters;
    
}


-(NSString *)setTouchBaseParameters:(ParseServiseType)eparseType
{
    NSString *lastUpdateDate = [self lastUpdateddateFromTimeStamp:eparseType];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *URLWithParameters = [NSString stringWithFormat:@"%@?userId=%@&operationType=%d&LastUpdatedDate=%@",TOUCHBASE_FETCH_URL,userID,eparseType,lastUpdateDate];
    return URLWithParameters;
}

-(NSString *)setDirectoryParameters:(ParseServiseType)eparseType
{
    NSString *lastUpdateDate = [self lastUpdateddateFromTimeStamp:eparseType];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *URLWithParameters = [NSString stringWithFormat:@"%@?userId=%@&operationType=%d&LastUpdatedDate=%@",DIRECTORY_FETCH_URL,userID,eparseType,lastUpdateDate];
    
    return URLWithParameters;
}


-(NSString *)setReadMessageParameters:(ParseServiseType)eparseType
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *URLWithParameters = [NSString stringWithFormat:@"%@?userId=%@&operationType=%d",READ_MESSAGE_URL,userID,eparseType];
    return URLWithParameters;
}

-(NSString *)setMyprofileParameters:(ParseServiseType)eparseType
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *URLWithParameters = [NSString stringWithFormat:@"%@?userId=%@&operationType=%d",MYPROFILE_FETCH_URL,userID,eparseType];
    return URLWithParameters;
}

-(NSString *)setCoverageCalenderParameters:(ParseServiseType)eparseType
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *URLWithParameters = [NSString stringWithFormat:@"%@?userId=%@&operationType=%d",COVERAGECALENDER_FETCH_URL,userID,eparseType];
    return URLWithParameters;
}

- (NSString *)lastUpdateddateFromTimeStamp :(ParseServiseType)eparseType
{
    
    NSString *lastUpdateDate;
    
    TimeStamp *timeStamp = [DataManager fetchExistingEntityObject:@"TimeStamp" attributeName:@"operationType" selectBy:eparseType];
    
    if (!timeStamp)
    {
        lastUpdateDate = @"1/1/1901";
    }
    else
    {
        NSDate *lastUpdatedStringDate = timeStamp.lastUpdatedDate;
        
        lastUpdateDate = [DateFormatter getDateStringFromDate:lastUpdatedStringDate withFormat:@"MM/dd/yyyy"];
    }
    
    return lastUpdateDate;
}

-(MsgRecipient*)fetchEntityObjectForMsgRecipient:(NSString *)entityName selectBy:(int)recipientID
{
    MsgRecipient* msgRecipientObject;
    
    msgRecipientObject = (MsgRecipient*)[DataManager fetchExistingEntityObject:entityName attributeName:@"recipientId" selectBy:recipientID];
    
    if (!msgRecipientObject)
    {
        msgRecipientObject = (MsgRecipient*)[DataManager createEntityObject:entityName];
        
    }
    else
    {
    }
    
    return msgRecipientObject;
}

-(id)fetchEntityObjectForDirectory:(NSString *)entityName selectBy:(int)physicianID
{
    id managedObject = nil;
    
    managedObject = [DataManager fetchExistingEntityObject:entityName attributeName:@"physicianId" selectBy:physicianID];
    if (!managedObject)
    {
        managedObject = [DataManager createEntityObject:entityName];
        isExistingDirectoryObj = NO;
    }
    else
    {
        isExistingDirectoryObj = YES;
    }
    
    return managedObject;
}

-(DiscussionParticipants *)fetchEntityObjectForDiscussionParticipents:(NSString *)entityName selectBy:(int)participentID
{
    //    id managedObject = nil;
    DiscussionParticipants *discussionparticipentsObj;
    discussionparticipentsObj = (DiscussionParticipants *)[DataManager fetchExistingEntityObject:entityName attributeName:@"participantId" selectBy:participentID];
    if (!discussionparticipentsObj)
    {
        discussionparticipentsObj = (DiscussionParticipants *)[DataManager createEntityObject:entityName];
    }
    else
    {
        NSLog(@"ADD PARTICIPANT ALREADY");
    }
    
    return discussionparticipentsObj;
}
-(id)fetchEntityObjectForComments:(NSString *)entityName selectBy:(int)commentsID
{
    id managedObject = nil;
    
    managedObject = [DataManager fetchExistingEntityObject:entityName attributeName:@"commentsId" selectBy:commentsID];
    if (!managedObject)
    {
        managedObject = [DataManager createEntityObject:entityName];
    }
    else
    {
        
    }
    
    return managedObject;
}

- (BOOL)updateTimeStampEntity:(NSString *)date operatioTypeValue:(int)operationType
{
    BOOL isSaved;
    NSDate *updatedDate = [DateFormatter getDateFromDateString:date forFormat:@"mm/dd/yyyy"];
    TimeStamp *timeStamp = [DataManager fetchExistingEntityObject:@"TimeStamp" attributeName:@"operationType" selectBy:operationType];
    if (!timeStamp)
    {
        timeStamp = [DataManager createEntityObject:@"TimeStamp"];
    }
    timeStamp.lastUpdatedDate = updatedDate;
    timeStamp.operationType  = [NSNumber numberWithInt:operationType];
    isSaved = [DataManager saveContext];
    return isSaved;
}

/*******************************************************************************
 *  Function Name: existImage.
 *  Purpose: To check image is exixsting in Cache??.
 *  Parametrs: image name.
 *  Return Values: nil.
 ********************************************************************************/
-(BOOL)existImage:(NSString *)name
{
    NSString *path = [self getPathDocAppendedBy:name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return fileExists;
}

/*******************************************************************************
 *  Function Name: getPathDocAppendedBy.
 *  Purpose: To Get the Cache path.
 *  Parametrs: image name.
 *  Return Values: nil.
 ********************************************************************************/
-(NSString *)getPathDocAppendedBy:(NSString *)_appString
{
	NSString* documentsPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"IMAGES"];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:_appString];
	return foofile;
}
#pragma mark-
-(void)cacheImages:(NSArray *)imgNameArr
{
    if ([imgNameArr count] > 0)
    {
        [[Utilities sharedInstance] cacheImage:[imgNameArr objectAtIndex:0]imgName:[imgNameArr objectAtIndex:1]];
    }
    
}


- (void)dealloc
{
    
}

@end
