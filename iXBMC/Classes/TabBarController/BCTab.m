#import "BCTab.h"

@interface BCTab ()
@property (nonatomic, retain) UIImage *rightBorder;
@property (nonatomic, retain) UIImage *background;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *selectedImageNameSuffix;
@property (nonatomic, retain) NSString *landscapeImageNameSuffix;
@end

@implementation BCTab
@synthesize rightBorder, background, imageName, selectedImageNameSuffix, landscapeImageNameSuffix;

- (void)assignImages:(NSString *)image selectedImageNameSuffix:(NSString *)selectedSuffix 
{
    NSString *selectedImageName = [image stringByDeletingPathExtension];
	if (selectedImageNameSuffix)
	{
		selectedImageName = [selectedImageName stringByAppendingString:selectedSuffix];
	}
	[selectedImageName stringByAppendingPathExtension:[image pathExtension]];
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
}

-(void)setButtonTitle:(NSString*)tt
{
	[self setTitle:tt forState:UIControlStateNormal];
	[self setTitle:tt forState:UIControlStateSelected];
}

- (id)initWithIconImageName:(NSString *)image 
	selectedImageNameSuffix:(NSString *)selectedSuffix 
   landscapeImageNameSuffix:(NSString *)landscapeSuffix 
					  title:(NSString*) tt
{
	self = [super init];
    if (self) 
	{
		self.adjustsImageWhenHighlighted = NO;
		self.background = [UIImage imageNamed:@"BCTabBarController.bundle/tab-background.png"];
		self.rightBorder = [UIImage imageNamed:@"BCTabBarController.bundle/tab-right-border.png"];
		self.backgroundColor = [UIColor clearColor];
		
		////Image Configuration
 		[self assignImages:image selectedImageNameSuffix:selectedSuffix];
        self.imageName = image;
        self.selectedImageNameSuffix = selectedSuffix;
        self.landscapeImageNameSuffix = landscapeSuffix;
		
		
		///Title Configuration
		self.titleLabel.font = TTSTYLEVAR(tabBarTextFont);
		self.titleLabel.backgroundColor   = [UIColor redColor];
		self.titleLabel.lineBreakMode   = TTSTYLEVAR(tabBarTextLineBreakMode);
		self.titleLabel.shadowOffset    = TTSTYLEVAR(tabBarTextShadowOffset);
		self.contentHorizontalAlignment = TTSTYLEVAR(tabBarTextHAlignment);
		self.contentVerticalAlignment = TTSTYLEVAR(tabBarTextVAlignment);
		[self setTitleColor:TTSTYLEVAR(tabBarTextColor) forState:UIControlStateNormal];
		[self setTitleColor:TTSTYLEVAR(tabBarTextColor) forState:UIControlStateSelected];
		[self setTitleShadowColor:TTSTYLEVAR(tabBarTextShadowColor) forState:UIControlStateNormal];
		[self setTitleShadowColor:TTSTYLEVAR(tabBarTextShadowColor) forState:UIControlStateSelected];
		[self setButtonTitle:tt];
	}
	return self;
}

- (id)initWithIconImageName:(NSString *)image 
	selectedImageNameSuffix:(NSString *)selectedSuffix 
   landscapeImageNameSuffix:(NSString *)landscapeSuffix
{
	return [self initWithIconImageName:image 
			   selectedImageNameSuffix:selectedSuffix 
			  landscapeImageNameSuffix:landscapeSuffix
								 title:@""];
}

- (void)dealloc {
	self.rightBorder = nil;
	self.background = nil;
    self.imageName = nil;
    self.selectedImageNameSuffix = nil;
    self.landscapeImageNameSuffix = nil;
	[super dealloc];
}

- (void)setHighlighted:(BOOL)aBool {
	// no highlight state
}

- (void)drawRect:(CGRect)rect {
	if (self.selected) {
		[background drawAtPoint:CGPointMake(0, 2)];
		[rightBorder drawAtPoint:CGPointMake(self.bounds.size.width - rightBorder.size.width, 2)];
		CGContextRef c = UIGraphicsGetCurrentContext();
		[[UIColor colorWithRed:24.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1.0] set];
		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
		[[UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:1.0] set];
		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
		CGContextFillRect(c, CGRectMake(self.bounds.size.width - 0.5, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
		}
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}

- (void)layoutSubviews {
	[super layoutSubviews];
//	CGFloat yOffset = 0;
//	if (![self.titleLabel.text isEqualToString:@""])
//	{
//		yOffset = -10;
//	}
	
	if (self.imageView)
	{
		UIEdgeInsets imageInsets = UIEdgeInsetsMake(floor((self.bounds.size.height / 2) -
												(self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
												(self.imageView.image.size.width / 2)),
												floor((self.bounds.size.height / 2) -
												(self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
												(self.imageView.image.size.width / 2)));
		self.imageEdgeInsets = imageInsets;
	}
//	self.titleEdgeInsets    = TTSTYLEVAR(tabBarTextEdgeInsets);
}

- (void)adjustImageForOrientation {
    NSString *orientationAwareName = self.imageName;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) && 
        self.landscapeImageNameSuffix && [self.landscapeImageNameSuffix length] > 0) {
        orientationAwareName = [[[self.imageName stringByDeletingPathExtension] stringByAppendingString:self.landscapeImageNameSuffix] stringByAppendingPathExtension:[self.imageName pathExtension]];
    }
    [self assignImages:orientationAwareName selectedImageNameSuffix:self.selectedImageNameSuffix];
}

@end
