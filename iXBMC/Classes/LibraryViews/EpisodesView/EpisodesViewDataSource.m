
#import "EpisodesViewDataSource.h"

#import "EpisodesViewModel.h"
#import "Season.h"
#import "Episode.h"
#import "EpisodeTableItem.h"
#import "EpisodeTableItemCell.h"

#import "ActiveManager.h"

#import "XBMCHttpInterface.h"

// Three20 Additions
#import <Three20Core/NSDateAdditions.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EpisodesViewDataSource
@synthesize hideWatched = _hideWatched;
@synthesize showId = _showId;
@synthesize season = _season;


- (void)setPredicate
{
	NSString* predString = [NSString stringWithFormat:@"tvshowid == %@", self.showId];
	if(_hideWatched)
	{
		predString = [predString stringByAppendingString:@" AND (playcount == 0)"];
	}
	if (![self.season isEqualToString:@"-1"])
	{
		predString = [predString stringByAppendingFormat:@" AND (season.season == %@)", self.season];
	}
	self.predicate = [NSPredicate predicateWithFormat:predString];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithTVShow:(NSString *)tvshowid season:(NSString *)season showWatched:(BOOL)watched controllerTableView:(UITableView *)controllerTableView
{
    self = [super initWithEntity:[[[[ActiveManager shared] managedObjectModel] 
								   entitiesByName] objectForKey:@"Episode"]
			 controllerTableView:controllerTableView];
    if (self) 
    {
        appDelegate = ((AppDelegate*)[UIApplication sharedApplication].delegate); 
        self.tableView = controllerTableView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(libraryContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
        _model = [[TTModel alloc] init];
        _hideWatched = !watched;
		self.showId = tvshowid;
		self.season = season;

		[self setPredicate];
    }

  return self;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	TT_RELEASE_SAFELY(_model);
	TT_RELEASE_SAFELY(_season);
	TT_RELEASE_SAFELY(_showId);
	[super dealloc];
}

-(NSUInteger) count
{
    return [self.fetchedResultsController.fetchedObjects count];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
  return NSLocalizedString(@"Looking for Episodes...", @"");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No Episode found.", @"");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the Episodes.", @"");
}

- (void)libraryContextDidSave:(NSNotification*)saveNotification {
	if ([self isLoaded])
    {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
		
		// Fault in all updated objects
		NSArray* updates = [[saveNotification.userInfo objectForKey:@"updated"] allObjects];
		for (NSInteger i = [updates count]-1; i >= 0; i--)
		{
			[[context objectWithID:[[updates objectAtIndex:i] objectID]] willAccessValueForKey:nil];
		}
		
		// Merge
		[context mergeChangesFromContextDidSaveNotification:saveNotification];
    }
}

- (void) toggleWatched
{
    _hideWatched = !_hideWatched;
	[self setPredicate];

    [self performFetch];
//    [self silentDidLoad];        
} 

#pragma mark -
#pragma mark Table view data source methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
	return @"";
}

/*
 The data source methods are handled primarily by the fetch results controller
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView] + 1*([self count] > 0);
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self count] > 0 && section == 0 ) return 1;
    else return [super tableView:tableView numberOfRowsInSection:section - 1*([self count] > 0)];
}

#pragma mark -
#pragma mark TTTable view data source methods

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
		return [EpisodeTableItemCell class];
}

// override TTTableViewDataSource's method to return the cell TableItem we want - three20 will take care of returning the right cell
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	Episode *episode = nil;
	EpisodeTableItem* item = [EpisodeTableItem item];
	item.watched = TRUE;
	if (indexPath.section == 0)
	{
		item.label = @"All Episodes";
		item.episode = [NSNumber numberWithInt:-1];
	}
	else
	{
		NSIndexPath* realIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
		episode = (Episode*)[self.fetchedResultsController objectAtIndexPath:realIndex];
		
		item.label = episode.label;
		item.imageURL = episode.thumbnail;
	    item.runtime = episode.runtime;
	    item.file = episode.file;
		item.itemId = episode.episodeid;
		item.episode = episode.episode;
		item.season = episode.season.season;
	    item.firstaired = episode.firstaired;
		item.rating = [NSString stringWithFormat:@"%.1f",[episode.rating floatValue]];
//		item.tagline = episode.plot;
		item.watched = [episode.playcount intValue] > 0;

	}
	return item;    
}

@end

