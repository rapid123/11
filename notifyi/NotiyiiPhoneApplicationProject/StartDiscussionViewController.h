//
//  StartDiscussionViewController.h
//  SendMessage
//
//  Created by Amal T on 13/09/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectoryViewController.h"

@interface StartDiscussionViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,ContactSelectedDelegate,JsonParserDelegate>{

}
@property(nonatomic, strong)NSMutableArray *recipientAddressObjectIDs;
@property(nonatomic, strong)NSNumber *selectedPhysicianId;
@property(nonatomic, strong)NSMutableArray *toRecipientSelectedIdArray;

@end
