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
#import "MovieTableItem.h"
#import "MovieViewController.h"

@class TTImageView;
@class MovieTableItemCell;
@class FadingImageView;
@class MovieCellView;
@protocol MovieTableItemCellDelegate

@required
- (void)MovieTableItemCellAnimationFinished:(MovieTableItemCell *)cell;

@end


@interface MovieTableItemCell : TTTableLinkedItemCell {
	
	MovieCellView *_movieView;

	
//    UIImageView* _line;
//    UIView* _yearBackground;
//
//    UILabel* _firstLabel;
//    UILabel* _secondLabel;
//    UILabel* _thirdLabel;

//    TTStyle*  _normalStyle;
//    TTStyle*  _selectedStyle;
//    
//    UIImageView* _photoFrame;
//    FadingImageView *_photo;
//    UIImageView *_newFlag;
//    UILabel* subtitleLabel;
//    UILabel* _yearLabel;
//    UILabel* _ratingLabel;
//    UIImageView* _ratingStars;
//    UIActivityIndicatorView *scrollingWheel;
    MovieViewController *delegate;
    
    TTButton *_playButton;
    TTButton *_imdbButton;
    TTButton *_detailsButton;
    TTButton *_trailerButton;
    TTButton *_enqueueButton;
        
    NSMutableArray* _buttons;
    BOOL _imageLoaded;
}

//@property (nonatomic, readonly, retain) UILabel*      firstLabel;
//@property (nonatomic, readonly, retain) UILabel*      secondLabel;
//@property (nonatomic, readonly, retain) UILabel*      thirdLabel;
//@property (nonatomic, readonly, retain) FadingImageView*  photo;
@property (nonatomic, assign) MovieViewController *delegate;
//@property (nonatomic, retain) Movie *movie;

- (void)loadImage;
- (void)toggleImage:(BOOL)animated;


-(void) showTrailer:(id)sender;
-(void) play:(id)sender;
-(void) enqueue:(id)sender;
-(void) moreInfos:(id)sender;
-(void) imdb:(id)sender;

- (void)redisplay;


@end
