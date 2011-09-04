//
//  TableHeaderView.m
//  iXBMC
//
//  Created by Martin Guillon on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableHeaderView.h"


@implementation TableHeaderView
@synthesize label      = _label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
	
    TT_RELEASE_SAFELY(_label);
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
	
	// Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);

	
//	CGRect contentRect = self.bounds;
//	CGFloat boundsX = contentRect.origin.x;
//	CGFloat boundsY = contentRect.origin.y;
//	CGFloat height = contentRect.size.height;
//	CGFloat width = contentRect.size.width;
//	CGFloat left = 0;
//	CGFloat photoHeight = height - 4;
//	left = boundsX + 5 + photoHeight*2/3 + kTableCellSmallMargin;
	
//	CGPoint point;
//	
//	
//	CGContextSetStrokeColorWithColor(ctx, TTSTYLEVAR(tableViewHeaderMainColor).CGColor);
//	CGContextSetFillColorWithColor(ctx, TTSTYLEVAR(tableViewHeaderMainColor).CGColor);
//	CGContextFillRect(ctx, self.bounds);
//
//	CGContextSetLineWidth(ctx, 2.0);
//	
//	CGContextSetStrokeColorWithColor(ctx, TTSTYLEVAR(tableViewHeaderBorderColor).CGColor);
//	CGContextMoveToPoint(ctx, 0,boundsY + height); //start at this point
//	CGContextAddLineToPoint(ctx, width,boundsY + height); //draw to this point
//	CGContextStrokePath(ctx);
	
	[TTSTYLEVAR(tableViewHeaderMainColor) set];
	CGContextFillRect(ctx, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 1));
	[TTSTYLEVAR(tableViewHeaderBorderColor) set];
	CGContextFillRect(ctx, CGRectMake(0, self.bounds.size.height - 1
									, self.bounds.size.width, 1));
		
	CGFloat firstLabelHeight = TTSTYLEVAR(tableViewHeaderTextFont).ttLineHeight;
		
	CGPoint point = CGPointMake(10, self.bounds.origin.y + self.bounds.size.height/2 - firstLabelHeight/2);
	[TTSTYLEVAR(tableViewHeaderTextColor) set];
	[[_label uppercaseString] drawAtPoint:point forWidth:self.bounds.size.width - 10 withFont:TTSTYLEVAR(tableViewHeaderTextFont) lineBreakMode:UILineBreakModeTailTruncation];
	
	
}


@end
