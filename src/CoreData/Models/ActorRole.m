//
//  ActorRole.m
//  iXBMC
//
//  Created by Martin Guillon on 6/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActorRole.h"
#import "Actor.h"
#import "Episode.h"
#import "Movie.h"
#import "TVShow.h"


@implementation ActorRole
@dynamic role;
@dynamic actorName;
@dynamic actor;
@dynamic episodes;
@dynamic tvshows;
@dynamic movies;


- (void)addEpisodesObject:(Episode *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"episodes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [(NSMutableArray*)[self primitiveValueForKey:@"episodes"] addObject:value];
    [self didChangeValueForKey:@"episodes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEpisodesObject:(Episode *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"episodes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"episodes"] removeObject:value];
    [self didChangeValueForKey:@"episodes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEpisodes:(NSSet *)value {    
    [self willChangeValueForKey:@"episodes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"episodes"] unionSet:value];
    [self didChangeValueForKey:@"episodes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEpisodes:(NSSet *)value {
    [self willChangeValueForKey:@"episodes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"episodes"] minusSet:value];
    [self didChangeValueForKey:@"episodes" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addTvshowsObject:(TVShow *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [(NSMutableArray*)[self primitiveValueForKey:@"tvshows"] addObject:value];
    [self didChangeValueForKey:@"tvshows" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTvshowsObject:(TVShow *)value {
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


- (void)addMoviesObject:(Movie *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"movies" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [(NSMutableArray*)[self primitiveValueForKey:@"movies"] addObject:value];
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


@end
