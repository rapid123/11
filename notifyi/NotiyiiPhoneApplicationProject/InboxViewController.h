
//
//  InboxViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inbox.h"
#import "InboxTableViewCell.h"
#import "ListMenuViewController.h"
#import "JsonParser.h"

@interface InboxViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate,MailListMenuSelected,JsonParserDelegate>


typedef enum {
    sentMsg = 0,
    inboxMsg = 1,
    draftMsg = 2,
    trashMsg = 3
    
} messageType;

@property(weak, nonatomic) IBOutlet UILabel *inboxLabel;
@property(nonatomic, strong) IBOutlet UITableView *inboxTableView;
@property(nonatomic, strong) IBOutlet UISearchBar *inboxSearchBar;
@property(nonatomic, strong) Inbox *inbox;
@property(nonatomic, strong) IBOutlet InboxTableViewCell *inboxTableViewCell;

- (void)inboxTabbarTouched;
-(void)inboxDataRefreshing;
-(void)getInboxInformation;

@end

