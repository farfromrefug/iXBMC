#import "BaseTableItemCell.h"

@interface MovieTableItemCell : BaseTableItemCell {

    UIButton *_playButton;
    UIButton *_imdbButton;
    UIButton *_detailsButton;
    UIButton *_trailerButton;
    UIButton *_enqueueButton;
}

-(void) showTrailer:(id)sender;
-(void) play:(id)sender;
-(void) enqueue:(id)sender;
-(void) moreInfos:(id)sender;
-(void) imdb:(id)sender;

@end
