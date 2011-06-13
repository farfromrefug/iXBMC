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

// Style
#import "Three20Style/TTStyleSheet.h"

@interface StyleSheet : TTDefaultStyleSheet

@property (nonatomic, readonly) CGFloat headerViewHeight;
@property (nonatomic, readonly) CGFloat moviesViewCellsHeight;
@property (nonatomic, readonly) CGFloat moviesViewCellsMinHeight;
@property (nonatomic, readonly) CGFloat moviesViewCellsMaxHeight;
@property (nonatomic, readonly) CGFloat movieDetailsViewCoverHeight;
@property (nonatomic, readonly) BOOL moviesViewRatingStars;
@property (nonatomic, readonly) UIColor*  navigationBarTintColor;
@property (nonatomic, readonly) TTStyle* whiteText;
@property (nonatomic, readonly) TTStyle* plotText;
@property (nonatomic, readonly) TTStyle* bigWhiteText;
@property (nonatomic, readonly) UIColor*  tabTintColor;
@property (nonatomic, readonly) UIColor*  themeColor;
@property (nonatomic, readonly) TTStyle* tableToolbar;
@property (nonatomic, readonly) NSString*  emptyDBName;
@property (nonatomic, readonly) UITableViewCellSelectionStyle tableSelectionStyle;

@end
