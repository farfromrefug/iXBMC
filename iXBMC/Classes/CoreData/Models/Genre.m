//
//  Genre.m
//  iXBMC
//
//  Created by Martin Guillon on 5/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Genre.h"
#import "Movie.h"


@implementation Genre
@dynamic name;
@dynamic GenreToMovie;

- (void)addGenreToMovieObject:(Movie *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"GenreToMovie" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"GenreToMovie"] addObject:value];
    [self didChangeValueForKey:@"GenreToMovie" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeGenreToMovieObject:(Movie *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"GenreToMovie" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"GenreToMovie"] removeObject:value];
    [self didChangeValueForKey:@"GenreToMovie" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addGenreToMovie:(NSSet *)value {    
    [self willChangeValueForKey:@"GenreToMovie" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"GenreToMovie"] unionSet:value];
    [self didChangeValueForKey:@"GenreToMovie" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeGenreToMovie:(NSSet *)value {
    [self willChangeValueForKey:@"GenreToMovie" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"GenreToMovie"] minusSet:value];
    [self didChangeValueForKey:@"GenreToMovie" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
