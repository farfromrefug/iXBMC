//
//  Movie.m
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"
#import "ActorRole.h"
#import "Genre.h"


@implementation Movie
@dynamic thumbnail;
@dynamic runtime;
@dynamic playcount;
@dynamic tagline;
@dynamic file;
@dynamic trailer;
@dynamic dateAddedLocal;
@dynamic plot;
@dynamic year;
@dynamic imdbid;
@dynamic plotoutline;
@dynamic label;
@dynamic studio;
@dynamic sortLabel;
@dynamic director;
@dynamic writer;
@dynamic genre;
@dynamic fanart;
@dynamic dateAdded;
@dynamic rating;
@dynamic movieid;
@dynamic firstLetter;
@dynamic MovieToGenre;
@dynamic MovieToRole;

- (void)addMovieToGenreObject:(Genre *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"MovieToGenre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"MovieToGenre"] addObject:value];
    [self didChangeValueForKey:@"MovieToGenre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMovieToGenreObject:(Genre *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"MovieToGenre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"MovieToGenre"] removeObject:value];
    [self didChangeValueForKey:@"MovieToGenre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMovieToGenre:(NSSet *)value {    
    [self willChangeValueForKey:@"MovieToGenre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"MovieToGenre"] unionSet:value];
    [self didChangeValueForKey:@"MovieToGenre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMovieToGenre:(NSSet *)value {
    [self willChangeValueForKey:@"MovieToGenre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"MovieToGenre"] minusSet:value];
    [self didChangeValueForKey:@"MovieToGenre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addMovieToRoleObject:(ActorRole *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"MovieToRole"] addObject:value];
    [self didChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMovieToRoleObject:(ActorRole *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"MovieToRole"] removeObject:value];
    [self didChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMovieToRole:(NSSet *)value {    
    [self willChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"MovieToRole"] unionSet:value];
    [self didChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMovieToRole:(NSSet *)value {
    [self willChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"MovieToRole"] minusSet:value];
    [self didChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
