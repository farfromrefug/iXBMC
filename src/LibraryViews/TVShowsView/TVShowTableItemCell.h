
#import "BaseTableItemCell.h"

@interface TVShowTableItemCell : BaseTableItemCell {
	    
    TTButton *_tvdbButton;
    TTButton *_detailsButton;
}

-(void) moreInfos:(id)sender;
-(void) tvdb:(id)sender;

@end
