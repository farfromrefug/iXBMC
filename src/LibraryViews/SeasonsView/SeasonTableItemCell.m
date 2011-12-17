
#import "SeasonTableItemCell.h"
#import "SeasonTableItem.h"
#import "SeasonsViewDataSource.h"

#import "Episode.h"

#import "XBMCStateListener.h"
#import "XBMCCommand.h"
#import "XBMCImage.h"
#import "ActiveManager.h"

#import "SeasonCellView.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeasonTableItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) 
    {
		
		// Create a time zone view and add it as a subview of self's contentView.
		CGRect tzvFrame = self.contentView.bounds;
		_infoView = [[SeasonCellView alloc] initWithFrame:tzvFrame];
		_infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:_infoView];
		
        _playUnwatchedButton = [[[TTButton alloc] initWithFrame:CGRectZero] autorelease];
        [_playUnwatchedButton setTitle:@"Play Unwatched" forState:UIControlStateNormal];
        [_playUnwatchedButton setBackgroundColor:[UIColor clearColor]];
        [_playUnwatchedButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_playUnwatchedButton addTarget:self action:@selector(playUnwatched:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playUnwatchedButton];
		
		_playAllButton = [[[TTButton alloc] initWithFrame:CGRectZero] autorelease];
        [_playAllButton setTitle:@"Play All" forState:UIControlStateNormal];
        [_playAllButton setBackgroundColor:[UIColor clearColor]];
        [_playAllButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
																			 color2:[UIColor grayColor] 
																			  width:1 next:
										[TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
															 color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_playAllButton addTarget:self action:@selector(playAll:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playAllButton];
        
        _enqueueUnwatchedButton = [[[TTButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)] autorelease];
        [_enqueueUnwatchedButton setTitle:@"Enqueue Unwatched" forState:UIControlStateNormal];
        [_enqueueUnwatchedButton setBackgroundColor:[UIColor clearColor]];
        [_enqueueUnwatchedButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
                                                               color2:[UIColor grayColor] 
                                                                width:1 next:
                          [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                               color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_enqueueUnwatchedButton addTarget:self action:@selector(enqueueUnwatched:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_enqueueUnwatchedButton];
		
		_enqueueAllButton = [[[TTButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)] autorelease];
        [_enqueueAllButton setTitle:@"Enqueue All" forState:UIControlStateNormal];
        [_enqueueAllButton setBackgroundColor:[UIColor clearColor]];
        [_enqueueAllButton setStyle:[TTLinearGradientBorderStyle styleWithColor1:[UIColor clearColor] 
																	   color2:[UIColor grayColor] 
																		width:1 next:
								  [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
													   color:[UIColor grayColor] next:nil]] forState:UIControlStateNormal];
        [_enqueueAllButton addTarget:self action:@selector(enqueueAll:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_enqueueAllButton];
        
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
    return [[defaults valueForKey:@"seasonCell:height"] floatValue];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object 
{
    [super setObject:object];

    if (_item != nil)
    {
//        SeasonTableItem* item = (SeasonTableItem*)_item;
		
        if ([XBMCStateListener connected])
        {
            _playUnwatchedButton.hidden = FALSE;
            _playAllButton.hidden = FALSE;
            _enqueueUnwatchedButton.hidden = FALSE;
            _enqueueAllButton.hidden = FALSE;
            [_buttons addObject:_playUnwatchedButton];
            [_buttons addObject:_playAllButton];
            [_buttons addObject:_enqueueAllButton];
            [_buttons addObject:_enqueueUnwatchedButton];
        }
        else
        {
            _playUnwatchedButton.hidden = TRUE;
            _playAllButton.hidden = TRUE;
            _enqueueAllButton.hidden = TRUE;
            _enqueueUnwatchedButton.hidden = TRUE;
        }
    }
}

#pragma mark -
#pragma mark actions

-(void) play:(BOOL)withWatched
{	
	SeasonsViewDataSource* dataSource  = ((SeasonTableItem*)_item).dataSource;
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"tvshowid == %@"
							  , ((SeasonTableItem*)_item).showId];
	if ([((SeasonTableItem*)_item).itemId intValue] != -1)
	{
		NSPredicate * newCondition = [NSPredicate predicateWithFormat:@"season.season == %@", ((SeasonTableItem*)_item).itemId];
		predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:[dataSource predicate], newCondition, nil]];
	}
	if (!withWatched)
	{
		NSPredicate * newCondition = [NSPredicate predicateWithFormat:@"playcount == 0"];
		predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:[dataSource predicate], newCondition, nil]];
	}
	NSArray *episodes = [[[ActiveManager shared] managedObjectContext] fetchObjectsForEntityName:@"Episode" withPredicate:predicate];
	
	NSMutableArray* items = [NSMutableArray array];
	for (Episode* episode in episodes)
	{
//		NSLog(@"adding Episode %@", episode.episode);
		[items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						  @"episode", @"type", 
						  episode.episodeid, @"id",nil]];
	}
	[XBMCCommand setVideoPlaylistAndPlay:items];
}

-(void) playAll:(id)sender
{
	[self play:TRUE];
}

-(void) playUnwatched:(id)sender
{
	[self play:FALSE];
}

-(void) enqueue:(BOOL)withWatched
{
	SeasonsViewDataSource* dataSource  = ((SeasonTableItem*)_item).dataSource;
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"tvshowid == %@"
							  , ((SeasonTableItem*)_item).showId];
	if ([((SeasonTableItem*)_item).itemId intValue] != -1)
	{
		NSPredicate * newCondition = [NSPredicate predicateWithFormat:@"season.season == %@", ((SeasonTableItem*)_item).itemId];
		predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:[dataSource predicate], newCondition, nil]];
	}
	if (!withWatched)
	{
		NSPredicate * newCondition = [NSPredicate predicateWithFormat:@"playcount == 0"];
		predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:[dataSource predicate], newCondition, nil]];
	}
	NSArray *episodes = [[[ActiveManager shared] managedObjectContext] fetchObjectsForEntityName:@"Episode" withPredicate:predicate];
	
	NSMutableArray* items = [NSMutableArray array];
	for (Episode* episode in episodes)
	{
//		NSLog(@"adding Episode %@", episode.episode);
		[items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						  @"episode", @"type", 
						  episode.episodeid, @"id",nil]];
	}
	[XBMCCommand enqueue:items];
}

-(void) enqueueAll:(id)sender
{
	[self enqueue:TRUE];
}

-(void) enqueueUnwatched:(id)sender
{
	[self enqueue:FALSE];
}

-(void) moreInfos:(id)sender
{	
}

-(void) activate
{	
	NSString* url = [NSString stringWithFormat:@"tt://library/episodes/%@/%@/%d"
					 ,((SeasonTableItem*)_item).showId, ((SeasonTableItem*)_item).itemId, !((SeasonTableItem*)_item).dataSource.hideWatched];
	TTOpenURL(url);
}

@end
