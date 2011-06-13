//
//  PlayingOSDView.h
//  iXBMC
//
//  Created by Martin Guillon on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlayingOSDView : UIView {
    UIImageView* _pausedOSD;
    UIImageView* _timeOSD;
    TTView *_timeBackBar;
    TTView *_timeCurrentBar;
    UILabel *_currentTimeLabel;
    UILabel *_totalTimeLabel;
}
- (void) showPausedOSD;
- (void) hidePausedOSD;

@end
