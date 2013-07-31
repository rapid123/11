//
//  SyncManager.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonParser.h"

@protocol SyncDelegates <NSObject>

-(void)SyncCompletedWithSuccess;
-(void)SyncCompletedWithError;
-(void)netWorkNotReachable;

@end

@interface SyncManager : NSObject <JsonParserDelegate>
{
    
}
- (void)inboxParsing;
- (void)touchBaseParsing;
- (void)DirectoryParsing;
- (void)profileParsing;
@property(nonatomic,strong)id <SyncDelegates>delegate;
@end
