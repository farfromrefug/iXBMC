#import <UIKit/UIKit.h>

@class RecentEpisodeView;
@interface RecentEpisodeViewController : TTViewController<UIActionSheetDelegate>
{
	RecentEpisodeView* _mainView;
    NSUInteger     index;
	NSString* _posterURL;
	NSString* _fanartURL;
}
@property (assign) NSUInteger index;

@property (nonatomic, retain) NSString*      file;
@property (nonatomic, retain) NSNumber*      episodeid;
@property (nonatomic, retain) NSString*      season;
@property (nonatomic, retain) NSString*      episode;
@property (nonatomic, retain) NSString*      tvshow;
@property (nonatomic, retain) NSString*      title;
@property (nonatomic, retain) NSString*      posterURL;
@property (nonatomic, retain) NSString*      fanartURL;
@property (nonatomic, retain) UIImage*  poster;
@property (nonatomic, retain) UIImage*  fanart;
@property (nonatomic) BOOL  watched;

- (void)thumbnailLoaded:(NSDictionary*) result;
- (void)fanartLoaded:(NSDictionary*) result;

- (CGFloat)posterHeight;
- (CGFloat)fanartHeight;
@end
