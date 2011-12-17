
//#import "TVShowTableItem.h"
//
//@class TVShowTableItemCell;
@class BaseTableItem;
@class BaseCellInfoView;


@interface BaseTableItemCell : TTTableViewCell {
	
	BaseCellInfoView *_infoView;
	BaseTableItem* _item;
//    
//    TTButton *_tvdbButton;
//    TTButton *_detailsButton;

	
    NSMutableArray* _buttons;
    BOOL _imageLoaded;
}

- (CGFloat)cellHeight;

- (void)loadImage;

//-(void) moreInfos:(id)sender;
//-(void) tvdb:(id)sender;
-(void) activate;

- (void)redisplay;


@end
