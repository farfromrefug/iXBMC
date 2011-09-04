
#import "MovieCellView.h"
#import "MovieTableItem.h"
#import "XBMCImage.h"

@implementation MovieCellView


- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
//		self.contentScaleFactor = 1.0;
		self.contentMode = UIViewContentModeTop;
//		self.contentStretch = self.realContentRect;
//		_newFlag = [TTIMAGE(@"bundle://newFlagSmall.png") retain];
//		_frame = [TTIMAGE(@"bundle://frameSmall.png") retain];
//		_noCover = [TTIMAGE(@"bundle://noCoverSmall.png") retain];
	}
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_stars);
    TT_RELEASE_SAFELY(_frame);
    TT_RELEASE_SAFELY(_noCover);
    TT_RELEASE_SAFELY(_newFlag);
    [super dealloc];
}

- (void)setItem:(MovieTableItem *)item {
	
	if (_item != item) {
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		TT_RELEASE_SAFELY(_stars);
//        BOOL showStars = [[defaults valueForKey:@"movieCell:ratingStars"] boolValue];
//        if (showStars)
//        {
//            if (((MovieTableItem*)_item).rating && ![((MovieTableItem*)_item).rating isEqual:@"0"]) 
//            {
//                
//                NSString* url = [NSString stringWithFormat:@"bundle://star.%@_small.png",item.rating];
//                _stars = [TTIMAGE(url) retain];
//            }
//            else
//            {
//                _stars = [TTIMAGE(@"bundle://star.0.0_small.png") retain];
//            }
//        }		
	}
	[super setItem:item];
}

- (CGFloat)posterHeight
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = TTSTYLEVAR(movieCellMaxHeight);
	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
	{
		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
	}
	return height;
}

- (void) setFrame:(CGRect)frame 
{
//	NSLog(@"%@ setFrame %@", _item.label, NSStringFromCGRect(frame));
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//	NSLog(@"%@ layout Subviews", _item.label);
}

