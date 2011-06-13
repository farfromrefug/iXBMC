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
@dynamic ActorToRole;

- (void)addActorToRoleObject:(ActorRole *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ActorToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ActorToRole"] addObject:value];
    [self didChangeValueForKey:@"ActorToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeActorToRoleObject:(ActorRole *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ActorToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ActorToRole"] removeObject:value];
    [self didChangeValueForKey:@"ActorToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addActorToRole:(NSSet *)value {    
    [self willChangeValueForKey:@"ActorToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ActorToRole"] unionSet:value];
    [self didChangeValueForKey:@"ActorToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeActorToRole:(NSSet *)value {
    [self willChangeValueForKey:@"ActorToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ActorToRole"] minusSet:value];
    [self didChangeValueForKey:@"ActorToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

@end
