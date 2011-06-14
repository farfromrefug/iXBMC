#import "RecentlyAddedViewController.h"
#import "RecentMovieViewController.h"
#import "RecentlyAddedMoviesView.h"
#import "RecentMovieViewController.h"

#import "XBMCImage.h"

#define MAX_PAGES 15

@interface RecentlyAddedViewController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end


@implementation RecentlyAddedViewController

@synthesize viewControllers;
@synthesize movies = _movies;
@synthesize scrollView;
@synthesize pageControl;

// load the view nib and initialize the pageNumber ivar
- (id)init
{
    self = [super init];
    if (self)
    {
       

    }
    return self;
}

//
//- (void) rotatePage: (NSTimer *) theTimer
//{
//    int newPage = 0;
//    if (self.pageControl.currentPage < [self nbMovies] - 1)
//    {
//        newPage = self.pageControl.currentPage + 1; 
//    }
//    
//    [self setCenterPageIndex:newPage];
//    CGRect frame = self.scrollView.frame;
//    frame.origin.x = frame.size.width * self.pageControl.currentPage;
//    frame.origin.y = 0;
//    [self.scrollView scrollRectToVisible:frame animated:(newPage != 0)];
//}

//- (void)startRotate 
//{
//    if (_rotateTimer == nil)
//    {
//        _rotateTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0
//                                                    target: self
//                                                  selector: @selector(rotatePage:)
//                                                  userInfo: nil repeats:TRUE];
//    }
//}
//
//- (void)stopRotate
//{
//    if (_rotateTimer != nil)
//    {
//        [_rotateTimer invalidate];
//        _rotateTimer = nil;
//    }
//}


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
//    [self startRotate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self stopRotate];
}

- (UIScrollView *)scrollView
{
    return ((RecentlyAddedMoviesView*)self.view).scrollView;
}

- (UIPageControl *)pageControl
{
    return ((RecentlyAddedMoviesView*)self.view).pageControl;
}

-(int) nbMovies
{
    return MIN(MAX_PAGES, [_movies count]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadData {
	[recycledPages removeAllObjects];
	[visiblePages removeAllObjects];
//	TT_RELEASE_SAFELY(recycledPages);
//	TT_RELEASE_SAFELY(visiblePages);
//	recycledPages = [[NSMutableSet alloc] init];
//    visiblePages  = [[NSMutableSet alloc] init];
    self.scrollView.contentSize = [self contentSizeForPagingScrollView];
	[self tilePages];
}

- (void)setMovies: (NSArray *)newMovies
{    
    TT_RELEASE_SAFELY(_movies);
    if (newMovies != nil)
    {
        _movies = [newMovies retain];
        [self reloadData];
    }
}  

//// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self stopRotate];
//    pageControlUsed = NO;
//}
//
//// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self stopRotate];
//    pageControlUsed = NO;
//}
//
//- (IBAction)changePage:(id)sender
//{    
//    pageControlUsed = YES;
//    [self stopRotate];
//    [self setCenterPageIndex:self.pageControl.currentPage];
//    CGRect frame = self.scrollView.frame;
//    frame.origin.x = frame.size.width * self.pageControl.currentPage;
//    frame.origin.y = 0;
//    [self.scrollView scrollRectToVisible:frame animated:YES];
//
//
//}




#pragma mark -
#pragma mark View loading and unloading

- (void)loadView 
{    
	_rotateTimer = nil;
	RecentlyAddedMoviesView* view = [[[RecentlyAddedMoviesView alloc] init] autorelease];
	self.view = view;
	
	_movies = [[NSArray alloc] init];
	self.scrollView.pagingEnabled = YES;
	//        self.scrollView.scrollEnabled = NO;
	self.scrollView.bounces = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollsToTop = NO;
	self.scrollView.delegate = self;
	
//	[self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center
     addObserver:self
     selector:@selector(reloadData)
     name:@"highQualityChanged"
     object:nil ];
}

- (void) setViewFrame:(CGRect) frame
{
	[self.view setFrame:frame];
	[self reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	TT_RELEASE_SAFELY(recycledPages);
	TT_RELEASE_SAFELY(visiblePages);
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Tiling and page configuration

- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.scrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self nbMovies] - 1);
    
    // Recycle no-longer-visible pages 
    for (RecentMovieViewController *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page.view removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            RecentMovieViewController *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[RecentMovieViewController alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [self.scrollView addSubview:page.view];
            [visiblePages addObject:page];
        }
    }    
}

