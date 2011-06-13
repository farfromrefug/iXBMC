#import <Three20/Three20.h>

@class CustomTitleView;
@class DetailView;
@interface DetailViewController : TTViewController
{
	DetailView* _detailView;
	NSDate * _start ;
    NSString* _entity;
    NSString* _entityId;
    NSString* _coverUrl;
    NSString* _fanartUrl;
    NSString* _fileUrl;
    NSString* _trailerUrl;
    NSString* _imdbId;
	BOOL _watched;
	
	NSString* _info;
	NSString* _plot;
	NSString* _cast;

	CustomTitleView* _titleBackground;
    TTView* _toolBar;
	
	TTButton *_playButton;
    TTButton *_imdbButton;
    TTButton *_trailerButton;
    TTButton *_enqueueButton;
    NSMutableArray* _toolbarButtons;
}
- (id)initWithEntity:(NSString *)entity id:(NSString *)entityId;

- (TTView*) createToolbar;
- (void) hideToolbar;

@property (nonatomic, retain)   NSString* entity;
@property (nonatomic, retain)   NSString* entityId;
@property (nonatomic, retain)   NSString* coverUrl;
@property (nonatomic, retain)   NSString* fanartUrl;
@property (nonatomic, retain)   NSString* fileUrl;
@property (nonatomic, retain)   NSString* trailerUrl;
@property (nonatomic, retain)   NSString* imdbId;
@property (nonatomic, retain)   NSString* info;
@property (nonatomic, retain)   NSString* plot;
@property (nonatomic, retain)   NSString* cast;
@end
