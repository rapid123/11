//
//  InboxDetailsViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inbox.h"
#import "JsonParser.h"

@interface InboxDetailsViewController : UIViewController<UIGestureRecognizerDelegate,UITextViewDelegate,UIAlertViewDelegate,JsonParserDelegate>

@property (nonatomic, strong)NSArray *inboxManagerArr;
@property (assign) int swipeCount;
@property (nonatomic,assign) int messageTypeID;

@end
