//
//  ListMenuViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 20/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListMenuViewController.h"
#import "InboxViewController.h"
#import <QuartzCore/CoreAnimation.h>
#import "GeneralClass.h"
#define SORT_MAIL_ARRAY [NSArray arrayWithObjects: @"Inbox",@"Sent Mail",@"Draft",@"Trash",nil]
#define SORT_MAILID_ARRAY [NSArray arrayWithObjects: @"1",@"0",@"2",@"3",nil]

@interface ListMenuViewController ()
{
    __weak IBOutlet UILabel *mailboxesLabel;
    NSArray *imageArray;
}
@property (strong, nonatomic) IBOutlet UITableView *listMenuTableView;
@end

@implementation ListMenuViewController
@synthesize listMenuTableView;
@synthesize delegate;

#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark- ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    mailboxesLabel.font = [GeneralClass getFont:titleFont and:boldFont];
    imageArray = [[NSArray alloc]initWithObjects:@"inbox_icon.png",@"sent_icon.png",@"draft_icon.png",@"trash_icon.png",nil];
}

#pragma mark - Table view data source
/*******************************************************************************
 *  UITable view data source.
 ********************************************************************************/
- (CGFloat) tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SORT_MAIL_ARRAY count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CGRect labelFrame = CGRectMake(45, 15, 100, 20);
    CGRect imageViewFrame;
    UILabel* label = [[UILabel alloc]initWithFrame:labelFrame];
    label.font =[GeneralClass getFont:customRegular and:regularFont];
    label.textColor = [UIColor blackColor];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(indexPath.row==0)
    {
        imageViewFrame = CGRectMake(7, 10, 30, 24);
    }
    else
    {
        imageViewFrame = CGRectMake(7, 10, 21, 26);
        
    }
    UIImageView *images = [[UIImageView alloc]initWithFrame:imageViewFrame];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell addSubview:images];
        NSString *cellValue = [SORT_MAIL_ARRAY objectAtIndex:indexPath.row];
        label.text = cellValue;
        images.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:label];
    }
	return cell;
}

#pragma mark - Table view delegate
/*******************************************************************************
 *  UITable view delegate.
 ********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(delegate && [delegate respondsToSelector:@selector(sortItemSelected:)])
    {
        [delegate sortItemSelected:[[SORT_MAILID_ARRAY objectAtIndex:indexPath.row]intValue]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Unload
- (void)viewDidUnload
{
    mailboxesLabel = nil;
    [super viewDidUnload];
}

-(void)dealloc
{
    [self setListMenuTableView:nil];
}

#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
