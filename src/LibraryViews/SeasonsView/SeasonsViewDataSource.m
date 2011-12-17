
#import "SeasonsViewDataSource.h"

#import "SeasonsViewModel.h"
#import "Season.h"
#import "Episode.h"
#import "SeasonTableItem.h"
#import "SeasonTableItemCell.h"

#import "ActiveManager.h"

#import "XBMCHttpInterface.h"

// Three20 Additions
#import <Three20Core/NSDateAdditions.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SeasonsViewDataSource
@synthesize hideWatched = _hideWatched;
@synthesize showId = _showId;

- (void)setPredicate
{
	NSString* predString = [NSString stringWithFormat:@"tvshowid == %@", self.showId];
	if(_hideWatched)
	{
		predString = [predString stringByAppendingString:@" AND (ANY episodes.playcount == 0)"];
	}
	self.predicate = [NSPredicate predicateWithFormat:predString];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithTVShow:(NSString *)tvshowid showWatched:(BOOL)watched controllerTableView:(UITableView *)controllerTableView
{
    self = [super initWithEntity:[[[[ActiveManager shared] managedObjectModel] 
								   entitiesByName] objectForKey:@"Season"]
			 controllerTableView:controllerTableView];
    if (self) 
    {
        appDelegate = ((AppDelegate*)[UIApplication sharedApplication].delegate); 
        self.tableView = controllerTableView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(libraryContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
        _model = [[TTModel alloc] init];
        _hideWatched = !watched;
		self.showId = tvshowid;
		
        [self setPredicate];
    }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	TT_RELEASE_SAFELY(_model);
	TT_RELEASE_SAFELY(_showId);
//    TT_RELEASE_SAFELY(_nbEpisodesToQueue);
	[super dealloc];
}

-(NSUInteger) count
{
    return [self.fetchedResultsController.fetchedObjects count];
}

//- (void)tableViewDidLoadModel:(UITableView*)tableView {
////    // the model has loaded, and hence Core Data entities are populated    
////    //self.managedObjectContext = appDelegate.managedObjectContext;
////    
////    NSError* error;
////    if( ![self.fetchedResultsController performFetch:&error] ) {
////        // handle error
////    }
////    [self loadLocal:TRUE];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
  return NSLocalizedString(@"Looking for Seasons...", @"");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
  return NSLocalizedString(@"No Season found.", @"");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
  return NSLocalizedString(@"Sorry, there was an error loading the Seasons.", @"");
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
} 

#pragma mark -
#pragma mark Table view data source methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
	return @"";
}

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
		return [SeasonTableItemCell class];
}

// override TTTableViewDataSource's method to return the cell TableItem we want - three20 will take care of returning the right cell
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	Season *season = nil;
	SeasonTableItem* item = [SeasonTableItem item];
	item.dataSource = self;
	item.showId = self.showId;
	item.watched = TRUE;
	if (indexPath.section == 0)
	{
		item.label = @"All Seasons";
		item.itemId = [NSNumber numberWithInt:-1];
//		item.nbEpisodes = self.nbEpisodesToQueue;
	}
	else
	{
		NSIndexPath* realIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
		season = (Season*)[self.fetchedResultsController objectAtIndexPath:realIndex];
		
		item.label = season.label;
		item.imageURL = season.thumbnail;
		item.itemId = season.season;
		item.showId = self.showId;
		item.nbUnWatched = [NSNumber numberWithInt:0];
		item.nbEpisodes = [NSNumber numberWithInt:[season.episodes count]];
		for (Episode* ep in season.episodes)
		{
			if ([ep.playcount intValue] == 0)
			{
				item.watched = FALSE;
				item.nbUnWatched = [NSNumber numberWithInt:[item.nbUnWatched intValue] + 1];
			}
		}
	}
	return item;    
}

@end

