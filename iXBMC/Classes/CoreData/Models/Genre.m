//
//  Genre.m
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Genre.h"
#import "Movie.h"


@implementation Genre
@dynamic name;
@dynamic movies;
@dynamic tvshows;

- (void)addMoviesObject:(Movie *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"movies"] addObject:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMoviesObject:(Movie *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"movies"] removeObject:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMovies:(NSSet *)value {    
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"movies"] unionSet:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMovies:(NSSet *)value {
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"movies"] minusSet:value];
    [self didChangeValueForKey:@"movies" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addTvshowsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tvshows"] addObject:value];
    [self didChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTvshowsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"tvshows"] removeObject:value];
    [self didChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTvshows:(NSSet *)value {    
    [self willChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tvshows"] unionSet:value];
    [self didChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTvshows:(NSSet *)value {
    [self willChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"tvshows"] minusSet:value];
    [self didChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
