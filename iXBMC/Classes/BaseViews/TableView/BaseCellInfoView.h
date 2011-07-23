
@class BaseTableItem;

@interface BaseCellInfoView : TTView 
{
	BaseTableItem *_item;
	
	BOOL highlighted;
	BOOL editing;
}
@property (nonatomic, retain) BaseTableItem *item;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;

- (CGFloat)posterHeight;
- (void)loadImage;

@end
