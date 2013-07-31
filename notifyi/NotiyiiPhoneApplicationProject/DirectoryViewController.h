//
//  DirectoryViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDirectoryCell.h"
#import "popOverViewController.h"
#import "JsonParser.h"
#import "NSURLConnectionWithTag.h"

@protocol ContactSelectedDelegate <NSObject>

- (void)selectedContacts:(NSMutableArray *)contacts;
@end

@interface DirectoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate,popOverSelectedDelegate,JsonParserDelegate>
{
    NSString * currentState;
    BOOL enablePagination;
}

@property (nonatomic,strong) id<ContactSelectedDelegate>delegate;
@property(nonatomic, strong) IBOutlet CustomDirectoryCell *customDirectoryCell;
@property(nonatomic, strong) NSMutableArray *selectedPhysicianIdArray;
@property(assign) int toAndCcFlag;
@property(assign) int presentDirectoryId;
@property (nonatomic,strong) NSArray *userStateDirectoryListArray;

-(void) beginWithAddParticipants:(int)falgValue;

@end
