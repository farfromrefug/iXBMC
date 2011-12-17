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
@property (nonatomic, retain) NSSet* roles;

- (void)addRolesObject:(ActorRole *)value;
- (void)removeRolesObject:(ActorRole *)value;
- (void)addRoles:(NSSet *)value;
- (void)removeRoles:(NSSet *)value;
@end
