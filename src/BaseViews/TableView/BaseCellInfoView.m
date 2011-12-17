
#import "BaseCellInfoView.h"
#import "BaseTableItem.h"
#import "XBMCImage.h"
#import "XBMCHttpInterface.h"

@implementation BaseCellInfoView
@synthesize item = _item;
@synthesize highlighted;
@synthesize editing;
@synthesize realContentRect = _realContentRect;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
        _imageView = [[self networkImageView] retain];
	}
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_item);
    [super dealloc];
    [_imageView release];
}

- (NINetworkImageView *)networkImageView {
    UIImage* initialImage = [UIImage imageWithContentsOfFile:
                             NIPathForBundleResource(nil, @"noCoverSmall.png")];
    
    NINetworkImageView* networkImageView = [[[NINetworkImageView alloc] initWithImage:initialImage]
                                            autorelease];
    networkImageView.delegate = self;
    networkImageView.contentMode = UIViewContentModeScaleToFill;
    
    // Try playing with the following scale options and turning off clips to bounds to
    // see the effects on the result image.
    //networkImageView.scaleOptions = (NINetworkImageViewScaleToFillLeavesExcess
    //                                 | NINetworkImageViewScaleToFitCropsExcess);
    //networkImageView.clipsToBounds = NO;
    
    networkImageView.backgroundColor = [UIColor blackColor];
    
    networkImageView.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.2] CGColor];
    networkImageView.layer.borderWidth = 1;
    
    return networkImageView;
}

- (void)prepareForReuse
{
    [_imageView prepareForReuse];
}

- (void)setItem:(BaseTableItem *)item {
	
	// If the time zone wrapper changes, update the date formatter and abbreviation string.
	if (_item != item) {
		TT_RELEASE_SAFELY(_item);
		_item = [item retain];

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

- (void)imageLoaded:(NSDictionary*) result
{
    if ([[result valueForKey:@"url"] isEqualToString:((BaseTableItem*)_item).imageURL]
        && [result objectForKey:@"image"])
    {
		_item.poster = [result objectForKey:@"image"];
		[self setNeedsDisplay];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)networkImageView:(NINetworkImageView *)imageView didLoadImage:(UIImage *)image {
    [self setNeedsDisplay];
}

- (CGFloat)posterHeight
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = TTSTYLEVAR(cellHeight);
	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
	{
		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
	}
	return height;
}

- (void)loadImage
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = [self posterHeight];
	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
	{
		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
	}
    [_imageView setPathToNetworkImage:
              [XBMCHttpInterface getUrlFromSpecial:_item.imageURL]
                                             forDisplaySize: CGSizeMake(height, height)];
//	if (_item.imageURL && [XBMCImage hasCachedImage:_item.imageURL thumbnailHeight:height]) 
//	{
//		_item.poster = [XBMCImage cachedImage:_item.imageURL 
//								thumbnailHeight:height];
//	}
//	else if (_item.imageURL && !_item.poster )
//    {
//        [XBMCImage askForImage:_item.imageURL 
//                        object:self selector:@selector(imageLoaded:) 
//                 thumbnailHeight:height];
//    }
}


@end
