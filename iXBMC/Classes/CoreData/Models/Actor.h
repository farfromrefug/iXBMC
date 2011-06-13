//
//  Actor.h
//  iXBMC
//
//  Created by Martin Guillon on 5/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActorRole;

@interface Actor : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * firstLetter;
@property (nonatomic, retain) NSSet* ActorToRole;

- (void)addActorToRoleObject:(ActorRole *)value;
- (void)removeActorToRoleObject:(ActorRole *)value;
- (void)addActorToRole:(NSSet *)value;
- (void)removeActorToRole:(NSSet *)value;
@end
