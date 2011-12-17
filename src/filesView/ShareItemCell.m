
#import "ShareItemCell.h"
#import "ShareItem.h"

@implementation ShareItemCell
@synthesize item = _item;
@synthesize highlighted;
@synthesize editing;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) 
    {
        [self setClipsToBounds:YES];
		
        self.backgroundColor = TTSTYLEVAR(tableViewBackColor);
        self.contentView.backgroundColor = TTSTYLEVAR(tableViewBackColor);
		_text = @"";
		_dirIcon = [TTIMAGE(@"bundle://70-tv.png") retain];

		self.opaque = NO;
	}
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_item);
    TT_RELEASE_SAFELY(_dirIcon);
    TT_RELEASE_SAFELY(_fileIcon);
    TT_RELEASE_SAFELY(_movieIcon);
    TT_RELEASE_SAFELY(_text);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	return TT_ROW_HEIGHT;
}


- (void)setObject:(id)object {
    if (_item != object) {
		TT_RELEASE_SAFELY(_item);
		_item = [(ShareItem*)object retain];
		
		self.textLabel.text = _item.text;
		self.imageView.image = _dirIcon;
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

- (void)prepareForReuse
{
	[self setSelected:FALSE];
}


- (void)drawRect:(CGRect)rect {
	// Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = TTSTYLEVAR(tableViewCellTextFirstFont);
//	
//	// Color and font for the secondary text items (GMT offset, day)
//	UIColor *secondaryTextColor = nil;
//	UIFont *secondaryFont = TTSTYLEVAR(tableViewCellTextSecondFont);
//	
//	// Color and font for the secondary text items (GMT offset, day)
//	UIColor *thirdTextColor = nil;
//	UIFont *thirdFont = TTSTYLEVAR(tableViewCellTextThirdFont);
//	
	// Choose font color based on highlighted state.
	if (highlighted) {
		mainTextColor = TTSTYLEVAR(tableViewCellHighlightedTextFirstColor);
//		secondaryTextColor = TTSTYLEVAR(tableViewCellHighlightedTextSecondColor);
//		thirdTextColor = TTSTYLEVAR(tableViewCellHighlightedTextThirdColor);
	}
	else {
		mainTextColor = TTSTYLEVAR(tableViewCellTextFirstColor);
//		secondaryTextColor = TTSTYLEVAR(tableViewCellTextSecondColor);
//		thirdTextColor = TTSTYLEVAR(tableViewCellTextThirdColor);
	}
	
	CGRect contentRect = self.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat height = contentRect.size.height;
	CGFloat width = contentRect.size.width;
	CGFloat left = 5;
	CGFloat right = boundsX + width - 5;
	CGFloat iconHeight = height - 4;
	
	CGFloat iconWidth = iconHeight;
	
//	BOOL drawText = TRUE;
	
	CGPoint point;
	
	if (highlighted) {
		CGContextSetFillColorWithColor(ctx, TTSTYLEVAR(tableViewCellHighlightedMainColor).CGColor);
		CGContextFillRect(ctx, self.bounds);
	}
	else
	{
		CGContextSetLineWidth(ctx, 1.0);
		
		CGContextSetStrokeColorWithColor(ctx, TTSTYLEVAR(tableViewCellSecondBorderColor).CGColor);
		CGContextMoveToPoint(ctx, 0,boundsY + height); //start at this point
		CGContextAddLineToPoint(ctx, self.bounds.size.width,boundsY + height); //draw to this point
		CGContextStrokePath(ctx);
		
		CGContextSetStrokeColorWithColor(ctx, TTSTYLEVAR(tableViewCellFirstBorderColor).CGColor);
		CGContextMoveToPoint(ctx, 0,0); //start at this point
		CGContextAddLineToPoint(ctx, self.bounds.size.width,0); //draw to this point
		CGContextStrokePath(ctx);
		
		
	}
	
	CGRect iconRect = CGRectMake(5
								   , boundsY + height/2 - iconHeight/2
								   , iconWidth, iconHeight);
	
	[_dirIcon drawInRect:iconRect contentMode:UIViewContentModeScaleAspectFill];
	
	CGFloat firstLabelHeight = mainFont.ttLineHeight;
	CGFloat textWidth = right - iconRect.origin.x - iconRect.size.width;
	
	NSLog(@"test rect: %@", NSStringFromCGRect(iconRect));
	NSLog(@"item text: %@", _item.text);
	
	[mainTextColor set];
	point = CGPointMake(left, boundsY + height/2 - firstLabelHeight/2);
	[_item.text drawAtPoint:point forWidth:textWidth withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
}

@end
