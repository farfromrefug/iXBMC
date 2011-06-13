#import <UIKit/UIKit.h>

@class RecentMovieView;
@interface RecentMovieViewController : TTViewController<UIActionSheetDelegate>
{
	RecentMovieView* _mainView;
    NSUInteger     index;
	NSString* _posterURL;
	NSString* _fanartURL;
}
@property (assign) NSUInteger index;

@property (nonatomic, retain) NSString*      file;
@property (nonatomic, retain) NSNumber*      movieid;
@property (nonatomic, retain) NSString*      trailer;
@property (nonatomic, retain) NSString*      imdb;
@property (nonatomic, retain) NSString*      title;
@property (nonatomic, retain) NSString*      posterURL;
@property (nonatomic, retain) NSString*      fanartURL;
@property (nonatomic, retain) UIImage*  poster;
@property (nonatomic, retain) UIImage*  fanart;
@property (nonatomic) BOOL  watched;

- (void)thumbnailLoaded:(NSDictionary*) result;
- (void)fanartLoaded:(NSDictionary*) result;

- (CGFloat)posterHeight;
- (CGFloat)fanartWidth;
@end
