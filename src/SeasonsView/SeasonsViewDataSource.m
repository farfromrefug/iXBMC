
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
//@synthesize nbEpisodesToQueue = _nbEpisodesToQueue;
@synthesize showId = _showId;

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
		
        if(_hideWatched)
		{
			self.predicate = [NSPredicate predicateWithFormat:@"tvshowid == %@ AND (ANY episodes.playcount == 0)", self.showId];
		}
		else
		{
			self.predicate = [NSPredicate predicateWithFormat:@"tvshowid == %@", self.showId];
		}
    }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	TT_RELEASE_SAFELY(_model);
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
//        [self didStartLoad];
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
//        // Merging changes causes the fetched results controller to update its results
////        [context mergeChangesFromContextDidSaveNotification:saveNotification];	
//        [context performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
//                                       withObject:saveNotification
//                                    waitUntilDone:YES]; 
		
		// Fault in all updated objects
		NSArray* updates = [[saveNotification.userInfo objectForKey:@"updated"] allObjects];
		for (NSInteger i = [updates count]-1; i >= 0; i--)
		{
			[[context objectWithID:[[updates objectAtIndex:i] objectID]] willAccessValueForKey:nil];
		}
		
		// Merge
		[context mergeChangesFromContextDidSaveNotification:saveNotification];
		
//		[context mergeChangesFromContextDidSaveNotification:saveNotification];
//        [self.model.delegates perform:@selector(modelDidFinishLoad:) withObject:self.model];
//        [self load:TTURLRequestCachePolicyNone more:TRUE];
//        [self.tableView reloadData];
////        [self load:TTURLRequestCachePolicyNone more:TRUE];
//        [self silentDidLoad];        
//    }
//    else
//    {
////        [self didStartLoad];
//        [self load:TTURLRequestCachePolicyNone more:TRUE];
//        [self.tableView reloadData];
//        [self silentDidLoad];        
    }
}

- (void) toggleWatched
{
    _hideWatched = !_hideWatched;
    if(_hideWatched)
    {
		self.predicate = [NSPredicate predicateWithFormat:@"tvshowid == %@ AND (ANY episodes.playcount == 0)", self.showId];
    }
	else
	{
		self.predicate = [NSPredicate predicateWithFormat:@"tvshowid == %@", self.showId];
	}
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
    return [super numberOfSectionsInTableView:tableView] + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0 ) return 1;
    else return [super tableView:tableView numberOfRowsInSection:section - 1];
}

#pragma mark -
#pragma mark TTTable view data source methods

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
//	if ([object isKindOfClass:[SeasonTableItem class]])
		return [SeasonTableItemCell class];
//	else return [TTTableTextItemCell class];
}

// override TTTableViewDataSource's method to return the cell TableItem we want - three20 will take care of returning the right cell
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	Season *season = nil;
	SeasonTableItem* item = [SeasonTableItem item];
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
//		Season *season = nil;
		season = (Season*)[self.fetchedResultsController objectAtIndexPath:realIndex];
		
		item.label = season.label;
		item.imageURL = season.thumbnail;
	//    item.runtime = season.runtime;
	//    item.selected = [_selectedCellIndexPath isEqual:indexPath];
	//    item.file = season.file;
	//    item.trailer = season.trailer;
		item.itemId = season.season;
	//    item.year = [season.year stringValue];
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

