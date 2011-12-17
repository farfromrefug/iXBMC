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
@dynamic genres;
@dynamic roles;

- (void)addGenresObject:(Genre *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"genres" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [(NSMutableArray*)[self primitiveValueForKey:@"genres"] addObject:value];
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
    [(NSMutableArray*)[self primitiveValueForKey:@"roles"] addObject:value];
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

+ (NSString*)defaultSort
{
    return @"firstLetter asc sortLabel asc";
}

+ (NSArray*)sorts
{
    return [NSArray arrayWithObjects:[self defaultSort], @"year des sortLabel asc", @"director asc sortLabel asc", nil];
}
+ (NSArray*)sortNames
{
    return [NSArray arrayWithObjects:@"Title", @"Year", @"Director", nil];
}

@end
