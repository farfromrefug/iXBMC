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
	if (selectedSuffix)
	{
		selectedImageName = [selectedImageName stringByAppendingString:selectedSuffix];
	}
	selectedImageName = [selectedImageName stringByAppendingPathExtension:[image pathExtension]];
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
//		self.background = [UIImage imageNamed:@"BCTabBarController.bundle/tab-background.png"];
//		self.rightBorder = [UIImage imageNamed:@"BCTabBarController.bundle/tab-right-border.png"];
		self.backgroundColor = [UIColor clearColor];

        self.imageName = image;
        self.selectedImageNameSuffix = selectedSuffix;
        self.landscapeImageNameSuffix = landscapeSuffix;
//		self.imageView.contentMode = UIViewContentModeScaleToFill;
//		self.imageView.backgroundColor   = [UIColor redColor];
		
		///Title Configuration
		self.titleLabel.font = TTSTYLEVAR(tabBarTextFont);
		self.titleLabel.textAlignment = TTSTYLEVAR(tabBarTextAlignment);
//		self.titleLabel.backgroundColor   = [UIColor redColor];
		self.titleLabel.lineBreakMode   = TTSTYLEVAR(tabBarTextLineBreakMode);
		self.titleLabel.shadowOffset    = TTSTYLEVAR(tabBarTextShadowOffset);
		self.contentVerticalAlignment = TTSTYLEVAR(tabBarTextVAlignment);
		[self setTitleColor:TTSTYLEVAR(tabBarTextColor) forState:UIControlStateNormal];
		[self setTitleColor:TTSTYLEVAR(tabBarTextHighlightedColor) forState:UIControlStateSelected];
		[self setTitleShadowColor:TTSTYLEVAR(tabBarTextShadowColor) forState:UIControlStateNormal];
		[self setTitleShadowColor:TTSTYLEVAR(tabBarTextShadowColor) forState:UIControlStateSelected];
		
		////Image Configuration
 		[self assignImages:image selectedImageNameSuffix:selectedSuffix];
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
//	if (self.selected) {
////		[background drawAtPoint:CGPointMake(0, 2)];
////		[rightBorder drawAtPoint:CGPointMake(self.bounds.size.width - rightBorder.size.width, 2)];
//		CGContextRef c = UIGraphicsGetCurrentContext();
////		[[UIColor colorWithRed:24.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1.0] set];
////		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
////		[[UIColor colorWithRed:14.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:1.0] set];
////		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
////		CGContextFillRect(c, CGRectMake(self.bounds.size.width - 0.5, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
//		
//		[TTSTYLEVAR(tabBarHighlightedColor) set];
//		CGContextFillRect(c, CGRectMake(5, 0, self.bounds.size.width - 10, 2));
//		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height - 2
//										, self.bounds.size.width, 2));
//		}
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
//	if (self.imageView)
//	{
//		UIEdgeInsets imageInsets = UIEdgeInsetsMake(
//			floor((self.height / 2) - (self.imageView.image.size.height / 2))
//		  , floor((self.width / 2) - (self.imageView.image.size.width / 2))
//		  , floor((self.height / 2) - (self.imageView.image.size.height / 2) + (self.titleLabel.height / 2))
//		  , floor((self.width / 2) - (self.imageView.image.size.width / 2)));
//		self.imageEdgeInsets = imageInsets;
//	}
	self.titleLabel.frame = CGRectMake(0, self.titleLabel.frame.origin.y + 2
										   , self.frame.size.width
										   , self.titleLabel.frame.size.height);
		
	CGFloat imageHeight = self.height - self.titleLabel.height;
	
	self.imageView.frame = CGRectMake(self.width/2 - imageHeight/2, self.titleLabel.bottom - 3
									  , imageHeight
									  , imageHeight);
	
	if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentBottom)
	{
		self.imageView.top = 0;
	}	
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
