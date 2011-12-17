#import "RecentlyAddedEpisodesView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RecentlyAddedEpisodesView
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    if (self = [super init]) {
        [self setClipsToBounds:YES];
		self.backgroundColor = TTSTYLEVAR(recentEpisodesBackColor);
        
        _pageControl = [[[UIPageControl alloc] init] retain];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
        
        _scrollView = [[[UIScrollView alloc] init] retain];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
                
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    _scrollView.delegate = nil;
//    _scrollView.dataSource = nil;
    TT_RELEASE_SAFELY(_pageControl);
    TT_RELEASE_SAFELY(_scrollView);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView

-(void) setFrame:(CGRect) frame
{
    [super setFrame:frame];
    [self layoutSubviews];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    int pageControlHeight = 0;
    if (!_pageControl.hidden) 
    {
        [_pageControl setFrame:CGRectMake(0,self.height - 20, self.width, 20)];
        pageControlHeight = _pageControl.height;
    }
    
    
    
    [_scrollView setFrame:CGRectMake(0,0, self.bounds.size.width
                                     , self.bounds.size.height - pageControlHeight)];
    
}

@end
