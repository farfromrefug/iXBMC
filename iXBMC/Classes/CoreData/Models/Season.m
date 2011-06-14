//
//  Season.m
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Season.h"
#import "Episode.h"


@implementation Season
@dynamic fanart;
@dynamic showtitle;
@dynamic playcount;
@dynamic thumbnail;
@dynamic season;
@dynamic tvshowid;
@dynamic label;
@dynamic nbepisodes;
@dynamic tvshow;
@dynamic episodes;


- (void)addEpisodesObject:(Episode *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"episodes" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"episodes"] addObject:value];
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


@end
