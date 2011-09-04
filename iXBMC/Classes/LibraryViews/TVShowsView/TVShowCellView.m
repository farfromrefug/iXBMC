//
//  TVShowsCellView.m
//  iXBMC
//
//  Created by Martin Guillon on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TVShowCellView.h"
#import "TVShowTableItem.h"
#import "XBMCImage.h"

@implementation TVShowCellView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) 
	{
//		_newFlag = [TTIMAGE(@"bundle://UnWatched.png") retain];
	}
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_stars);
    TT_RELEASE_SAFELY(_newFlag);
    [super dealloc];
}

- (void)setItem:(BaseTableItem *)item {
	// If the time zone wrapper changes, update the date formatter and abbreviation string.
	if (_item != item) 
	{
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		TT_RELEASE_SAFELY(_stars);
        BOOL showStars = [[defaults valueForKey:@"tvshowCell:ratingStars"] boolValue];
//        if (showStars)
//        {
//            if (((TVShowTableItem*)item).rating 
//				&& ![((TVShowTableItem*)item).rating isEqual:@"0"]) 
//            {
//                
//                NSString* url = [NSString stringWithFormat:@"bundle://star.%@_small.png"
//								 , ((TVShowTableItem*)item).rating];
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
	CGFloat height = TTSTYLEVAR(tvshowCellMaxHeight);
	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
	{
		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
	}
	return height;	
}

- (void)drawRect:(CGRect)rect {	
	// Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);

	UIColor *mainTextHighlightedColor = TTSTYLEVAR(tableViewCellHighlightedTextFirstColor);

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
	
	CGPoint point;
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat height = contentRect.size.height;
	CGFloat width = contentRect.size.width;
	CGFloat left = 3;
	CGFloat right = boundsX + width;
	CGFloat photoHeight = height;
	
	CGFloat photoWidth = photoHeight*2/3;
	if (_item.poster && _item.poster.size.width > _item.poster.size.height)
	{
//		photoHeight = photoHeight;
//		photoWidth = photoHeight*3/2;
	}
			
	CGRect posterRect = CGRectMake(right - photoWidth
								   , boundsY + height/2 - photoHeight/2
								   , photoWidth, photoHeight);
	
	CGRect bannerRect = CGRectMake(boundsX, boundsY, posterRect.origin.x, 20);
	
	[TTSTYLEVAR(tableViewCellSecondColor) set];
	CGContextFillRect(ctx, bannerRect);
	[TTSTYLEVAR(tableViewCellSecondBorderColor) set];
	CGContextFillRect(ctx, CGRectMake(1, bannerRect.size.height
									  , bannerRect.size.width - 1, 1));
		
	if (_item.poster && _item.poster.size.width > _item.poster.size.height)
	{
		
	}
	
	if (_item.poster)
	{
		[_item.poster drawInRect:posterRect contentMode:UIViewContentModeLeft];
	}
	
	if (!((TVShowTableItem*)_item).watched)
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
	CGRect textRect = CGRectMake(left, bannerRect.origin.y, bannerRect.size.width - 2*left, bannerRect.size.height);
	[[_item.label uppercaseString] drawInRect:textRect withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
	
	[secondaryTextColor set];
	point = CGPointMake(left, self.bottom - thirdLabelHeight - secondLabelHeight - 3);
	[((TVShowTableItem*)_item).genre drawAtPoint:point forWidth:textWidth withFont:secondaryFont lineBreakMode:UILineBreakModeTailTruncation];
	
	NSString* thirdline = [NSString stringWithFormat:@"%@ Episodes"
						   ,((TVShowTableItem*)_item).nbEpisodes];
	if ([((TVShowTableItem*)_item).nbUnWatched intValue] > 0)
	{
		thirdline = [NSString stringWithFormat:@"%@ of %@ new Episodes"
					 , ((TVShowTableItem*)_item).nbUnWatched
					 , ((TVShowTableItem*)_item).nbEpisodes];
	}
	
	[thirdTextColor set];
	point = CGPointMake(left, self.bottom - thirdLabelHeight - 3);
	[thirdline drawAtPoint:point forWidth:textWidth withFont:thirdFont lineBreakMode:UILineBreakModeTailTruncation];
		
	NSString* ratingStars = @"■■■■■";
	UIFont* ratingFont = [UIFont fontWithName:@"Arial" size:20.0];
	CGSize ratingSize = [ratingStars sizeWithFont:ratingFont];
	point = CGPointMake(posterRect.origin.x - ratingSize.width, self.bottom - ratingSize.height + 2);
	
	[ratingStars drawAtPoint:point forWidth:ratingSize.width withFont:ratingFont lineBreakMode:UILineBreakModeClip];
	
	[mainTextHighlightedColor set];
	point = CGPointMake(point.x - 1, point.y - 1);
	[ratingStars drawAtPoint:point 
					forWidth:ratingSize.width*([((TVShowTableItem*)_item).rating floatValue]/10.0) withFont:ratingFont lineBreakMode:UILineBreakModeClip];
}

@end
