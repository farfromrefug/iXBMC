#import "RecentMovieView.h"

#define H_SPACING 10
#define V_SPACING 5
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RecentMovieView
@synthesize poster = _poster;
@synthesize fanart = _fanart;
@synthesize title = _title;
@synthesize watched = _watched;
@synthesize movieid = _movieid;
@synthesize trailer = _trailer;
@synthesize imdb = _imdb;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    if (self = [super init]) {
        [self setClipsToBounds:YES];
		self.backgroundColor = [UIColor clearColor];
		
		_title = @"";
		_fanart = nil;
		_poster = nil;
		_newFlag = [TTIMAGE(@"bundle://unWatched.png") retain];
		_posterBack = [TTIMAGE(@"bundle://coverSmall.png") retain];
		_fanartBack = [TTIMAGE(@"bundle://recentFanart.png") retain];
		_titleBack = [TTIMAGE(@"bundle://recentFanartTitleBack.png") retain];
		_playTrailerButton = [TTIMAGE(@"bundle://OSDPlayFO.png") retain];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_poster);
    TT_RELEASE_SAFELY(_posterBack);
    TT_RELEASE_SAFELY(_fanart);
    TT_RELEASE_SAFELY(_fanartBack);
    TT_RELEASE_SAFELY(_newFlag);
    TT_RELEASE_SAFELY(_playTrailerButton);
    TT_RELEASE_SAFELY(_titleBack);
    TT_RELEASE_SAFELY(_title);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView

- (void)drawRect:(CGRect)rect {
	
#define MAIN_FONT_SIZE 14
#define MIN_MAIN_FONT_SIZE 14

	// Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
	mainTextColor = [UIColor grayColor];
	
	
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat height = contentRect.size.height;
	CGFloat width = contentRect.size.width;
	//	CGSize size;
	
	int thumbnailHeight = height - 2*V_SPACING;
	
	CGRect posterShadowRect = CGRectMake(boundsX + H_SPACING, boundsY + V_SPACING, 
								   thumbnailHeight*2/3, thumbnailHeight);
	
	CGRect posterRect = CGRectMake(0, 0
								   , posterShadowRect.size.width*0.88
								   , posterShadowRect.size.height*0.92);
	posterRect.origin.x = posterShadowRect.origin.x + (posterShadowRect.size.width - posterRect.size.width)/2;
	posterRect.origin.y = posterShadowRect.origin.y + (posterShadowRect.size.height - posterRect.size.height)/2;
	
	CGFloat posterRight = posterShadowRect.origin.x + posterShadowRect.size.width;
	CGRect fanartShadowRect = CGRectMake(posterRight + H_SPACING, V_SPACING, 
										 width - posterRight - 2*H_SPACING, thumbnailHeight);
	
	CGRect fanartRect = CGRectMake(0, 0
								   , fanartShadowRect.size.width*0.96
								   , fanartShadowRect.size.height*0.92);
	fanartRect.origin.x = fanartShadowRect.origin.x + (fanartShadowRect.size.width - fanartRect.size.width)/2;
	fanartRect.origin.y = fanartShadowRect.origin.y + (fanartShadowRect.size.height - fanartRect.size.height)/2;

	if (_posterBack)
	{
		[_posterBack drawInRect:posterShadowRect
					  contentMode:UIViewContentModeScaleToFill];
	}
		
	
	if (_poster)
	{
		[_poster drawInRect:posterRect 
					 radius:4 contentMode:UIViewContentModeScaleToFill];
	}
	
	if (!_watched)
	{
		if (_newFlag)
		{
			int newFlagWidth = posterRect.size.width*2/3;
			[_newFlag drawInRect:CGRectMake(posterRect.origin.x + posterRect.size.width - newFlagWidth
											, posterRect.origin.y
											, newFlagWidth, newFlagWidth) 
					 contentMode:UIViewContentModeScaleToFill];
		}
	}
	
	if (_fanartBack)
	{
		[_fanartBack drawInRect:fanartShadowRect
					contentMode:UIViewContentModeScaleToFill];
	}
	
	
	if (_fanart)
	{
		[_fanart drawInRect:fanartRect 
					 radius:4 contentMode:UIViewContentModeScaleAspectFit];
		if (_titleBack)
		{
			[_titleBack drawInRect:fanartRect 
						 contentMode:UIViewContentModeScaleToFill];
		}
	}
	
	if (![_trailer isEqualToString:@""] && _playTrailerButton)
	{
		CGRect playTrailerButtonRect = CGRectMake(fanartShadowRect.origin.x 
												  + fanartShadowRect.size.width/2 - 30
												  , fanartShadowRect.origin.y 
												  + fanartShadowRect.size.height/2 - 30, 60, 60);
		[_playTrailerButton drawInRect:playTrailerButtonRect
					contentMode:UIViewContentModeScaleToFill];
	}
	
	
//	CGFloat firstLabelHeight = mainFont.ttLineHeight;
	CGRect titleRect = CGRectMake(fanartRect.origin.x + 5, fanartRect.origin.y
								  + fanartRect.size.height - 20
								, fanartRect.size.width - 10, 20);
//	
	[mainTextColor set];
	[_title drawInRect:titleRect withFont:mainFont  
		  lineBreakMode:UILineBreakModeTailTruncation 
			alignment:UITextAlignmentLeft];
}

@end
