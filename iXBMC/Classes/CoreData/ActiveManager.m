//
//  ActiveManager.m
//  Shopify_Mobile
//
//  Created by Matthew Newberry on 8/2/10.
//  Copyright 2010 Shopify. All rights reserved.
//

#import "ActiveManager.h"
#import "NSManagedObjectContext+Additions.h"

#define kRKManagedObjectContextKey @"RKManagedObjectContext"
#define OR_CORE_DATA_MIGRATION_NEED @"coreDataMigrationNeeded"

#define kStoreType      NSSQLiteStoreType
#define kStoreFilename  @"empty"

static ActiveManager *_shared = nil;

@implementation ActiveManager

@synthesize logLevel;
@synthesize connectedStoreName;
@synthesize defaultDateParser = _defaultDateParser;
@synthesize defaultNumberFormatter = _defaultNumberFormatter;
@synthesize entityDescriptions = _entityDescriptions;
@synthesize modelProperties = _modelProperties;
@synthesize modelRelationships = _modelRelationships;
@synthesize modelAttributes = _modelAttributes;
@synthesize requestQueue = _requestQueue;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (ActiveManager *) shared{
    	
	if(_shared == nil)
		_shared = [[ActiveManager alloc] init];
	
	return _shared;
}

- (id) init{
	self = [super init];
	if(self)
    {
        self.connectedStoreName = [NSString stringWithFormat:@"%@.sqlite", kStoreFilename];
		self.managedObjectModel = [self managedObjectModel];
		self.persistentStoreCoordinator = [self persistentStoreCoordinator];
		_managedObjectContext = [self managedObjectContext];
		
		_defaultDateParser = [[NSDateFormatter alloc] init];
		[_defaultDateParser setTimeZone:[NSTimeZone localTimeZone]];
        
        _defaultNumberFormatter = [[NSNumberFormatter alloc] init];
        
		self.entityDescriptions = [NSMutableDictionary dictionary];
        self.modelProperties = [NSMutableDictionary dictionary];
        self.modelRelationships = [NSMutableDictionary dictionary];
		
		self.logLevel = 2;
	}
	
	return self;
}



/*	Core Data		*/

- (void) managedObjectContextDidSave:(NSNotification *)notification{
            
	[self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
												withObject:notification
											 waitUntilDone:YES];
}

- (void)mergeChanges:(NSNotification *)notification {

	[self performSelectorOnMainThread:@selector(managedObjectContextDidSave:) withObject:notification waitUntilDone:YES];
}

- (NSManagedObjectContext*) newManagedObjectContext {
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    [moc setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    [moc setUndoManager:nil];
    [moc setMergePolicy:NSOverwriteMergePolicy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:moc];
    return moc;
}

- (NSManagedObjectContext*) managedObjectContext {
	
	if ([NSThread isMainThread]) 
    {
        if( _managedObjectContext == nil )
            _managedObjectContext = [self newManagedObjectContext];
		return _managedObjectContext;
		
	} else {
		
		NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
		NSManagedObjectContext *backgroundThreadContext = [threadDictionary objectForKey:kRKManagedObjectContextKey];
		
		if (!backgroundThreadContext) {
			
			backgroundThreadContext = [self newManagedObjectContext];					
			[threadDictionary setObject:backgroundThreadContext forKey:kRKManagedObjectContextKey];			
			[backgroundThreadContext release];
		}
		return backgroundThreadContext;
	}
}



- (NSManagedObjectModel*) managedObjectModel 
{
	if( _managedObjectModel != nil )
		return _managedObjectModel;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"iXBMC" ofType:@"momd"];
	
	if(!path)
		path = [[NSBundle mainBundle] pathForResource:@"iXBMC" ofType:@"mom"];
	
    NSURL *momURL = [NSURL fileURLWithPath:path];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
	
	if(!_managedObjectModel)
		_managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	
	return _managedObjectModel;
}



- (NSString*) storePath {
    return [[self applicationDocumentsDirectory]
            stringByAppendingPathComponent: connectedStoreName];
}


- (NSURL*) storeUrl {
	return [NSURL fileURLWithPath:[self storePath]];
}


- (NSDictionary*) migrationOptions {
	
    return [NSDictionary dictionaryWithObjectsAndKeys: 
            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
            [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
}

- (void)newPersistentStoreCoordinator: (NSString *) name
{
    self.connectedStoreName = [NSString stringWithFormat:@"%@.sqlite", name];
    if (_persistentStoreCoordinator != nil)
    {
        TT_RELEASE_SAFELY(_managedObjectContext);
        TT_RELEASE_SAFELY(_managedObjectModel);
        TT_RELEASE_SAFELY(_persistentStoreCoordinator);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"persistentStoreChanged" object:nil];
    }
}

- (void)deleteStore: (NSString *) name
{
    
    NSString* storePath = [[self applicationDocumentsDirectory]
                           stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.sqlite", name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:storePath error:NULL];
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator 
{
	if( _persistentStoreCoordinator != nil ) {
		return _persistentStoreCoordinator;
	}
	
	NSString* storePath = [self storePath];
	NSURL *storeUrl = [self storeUrl];
    
    NSError* error;
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								  initWithManagedObjectModel: self.managedObjectModel];
	
	NSDictionary* options = [self migrationOptions];
	
	// Check whether the store already exists or not.
	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL exists = [fileManager fileExistsAtPath:storePath];
	
	if(!exists ) {
		_modelCreated = YES;
	} else {
		if( _resetModel ||
		   [[NSUserDefaults standardUserDefaults] boolForKey:@"erase_all_preference"] ) {
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"erase_all_preference"];
			[fileManager removeItemAtPath:storePath error:nil];
			_modelCreated = YES;
		}
	}
    
    BOOL compatible = [self.managedObjectModel isConfiguration:nil compatibleWithStoreMetadata:[NSPersistentStoreCoordinator metadataForPersistentStoreOfType:kStoreType URL:storeUrl error:&error]];
    
    if(!compatible)
        [[NSNotificationCenter defaultCenter] postNotificationName:OR_CORE_DATA_MIGRATION_NEED object:nil];
	
	if (![_persistentStoreCoordinator
		  addPersistentStoreWithType: kStoreType
		  configuration: nil
		  URL: storeUrl
		  options: options
		  error: &error
		  ]) {
		// We couldn't add the persistent store, so let's wipe it out and try again.
		[fileManager removeItemAtPath:storePath error:nil];
		_modelCreated = YES;
		
		if (![_persistentStoreCoordinator
			  addPersistentStoreWithType: kStoreType
			  configuration: nil
			  URL: storeUrl
			  options: options
			  error: &error
			  ]) {
			// Something is terribly wrong here.
		}
	}
	
	return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (id)copyWithZone:(NSZone *)zone	{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

- (BOOL) save
{
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges]) 
        {
            return [_managedObjectContext save];
        }
    }
    return TRUE;
}

- (void)dealloc{
	[_requestQueue release];
	[_managedObjectContext release];
	[_managedObjectModel release];
	[_persistentStoreCoordinator release];

	[_defaultDateParser release];
    [_defaultNumberFormatter release];
	[_entityDescriptions release];
	[_modelProperties release];
	[_modelRelationships release];
	[_modelAttributes release];

	[super dealloc];
}


@end
