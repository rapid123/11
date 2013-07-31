//
//  TouchBaseViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchBaseDetailsViewController.h"
#import "CustomTouchBaseTableViewCell.h"
#import "TouchBase.h"
#import "JsonParser.h"

@interface TouchBaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,JsonParserDelegate>

@property(nonatomic,strong)IBOutlet CustomTouchBaseTableViewCell *customTouchBaseTableViewCell;
@property(nonatomic, strong) TouchBase *touchBase;

-(void)touchBaseDataRefreshing;
-(void)getTouchBaseInformation;

@end
