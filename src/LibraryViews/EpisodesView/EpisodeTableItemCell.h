
#import "BaseTableItemCell.h"

@interface EpisodeTableItemCell : BaseTableItemCell {
	    
    TTButton *_playButton;
    TTButton *_detailsButton;
    TTButton *_enqueueButton;
}

-(void) play:(id)sender;
-(void) enqueue:(id)sender;
-(void) moreInfos:(id)sender;


@end