- (RecentMovieViewController *)dequeueRecycledPage
{
    RecentMovieViewController *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (RecentMovieViewController *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(RecentMovieViewController *)page forIndex:(NSUInteger)index
{
	if (index == page.index) return;
    page.index = index;
    page.view.frame = [self frameForPageAtIndex:index];
	
	page.title = [[_movies objectAtIndex:page.index] objectForKey:@"label"];
	page.posterURL = [[_movies objectAtIndex:page.index] objectForKey:@"thumbnail"];
	page.fanartURL = [[_movies objectAtIndex:page.index] objectForKey:@"fanart"];
	
	CGFloat posterHeight = [page posterHeight];
	if (page.posterURL
		&& [XBMCImage hasCachedImage:page.posterURL 
					   thumbnailHeight:posterHeight])
	{
		page.poster = [XBMCImage cachedImage:page.posterURL
							   thumbnailHeight:posterHeight];
	}
	else
	{
		page.poster = nil;
		[XBMCImage askForImage:page.posterURL
						object:page selector:@selector(thumbnailLoaded:) 
				 thumbnailHeight:posterHeight];
	}
	
	page.watched = ([[[_movies objectAtIndex:page.index] objectForKey:@"playcount"] intValue] > 0);
	
	CGFloat fanartHeight = [page fanartHeight];
	
	if (page.fanartURL
		&& [XBMCImage hasCachedImage:page.fanartURL 
					   thumbnailHeight:fanartHeight])
	{  
		page.fanart = [XBMCImage cachedImage:[[_movies objectAtIndex:page.index] objectForKey:@"fanart"]
							   thumbnailHeight:fanartHeight];
	}
	else
	{
		page.fanart = nil;
		[XBMCImage askForImage:page.fanartURL
						object:page selector:@selector(fanartLoaded:) 
				 thumbnailHeight:fanartHeight];
	}
	
	page.movieid = [[_movies objectAtIndex:page.index] objectForKey:@"id"];
	page.trailer = [[_movies objectAtIndex:page.index] objectForKey:@"trailer"];
	page.imdb = [[_movies objectAtIndex:page.index] objectForKey:@"imdb"];
	page.file = [[_movies objectAtIndex:page.index] objectForKey:@"file"];
	
	UITapGestureRecognizer *taprecognizer;
	taprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:page 
															action:@selector(showTrailer:)];
	taprecognizer.numberOfTapsRequired = 1;
	[page.view addGestureRecognizer:taprecognizer];
	[taprecognizer release];
	
	UILongPressGestureRecognizer *longpress;
    longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:page action:@selector(handleLongPress:)];
    [page.view addGestureRecognizer:longpress];
    [longpress release];
	
	page.view.userInteractionEnabled = YES;
	[page.view setNeedsDisplay];
}


#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

#pragma mark -
#pragma mark View controller rotation methods

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
//{
//    return YES;
//}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
//    // place to calculate the content offset that we will need in the new orientation
//    CGFloat offset = pagingScrollView.contentOffset.x;
//    CGFloat pageWidth = pagingScrollView.bounds.size.width;
//    
//    if (offset >= 0) {
//        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
//        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
//    } else {
//        firstVisiblePageIndexBeforeRotation = 0;
//        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
//    }    
//}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    // recalculate contentSize based on current orientation
//    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
//    
//    // adjust frames and configuration of each visible page
//    for (ImageScrollView *page in visiblePages) {
//        CGPoint restorePoint = [page pointToCenterAfterRotation];
//        CGFloat restoreScale = [page scaleToRestoreAfterRotation];
//        page.frame = [self frameForPageAtIndex:page.index];
//        [page setMaxMinZoomScalesForCurrentBounds];
//        [page restoreCenterPoint:restorePoint scale:restoreScale];
//        
//    }
//    
//    // adjust contentOffset to preserve page location based on values collected prior to location
//    CGFloat pageWidth = pagingScrollView.bounds.size.width;
//    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
//    pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
//}

#pragma mark -
#pragma mark  Frame calculations
#define PADDING  10

- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = self.scrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = self.scrollView.bounds;
    return CGSizeMake(bounds.size.width * [self nbMovies], bounds.size.height);
}

@end
