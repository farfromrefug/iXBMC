//
//  XBMCFetchedResultDataSource.h
//  iXBMC
//
//  Created by Martin Guillon on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFetchedResultsDataSource.h"


@interface XBMCFetchedResultDataSource : NSFetchedResultsDataSource {
    
}

- (NSString*) currentSortName;
- (NSString*) switchSort;
- (void) performFetch;
- (void) deepFetch;

@end
