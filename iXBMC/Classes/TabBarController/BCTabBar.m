#import "BCTabBar.h"
#import "BCTab.h"
#define kTabMargin 0.0

@interface BCTabBar ()
@property (nonatomic, retain) UIImage *backgroundImage;

- (void)positionArrowAnimated:(BOOL)animated;
@end

@implementation BCTabBarArrow
- (id)init {
	if ((self = [super initWithFrame:CGRectZero])) 
	{
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	[TTSTYLEVAR(tabBarHighlightedColor) set];
	CGContextFillRect(c, CGRectMake(0, 0, self.bounds.size.width, 2));
	CGContextFillRect(c, CGRectMake(10, self.bounds.size.height - 2
									, self.bounds.size.width - 20, 2));
}
@end


@implementation BCTabBar
@synthesize tabs, selectedTab, backgroundImage, arrow, delegate, isInvisible;

- (id)initWithFrame:(CGRect)aFrame {

	if ((self = [super initWithFrame:aFrame])) {
		self.backgroundColor = [UIColor clearColor];
//		self.backgroundImage = [UIImage imageNamed:@"BCTabBarController.bundle/tab-bar-background.png"];
		self.arrow = [[[BCTabBarArrow alloc] init] autorelease];
//		CGRect r = self.arrow.frame;
//		r.origin.y = - (r.size.height - 2);
//		self.arrow.frame = r;
		[self addSubview:self.arrow];
		self.userInteractionEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
		                        UIViewAutoresizingFlexibleTopMargin;
						 
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef context = UIGraphicsGetCurrentContext();
//	[self.backgroundImage drawAtPoint:CGPointMake(0, 0)];
	[TTSTYLEVAR(tabBarBackColor) set];
//	CGContextFillRect(context, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
	
	CGContextFillRect(context, CGRectMake(0, 2, self.bounds.size.width, self.bounds.size.height - 2));
	
	[TTSTYLEVAR(tabBarBorderColor) set];
	CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, 2));
}

- (void)setTabs:(NSArray *)array {
	for (BCTab *tab in tabs) {
		[tab removeFromSuperview];
	}
	
	[tabs release];
	tabs = [array retain];
	
	for (BCTab *tab in tabs) {
		tab.userInteractionEnabled = YES;
		[tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
	}
	[self setNeedsLayout];
}

- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated {
	if (aTab != selectedTab) {
		[selectedTab release];
		selectedTab = [aTab retain];
		selectedTab.selected = YES;
		
		for (BCTab *tab in tabs) {
			if (tab == aTab) continue;
			
			tab.selected = NO;
		}
	}
	
	[self positionArrowAnimated:animated];	
}

- (void)setSelectedTab:(BCTab *)aTab {
	[self setSelectedTab:aTab animated:YES];
}

- (void)tabSelected:(BCTab *)sender {
	[self.delegate tabBar:self didSelectTabAtIndex:[self.tabs indexOfObject:sender]];
}

- (void)positionArrowAnimated:(BOOL)animated {
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
	}
	CGRect f = self.arrow.frame;
	f.origin.x = self.selectedTab.frame.origin.x + ((self.selectedTab.frame.size.width / 2) - (f.size.width / 2));
	self.arrow.frame = f;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = self.bounds;
	f.size.width /= self.tabs.count;
	f.size.width -= (kTabMargin * (self.tabs.count + 1)) / self.tabs.count;
	
	self.arrow.frame = f;
	
	for (BCTab *tab in self.tabs) {
		f.origin.x += kTabMargin;
		tab.frame = f;
		f.origin.x += f.size.width;
		[self insertSubview:tab belowSubview:self.arrow];
	}
	
	[self positionArrowAnimated:NO];
}

- (void)dealloc {
	self.tabs = nil;
	self.selectedTab = nil;
	self.backgroundImage = nil;
	[super dealloc];
}


- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}


@end
