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

#import "TVShowTableItemCell.h"
#import "TVShowsViewDataSource.h"

#import "XBMCStateListener.h"
#import "XBMCImage.h"

#import "TVShowCellView.h"

#define MENU_HEIGHT 25;
#define FORSEARCH_HEIGHT 40;

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TVShowTableItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) 
    {
        [self setClipsToBounds:YES];
		
		// Create a time zone view and add it as a subview of self's contentView.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		CGFloat height = [[defaults valueForKey:@"tvshowCell:height"] floatValue];
		CGRect tzvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, height);
		_infoView = [[TVShowCellView alloc] initWithFrame:tzvFrame];
		_infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:_infoView];
		
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
        
        _tvdbButton = [[[TTButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)] autorelease];
        [_tvdbButton setTitle:@"TheTvdb" forState:UIControlStateNormal];
        [_tvdbButton setBackgroundColor:[UIColor clearColor]];
        [_tvdbButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_tvdbButton addTarget:self action:@selector(tvdb:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_tvdbButton];
        
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_buttons);
    TT_RELEASE_SAFELY(_infoView);
    [super dealloc];
}

- (void)redisplay {
	[_infoView setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame 
{
    [super setFrame:frame];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = [[defaults valueForKey:@"tvshowCell:height"] floatValue];
	CGRect tzvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, height);
	_infoView.frame = tzvFrame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat height = [[defaults valueForKey:@"tvshowCell:height"] floatValue];
    
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
        TVShowTableItem* item = (TVShowTableItem*)_item;
		
		[_infoView setItem:item];

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
        
        if (item.tvdb != nil && ![item.tvdb isEqual:@""])
        {
            _tvdbButton.hidden = FALSE;
            [_buttons addObject:_tvdbButton];
        }
        else
        {
            _tvdbButton.hidden = TRUE;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
	[_infoView setHighlighted:selected];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (void)prepareForReuse
{
	[self setSelected:FALSE];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)subtitleLabel {
    return self.detailTextLabel;
}

- (void)toggleImage:(BOOL)animated
{
}


- (void)loadImage
{
	[_infoView loadImage];
}

#pragma mark -
#pragma mark actions

-(void) play:(id)sender
{
//    if (((TVShowTableItem*)_item).file)
//    {
////        [XBMCStateListener play:((TVShowsTableItem*)_item).file];
//    }
}
-(void) enqueue:(id)sender
{
//    if ([delegate respondsToSelector:@selector(TVShows:action:)])
//    {
////        [delegate TVShows:TVShows action:@"enqueue"];
//    }
}
-(void) moreInfos:(id)sender
{	
//	[[NSNotificationCenter defaultCenter] 
//	 postNotificationName:@"showSeasons" 
//	 object:nil userInfo:[NSDictionary 
//						  dictionaryWithObjectsAndKeys:((TVShowTableItem*)_item).itemId, @"tvshowid"
//						  , nil]];
//	
//	NSNumber* tvshowId = [[notification userInfo] objectForKey:@"tvshowid"];
//	NSLog(@"Asking for seasons %@",tvshowId);
	
	NSString* url = [NSString stringWithFormat:@"tt://library/seasons/%@/%d"
					 ,((TVShowTableItem*)_item).itemId, !((TVShowTableItem*)_item).dataSource.hideWatched];
	TTOpenURL(url);
}

-(void) tvdb:(id)sender
{
    if (((TVShowTableItem*)_item).tvdb)
    {
		NSLog(@"tvdb %@", ((TVShowTableItem*)_item).tvdb);
        [((AppDelegate*)[UIApplication sharedApplication].delegate) showTvdb:((TVShowTableItem*)_item).tvdb];
    }
}

@end
