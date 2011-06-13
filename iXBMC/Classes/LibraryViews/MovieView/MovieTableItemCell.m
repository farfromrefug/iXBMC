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

#import "MovieTableItemCell.h"

#import "XBMCStateListener.h"
#import "XBMCImage.h"

#import "FadingImageView.h"
#import "MovieCellView.h"

#define MENU_HEIGHT 25;
#define FORSEARCH_HEIGHT 40;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MovieTableItemCell
@synthesize delegate;
//@synthesize photo = _photo;
//@synthesize firstLabel = _firstLabel;
//@synthesize secondLabel = _secondLabel;
//@synthesize thirdLabel = _thirdLabel;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) 
    {
        [self setClipsToBounds:YES];
		
		// Create a time zone view and add it as a subview of self's contentView.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		CGFloat height = [[defaults valueForKey:@"moviesView:cellHeight"] floatValue];
		CGRect tzvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, height);
		_movieView = [[MovieCellView alloc] initWithFrame:tzvFrame];
		_movieView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:_movieView];
		
        
//        _firstLabel = [[[UILabel alloc] init] autorelease];
//        _secondLabel = [[[UILabel alloc] init] autorelease];
//        _thirdLabel = [[[UILabel alloc] init] autorelease];
//
//        _firstLabel.backgroundColor = [UIColor clearColor];
//        _secondLabel.backgroundColor = [UIColor clearColor];
//        _thirdLabel.backgroundColor = [UIColor clearColor];
//
//        _firstLabel.font = [UIFont systemFontOfSize:14];
//        _secondLabel.font = [UIFont systemFontOfSize:12];
//        _thirdLabel.font = [UIFont systemFontOfSize:12];
//        
//        _firstLabel.textColor = [UIColor whiteColor];
//        _secondLabel.textColor = [UIColor grayColor];
//        _thirdLabel.textColor = [UIColor grayColor];
//        
//        _firstLabel.highlightedTextColor = TTSTYLEVAR(themeColor);
//        _secondLabel.highlightedTextColor = [UIColor darkGrayColor];
//        _thirdLabel.highlightedTextColor = [UIColor darkGrayColor];
//        
//        _firstLabel.textAlignment = UITextAlignmentLeft;
//        _secondLabel.textAlignment = UITextAlignmentLeft;
//        _thirdLabel.textAlignment = UITextAlignmentLeft;
//        
//        _firstLabel.adjustsFontSizeToFitWidth = NO;
//        _secondLabel.adjustsFontSizeToFitWidth = NO;
//        _thirdLabel.adjustsFontSizeToFitWidth = NO;
//
//        _firstLabel.lineBreakMode = UILineBreakModeTailTruncation;
//        _secondLabel.lineBreakMode = UILineBreakModeTailTruncation;
//        _thirdLabel.lineBreakMode = UILineBreakModeTailTruncation;
//
//        _firstLabel.text = @"";
//        _secondLabel.text = @"";
//        _thirdLabel.text = @"";

//        [self.contentView addSubview:_firstLabel];
//        [self.contentView addSubview:_secondLabel];
//        [self.contentView addSubview:_thirdLabel];

//        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//        self.selectedBackgroundView.backgroundColor = RGBACOLOR(100, 100, 100, 0.2);
        
//        UIImageView* cellBack = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://cellSelected.png")] autorelease];
//        self.selectedBackgroundView = cellBack;
//        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
//        _line = [[[UIImageView alloc] init] autorelease];
//        _line.autoresizingMask = UIViewAutoresizingFlexibleWidth
//            | UIViewAutoresizingFlexibleTopMargin;
//        _line.image = TTIMAGE(@"bundle://cellline.png");
////        [self.contentView addSubview:_line];
//        
//        _yearBackground = [[[UIView alloc] init] autorelease];
//        _yearBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        _yearBackground.backgroundColor = RGBACOLOR(100, 100, 100, 0.2);
//        [self.contentView addSubview:_yearBackground];
        
//        scrollingWheel = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0, 27.0, 20.0, 20.0)] autorelease];
//        scrollingWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        scrollingWheel.hidesWhenStopped = YES;
//        [scrollingWheel stopAnimating];
//        [self.contentView addSubview:scrollingWheel];
        
