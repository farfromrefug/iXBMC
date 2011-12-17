
@class BaseTableItem;
@interface BaseCellInfoView : TTView <NINetworkImageViewDelegate> 
{
	BaseTableItem *_item;
	
	BOOL highlighted;
	BOOL editing;
	CGRect _realContentRect;
    
    NINetworkImageView* _imageView;
}
@property (nonatomic, retain) BaseTableItem *item;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;
@property (nonatomic) CGRect realContentRect;

- (NINetworkImageView *)networkImageView;
- (CGFloat)posterHeight;
- (void)loadImage;
- (void)prepareForReuse;

@end
