#import <Three20/Three20.h>

@class CustomTitleView;
@class DetailView;
@interface DetailViewController : TTViewController
{
	DetailView* _detailView;
	NSMutableDictionary* _details;
	NSDate * _start ;

	CustomTitleView* _titleBackground;
    TTView* _toolBar;
	
	TTButton *_playButton;
    TTButton *_imdbButton;
    TTButton *_trailerButton;
    TTButton *_enqueueButton;
    NSMutableArray* _toolbarButtons;
}
-(id) initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query;
//- (id)initWithEntity:(NSString *)entity id:(NSString *)entityId;

- (TTView*) createToolbar;
- (void) hideToolbar;
- (void)updateViewForMovie;

@property (nonatomic, retain)   NSMutableDictionary* details;

@end