//        _photoFrame = [[[UIImageView alloc] init] autorelease];
//        _photoFrame.contentMode = UIViewContentModeScaleToFill;
//        _photoFrame.clipsToBounds = YES;
//        _photoFrame.backgroundColor = [UIColor clearColor];
//        _photoFrame.image = TTIMAGE(@"bundle://posterShadow.png");
//        [self.contentView addSubview:_photoFrame];
////        
//        _photo = [[[FadingImageView alloc] init] autorelease];
//        _photo.contentMode = UIViewContentModeScaleToFill;
//        _photo.backgroundColor = [UIColor clearColor];
//        _photo.defaultImage = TTIMAGE(@"bundle://thumbnailNone.png");
////        _photo.style = [TTContentStyle styleWithNext:nil];
//        CALayer * layer = [_photo layer];
//        [layer setMasksToBounds:YES];
//        [layer setCornerRadius:4.0];
//		layer.shouldRasterize = YES;
//
//        [_photoFrame addSubview:_photo];
//        
////        _selectedStyle = [[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4] next:
////                            [TTShadowStyle styleWithColor:TTSTYLEVAR(themeColor) blur:5 offset:CGSizeMake(0, 0) next:
////                             [TTContentStyle styleWithNext:nil]]] retain];
////        _normalStyle = [[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4] next:
////                            [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,1.0) blur:5 offset:CGSizeMake(0, 0) next:
////                             [TTContentStyle styleWithNext:nil]]] retain];
////
////        _normalStyle = [[TTMaskStyle styleWithMask:TTIMAGE(@"bundle://posterShadowMask.png") next:[TTContentStyle styleWithNext:nil]] retain];
//        
//        _newFlag = [[[UIImageView alloc] init] autorelease];
//        _newFlag.backgroundColor = [UIColor clearColor];
//        _newFlag.image = TTIMAGE(@"bundle://UnWatched.png");
////        _newFlag.style = [TTContentStyle styleWithNext:nil];
//        [_photo addSubview:_newFlag];
        
