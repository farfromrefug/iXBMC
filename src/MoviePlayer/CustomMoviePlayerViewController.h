#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class CustomTitleView;
@interface CustomMoviePlayerViewController : TTViewController 
{
  MPMoviePlayerController *mp;
  NSURL *movieURL;
	CustomTitleView* _titleBackground;
}

- (id)initWithUrl:(NSString *)movieURL name:(NSString*)name;
- (void)readyPlayer;

@end
