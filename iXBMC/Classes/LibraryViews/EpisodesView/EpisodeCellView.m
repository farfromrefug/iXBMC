//
//  EpisodesCellView.m
//  iXBMC
//
//  Created by Martin Guillon on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EpisodeCellView.h"
#import "EpisodeTableItem.h"
#import "XBMCImage.h"
//#import "UIImage+Alpha.h"
//#import "UIImage+Resize.h"

@implementation EpisodeCellView
@synthesize item = _item;
@synthesize highlighted;
@synthesize editing;


- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
        self.backgroundColor = [UIColor clearColor];
		_line = [TTIMAGE(@"bundle://cellline.png") retain];
		_posterShadow = [TTIMAGE(@"bundle://coverSmall.png") retain];
		_posterShadowSelected = [TTIMAGE(@"bundle://coverSmallSelected.png") retain];
		_newFlag = [TTIMAGE(@"bundle://UnWatched.png") retain];
		/*
		 Cache the formatter. Normally you would use one of the date formatter styles (such as NSDateFormatterShortStyle), but here we want a specific format that excludes seconds.
		 */
//		dateFormatter = [[NSDateFormatter alloc] init];
//		[dateFormatter setDateFormat:@"h:mm a"];
		self.opaque = YES;
	}
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_stars);
    TT_RELEASE_SAFELY(_item);
    TT_RELEASE_SAFELY(_posterShadow);
    TT_RELEASE_SAFELY(_posterShadowSelected);
    TT_RELEASE_SAFELY(_newFlag);
    TT_RELEASE_SAFELY(_line);
    [super dealloc];
}