//        _yearLabel = [[[UILabel alloc] init] autorelease];
//        _yearLabel.font = [UIFont systemFontOfSize:12];
//        _yearLabel.textColor = [UIColor whiteColor];
//        _yearLabel.backgroundColor = [UIColor clearColor];
//        _yearLabel.textAlignment = UITextAlignmentCenter;
//        _yearLabel.contentMode = UIViewContentModeBottom;
////        [self.contentView addSubview:_yearLabel];
//        
//        _ratingLabel = [[[UILabel alloc] init] autorelease];
//        _ratingLabel.font = [UIFont systemFontOfSize:12];
//        _ratingLabel.textColor = [UIColor whiteColor];
//        _ratingLabel.backgroundColor = [UIColor clearColor];
//        _ratingLabel.textAlignment = UITextAlignmentCenter;
//        _ratingLabel.contentMode = UIViewContentModeTop;
////        [self.contentView addSubview:_ratingLabel];
//        
//        _ratingStars = [[[UIImageView alloc] init] autorelease];
//        _ratingStars.alpha = 0.7;
//        _ratingStars.backgroundColor = [UIColor clearColor];
//        _ratingStars.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:_ratingStars];
        
        _buttons = [[NSMutableArray alloc] init];
        _detailsButton = [[[TTButton alloc] initWithFrame:CGRectZero] autorelease];
        [_detailsButton setTitle:@"Info" forState:UIControlStateNormal];
        [_detailsButton setBackgroundColor:[UIColor clearColor]];
        [_detailsButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_detailsButton addTarget:self action:@selector(moreInfos:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_detailsButton];
        
        _playButton = [[[TTButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)] autorelease];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
        [_playButton setBackgroundColor:[UIColor clearColor]];
        [_playButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playButton];
            
        _enqueueButton = [[[TTButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)] autorelease];
        [_enqueueButton setTitle:@"Enqueue" forState:UIControlStateNormal];
        [_enqueueButton setBackgroundColor:[UIColor clearColor]];
        [_enqueueButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_enqueueButton addTarget:self action:@selector(enqueue:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_enqueueButton];
        
        _trailerButton = [[[TTButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)] autorelease];
        [_trailerButton setTitle:@"Trailer" forState:UIControlStateNormal];
        [_trailerButton setBackgroundColor:[UIColor clearColor]];
        [_trailerButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_trailerButton addTarget:self action:@selector(showTrailer:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_trailerButton];
        
        _imdbButton = [[[TTButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)] autorelease];
        [_imdbButton setTitle:@"Imdb" forState:UIControlStateNormal];
        [_imdbButton setBackgroundColor:[UIColor clearColor]];
        [_imdbButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_imdbButton addTarget:self action:@selector(imdb:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_imdbButton];
        
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_buttons);
    TT_RELEASE_SAFELY(_movieView);
    [super dealloc];
}

- (void)redisplay {
	[_movieView setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame 
{
    [super setFrame:frame];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = [[defaults valueForKey:@"moviesView:cellHeight"] floatValue];
	CGRect tzvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, height);
	_movieView.frame = tzvFrame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public


/////////////////////////////////////////////////////////////////////////////////////////////////////
//+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
//    MovieTableItem* item = object;
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    CGFloat height = [[defaults valueForKey:@"moviesView:cellHeight"] floatValue];
//    
//    if (item.forSearch)
//    {
//        height = FORSEARCH_HEIGHT ;
//    }
//    
////    if (self.selected == YES)
////    {
////        height += MENU_HEIGHT;
////    }
//    
//    return height;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat height = [[defaults valueForKey:@"moviesView:cellHeight"] floatValue];
    
//    if (((MovieTableItem*)_item).forSearch)
//    {
//        height = FORSEARCH_HEIGHT ;
//    }
//    //    CGFloat width = self.contentView.width - (height + kTableCellSmallMargin);
//    CGFloat left = 0;
//    
//    _line.frame = CGRectMake(0, height -1
//               , self.contentView.width, 1);
//    
//    CGFloat photoHeight = height - 4;
//    _photoFrame.frame = CGRectMake(5, 2, photoHeight*2/3, photoHeight);
//    _photo.frame = CGRectMake(photoHeight/30, photoHeight/20, _photoFrame.width - photoHeight/15, _photoFrame.height - photoHeight/10);
////    scrollingWheel.center =_photo.center;
////    left = _photoFrame.right + kTableCellSmallMargin;
//    
//    int newFlagWidth = _photo.width*2/3;
//    _newFlag.frame = CGRectMake(_photo.width - newFlagWidth, 0
//                                , newFlagWidth, newFlagWidth);

//    _yearBackground.frame = CGRectMake(self.contentView.width - 60, 0
//                                , 60, height);
//    
//    CGFloat firstLabelHeight = self.firstLabel.font.ttLineHeight;
//    CGFloat secondLabelHeight = self.secondLabel.font.ttLineHeight;
//    CGFloat thirdLabelHeight = self.thirdLabel.font.ttLineHeight;
//    CGFloat paddingY = (height - (firstLabelHeight + secondLabelHeight))/2;
//    if (firstLabelHeight + secondLabelHeight  + paddingY > height)
//    {
//        secondLabelHeight = thirdLabelHeight = 0;
//        paddingY = floor((height - (firstLabelHeight))/2);
//    }
//    else
//    {
//        paddingY = (height - (firstLabelHeight + secondLabelHeight + thirdLabelHeight))/2;
//        if (firstLabelHeight + secondLabelHeight + thirdLabelHeight + paddingY > height)
//        {
//            thirdLabelHeight = 0;
//            paddingY = (height - (firstLabelHeight + secondLabelHeight))/2;
//        } 
//    } 
//    
//    self.firstLabel.frame = CGRectMake(left, paddingY, _yearBackground.left - left, firstLabelHeight);
//    self.secondLabel.frame = CGRectMake(left, self.firstLabel.bottom, _yearBackground.left - left, secondLabelHeight);
//    self.thirdLabel.frame = CGRectMake(left, self.secondLabel.bottom, _yearBackground.left - left, thirdLabelHeight);
//
//    _yearLabel.frame = CGRectMake(_yearBackground.left, 0, _yearBackground.width, _yearBackground.height / 2);
//    _ratingLabel.frame = CGRectMake(_yearBackground.left, _yearBackground.height / 2, _yearBackground.width, _yearBackground.height / 2);
//    _ratingStars.frame = CGRectMake(_yearBackground.left, _yearBackground.height / 2, _yearBackground.width, _yearBackground.height / 2);
//
    int nbButtons = [_buttons count];
    int buttonWidth = (self.contentView.width)/(nbButtons);
    int buttonHeight = MENU_HEIGHT;
    buttonHeight -= 1;
    int i = 0;
    for(TTButton *button in _buttons)
    {
        button.frame = CGRectMake(buttonWidth * i
                                  , height + 1
                                  , buttonWidth
                                  , buttonHeight);
        i += 1;
        
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
    }
    if (_item != nil)
    {
//        self.selectionStyle = TTSTYLEVAR(tableSelectionStyle);
//
        MovieTableItem* item = (MovieTableItem*)_item;
		
		NSRange foundRange = [item.runtime rangeOfString:@"min"];
		
		if ((foundRange.length == 0) ||
			(foundRange.location == 0))
		{
			item.runtime = [item.runtime stringByAppendingString:@" min"];
		}
		
		[_movieView setItem:item];
		
		

//        self.firstLabel.text = item.label;
//        self.secondLabel.text = item.genre;
//        self.thirdLabel.text = item.runtime;
//        
//        if (item.runtime && ![item.runtime isEqualToString:@""]) 
//        {
//            NSRange foundRange = [self.thirdLabel.text rangeOfString:@"min"];
//            
//            if ((foundRange.length == 0) ||
//                (foundRange.location == 0))
//            {
//                self.thirdLabel.text = [self.thirdLabel.text stringByAppendingString:@" min"];
//            }
//        }
//        
//        if (item.year && ![item.year isEqual:@"0"]) {
//            _yearLabel.text = item.year;
//        }
//        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        BOOL showStars = [[defaults valueForKey:@"moviesView:ratingStars"] boolValue];
//        if (showStars)
//        {
//            [_ratingStars setHidden:FALSE];
//            [_ratingLabel setHidden:TRUE];
//            if (item.rating && ![item.rating isEqual:@"0"]) 
//            {
//                
//                NSString* url = [NSString stringWithFormat:@"bundle://star.%@.png",item.rating];
//                _ratingStars.image = TTIMAGE(url);
//            }
//            else
//            {
//                _ratingStars.image = TTIMAGE(@"bundle://star.0.0.png");
//            }
//        }
//        else
//        {
//            [_ratingStars setHidden:TRUE];
//            [_ratingLabel setHidden:FALSE];
//            if (item.rating && ![item.rating isEqual:@"0"]) 
//            {
//                _ratingLabel.text = item.rating;
//            }
//        }
//        
//        CGFloat height = TTSTYLEVAR(moviesViewCellsMaxHeight)*[UIScreen mainScreen].scale;
//        
//        _photo.image = nil;
//        if (item.imageURL && [XBMCImage hasCachedImage:item.imageURL thumbnailSize:height]) 
//        {
//            
//            _photo.image = [XBMCImage cachedImage:(NSString*)((MovieTableItem*)_item).imageURL 
//                                           thumbnailSize:height];
//            _imageLoaded = _photo.image != nil;
//        }
//        else
//        {
//            _imageLoaded = false;
//        }
//        
//        if (self.selected)
//        {
//            _photoFrame.image = TTIMAGE(@"bundle://posterShadowSelected.png");
//        }
//        else
//        {
//            _photoFrame.image = TTIMAGE(@"bundle://posterShadow.png");
//        }
//        
//        if(!item.watched)
//        {
//            _newFlag.hidden = FALSE;
//        }
//        else
//        {
//            _newFlag.hidden = TRUE;
//        }
//        
        [_buttons removeAllObjects];
        
        [_buttons addObject:_detailsButton];
        if ([XBMCStateListener connected])
        {
            _playButton.hidden = FALSE;
            _enqueueButton.hidden = FALSE;
            [_buttons addObject:_playButton];
            [_buttons addObject:_enqueueButton];
        }
        else
        {
            _playButton.hidden = TRUE;
            _enqueueButton.hidden = TRUE;
        }
        
        if (item.trailer != nil && ![item.trailer isEqual:@""])
        {
            _trailerButton.hidden = FALSE;
            [_buttons addObject:_trailerButton];
        }
        else
        {
            _trailerButton.hidden = TRUE;
        }
        
        if (item.imdb != nil && ![item.imdb isEqual:@""])
        {
            _imdbButton.hidden = FALSE;
            [_buttons addObject:_imdbButton];
        }
        else
        {
            _imdbButton.hidden = TRUE;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
	
//	if (self.selected)
//	{
//		_photoFrame.image = TTIMAGE(@"bundle://posterShadowSelected.png");
//	}
//	else
//	{
//		_photoFrame.image = TTIMAGE(@"bundle://posterShadow.png");
//	}
	[_movieView setHighlighted:selected];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (void)prepareForReuse
{
	[self setSelected:FALSE];
    //     [movie cancelLoading];
    //     _photo.defaultImage = nil;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)subtitleLabel {
    return self.detailTextLabel;
}

- (void)toggleImage:(BOOL)animated
{
//    if (animated)
//    {
//        [UIView beginAnimations:nil context:_photoFrame];
//        [UIView setAnimationDuration:0.5];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_photoFrame cache:YES];
//        [UIView setAnimationDelegate:self];
//    }
//    if (self.selected)
//    {
//        _photoFrame.image = TTIMAGE(@"bundle://posterShadowSelected.png");
//    }
//    else
//    {
//        _photoFrame.image = TTIMAGE(@"bundle://posterShadow.png");
//    }
//    if (animated)
//    {
//        [UIView commitAnimations];
//    }
}

//- (void)imageLoaded:(NSDictionary*) result
//{
//    if ([[result valueForKey:@"url"] isEqualToString:((MovieTableItem*)_item).imageURL]
//        && [result objectForKey:@"image"])
//    {
//        _imageLoaded = true;
//        [_photo animateNewImage:[result objectForKey:@"image"]];
//    }
//}

- (void)loadImage
{
	[_movieView loadImage];
//	[_movieView performSelectorInBackground:@selector(loadImage) withObject:nil];
//    if (((MovieTableItem*)_item).imageURL && !_imageLoaded)
//    {
//        NSInteger height = TTSTYLEVAR(moviesViewCellsMaxHeight)*[UIScreen mainScreen].scale;
//        [XBMCImage askForImage:(NSString*)((MovieTableItem*)_item).imageURL 
//                        object:self selector:@selector(imageLoaded:) 
//                 thumbnailSize:height];
//    }
}

#pragma mark -
#pragma mark UIView animation delegate methods

- (void)animationFinished
{
    if ([delegate respondsToSelector:@selector(MovieCellAnimationFinished:)])
    {
        //        [delegate MovieCellAnimationFinished:self];
    }
}

-(void) showTrailer:(id)sender
{
    if (((MovieTableItem*)_item).trailer)
    {
        [((AppDelegate*)[UIApplication sharedApplication].delegate) 
		 showTrailer:((MovieTableItem*)_item).trailer
		 name:((MovieTableItem*)_item).label];
    }
}
-(void) play:(id)sender
{
    if (((MovieTableItem*)_item).file)
    {
        [XBMCStateListener play:((MovieTableItem*)_item).file];
    }
}
-(void) enqueue:(id)sender
{
    if ([delegate respondsToSelector:@selector(Movie:action:)])
    {
//        [delegate Movie:movie action:@"enqueue"];
    }
}
-(void) moreInfos:(id)sender
{
    if (((MovieTableItem*)_item).itemId)
    {
        [((AppDelegate*)[UIApplication sharedApplication].delegate) showMovieDetails:((MovieTableItem*)_item).itemId];
    }
}

-(void) imdb:(id)sender
{
    if (((MovieTableItem*)_item).imdb)
    {
        [((AppDelegate*)[UIApplication sharedApplication].delegate) showImdb:((MovieTableItem*)_item).imdb];
    }
}

@end
