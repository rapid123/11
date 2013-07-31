//
//  SendMessageViewController.h
//  SendMessage
//
//  Created by Amal T on 12/09/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inbox.h"
#import "DirectoryViewController.h"

@interface SendMessageViewController : UIViewController <UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,ContactSelectedDelegate,JsonParserDelegate> {
}

@property(strong, nonatomic)IBOutlet UITextField *toText;
@property(strong, nonatomic)IBOutlet UITextField *ccText;
@property(strong, nonatomic)IBOutlet UILabel *sendMsg;
@property(strong, nonatomic)IBOutlet UITextField *subjectText;
@property(strong, nonatomic)Inbox *inboxMsgObj;
@property(strong, nonatomic)IBOutlet UITextView *sendMsgBodyTxtView;
@property(strong, nonatomic)IBOutlet UITextField *addPatientTxtField;
@property(strong, nonatomic)IBOutlet UITextField *patientFirstNameTxtField;
@property(strong, nonatomic)IBOutlet UITextField *patientLastNameTxtField;
@property(strong, nonatomic)IBOutlet UITextField *patientDOBTxtField;
@property(strong, nonatomic)NSMutableArray *recipientNameArray;
@property(strong, nonatomic)NSMutableArray *ccRecipientNames;
@property(nonatomic, strong)NSMutableArray *toRecipientSelectedIdArray;
@property(nonatomic, strong)NSMutableArray *ccRecipientSelectedIdArray;
@property(nonatomic, strong)NSNumber *selectedPhysicianId;

-(void) beginWithReplyAction:(int)replyFalg inbox:(Inbox *)inbox;


@end
