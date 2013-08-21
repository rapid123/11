

#import "HowItWorksSlideShow.h"

@implementation UIPageControl (Custom)

- (void)setCurrentPage:(NSInteger)page {
    
    NSString* imgActive = [[NSBundle mainBundle] pathForResource:@"selecteddot@2x" ofType:@"png"];
    NSString* imgInactive = [[NSBundle mainBundle] pathForResource:@"unselecteddot@2x" ofType:@"png"];
    
    for (int subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        subview.layer.cornerRadius=8.0;
        subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y, 10, 10);
        if (subviewIndex == page)
            [subview setImage:[UIImage imageWithContentsOfFile:imgActive]];
        else 
            [subview setImage:[UIImage imageWithContentsOfFile:imgInactive]];
    }
}

@end



static NSUInteger kNumberOfPages = 5;

@interface HowItWorksSlideShow (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end


@implementation HowItWorksSlideShow

@synthesize scrollView;
@synthesize pageControl;
@synthesize prevButton;
@synthesize nextButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (UIImageView *)getImageViewForIndex:(int)index {
    
    NSString *path = [NSString stringWithFormat:@"slide%d",index+1];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path
                                                                                      ofType:kRBImageType]];
    UIImageView *slideImageView = [[UIImageView alloc] initWithImage:image];
    [image release];
    image = nil;
    
    return [slideImageView autorelease];
}


-(void)initializeImages {
    
    slideImageViews = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [slideImageViews addObject:[NSNull null]];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self initializeImages];
    [prevButton setHidden:YES];
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    //otherwise users will be able to click on the dots

    pageControl.enabled =NO;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];

}

#pragma mark - view handlers

-(void)resetButtonStatus {
    
    [prevButton setHidden:NO];
    [nextButton setHidden:NO];
    [nextButton setImage:[UIImage imageNamed:@"slideShowRightarrow.png"] forState:UIControlStateNormal];
}

-(void)changeButtonStatus:(int)page {
 
    [self resetButtonStatus];
    if(page==0){
        [prevButton setHidden:YES];
    }
    else if(page == kNumberOfPages - 1){
        [nextButton setImage:[UIImage imageNamed:@"slideShowdone.png"] forState:UIControlStateNormal];
    }
}


#pragma mark - scrolling helpers

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    UIImageView *slideImage =  [slideImageViews objectAtIndex:page];
    if ((NSNull *)slideImage == [NSNull null]) {
        slideImage = [self getImageViewForIndex:page];
        [slideImageViews replaceObjectAtIndex:page withObject:slideImage];
        //[slideImage release];
    }
    // add the controller's view to the scroll view
    if (nil == slideImage.superview) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        slideImage.frame = frame;
        [self.scrollView addSubview:slideImage];
        slideImage = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    currentPage=page;
    [self changeButtonStatus:page];
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}


- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = scrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * 10);
    pageFrame.origin.x = (bounds.size.width * index);
    return pageFrame;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

#pragma mark- button Clicks

-(void)dismissTheView {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)jumpToPageAtIndex:(NSUInteger)index {
	
	// Change page
	if (index < kNumberOfPages) {
		CGRect pageFrame = [self frameForPageAtIndex:index];
		scrollView.contentOffset = CGPointMake(pageFrame.origin.x, 0);
	}
	
}

- (IBAction)gotoPreviousPage:(id)sender { [self jumpToPageAtIndex:currentPage-1]; }

- (IBAction)gotoNextPage:(id)sender { 
    
    if(currentPage== kNumberOfPages - 1){
        [self dismissTheView];
    }
    else
        [self jumpToPageAtIndex:currentPage+1]; 
}


#pragma mark - memory management

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    
    //self.scrollView = nil;
    self.pageControl = nil;
    [slideImageViews release];
    self.prevButton = nil;
    self.nextButton = nil;
    
    [super dealloc];
    
}

@end