- (void)drawRect:(CGRect)rect
{	
	// Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	UIColor *mainTextHighlightedColor = TTSTYLEVAR(tableViewCellHighlightedTextFirstColor);
	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIColor *secondaryTextColor = nil;
	UIColor *thirdTextColor = nil;
	UIFont *mainFont = TTSTYLEVAR(tableViewCellTextFirstFont);
	UIFont *secondaryFont = TTSTYLEVAR(tableViewCellTextSecondFont);
	UIFont *thirdFont = TTSTYLEVAR(tableViewCellTextThirdFont);
	
	NSString* ratingStars = @"■■■■■";
	UIFont* ratingFont = [UIFont fontWithName:@"Arial" size:18.0];
	CGSize ratingSize = [ratingStars sizeWithFont:ratingFont];
	
	CGPoint point;
	CGRect contentRect = self.realContentRect;
	CGFloat topMarging = 4;
	CGFloat leftMarging = 5;
	CGFloat boundsX = contentRect.origin.x + leftMarging;
	CGFloat boundsY = contentRect.origin.y + topMarging;
	CGFloat height = contentRect.size.height - 2*topMarging;
	CGFloat width = contentRect.size.width - 2*leftMarging;
	CGFloat left = boundsX + 3;
	CGFloat right = boundsX + width;
	CGFloat photoHeight = 0;
	CGFloat photoWidth = 0;
	
	// Choose font color based on highlighted state.
	if (highlighted) {
		mainTextColor = TTSTYLEVAR(tableViewCellHighlightedTextFirstColor);
		secondaryTextColor = TTSTYLEVAR(tableViewCellHighlightedTextSecondColor);
		thirdTextColor = TTSTYLEVAR(tableViewCellHighlightedTextThirdColor);
	}
	else {
		mainTextColor = TTSTYLEVAR(tableViewCellTextFirstColor);
		secondaryTextColor = TTSTYLEVAR(tableViewCellTextSecondColor);
		thirdTextColor = TTSTYLEVAR(tableViewCellTextThirdColor);
	}
	
	[TTSTYLEVAR(tableViewCellFirstBorderColor) set];
	CGContextFillRect(ctx, CGRectMake(self.bounds.origin.x + leftMarging + 2
									  , self.bounds.origin.y + topMarging + 2
									  , self.bounds.size.width - 2*leftMarging
									  , self.bounds.size.height - 2*topMarging));
	[TTSTYLEVAR(tableViewCellMainColor) set];
	CGContextFillRect(ctx, CGRectMake(self.bounds.origin.x + leftMarging
									  , self.bounds.origin.y + topMarging
									  , self.bounds.size.width - 2*leftMarging
									  , self.bounds.size.height - 2*topMarging));
	
	if (_item.poster)
	{
		photoHeight = height;
		
		photoWidth = photoHeight*2/3;
		if (_item.poster.size.width > _item.poster.size.height)
		{
			//		photoHeight = photoHeight;
			//		photoWidth = photoHeight*3/2;
		}
	}

	CGRect posterRect = CGRectMake(right - photoWidth
								   , boundsY + height/2 - photoHeight/2
								   , photoWidth, photoHeight);
	
	CGRect bannerRect = CGRectMake(boundsX - 1, boundsY, width + 1, 20);
	
	[TTSTYLEVAR(tableViewCellSecondColor) set];
	CGContextFillRect(ctx, bannerRect);
	[TTSTYLEVAR(tableViewCellSecondBorderColor) set];
	CGContextFillRect(ctx, CGRectMake(bannerRect.origin.x + 1
									  , bannerRect.origin.y + bannerRect.size.height
									  , bannerRect.size.width - 1, 1));
	
	if (_item.poster && _item.poster.size.width > _item.poster.size.height)
	{
		
	}
	
	if (_item.poster)
	{
		[_item.poster drawInRect:posterRect contentMode:UIViewContentModeScaleToFill];
	}
	
	if (!((MovieTableItem*)_item).watched)
	{
		if (_newFlag)
		{
			//			int newFlagWidth = posterRect.size.height*4/9;
			//			[_newFlag drawInRect:CGRectMake(posterRect.origin.x + posterRect.size.width - newFlagWidth
			//											, posterRect.origin.y
			//											, newFlagWidth, newFlagWidth) 
			//					 contentMode:UIViewContentModeScaleToFill];
		}
	}
	
	CGFloat secondLabelHeight = secondaryFont.ttLineHeight;
	CGFloat thirdLabelHeight = thirdFont.ttLineHeight;
	
	CGFloat textWidth = posterRect.origin.x - 2*left;
	
	[mainTextColor set];
	CGRect textRect = CGRectMake(left, bannerRect.origin.y + 1, bannerRect.size.width - 2*left, bannerRect.size.height);
	[[_item.label uppercaseString] drawInRect:textRect withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
	
	[secondaryTextColor set];
	point = CGPointMake(left, boundsY + height - thirdLabelHeight - secondLabelHeight - 3);
	[((MovieTableItem*)_item).genre drawAtPoint:point forWidth:textWidth withFont:secondaryFont lineBreakMode:UILineBreakModeTailTruncation];
	
	textWidth = textWidth - ratingSize.width;
	
	[thirdTextColor set];
	point = CGPointMake(left, boundsY + height - thirdLabelHeight - 3);
	[((MovieTableItem*)_item).runtime drawAtPoint:point forWidth:textWidth withFont:thirdFont lineBreakMode:UILineBreakModeTailTruncation];
	
	point = CGPointMake(posterRect.origin.x - ratingSize.width - 3, boundsY + height - ratingSize.height);
	
	[ratingStars drawAtPoint:point forWidth:ratingSize.width withFont:ratingFont lineBreakMode:UILineBreakModeClip];
	
	[mainTextHighlightedColor set];
//	point = CGPointMake(point.x, point.y - 1);
	[ratingStars drawAtPoint:point 
					forWidth:ratingSize.width*([((MovieTableItem*)_item).rating floatValue]/10.0) withFont:ratingFont lineBreakMode:UILineBreakModeClip];
}

@end