- (void)setItem:(EpisodeTableItem *)item {
	
	// If the time zone wrapper changes, update the date formatter and abbreviation string.
	if (_item != item) {
		TT_RELEASE_SAFELY(_item);
		_item = [item retain];

		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		TT_RELEASE_SAFELY(_stars);
        BOOL showStars = [[defaults valueForKey:@"episodeCell:ratingStars"] boolValue];
        if (showStars)
        {
            if (_item.rating && ![_item.rating isEqual:@"0"]) 
            {
                
                NSString* url = [NSString stringWithFormat:@"bundle://star.%@_small.png",item.rating];
                _stars = [TTIMAGE(url) retain];
            }
            else
            {
                _stars = [TTIMAGE(@"bundle://star.0.0_small.png") retain];
            }
        }
		[self loadImage];
		
	}
	// May be the same wrapper, but the date may have changed, so mark for redisplay.
	[self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)lit {
	// If highlighted state changes, need to redisplay.
	if (highlighted != lit) {
		highlighted = lit;	

		[self setNeedsDisplay];
	}
}



- (void)drawRect:(CGRect)rect {
		
#define MAIN_FONT_SIZE 14
#define MIN_MAIN_FONT_SIZE 14
#define SECONDARY_FONT_SIZE 12
#define THIRD_FONT_SIZE 12
#define MIN_SECONDARY_FONT_SIZE 10
	
	// Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	if (highlighted) {
		CGContextSetRGBFillColor(ctx, 100, 100, 100, 0.2);
		CGContextFillRect(ctx, self.bounds);
	}
	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *secondaryTextColor = nil;
	UIFont *secondaryFont = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *thirdTextColor = nil;
	UIFont *thirdFont = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
	
	// Choose font color based on highlighted state.
	if (!highlighted) {
		mainTextColor = [UIColor whiteColor];
		secondaryTextColor = [UIColor grayColor];
		thirdTextColor = [UIColor grayColor];
	}
	else {
		mainTextColor = TTSTYLEVAR(themeColor);
		secondaryTextColor = [UIColor whiteColor];
		thirdTextColor = [UIColor whiteColor];
	}
	
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat height = contentRect.size.height;
	CGFloat width = contentRect.size.width;
	CGFloat yearBgdWidth = 0;
	CGFloat yearBgdLeft = boundsX +  width - yearBgdWidth;
	CGFloat left = 0;
	CGFloat photoHeight = height - 4;
	CGFloat photoWidth = photoHeight*5/3;
	left = boundsX + 5 + photoWidth + kTableCellSmallMargin;
	
	CGPoint point;
	
	CGFloat actualFontSize;
//	CGSize size;
	
//	point = CGPointMake(boundsX, boundsY + height - 1);
	[_line drawInRect:CGRectMake(boundsX, boundsY + height - 1
								 , width, 1) 
						  contentMode:UIViewContentModeScaleToFill];
	
		
	CGRect shadowRect = CGRectMake(boundsX + 5, boundsY + 2
								   , photoWidth, photoHeight);
	CGRect posterRect = CGRectMake(0, 0
								   , shadowRect.size.width*0.94
								   , shadowRect.size.height*0.92);
	posterRect.origin.x = shadowRect.origin.x + (shadowRect.size.width - posterRect.size.width)/2;
	posterRect.origin.y = shadowRect.origin.y + (shadowRect.size.height - posterRect.size.height)/2;
	
	
	///All episodes case
	if ([_item.episode intValue] == -1)
	{
		CGFloat firstLabelHeight = mainFont.ttLineHeight;
		CGFloat textWidth = boundsX + width - left;
		point = CGPointMake(left, boundsY + height/2 - firstLabelHeight/2);
		
		[mainTextColor set];
		[_item.label drawAtPoint:point forWidth:textWidth withFont:mainFont minFontSize:MAIN_FONT_SIZE actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
		return;
	}
	//////
	
	if (highlighted) 
	{
		if (_posterShadowSelected)
		{
			[_posterShadowSelected drawInRect:shadowRect 
								  contentMode:UIViewContentModeScaleToFill];
		}
	}
	else
	{
		if (_posterShadow)
		{
			[_posterShadow drawInRect:shadowRect
						  contentMode:UIViewContentModeScaleToFill];
		}
		
		//year background
		CGContextSetRGBFillColor(ctx, 100, 100, 100, 0.2);
		CGContextFillRect(ctx, CGRectMake(yearBgdLeft, boundsY, yearBgdWidth, height));
	}
	
	if (_item.poster)
	{
		//		[_item.poster drawInRect:posterRect contentMode:UIViewContentModeScaleToFill];
		[_item.poster drawInRect:posterRect radius:4 contentMode:UIViewContentModeScaleToFill];
	}
	
	if (!_item.watched)
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

	CGFloat firstLabelHeight = mainFont.ttLineHeight;
	CGFloat secondLabelHeight = secondaryFont.ttLineHeight;
	CGFloat thirdLabelHeight = thirdFont.ttLineHeight;
	CGFloat paddingY = (height - (firstLabelHeight + secondLabelHeight))/2;
	if (firstLabelHeight + secondLabelHeight  + paddingY > height)
	{
		secondLabelHeight = 0;
//					thirdLabelHeight = 0;
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
	CGFloat textWidth = yearBgdLeft - left;
	
	[mainTextColor set];
	point = CGPointMake(left, paddingY);
	
	[_item.label drawAtPoint:point forWidth:textWidth withFont:mainFont minFontSize:MAIN_FONT_SIZE actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	
	[secondaryTextColor set];
	point = CGPointMake(left, paddingY + firstLabelHeight);
	NSString *text = [NSString stringWithFormat:@"Season %02d ● Season %02d"
			,[_item.season intValue], [_item.episode intValue]];
	[text drawAtPoint:point forWidth:textWidth withFont:secondaryFont minFontSize:SECONDARY_FONT_SIZE actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//		
	[thirdTextColor set];
	point = CGPointMake(left, paddingY + firstLabelHeight + secondLabelHeight);
	[_item.runtime drawAtPoint:point forWidth:textWidth withFont:thirdFont minFontSize:THIRD_FONT_SIZE actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];

//	[[UIColor whiteColor] set];
//	[_item.firstaired drawInRect:CGRectMake(yearBgdLeft, height/4 - secondLabelHeight/2
//									  ,yearBgdWidth, secondLabelHeight) withFont:secondaryFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	if (_stars != nil)
	{
		//		point = CGPointMake(yearBgdLeft, height*3/4 - _stars.size.height/2);
		//		[_stars drawAtPoint:point];
		[_stars drawInRect:CGRectMake(boundsX + width - 60, height/2, 60, height/2) 
			   contentMode:UIViewContentModeScaleAspectFit];
	}
	else
	{
		//		point = CGPointMake(yearBgdLeft, height*3/4 - secondLabelHeight/2);
		[_item.rating drawInRect:CGRectMake(yearBgdLeft, height*3/4 - secondLabelHeight/2
											,yearBgdWidth, secondLabelHeight) withFont:secondaryFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
		
	}
}

- (void)imageLoaded:(NSDictionary*) result
{
    if ([[result valueForKey:@"url"] isEqualToString:((EpisodeTableItem*)_item).imageURL]
        && [result objectForKey:@"image"])
    {
//		NSLog(@"cover %@", NSStringFromCGSize(((UIImage*)[result objectForKey:@"image"]).size));

		_item.poster = [result objectForKey:@"image"];
		[self setNeedsDisplay];
    }
}

- (void)loadImage
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = TTSTYLEVAR(episodeCellMaxHeight);
	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
	{
		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
	}
	
	if (_item.imageURL && [XBMCImage hasCachedImage:_item.imageURL thumbnailHeight:height]) 
	{
		_item.poster = [XBMCImage cachedImage:_item.imageURL 
								thumbnailHeight:height];
	}
	else if (_item.imageURL && !_item.poster )
    {
		//		NSLog(@"scale %f", [UIScreen mainScreen].scale);
		//        NSInteger height = TTSTYLEVAR(EpisodessViewCellsMaxHeight);
        [XBMCImage askForImage:_item.imageURL 
                        object:self selector:@selector(imageLoaded:) 
                 thumbnailHeight:height];
    }
}


@end
