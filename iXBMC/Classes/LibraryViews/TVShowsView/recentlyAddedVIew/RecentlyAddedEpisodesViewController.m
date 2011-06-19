#import "RecentlyAddedEpisodesViewController.h"
#import "RecentEpisodeViewController.h"
#import "RecentlyAddedEpisodesView.h"
#import "RecentEpisodeViewController.h"

#import "XBMCImage.h"

#define MAX_PAGES 15

@interface RecentlyAddedEpisodesViewController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end


@implementation RecentlyAddedEpisodesViewController

@synthesize viewControllers;
@synthesize episodes = _episodes;
@synthesize scrollView;
@synthesize pageControl;

// load the view nib and initialize the pageNumber ivar
- (id)init
{
    self = [super init];
    if (self)
    {
		_forceUpdate = FALSE;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (UIScrollView *)scrollView
{
    return ((RecentlyAddedEpisodesView*)self.view).scrollView;
}

- (UIPageControl *)pageControl
{
    return ((RecentlyAddedEpisodesView*)self.view).pageControl;
}

-(int) nbEpisodes
{
    return MIN(MAX_PAGES, [_episodes count]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadData {
	_forceUpdate = TRUE;
    self.scrollView.contentSize = [self contentSizeForPagingScrollView];
	[self tilePages];
}

- (void)setEpisodes: (NSArray *)newEpisodes
{    
    TT_RELEASE_SAFELY(_episodes);
    if (newEpisodes != nil)
    {
        _episodes = [newEpisodes retain];
        [self reloadData];
    }
}  

#pragma mark -
#pragma mark View loading and unloading

- (void)loadView 
{    
	_rotateTimer = nil;
	RecentlyAddedEpisodesView* view = [[[RecentlyAddedEpisodesView alloc] init] autorelease];
	self.view = view;
	
	_episodes = [[NSArray alloc] init];
	self.scrollView.pagingEnabled = YES;
	self.scrollView.bounces = NO;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollsToTop = NO;
	self.scrollView.delegate = self;
    
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
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self nbEpisodes] - 1);
    
    // Recycle no-longer-visible pages 
    for (RecentEpisodeViewController *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page.view removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
	
	if (_forceUpdate)
	{
		// Recycle no-longer-visible pages 
		for (RecentEpisodeViewController *page in visiblePages) {
            [self configurePage:page forIndex:page.index];			
		}
	}
	_forceUpdate = FALSE;
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            RecentEpisodeViewController *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[RecentEpisodeViewController alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [self.scrollView addSubview:page.view];
            [visiblePages addObject:page];
        }
    } 
}

- (RecentEpisodeViewController *)dequeueRecycledPage
{
    RecentEpisodeViewController *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (RecentEpisodeViewController *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(RecentEpisodeViewController *)page forIndex:(NSUInteger)index
{
	if (index == page.index) return;
    page.index = index;
    page.view.frame = [self frameForPageAtIndex:index];
	
	page.title = [[_episodes objectAtIndex:page.index] objectForKey:@"label"];
	page.posterURL = [[_episodes objectAtIndex:page.index] objectForKey:@"thumbnail"];
	page.fanartURL = [[_episodes objectAtIndex:page.index] objectForKey:@"fanart"];
	page.episodeid = [[_episodes objectAtIndex:page.index] objectForKey:@"id"];
	page.tvshow = [[_episodes objectAtIndex:page.index] objectForKey:@"showtitle"];
	page.episode = [[_episodes objectAtIndex:page.index] objectForKey:@"episode"];
	page.season = [[_episodes objectAtIndex:page.index] objectForKey:@"season"];
	page.file = [[_episodes objectAtIndex:page.index] objectForKey:@"file"];

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
	
	page.watched = ([[[_episodes objectAtIndex:page.index] objectForKey:@"playcount"] intValue] > 0);
	
	CGFloat fanartHeight = [page fanartHeight];
	
	if (page.fanartURL
		&& [XBMCImage hasCachedImage:page.fanartURL 
					   thumbnailHeight:fanartHeight])
	{  
		page.fanart = [XBMCImage cachedImage:[[_episodes objectAtIndex:page.index] objectForKey:@"fanart"]
							   thumbnailHeight:fanartHeight];
	}
	else
	{
		page.fanart = nil;
		[XBMCImage askForImage:page.fanartURL
						object:page selector:@selector(fanartLoaded:) 
				 thumbnailHeight:fanartHeight];
	}
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
    return CGSizeMake(bounds.size.width * [self nbEpisodes], bounds.size.height);
}

@end
