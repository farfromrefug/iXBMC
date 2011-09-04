
#import "BaseTableItemCell.h"

#import "BaseTableItem.h"

#import "BaseCellInfoView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BaseTableItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) 
    {
        [self setClipsToBounds:YES];
        self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
//		// Create a time zone view and add it as a subview of self's contentView.
////		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////		CGFloat height = [[defaults valueForKey:@"tvshowCell:height"] floatValue];
//		CGRect tzvFrame = self.contentView.bounds;
//		_infoView = [[TVShowCellView alloc] initWithFrame:tzvFrame];
////		_infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		[self.contentView addSubview:_infoView];
		
        _buttons = [[NSMutableArray alloc] init];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	TT_RELEASE_SAFELY(_item);
    TT_RELEASE_SAFELY(_buttons);
    TT_RELEASE_SAFELY(_infoView);
    [super dealloc];
}

- (void)redisplay {
	[_infoView setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame 
{
    [super setFrame:frame];
	[self layoutSubviews];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView

- (CGFloat)cellHeight
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:@"cell:height"] floatValue];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = [self cellHeight];
    
    int nbButtons = [_buttons count];
    int buttonWidth = (self.contentView.width)/(nbButtons);
    int buttonHeight = TTSTYLEVAR(tableViewCellMenuHeight);
    buttonHeight -= 1;
    int i = 0;
    for(UIButton *button in _buttons)
    {
        button.frame = CGRectMake(buttonWidth * i
                                  , height + 1
                                  , buttonWidth
                                  , buttonHeight);
        i += 1;
        
    }
	CGRect tzvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, height);
	_infoView.frame = self.contentView.frame;
	_infoView.realContentRect = tzvFrame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)object {
	return _item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
	if (_item != object) {
		[_item release];
		_item = [object retain];
	}
	if (_item != nil)
    {		
		[_infoView setItem:_item];
		[_buttons removeAllObjects];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	[_infoView setHighlighted:selected];
	for(UIButton *button in _buttons)
    {
		button.hidden = !selected;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (void)prepareForReuse
{
	[self setSelected:FALSE];
}

- (void)loadImage
{
	[_infoView loadImage];
}

-(void) activate
{
	
}

- (void)drawRect:(CGRect)rect {	
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	
	CGRect contentRect = self.bounds;
	CGFloat boundsY = contentRect.origin.y;
	CGFloat height = contentRect.size.height;
	
	CGContextSetFillColorWithColor(ctx, TTSTYLEVAR(tableViewBackColor).CGColor);
	CGContextFillRect(ctx, self.bounds);
//	if (self.selected) {
////		CGContextSetFillColorWithColor(ctx, TTSTYLEVAR(tableViewCellHighlightedMainColor).CGColor);
//		CGContextFillRect(ctx, self.bounds);
//	}
//	else
//	{
//		CGContextSetFillColorWithColor(ctx, TTSTYLEVAR(tableViewBackColor).CGColor);
//		CGContextFillRect(ctx, self.bounds);
//		
////		CGContextSetLineWidth(ctx, 1.0);
////		
////		CGContextSetStrokeColorWithColor(ctx, TTSTYLEVAR(tableViewCellSecondBorderColor).CGColor);
////		CGContextMoveToPoint(ctx, 0,boundsY + height); //start at this point
////		CGContextAddLineToPoint(ctx, self.bounds.size.width,boundsY + height); //draw to this point
////		CGContextStrokePath(ctx);
////		
////		CGContextSetStrokeColorWithColor(ctx, TTSTYLEVAR(tableViewCellFirstBorderColor).CGColor);
////		CGContextMoveToPoint(ctx, 0,0); //start at this point
////		CGContextAddLineToPoint(ctx, self.bounds.size.width,0); //draw to this point
////		CGContextStrokePath(ctx);
////		
//		
//	}
}

@end
