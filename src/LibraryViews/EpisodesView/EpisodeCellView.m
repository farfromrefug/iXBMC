
#import "EpisodeCellView.h"
#import "EpisodeTableItem.h"

@implementation EpisodeCellView

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		_newFlag = [TTIMAGE(@"bundle://UnWatched.png") retain];
	}
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_stars);
    TT_RELEASE_SAFELY(_newFlag);
    [super dealloc];
}

- (void)setItem:(EpisodeTableItem *)item {
	
	// If the time zone wrapper changes, update the date formatter and abbreviation string.
	if (_item != item) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		TT_RELEASE_SAFELY(_stars);
        BOOL showStars = [[defaults valueForKey:@"episodeCell:ratingStars"] boolValue];
        if (showStars)
        {
            if (((EpisodeTableItem*)_item).rating && ![((EpisodeTableItem*)_item).rating isEqual:@"0"]) 
            {
                
                NSString* url = [NSString stringWithFormat:@"bundle://star.%@_small.png",item.rating];
                _stars = [TTIMAGE(url) retain];
            }
            else
            {
                _stars = [TTIMAGE(@"bundle://star.0.0_small.png") retain];
            }
        }		
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

- (void)drawRect:(CGRect)rect 
{	
	// Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = TTSTYLEVAR(tableViewCellTextFirstFont);
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *secondaryTextColor = nil;
	UIFont *secondaryFont = TTSTYLEVAR(tableViewCellTextSecondFont);
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *thirdTextColor = nil;
	UIFont *thirdFont = TTSTYLEVAR(tableViewCellTextThirdFont);
	
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
	
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat height = contentRect.size.height;
	CGFloat width = contentRect.size.width;
	CGFloat left = 5;
	CGFloat right = boundsX + width - 5;
	CGFloat photoHeight = height - 4;
	
	CGFloat photoWidth = photoHeight*2/3;
	if (_item.poster && _item.poster.size.width > _item.poster.size.height)
	{
		photoHeight = photoHeight;
		photoWidth = photoHeight*3/2;
	}
		
	CGPoint point;
	
	CGRect posterRect = CGRectMake(right - photoWidth
								   , boundsY + height/2 - photoHeight/2
								   , photoWidth, photoHeight);
	if (_item.poster && _item.poster.size.width > _item.poster.size.height)
	{
		
	}
	
	if (_item.poster)
	{
		[_item.poster drawInRect:posterRect radius:4 contentMode:UIViewContentModeScaleAspectFill];
	}
	
	if (!((EpisodeTableItem*)_item).watched)
	{
		if (_newFlag)
		{
			int newFlagWidth = posterRect.size.height*4/9;
			[_newFlag drawInRect:CGRectMake(posterRect.origin.x + posterRect.size.width - newFlagWidth
											, posterRect.origin.y
											, newFlagWidth, newFlagWidth) 
					 contentMode:UIViewContentModeScaleToFill];
		}
	}
	//	}
	
	CGFloat firstLabelHeight = mainFont.ttLineHeight;
	CGFloat secondLabelHeight = secondaryFont.ttLineHeight;
	CGFloat thirdLabelHeight = thirdFont.ttLineHeight;
	CGFloat paddingY = (height - (firstLabelHeight + secondLabelHeight))/2;
	if (firstLabelHeight + secondLabelHeight  + paddingY > height)
	{
		secondLabelHeight = 0;
		//		thirdLabelHeight = 0;
		paddingY = floor((height - (firstLabelHeight))/2);
	}
	else
	{
		paddingY = (height - (firstLabelHeight + secondLabelHeight + thirdLabelHeight))/2;
		if (firstLabelHeight + secondLabelHeight + thirdLabelHeight + paddingY > height)
		{
			//			thirdLabelHeight = 0;
			paddingY = (height - (firstLabelHeight + secondLabelHeight))/2;
		} 
	} 
	CGFloat textWidth = posterRect.origin.x - left;
	
	[mainTextColor set];
	point = CGPointMake(left, paddingY);
	[_item.label drawAtPoint:point forWidth:textWidth withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
	
	if ([((EpisodeTableItem*)_item).episode intValue] > 0)
	{
		NSString *text = [NSString stringWithFormat:@"Season %02d ● Episode %02d"
						  ,[((EpisodeTableItem*)_item).season intValue], [((EpisodeTableItem*)_item).episode intValue]];
		[secondaryTextColor set];
		point = CGPointMake(left, paddingY + firstLabelHeight);
		[text drawAtPoint:point forWidth:textWidth withFont:secondaryFont lineBreakMode:UILineBreakModeTailTruncation];
		
		[thirdTextColor set];
		point = CGPointMake(left, paddingY + firstLabelHeight + secondLabelHeight);
		[((EpisodeTableItem*)_item).runtime drawAtPoint:point forWidth:textWidth withFont:thirdFont lineBreakMode:UILineBreakModeTailTruncation];
	}
}

@end
