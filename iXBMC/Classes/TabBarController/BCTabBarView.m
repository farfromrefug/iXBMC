#import "BCTabBarView.h"
#import "BCTabBar.h"

@implementation BCTabBarView
@synthesize tabBar, contentView;

- (void)setTabBar:(BCTabBar *)aTabBar {
	[tabBar removeFromSuperview];
	[tabBar release];
	tabBar = aTabBar;
	[self addSubview:tabBar];
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
//	[tabBar setFrame:CGRectMake(0, self.frame.size.height - 44, 
//							   self.frame.size.width, 44)];
	[self setNeedsLayout];
}

- (void)setContentView:(UIView *)aContentView {
	[contentView removeFromSuperview];
	contentView = aContentView;
	contentView.frame = CGRectMake(0, 0, self.frame.size.width, 
										self.frame.size.height - self.tabBar.frame.size.height);

	[self addSubview:contentView];
	[self sendSubviewToBack:contentView];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = contentView.frame;
    if (self.tabBar.isInvisible) {
        f.size.height = self.frame.size.height;
    } else {
        f.size.height = self.frame.size.height - self.tabBar.frame.size.height;
    }
	contentView.frame = f;
	//[contentView layoutSubviews]; // this method should not be called directly!
    [contentView setNeedsLayout];
}

- (void)drawRect:(CGRect)rect {
//	CGContextRef c = UIGraphicsGetCurrentContext();
//	[[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] set];
//	CGContextFillRect(c, self.bounds);
}

@end
