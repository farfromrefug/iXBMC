
@class FadingImageView;
@interface RecentMovieView : TTView {
//    FadingImageView *_thumbnail;
//    FadingImageView *_fanart;
//    TTImageView *_newFlag;
    
//    TTView * _titleLabelBack;
    
    NSString* _trailer;
    NSString* _imdb;
    NSString *_title;
    NSNumber* _movieid;
	BOOL _watched;
	
	UIImage* _poster;
	UIImage* _fanart;
	UIImage* _posterBack;
	UIImage* _fanartBack;
    UIImage* _titleBack;
    UIImage* _newFlag;
    UIImage * _playTrailerButton;
}

@property (nonatomic, retain) NSNumber*      movieid;
@property (nonatomic, retain) NSString*      trailer;
@property (nonatomic, retain) NSString*      imdb;
@property (assign) BOOL watched;

@property (nonatomic, retain) NSString*      title;
@property (nonatomic, retain) UIImage*  poster;
@property (nonatomic, retain) UIImage*  fanart;

@end
