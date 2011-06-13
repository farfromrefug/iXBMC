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

#import "ConnectionActivityLabel.h"

static CGFloat kBannerPadding   = 8;
static CGFloat kSpacing         = 6;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ConnectionActivityLabel


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
  if (self = [super initWithFrame:CGRectZero]) {

    _bezelView = [[TTView alloc] init];

    _bezelView.backgroundColor = [UIColor clearColor];
    _bezelView.style = TTSTYLE(blackBanner);
    self.backgroundColor = [UIColor clearColor];


    self.autoresizingMask =
      UIViewAutoresizingFlexibleWidth |
      UIViewAutoresizingFlexibleHeight;

    _label = [[UILabel alloc] init];
    _label.text = nil;
    _label.backgroundColor = [UIColor clearColor];
    _label.lineBreakMode = UILineBreakModeTailTruncation;

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                                            UIActivityIndicatorViewStyleWhite];
    [_activityIndicator hidesWhenStopped];
    _label.font = TTSTYLEVAR(activityBannerFont);
    _label.textColor = [UIColor whiteColor];
    _label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    _label.shadowOffset = CGSizeMake(1, 1);

    [self addSubview:_bezelView];
    [_bezelView addSubview:_activityIndicator];
    [_bezelView addSubview:_label];
    [_activityIndicator startAnimating];
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_bezelView);
  TT_RELEASE_SAFELY(_activityIndicator);
  TT_RELEASE_SAFELY(_label);
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  [super layoutSubviews];

  CGSize textSize = [_label.text sizeWithFont:_label.font];

  CGFloat indicatorSize = 0;
  [_activityIndicator sizeToFit];
  if (_activityIndicator.isAnimating) {
    if (_activityIndicator.height > textSize.height) {
      indicatorSize = textSize.height;

    } else {
      indicatorSize = _activityIndicator.height;
    }
  }

  CGFloat contentWidth = indicatorSize + kSpacing + textSize.width;
  CGFloat contentHeight = textSize.height > indicatorSize ? textSize.height : indicatorSize;

  CGFloat margin, padding, bezelWidth, bezelHeight;
    margin = 0;
    padding = kBannerPadding;
    bezelWidth = self.width;
    bezelHeight = self.height;

  CGFloat maxBevelWidth = TTScreenBounds().size.width - margin*2;
  if (bezelWidth > maxBevelWidth) {
    bezelWidth = maxBevelWidth;
    contentWidth = bezelWidth - (kSpacing + indicatorSize);
  }

  CGFloat textMaxWidth = (bezelWidth - (indicatorSize + kSpacing)) - padding*2;
  CGFloat textWidth = textSize.width;
  if (textWidth > textMaxWidth) {
    textWidth = textMaxWidth;
  }

  _bezelView.frame = CGRectMake(floor(self.width/2 - bezelWidth/2),
                                floor(self.height/2 - bezelHeight/2),
                                bezelWidth, bezelHeight);

  CGFloat y = padding + floor((bezelHeight - padding*2)/2 - contentHeight/2);

  _label.frame = CGRectMake(floor((bezelWidth/2 - contentWidth/2) + kSpacing), y,
                            textWidth, textSize.height);

  _activityIndicator.frame = CGRectMake(bezelWidth - (indicatorSize+kSpacing), y,
                                        indicatorSize, indicatorSize);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)sizeThatFits:(CGSize)size {
  CGFloat padding;
    padding = kBannerPadding;

  CGFloat height = _label.font.ttLineHeight + padding*2;

  return CGSizeMake(size.width, height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)text {
  return _label.text;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setText:(NSString*)text {
  _label.text = text;
  [self setNeedsLayout];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)font {
  return _label.font;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFont:(UIFont*)font {
  _label.font = font;
  [self setNeedsLayout];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isAnimating {
  return _activityIndicator.isAnimating;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setIsAnimating:(BOOL)isAnimating {
  if (isAnimating) {
      [_activityIndicator startAnimating];

  } else {
    [_activityIndicator stopAnimating];
  }
}


@end
