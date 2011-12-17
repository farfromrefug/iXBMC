
#import "EpisodeTableItemCell.h"
#import "EpisodeTableItem.h"
#import "EpisodesViewDataSource.h"

#import "Episode.h"

#import "XBMCStateListener.h"
#import "XBMCCommand.h"
#import "XBMCImage.h"

#import "EpisodeCellView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EpisodeTableItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) 
    {		
		// Create a time zone view and add it as a subview of self's contentView.
		CGRect tzvFrame = self.contentView.bounds;
		_infoView = [[EpisodeCellView alloc] initWithFrame:tzvFrame];
		_infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:_infoView];
		
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
        [_enqueueButton setTitle:@"Enqueue Ep" forState:UIControlStateNormal];
        [_enqueueButton setBackgroundColor:[UIColor clearColor]];
        [_enqueueButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_enqueueButton addTarget:self action:@selector(enqueue:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_enqueueButton];
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
#pragma mark TTTableViewCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)cellHeight
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:@"episodeCell:height"] floatValue];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object 
{
    [super setObject:object];

    if (_item != nil)
    {
        EpisodeTableItem* item = (EpisodeTableItem*)_item;
		
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
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark actions

-(void) play:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	if ([[defaults valueForKey:@"tvshows:playAndEnqueue"] boolValue])
	{		
		EpisodesViewDataSource* dataSource  = ((EpisodeTableItem*)_item).dataSource;
		NSArray* episodes;
		
		if ([((EpisodeTableItem*)_item).episode intValue] == -1)
		{
			episodes = [dataSource.fetchedResultsController fetchedObjects];
		}
		else
		{
			NSPredicate * newCondition = [NSPredicate predicateWithFormat:@"episode >= %@", ((EpisodeTableItem*)_item).episode];
			NSPredicate * newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:[dataSource predicate], newCondition, nil]];
			episodes = [[dataSource.fetchedResultsController fetchedObjects] filteredArrayUsingPredicate:newPredicate];
		}
		
		NSMutableArray* items = [NSMutableArray array];
		for (Episode* episode in episodes)
		{
			[items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							  @"episode", @"type", 
							  episode.episodeid, @"id",nil]];
		}
		[XBMCCommand setVideoPlaylistAndPlay:items];
	}
	else
	{
		if (((EpisodeTableItem*)_item).file)
		{
			[XBMCCommand play:((EpisodeTableItem*)_item).file];
		}
	}
}
-(void) enqueue:(id)sender
{
	if (((EpisodeTableItem*)_item).itemId)
    {
        [XBMCCommand enqueue:[NSDictionary dictionaryWithObjectsAndKeys:@"movie", @"type"
							  , ((EpisodeTableItem*)_item).itemId,@"id", nil]];
    }
}
-(void) moreInfos:(id)sender
{
    if (((EpisodeTableItem*)_item).itemId)
    {
//        [((AppDelegate*)[UIApplication sharedApplication].delegate) showEpisodesDetails:((EpisodeTableItem*)_item).itemId];
    }
}

-(void) activate
{
	[self play:nil];
}


@end
