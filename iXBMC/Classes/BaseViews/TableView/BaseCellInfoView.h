
@class BaseTableItem;

@interface BaseCellInfoView : TTView 
{
	BaseTableItem *_item;
	
	BOOL highlighted;
	BOOL editing;
	CGRect _realContentRect;
}
@property (nonatomic, retain) BaseTableItem *item;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;
@property (nonatomic) CGRect realContentRect;

- (CGFloat)posterHeight;
- (void)loadImage;

@end
