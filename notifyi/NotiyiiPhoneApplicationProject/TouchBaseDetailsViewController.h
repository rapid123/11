//
//  TouchBaseDetailsViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTouchBaseDetailCell.h"
#import "Comments.h"
#import "DirectoryViewController.h"
#import "JsonParser.h"

@interface TouchBaseDetailsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate,ContactSelectedDelegate,JsonParserDelegate>

@property (nonatomic, strong)NSArray *touchBaseManagerArr;
@property (assign) int swipeCount;
@property(nonatomic, strong)NSMutableArray *recipientAddressObjects;
@end
