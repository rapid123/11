//
//  SyncManager.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncManager.h"
#import "GeneralClass.h"
JsonParser *objParser;
int errorParseType;

@implementation SyncManager
@synthesize delegate;


#pragma mark- Methods.

- (void)inboxParsing
{
    NSString *string=@"&PageNumber=1&searching=0&SearchToken=12-12";//No need of inputs right now.
    objParser= nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.APIType = AllInboxAPI;
        objParser.delegate=self;
    }
    [objParser parseJson:InboxAPI :string];
}

- (void)touchBaseParsing
{
    NSString *string=@"&PageNumber=1";
    objParser= nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    [objParser parseJson:TouchBaseAPI :string];
}

- (void)DirectoryParsing
{
    NSString *userState = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserState"];
    
    NSString *string = [NSString stringWithFormat:@"&PageNumber=0&searching=1&SearchToken=&State=%@",userState];

    objParser= nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate = self;
        objParser.APIType = AllDirectoryAPI;
    }
    [objParser parseJson:DirectoryAPI :string];
}

- (void)profileParsing
{
    NSString *string=@"";//No need of inputs right now.
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    [objParser parseJson:MyProfileAPI :string];
}
#pragma mark- Parser Delegates
/*******************************************************************************
 *  Function Name: parseCompleteSuccessfully,parseFailedWithError.
 *  Purpose: To delegate the json parser.
 *  Parametrs:Array of resulted parserObject.
 *  Return Values:nil.
 ********************************************************************************/
-(void)parseCompleteSuccessfully:(ParseServiseType) eparseType:(NSArray *)result
{
    if( eparseType == InboxAPI)
    {
        //Inbox finish
        [self profileParsing];
    }
    else if(eparseType == MyProfileAPI)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(SyncCompletedWithSuccess)])
        {
            [delegate SyncCompletedWithSuccess];
        }

    }
    else if(eparseType==TouchBaseAPI)
    {
        //Touch base finish
        [self DirectoryParsing];
        
    }
    else if(eparseType==DirectoryAPI)
    {
        //directory finish
        if(self.delegate && [self.delegate respondsToSelector:@selector(SyncCompletedWithSuccess)])
        {
            [delegate SyncCompletedWithSuccess];
        }
    }
}
-(void)parseFailedWithError:(ParseServiseType) eparseType:(NSError *)error:(int)errorCode
{
    [GeneralClass showAlertView:self
                            msg:nil
                          title:@"Parse with error. Try again?"
                    cancelTitle:@"YES"
                     otherTitle:@"NO"
                            tag:parseErrorTag];
    errorParseType = eparseType;    
}

-(void)netWorkNotReachable
{
    NSLog(@"NO NETWORK");
    if(self.delegate && [self.delegate respondsToSelector:@selector(netWorkNotReachable)])
    {
        [self.delegate netWorkNotReachable];
    }
    
}

-(void)parseWithInvalidMessage:(NSArray *)result
{
    if ([result count]>0)
    {
        NSString *resultResponseCode = @"No data from server";
        resultResponseCode = [resultResponseCode stringByAppendingFormat:@"\nDo you want to continue?"];
        
        [GeneralClass showAlertView:self
                                msg:nil //resultResponseCode
                              title:resultResponseCode
                        cancelTitle:@"YES"
                         otherTitle:@"NO"
                                tag:parseErrorTag];

        errorParseType = [[result valueForKey:@"operationType"] integerValue];
    }
    else
    {
        [self parseFailedWithError:0 :nil :0];
    }
}
#pragma mark- Alertview delegates
/*******************************************************************************
 *  UIAlertview delegates.
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == parseErrorTag)
    {
        NSLog(@"PresentErrorparseType===%d",errorParseType);
        if(errorParseType == InboxAPI)
        {
            if(buttonIndex == 0)
            {
                [self inboxParsing];
            }
            else
            {
                [self touchBaseParsing];
                
            }
            
        }
        else if (errorParseType == TouchBaseAPI)
        {
            if(buttonIndex == 0)
            {
                [self touchBaseParsing];
            }
            else
            {
                [self DirectoryParsing];
                
            }
        }
        else if (errorParseType == DirectoryAPI)
        {
            if(buttonIndex == 0)
            {
                [self DirectoryParsing];
            }
            else
            {
                if(self.delegate && [self.delegate respondsToSelector:@selector(SyncCompletedWithSuccess)])
                {
                    [delegate SyncCompletedWithSuccess];
                }
                
            }
            
        }
        
    }
    alertView = nil;
}
@end
