//
//  TextPage.m
//  Red Beacon
//
//  Created by Jayahari V on 17/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextPage.h"
#import "JobRequest.h"

@implementation TextPage

@synthesize jobDescriptionTextField;
@synthesize parent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)layoutSubviews {
    
    //if job Description is already entered, display for editing it.
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if (jRequest.jobDescription) {
        jobDescriptionTextField.text = jRequest.jobDescription;
    }
    
    //make keyboard always visible
    [jobDescriptionTextField becomeFirstResponder];
    [jobDescriptionTextField setDelegate:self];
}

#pragma marl-textview delegates
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    //while the shouldChange will fire the method before the text enetered into textfield. 
    // after the some seconds it will give us the decide output. else the add 
    //button won't be enable in the first time 
    [parent performSelector:@selector(textFieldChangedCharacter) 
                 withObject:nil afterDelay:0.1];
    return YES;
}

@end
