//
//  Actor.m
//  iXBMC
//
//  Created by Martin Guillon on 5/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Actor.h"
#import "ActorRole.h"


@implementation Actor
@dynamic name;
@dynamic firstLetter;
@dynamic roles;

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

@end
