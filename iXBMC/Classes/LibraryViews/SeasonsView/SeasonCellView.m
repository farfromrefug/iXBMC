//
//  SeasonsCellView.m
//  iXBMC
//
//  Created by Martin Guillon on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SeasonCellView.h"
#import "SeasonTableItem.h"

@implementation SeasonCellView

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) 
	{
		_newFlag = [TTIMAGE(@"bundle://UnWatched.png") retain];
	}
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_newFlag);
    [super dealloc];
}

- (void)setItem:(SeasonTableItem *)item 
{
	[super setItem:item];
}

- (CGFloat)posterHeight
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = TTSTYLEVAR(seasonCellMaxHeight);
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
	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = TTSTYLEVAR(tableViewCellTextFirstFont);
	
	// Color and font for the secondary text items (GMT offset, day)
//	UIColor *secondaryTextColor = nil;
//	UIFont *secondaryFont = TTSTYLEVAR(tableViewCellTextSecondFont);
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *thirdTextColor = nil;
	UIFont *thirdFont = TTSTYLEVAR(tableViewCellTextThirdFont);
	
	// Choose font color based on highlighted state.
	if (highlighted) {
		mainTextColor = TTSTYLEVAR(tableViewCellHighlightedTextFirstColor);
//		secondaryTextColor = TTSTYLEVAR(tableViewCellHighlightedTextSecondColor);
		thirdTextColor = TTSTYLEVAR(tableViewCellHighlightedTextThirdColor);
	}
	else {
		mainTextColor = TTSTYLEVAR(tableViewCellTextFirstColor);
//		secondaryTextColor = TTSTYLEVAR(tableViewCellTextSecondColor);
		thirdTextColor = TTSTYLEVAR(tableViewCellTextThirdColor);
	}
	
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat height = contentRect.size.height;
	CGFloat width = contentRect.size.width;
//	CGFloat yearBgdWidth = 60;
//	CGFloat yearBgdLeft = boundsX +  width - yearBgdWidth;
	CGFloat left = 5;
	CGFloat right = boundsX + width - 5;
	CGFloat photoHeight = height - 4;
	
	CGFloat photoWidth = photoHeight*2/3;
	if (_item.poster && _item.poster.size.width > _item.poster.size.height)
	{
		photoHeight = photoHeight*2/3;
		photoWidth = photoHeight*2;
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
	
	if (!((SeasonTableItem*)_item).watched)
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

	CGFloat firstLabelHeight = mainFont.ttLineHeight;
	CGFloat thirdLabelHeight = thirdFont.ttLineHeight;
	CGFloat paddingY = (height - (firstLabelHeight))/2;
	if (firstLabelHeight  + paddingY > height)
	{
		//		thirdLabelHeight = 0;
		paddingY = floor((height - (firstLabelHeight))/2);
	}
	else
	{
		paddingY = (height - (firstLabelHeight + thirdLabelHeight))/2;
		if (firstLabelHeight + thirdLabelHeight + paddingY > height)
		{
			//			thirdLabelHeight = 0;
			paddingY = (height - (firstLabelHeight))/2;
		} 
	} 
	CGFloat textWidth = posterRect.origin.x - left;
	
	[mainTextColor set];
	point = CGPointMake(left, paddingY);
	[_item.label drawAtPoint:point forWidth:textWidth withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
	
//		[secondaryTextColor set];
//		point = CGPointMake(left, paddingY + firstLabelHeight);
//		[_item.genre drawAtPoint:point forWidth:textWidth withFont:secondaryFont lineBreakMode:UILineBreakModeTailTruncation];
	
	if ([((SeasonTableItem*)_item).nbEpisodes intValue] > 0)
	{
		NSString* thirdline = [NSString stringWithFormat:@"%@ Episodes"
							   ,((SeasonTableItem*)_item).nbEpisodes];
		if ([((SeasonTableItem*)_item).nbUnWatched intValue] > 0)
		{
			thirdline = [thirdline stringByAppendingFormat:@" ● %@ Unwatched", ((SeasonTableItem*)_item).nbUnWatched];
		}
		
		[thirdTextColor set];
		point = CGPointMake(left, paddingY + firstLabelHeight);
		[thirdline drawAtPoint:point forWidth:textWidth withFont:thirdFont lineBreakMode:UILineBreakModeTailTruncation];
	}
}

@end
