#import "RecentEpisodeView.h"

#define H_SPACING 10
#define V_SPACING 5
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RecentEpisodeView
@synthesize poster = _poster;
@synthesize fanart = _fanart;
@synthesize title = _title;
@synthesize watched = _watched;
@synthesize episodeid = _episodeid;
@synthesize season = _season;
@synthesize episode = _episode;
@synthesize tvshow = _tvshow;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [super init];
    if (self) {
        [self setClipsToBounds:YES];
		self.backgroundColor = [UIColor clearColor];
		
		_title = @"";
		_season = @"";
		_episode = @"";
		_tvshow = @"";
		_fanart = nil;
		_poster = nil;
		_newFlag = [TTIMAGE(@"bundle://unWatched.png") retain];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_poster);
    TT_RELEASE_SAFELY(_fanart);
    TT_RELEASE_SAFELY(_newFlag);
    TT_RELEASE_SAFELY(_title);
    TT_RELEASE_SAFELY(_season);
    TT_RELEASE_SAFELY(_episode);
    TT_RELEASE_SAFELY(_tvshow);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView

- (void)drawRect:(CGRect)rect {

	// Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	UIColor *mainTextColor = TTSTYLEVAR(recentEpisodeTextFirstColor);
	UIFont *mainFont = TTSTYLEVAR(recentEpisodeTextFirstFont);
	
	UIColor *secondaryTextColor = TTSTYLEVAR(recentEpisodeTextSecondColor);
	UIFont *secondaryFont = TTSTYLEVAR(recentEpisodeTextSecondFont);
	
	
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat height = contentRect.size.height;
	CGFloat width = contentRect.size.width;
	
	int thumbnailHeight = height - 2*V_SPACING;
	int thumbnailWidth = thumbnailHeight*5/3;
	
	CGRect posterRect = CGRectMake(boundsX + H_SPACING, boundsY + V_SPACING, 
								   thumbnailWidth, thumbnailHeight);
	
	CGFloat posterRight = posterRect.origin.x + posterRect.size.width;
	CGRect fanartRect = CGRectMake(posterRight + H_SPACING, V_SPACING, 
										 width - posterRight - 2*H_SPACING, thumbnailHeight);
	if (_poster)
	{
		[_poster drawInRect:posterRect 
					 radius:4 contentMode:UIViewContentModeScaleToFill];
	}
	
	if (!_watched)
	{
		if (_newFlag)
		{
			int newFlagWidth = posterRect.size.height*2/3;
			[_newFlag drawInRect:CGRectMake(posterRect.origin.x + posterRect.size.width - newFlagWidth
											, posterRect.origin.y
											, newFlagWidth, newFlagWidth) 
					 contentMode:UIViewContentModeScaleToFill];
		}
	}
	
	if (_fanart)
	{
		[_fanart drawInRect:fanartRect 
					 radius:4 contentMode:UIViewContentModeScaleAspectFit];
		CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.7);
		CGContextFillRect(ctx, fanartRect);
	}
	
	CGFloat firstLabelHeight = mainFont.ttLineHeight;
	CGFloat secondLabelHeight = secondaryFont.ttLineHeight;
	
	CGRect textRect = CGRectMake(fanartRect.origin.x + 5, fanartRect.origin.y
								  + 5
								, fanartRect.size.width - 10, firstLabelHeight);

	[mainTextColor set];
	[_tvshow drawInRect:textRect withFont:mainFont  
		  lineBreakMode:UILineBreakModeTailTruncation 
			alignment:UITextAlignmentLeft];
	
	textRect.origin.y = textRect.origin.y + textRect.size.height;
	textRect.size.height = secondLabelHeight;
	NSString* text = [NSString stringWithFormat:@"Season %@ ● Episode %@", _season, _episode];
	[secondaryTextColor set];
	[text drawInRect:textRect withFont:secondaryFont  
		  lineBreakMode:UILineBreakModeTailTruncation 
			  alignment:UITextAlignmentLeft];
	
	textRect.origin.y = textRect.origin.y + textRect.size.height;
	[_title drawInRect:textRect withFont:secondaryFont  
	   lineBreakMode:UILineBreakModeTailTruncation 
		   alignment:UITextAlignmentLeft];
}

@end
