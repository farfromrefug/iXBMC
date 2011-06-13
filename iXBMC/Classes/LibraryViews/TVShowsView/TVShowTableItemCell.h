//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// UI
#import "Three20UI/TTTableLinkedItemCell.h"
#import "TVShowTableItem.h"

@class TTImageView;
@class TVShowTableItemCell;
@class FadingImageView;
@class TVShowCellView;
@protocol TVShowTableItemCellDelegate

@required
- (void)TVShowTableItemCellAnimationFinished:(TVShowTableItemCell *)cell;

@end


@interface TVShowTableItemCell : TTTableLinkedItemCell {
	
	TVShowCellView *_infoView;
    
    TTButton *_playButton;
    TTButton *_imdbButton;
    TTButton *_detailsButton;
    TTButton *_enqueueButton;
        
    NSMutableArray* _buttons;
    BOOL _imageLoaded;
}
//@property (nonatomic, assign) TVShowsViewController *delegate;

- (void)loadImage;
- (void)toggleImage:(BOOL)animated;

-(void) play:(id)sender;
-(void) enqueue:(id)sender;
-(void) moreInfos:(id)sender;
-(void) imdb:(id)sender;

- (void)redisplay;


@end
