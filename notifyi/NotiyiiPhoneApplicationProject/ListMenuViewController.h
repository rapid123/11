//
//  ListMenuViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 20/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MailListMenuSelected <NSObject>

-(void)sortItemSelected:(int)msgType;

@end

@interface ListMenuViewController : UIViewController

@property(nonatomic,strong) id<MailListMenuSelected> delegate;

@end
