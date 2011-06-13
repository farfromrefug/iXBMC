//
//  XBMCFetchedResultDataSource.m
//  iXBMC
//
//  Created by Martin Guillon on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCFetchedResultDataSource.h"
#import "ActiveSupport.h"

@implementation XBMCFetchedResultDataSource

- (id) initWithEntity:(NSEntityDescription *)entity controllerTableView:(UITableView *)controllerTableView{
	self = [super initWithEntity:entity controllerTableView:controllerTableView];
	if(self)
    {
		self.fetchLimit = 0;
	}
	
	return self;
}

- (NSString*) currentSortName
{
    NSUInteger index = [_sortArray indexOfObject:_sortBy];
    return [_sortNames objectAtIndex:index];
}

- (void) performFetch
{
	[NSFetchedResultsController deleteCacheWithName:nil];
    NSError *error = nil;
	
	[self.fetchedResultsController.fetchRequest setEntity:_entity];
	[self.fetchedResultsController.fetchRequest setSortDescriptors:$SORT(_sortBy)];
    
	[self.fetchedResultsController.fetchRequest setPropertiesToFetch:_selectFields];
	
	[self.fetchedResultsController.fetchRequest setPredicate:_predicate];
	[self.fetchedResultsController.fetchRequest setRelationshipKeyPathsForPrefetching:_relationshipsToFetch];
	
	[self.fetchedResultsController performFetch:&error];
    if (error) {   
		//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//        abort();
    }
}

- (void) deepFetch
{
	[self loadLocal:TRUE];
}

- (NSString*) switchSort
{
    NSUInteger index = [_sortArray indexOfObject:_sortBy];
    index += 1;
    if (index == [_sortArray count])
    {
        index = 0;
    }
    self.sortBy = [_sortArray objectAtIndex:index];
    self.sectionKey = [ActiveSupport firstSortDescriptorName:self.sortBy];

    [self deepFetch];    
    return [self currentSortName];
}

@end
