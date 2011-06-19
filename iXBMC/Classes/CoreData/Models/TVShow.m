//
//  TVShow.m
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TVShow.h"
#import "ActorRole.h"
#import "Episode.h"
#import "Genre.h"
#import "Season.h"


@implementation TVShow
@dynamic fanart;
@dynamic firstLetter;
@dynamic genre;
@dynamic tvdbid;
@dynamic label;
@dynamic tvshowid;
@dynamic plot;
@dynamic rating;
@dynamic sortLabel;
@dynamic studio;
@dynamic tagline;
@dynamic thumbnail;
@dynamic premiered;
@dynamic genres;
@dynamic roles;
@dynamic seasons;
@dynamic episodes;

- (void)addGenresObject:(Genre *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"genres" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"genres"] addObject:value];
    [self didChangeValueForKey:@"genres" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeGenresObject:(Genre *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"genres" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"genres"] removeObject:value];
    [self didChangeValueForKey:@"genres" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addGenres:(NSSet *)value {    
    [self willChangeValueForKey:@"genres" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"genres"] unionSet:value];
    [self didChangeValueForKey:@"genres" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeGenres:(NSSet *)value {
    [self willChangeValueForKey:@"genres" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"genres"] minusSet:value];
    [self didChangeValueForKey:@"genres" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addRolesObject:(ActorRole *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"roles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"roles"] addObject:value];
    [self didChangeValueForKey:@"roles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRolesObject:(ActorRole *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"roles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"roles"] removeObject:value];
    [self didChangeValueForKey:@"roles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRoles:(NSSet *)value {    
    [self willChangeValueForKey:@"roles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"roles"] unionSet:value];
    [self didChangeValueForKey:@"roles" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRoles:(NSSet *)value {
    [self willChangeValueForKey:@"roles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"roles"] minusSet:value];
    [self didChangeValueForKey:@"roles" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addSeasonsObject:(Season *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"seasons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"seasons"] addObject:value];
    [self didChangeValueForKey:@"seasons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeSeasonsObject:(Season *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"seasons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"seasons"] removeObject:value];
    [self didChangeValueForKey:@"seasons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addSeasons:(NSSet *)value {    
    [self willChangeValueForKey:@"seasons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"seasons"] unionSet:value];
    [self didChangeValueForKey:@"seasons" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeSeasons:(NSSet *)value {
    [self willChangeValueForKey:@"seasons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"seasons"] minusSet:value];
    [self didChangeValueForKey:@"seasons" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

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


+ (NSString*)defaultSort
{
    return @"firstLetter asc sortLabel asc";
}

+ (NSArray*)sorts
{
    return [NSArray arrayWithObjects:[self defaultSort], @"premiered des sortLabel asc", nil];
}
+ (NSArray*)sortNames
{
    return [NSArray arrayWithObjects:@"Title", @"Premier", nil];
}

@end
