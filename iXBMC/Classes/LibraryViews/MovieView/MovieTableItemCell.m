
#import "MovieTableItemCell.h"
#import "MovieTableItem.h"
#import "MovieCellView.h"

#import "XBMCStateListener.h"
#import "XBMCCommand.h"
#import "XBMCImage.h"

#import "MovieCellView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MovieTableItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) 
    {
		CGRect tzvFrame = self.contentView.bounds;
		 
		_infoView = [[MovieCellView alloc] initWithFrame:tzvFrame];
		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		_infoView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[self.contentView addSubview:_infoView];

        _detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_detailsButton.imageView.contentMode = UIViewContentModeBottom;
        [_detailsButton setImage:TTIMAGE(@"bundle://iconInfo.png") 
						forState:UIControlStateNormal];
		[_detailsButton setImage:TTIMAGE(@"bundle://iconInfoOn.png") 
								  forState:UIControlStateHighlighted];
        [_detailsButton setBackgroundColor:[UIColor clearColor]];
        [_detailsButton addTarget:self action:@selector(moreInfos:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_detailsButton];
		
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.imageView.contentMode = UIViewContentModeBottom;
        [_playButton setImage:TTIMAGE(@"bundle://iconPlay.png") 
						forState:UIControlStateNormal];
		[_playButton setImage:TTIMAGE(@"bundle://iconPlayOn.png") 
						forState:UIControlStateHighlighted];
        [_playButton setBackgroundColor:[UIColor clearColor]];
        [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playButton];
            
        _enqueueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enqueueButton.imageView.contentMode = UIViewContentModeBottom;
        [_enqueueButton setImage:TTIMAGE(@"bundle://iconEnqueue.png") 
					 forState:UIControlStateNormal];
		[_enqueueButton setImage:TTIMAGE(@"bundle://iconEnqueueOn.png") 
					 forState:UIControlStateHighlighted];
        [_enqueueButton setBackgroundColor:[UIColor clearColor]];
        [_enqueueButton addTarget:self action:@selector(enqueue:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_enqueueButton];
        
        _trailerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _trailerButton.imageView.contentMode = UIViewContentModeBottom;
        [_trailerButton setImage:TTIMAGE(@"bundle://iconTrailer.png") 
						forState:UIControlStateNormal];
		[_trailerButton setImage:TTIMAGE(@"bundle://iconTrailerOn.png") 
						forState:UIControlStateHighlighted];
        [_trailerButton setBackgroundColor:[UIColor clearColor]];
        [_trailerButton addTarget:self action:@selector(showTrailer:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_trailerButton];
        
        _imdbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imdbButton.imageView.contentMode = UIViewContentModeBottom;
        [_imdbButton setImage:TTIMAGE(@"bundle://iconImdb.png") 
						forState:UIControlStateNormal];
		[_imdbButton setImage:TTIMAGE(@"bundle://iconImdbOn.png") 
						forState:UIControlStateHighlighted];
        [_imdbButton setBackgroundColor:[UIColor clearColor]];
        [_imdbButton addTarget:self action:@selector(imdb:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_imdbButton];
        
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cellHeight
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:@"movieCell:height"] floatValue];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object 
{
    [super setObject:object];

    if (_item != nil)
    {
        MovieTableItem* item = (MovieTableItem*)_item;
		
		NSRange foundRange = [item.runtime rangeOfString:@"min"];
		
		if ((foundRange.length == 0) ||
			(foundRange.location == 0))
		{
			item.runtime = [item.runtime stringByAppendingString:@" min"];
		}
        
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

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark actions

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
        [XBMCCommand play:((MovieTableItem*)_item).file];
    }
}
-(void) enqueue:(id)sender
{
    if (((MovieTableItem*)_item).itemId)
    {
        [XBMCCommand enqueue:[NSDictionary dictionaryWithObjectsAndKeys:@"movie", @"type"
									, ((MovieTableItem*)_item).itemId,@"id", nil]];
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

-(void) activate
{
	[self moreInfos:nil];
}

@end
