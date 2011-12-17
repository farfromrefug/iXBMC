
@class FadingImageView;
@interface RecentEpisodeView : TTView {
    
    NSString* _episode;
    NSString* _season;
    NSString* _tvshow;
    NSString *_title;
    NSNumber* _episodeid;
	BOOL _watched;
	
	UIImage* _poster;
	UIImage* _fanart;
    UIImage* _newFlag;
}

@property (nonatomic, retain) NSNumber*      episodeid;
@property (nonatomic, retain) NSString*      season;
@property (nonatomic, retain) NSString*      episode;
@property (nonatomic, retain) NSString*      tvshow;
@property (assign) BOOL watched;

@property (nonatomic, retain) NSString*      title;
@property (nonatomic, retain) UIImage*  poster;
@property (nonatomic, retain) UIImage*  fanart;

@end
