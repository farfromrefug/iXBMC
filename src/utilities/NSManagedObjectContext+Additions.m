//
//  NSManagedObjectContext+Additions.m
//  Shopify_Mobile
//
//  Created by Matthew Newberry on 7/12/10.
//  Copyright 2010 Shopify. All rights reserved.
//

#import "NSManagedObjectContext+Additions.h"
#import "ActiveManager.h"

@implementation NSManagedObjectContext (NSManagedObjectContext_Additions)


- (BOOL) save{
		
	int insertedObjectsCount = [[self insertedObjects] count];
	int updatedObjectsCount = [[self updatedObjects] count];
	int deletedObjectsCount = [[self deletedObjects] count];
    	
	NSDate *startTime = [NSDate date];
		
	NSError *error;
	if(![self save:&error]) {
		NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  Error:%@", [error userInfo]);
		}
		
		return NO;
	}
	
	if([ActiveManager shared].logLevel > 0)
		NSLog(@"Created: %i, Updated: %i, Deleted: %i, Time: %f seconds", insertedObjectsCount, updatedObjectsCount, deletedObjectsCount, ([startTime timeIntervalSinceNow] *-1));
	
	return YES;
}

// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
					   withPredicate:(id)stringOrPredicate, ...
{
    NSEntityDescription *entity = [NSEntityDescription
								   entityForName:newEntityName inManagedObjectContext:self];
	
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entity];
    [request setSortDescriptors:$SORT([NSClassFromString([entity managedObjectClassName]) defaultSort])];
	

    
    if (stringOrPredicate)
    {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]])
        {
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate
											   arguments:variadicArguments];
            va_end(variadicArguments);
        }
        else
        {
            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
					  @"Second parameter passed to %s is of unexpected class %@",
					  sel_getName(_cmd), [stringOrPredicate className]);
            predicate = (NSPredicate *)stringOrPredicate;
        }
        [request setPredicate:predicate];
    }
	
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:[error description]];
    }
    
    return results;
}

@end
