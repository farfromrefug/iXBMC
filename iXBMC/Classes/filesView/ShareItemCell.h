
@class ShareItem;
@interface ShareItemCell : TTTableViewCell {
    UIImage* _dirIcon;
    UIImage* _movieIcon;
    UIImage* _fileIcon;
	NSString* _text;
	ShareItem *_item;
	
	BOOL highlighted;
//	BOOL editing;
}
@property (nonatomic, retain) ShareItem *item;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
//@property (nonatomic, getter=isEditing) BOOL editing;

@end
