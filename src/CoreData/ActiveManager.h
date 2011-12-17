//
//  ActiveManager.h
//  Shopify_Mobile
//
//  Created by Matthew Newberry on 8/2/10.
//  Copyright 2010 Shopify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveSupport.h"
#import "NSManagedObjectContext+Additions.h"

@interface ActiveManager : NSObject {
	
	NSOperationQueue *_requestQueue;
	
	NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectModel *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
			
	BOOL _modelCreated;
	BOOL _resetModel;
	
	NSDateFormatter *_defaultDateParser;
    NSNumberFormatter *_defaultNumberFormatter;
    
    NSMutableDictionary *_entityDescriptions;
    NSMutableDictionary *_modelProperties;
    NSMutableDictionary *_modelRelationships;
    NSMutableDictionary *_modelAttributes;
	
	int logLevel;
    NSString* connectedStoreName;
}

@property (nonatomic, retain) NSString* connectedStoreName;
@property (nonatomic, assign) int logLevel;
@property (nonatomic, retain) NSDateFormatter *defaultDateParser;
@property (nonatomic, retain) NSNumberFormatter *defaultNumberFormatter;
@property (nonatomic, retain) NSMutableDictionary *entityDescriptions;
@property (nonatomic, retain) NSMutableDictionary *modelProperties;
@property (nonatomic, retain) NSMutableDictionary *modelRelationships;
@property (nonatomic, retain) NSMutableDictionary *modelAttributes;
@property (nonatomic, retain) NSOperationQueue *requestQueue;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (ActiveManager *) shared;

- (NSManagedObjectContext *) newManagedObjectContext;
- (NSManagedObjectContext *) managedObjectContext;
- (NSManagedObjectModel *) managedObjectModel;
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator;
- (void)newPersistentStoreCoordinator: (NSString *) name;
- (void)deleteStore: (NSString *) name;
- (NSString *) applicationDocumentsDirectory;
- (BOOL) save;

@end
