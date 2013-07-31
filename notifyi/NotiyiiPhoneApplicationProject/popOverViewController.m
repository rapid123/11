//
//  popOverViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Amal T on 03/10/12.
//
//

#import "popOverViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GeneralClass.h"

@interface popOverViewController ()
{
    NSInteger currentIndexPath;
}
@property(weak,nonatomic)IBOutlet UITableView *popOverTableView;
@end

@implementation popOverViewController
@synthesize popOverTableView;
@synthesize delegate;
@synthesize stateCodeArr;

#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark- UITableView DataSource
/*******************************************************************************
 *  UITableView DataSource.
 ********************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"Returning No of sections");
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Returning no of rows==%d",[stateCodeArr count]);
    return [stateCodeArr count];
}
- (CGFloat) tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [GeneralClass getFont:customNormal and:boldFont];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    State *stateObj = [stateCodeArr objectAtIndex:indexPath.row];
    cell.textLabel.text = stateObj.StateCode;
    return cell;
}
#pragma mark- UITableView Delegates
/*******************************************************************************
 *  UITableView Delegates.
 ********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    State *stateObj = [stateCodeArr objectAtIndex:indexPath.row];
    
    if (delegate && [delegate respondsToSelector:@selector(popOverStateSelected:)])
    {
        [delegate popOverStateSelected:stateObj];
        [self.view removeFromSuperview];
    }
}

#pragma mark- Touch Event
/*******************************************************************************
 *  Function Name:touchesBegan.
 *  Purpose: To delegate back ground touch events.
 *  Parametrs:event.
 *  Return Values:nil.
 ********************************************************************************/
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"back ground touched");
    [self.view removeFromSuperview];
}
#pragma mark- Unload
- (void)viewDidUnload
{
    [self setPopOverTableView:nil];
    [super viewDidUnload];
    
}
#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
