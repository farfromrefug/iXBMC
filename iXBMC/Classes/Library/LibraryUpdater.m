//
//  LibraryUpdater.m
//  iHaveNoName
//
//  Created by Martin Guillon on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActiveManager.h"
#import "LibraryUpdater.h"
#import "XBMCJSONCommunicator.h"
#import "XBMCStateListener.h"
#import "AppDelegate.h"
#import "Movie.h"
#import "TVShow.h"
#import "Season.h"
#import "Episode.h"
#import "Actor.h"
#import "ActorRole.h"

@implementation NSArray (movieKeyedDictionaryExtension)

- (NSDictionary *)movieKeyedDictionary
{
    NSUInteger arrayCount = [self count];
    id arrayObjects[arrayCount], objectKeys[arrayCount];
    
    [self getObjects:arrayObjects range:NSMakeRange(0UL, arrayCount)];
    for(NSUInteger index = 0UL; index < arrayCount; index++) 
    { 
        objectKeys[index] = [[self objectAtIndex:index] valueForKey:@"movieid"]; 
    }
    
    return([NSDictionary dictionaryWithObjects:arrayObjects forKeys:objectKeys count:arrayCount]);
}

- (NSDictionary *)tvShowKeyedDictionary
{
    NSUInteger arrayCount = [self count];
    id arrayObjects[arrayCount], objectKeys[arrayCount];
    
    [self getObjects:arrayObjects range:NSMakeRange(0UL, arrayCount)];
    for(NSUInteger index = 0UL; index < arrayCount; index++) 
    { 
        objectKeys[index] = [[self objectAtIndex:index] valueForKey:@"tvshowid"]; 
    }
    
    return([NSDictionary dictionaryWithObjects:arrayObjects forKeys:objectKeys count:arrayCount]);
}

- (NSDictionary *)seasonKeyedDictionary
{
    NSUInteger arrayCount = [self count];
    id arrayObjects[arrayCount], objectKeys[arrayCount];
    
    [self getObjects:arrayObjects range:NSMakeRange(0UL, arrayCount)];
    for(NSUInteger index = 0UL; index < arrayCount; index++) 
    { 
        objectKeys[index] = [[self objectAtIndex:index] valueForKey:@"season"]; 
    }
    
    return([NSDictionary dictionaryWithObjects:arrayObjects forKeys:objectKeys count:arrayCount]);
}

- (NSDictionary *)episodeKeyedDictionary
{
    NSUInteger arrayCount = [self count];
    id arrayObjects[arrayCount], objectKeys[arrayCount];
    
    [self getObjects:arrayObjects range:NSMakeRange(0UL, arrayCount)];
    for(NSUInteger index = 0UL; index < arrayCount; index++) 
    { 
        objectKeys[index] = [[self objectAtIndex:index] valueForKey:@"episode"]; 
    }
    
    return([NSDictionary dictionaryWithObjects:arrayObjects forKeys:objectKeys count:arrayCount]);
}

- (NSDictionary *)actorKeyedDictionary
{
    NSUInteger arrayCount = [self count];
    id arrayObjects[arrayCount], objectKeys[arrayCount];
    
    [self getObjects:arrayObjects range:NSMakeRange(0UL, arrayCount)];
    for(NSUInteger index = 0UL; index < arrayCount; index++) 
    { 
        objectKeys[index] = [[self objectAtIndex:index] valueForKey:@"name"]; 
    }
    
    return([NSDictionary dictionaryWithObjects:arrayObjects forKeys:objectKeys count:arrayCount]);
}

@end

@interface LibraryUpdater()
- (void)updateMoviesCoreData:(id)result clean:(BOOL)canDelete;
- (void)updateMoviesCoreData:(id)result;
- (void)updateMoviesCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete;
- (void)updateAllTVShowsCoreData:(id)result;
- (void)updateAllTVShowsCoreData:(id)result clean:(BOOL)canDelete;
- (void)updateAllTVShowsCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete;

- (void)updateTVShow:(NSInteger) tvshowid;
- (void)updateTVShowCoreData:(id)result;
- (void)updateTVShowCoreData:(id)result clean:(BOOL)canDelete;
- (void)updateTVShowCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete;


- (void)updateSeason:(NSInteger) tvshowid season:(NSInteger)seasonid;
- (void)updateSeasonCoreData:(id)result;
- (void)updateSeasonCoreData:(id)result clean:(BOOL)canDelete;
- (void)updateSeasonCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete;

@end

@implementation LibraryUpdater
static LibraryUpdater *sharedInstance = nil;
@synthesize recentlyAddedMovies = _recentlyAddedMovies;
@synthesize updating = _updating;

+ (LibraryUpdater *) sharedInstance {
	return ( sharedInstance ? sharedInstance : ( sharedInstance = [[self alloc] init] ) );
}

+ (BOOL) updating
{
    return sharedInstance.updating;
}

- (void)start
{
//    _moviesQueue = [NSOperationQueue new];
//    [_moviesQueue setMaxConcurrentOperationCount:1];
	_lettersCharSet = [[ NSCharacterSet letterCharacterSet ] retain];

	_queue = dispatch_queue_create("com.ixbmc.library", NULL);
	_valid = TRUE;
    _updating = false;
	_nbrunningUpdates = 0;
    [self updateLibrary];
    _updatingTimer = [NSTimer scheduledTimerWithTimeInterval: 600.0
                                                       target: self
                                                     selector: @selector(updateLibrary)
                                                     userInfo: nil repeats:TRUE];
}

- (void)oneUpdateStarted
{
	if (_nbrunningUpdates == 0)
	{
	    [[NSNotificationCenter defaultCenter] 
		 postNotificationName:@"updatingLibrary" 
		 object:nil];	
	}
	_nbrunningUpdates += 1;
//	NSLog(@"adding an update %d", _nbrunningUpdates);
}

- (void)oneUpdateFinished
{
	_nbrunningUpdates -= 1;
//	NSLog(@"removing an update %d", _nbrunningUpdates);
	if (_nbrunningUpdates == 0)
	{
	    [[NSNotificationCenter defaultCenter] 
		 postNotificationName:@"updatedLibrary" 
		 object:nil];	
	}
}

- (void)stop
{
	
	if (_updatingTimer != nil)
    {
        [_updatingTimer invalidate];
        _updatingTimer = nil;
    }
	_valid = FALSE;
	// wait for queue to empty
	dispatch_sync(_queue, ^{});
	dispatch_release(_queue);
	[_lettersCharSet release];

}

#pragma mark -
#pragma mark Movies

-(void)updateMoviesCoreData:(id)result clean:(BOOL)canDelete
{	
	dispatch_async(_queue, ^{
        [self updateMoviesCoreDataBackgroundThread:result clean:canDelete];});
}

-(void)updateMoviesCoreData:(id)result
{
    [self updateMoviesCoreData:result clean:YES];
}

- (void)updateMoviesCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete
{
//	NSLog(@"Movies update %@", result);
	NSManagedObjectContext *context = [[[NSManagedObjectContext alloc] init] autorelease];
    NSPersistentStoreCoordinator *coordinator = [[ActiveManager shared] persistentStoreCoordinator];
    [context setPersistentStoreCoordinator:coordinator];
    [context setUndoManager:nil];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![[result objectForKey:@"failure"] boolValue])
    {
        NSError *error = nil;
        NSArray* movies = [[result objectForKey:@"result"] objectForKey:@"movies"];
        
        NSDictionary *newMovies = [movies movieKeyedDictionary];
        

        NSFetchRequest *movieFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *movieEntity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context];
        [movieFetchRequest setEntity:movieEntity];
        NSArray *moviesArray = [context executeFetchRequest:movieFetchRequest error:&error];
        [movieFetchRequest release];
        if (error) 
        {
			[self oneUpdateFinished];
            NSLog(@"error during update: %@", [error localizedDescription]);
            [pool drain];
            return;
        }
        NSDictionary *oldMovies = [moviesArray movieKeyedDictionary];
        
        NSFetchRequest *actorFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *actorEntity = [NSEntityDescription entityForName:@"Actor" inManagedObjectContext:context];
        [actorFetchRequest setEntity:actorEntity];
        NSArray *actorArray = [context executeFetchRequest:actorFetchRequest error:&error];
        [actorFetchRequest release];

        NSDictionary *oldActors = [actorArray actorKeyedDictionary];       
        
        NSSet *existingItems = [NSSet setWithArray:[oldMovies allKeys]];
        NSSet *newItems = [NSSet setWithArray:[newMovies allKeys]];
        
        // Determine which items were added
        NSMutableSet *addedItems = [NSMutableSet setWithSet:newItems];
        [addedItems minusSet:existingItems];
        
        // Determine which items were added
        NSMutableSet *toUpdateItems = [NSMutableSet setWithSet:newItems];
        [toUpdateItems intersectSet:existingItems];       
        
        NSEnumerator *enumerator = [addedItems objectEnumerator];
        id anObject;
        
        NSLog(@"existing Items count %d", [existingItems count]);
        NSLog(@"adding Items count %d", [addedItems count]);
        
        anObject = [enumerator nextObject];
        while (anObject) 
        {
            id newMovie = [newMovies objectForKey:anObject];
            NSString* label = [newMovie valueForKey:@"label"];
            
            if (![label isEqualToString:@""])
            {
           
                Movie *movie;
                movie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
                    
                NSString* sortLabel = [[label stringByReplacingOccurrencesOfString:@"The " withString:@""]
                 stringByReplacingOccurrencesOfString:@"the " withString:@""];
                [movie setValue:label forKey:@"label"];
                [movie setValue:sortLabel forKey:@"sortLabel"];
                
                [NSCharacterSet alphanumericCharacterSet];
                if ([_lettersCharSet characterIsMember:[sortLabel characterAtIndex:0]]) {
                    [movie setValue:[[sortLabel substringToIndex:1] uppercaseString] forKey:@"firstLetter"];
                }
                else
                {
                    [movie setValue:@"#" forKey:@"firstLetter"];
                }

                [movie setValue:[newMovie valueForKey:@"director"] forKey:@"director"];
                [movie setValue:[newMovie valueForKey:@"runtime"] forKey:@"runtime"];
                [movie setValue:[newMovie valueForKey:@"writer"] forKey:@"writer"];
                [movie setValue:[newMovie valueForKey:@"studio"] forKey:@"studio"];
                [movie setValue:[NSNumber numberWithInt:[[newMovie valueForKey:@"movieid"] intValue]] forKey:@"movieid"];
                [movie setValue:[NSNumber numberWithFloat:[[newMovie valueForKey:@"rating"] floatValue]] forKey:@"rating"];
                [movie setValue:[newMovie valueForKey:@"plot"] forKey:@"plot"];
                [movie setValue:[newMovie valueForKey:@"tagline"] forKey:@"tagline"];
                [movie setValue:[newMovie valueForKey:@"genre"] forKey:@"genre"];
                [movie setValue:[newMovie valueForKey:@"fanart"] forKey:@"fanart"];
                [movie setValue:[newMovie valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                [movie setValue:[newMovie valueForKey:@"imdbnumber"] forKey:@"imdbid"];
                [movie setValue:[newMovie valueForKey:@"year"] forKey:@"year"];
                [movie setValue:[newMovie valueForKey:@"playcount"] forKey:@"playcount"];
                [movie setValue:[newMovie valueForKey:@"trailer"] forKey:@"trailer"];
                [movie setValue:[newMovie valueForKey:@"file"] forKey:@"file"];
                
                if ([newMovie objectForKey:@"cast"] && [[newMovie objectForKey:@"cast"] isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary* role in [newMovie objectForKey:@"cast"])
                    {
                        NSString *actorName = [role valueForKey:@"name"];
                        NSString *actorRole = [role valueForKey:@"role"];
                        Actor *actor;
                        
                        if ([oldActors objectForKey:actorName] != nil) {
                            actor = [oldActors objectForKey:actorName];
                        }
                        else
                        {
                            actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:context];
                            [actor setValue:actorName forKey:@"name"];
                        }
                        ActorRole *newRole = [NSEntityDescription insertNewObjectForEntityForName:@"ActorRole" inManagedObjectContext:context];;
                        newRole.role = actorRole;
                        newRole.actorName = actorName;
						newRole.RoleToActor = actor;
                        [actor addActorToRoleObject:newRole];
                        [movie addMovieToRoleObject:newRole];
                    }
                }

            }
            anObject = [enumerator nextObject];
        }
        
        enumerator = [toUpdateItems objectEnumerator];
        
        anObject = [enumerator nextObject];
        while (anObject) 
        {
            id newMovie = [newMovies objectForKey:anObject];
//            NSLog(@"movie %@", newMovie);
            NSManagedObject *oldMovie = [oldMovies objectForKey:anObject];

            if (![[newMovie valueForKey:@"playcount"] isEqual: [oldMovie valueForKey:@"playcount"]])
            {
                [oldMovie setValue:[newMovie valueForKey:@"playcount"] forKey:@"playcount"];
            }
   
            anObject = [enumerator nextObject];
        }
        
        if (canDelete)
        {
            // Determine which items were removed
            NSMutableSet *removedItems = [NSMutableSet setWithSet:existingItems];
            [removedItems minusSet:newItems];
            enumerator = [removedItems objectEnumerator];
            
            anObject = [enumerator nextObject];
            while (anObject) 
            {
                [context deleteObject:[oldMovies objectForKey:anObject]];
                
                anObject = [enumerator nextObject];
            }
        }
        
//        if ([currentStore isEqual:[[coordinator persistentStores] objectAtIndex:0]])
        {
			[[[ActiveManager shared] persistentStoreCoordinator] lock];
			[context save:&error];
            if(error) {
                // handle error
            }
//            else
//            {
//    //        [fetchRequest release];
//                [[NSNotificationCenter defaultCenter] 
//                 postNotificationName:@"ContextDidSave" 
//                 object:context];
//            }
			[[[ActiveManager shared] persistentStoreCoordinator] unlock];
        }
    }
    [pool drain];
	[self oneUpdateFinished];
}

- (void)gotRecentlyAddedMovies:(id)result
{
    if (![[result objectForKey:@"failure"] boolValue])
    {
        TT_RELEASE_SAFELY(_recentlyAddedMovies);
        
        [self updateMoviesCoreData:result clean:NO];
        
        if ([[result objectForKey:@"result"] objectForKey:@"movies"] != nil)
        {
            NSMutableArray* movies = [[NSMutableArray alloc] init];
            for (NSDictionary* movie in [[result objectForKey:@"result"] objectForKey:@"movies"])
            {
                //NSDictionary* movie = [result objectForKey:@"movies"];
                [movies addObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:[[movie valueForKey:@"movieid"] intValue]], @"id"
                                    ,[movie objectForKey:@"label"], @"label"
                                    ,[movie objectForKey:@"thumbnail"], @"thumbnail"
                                    ,[movie objectForKey:@"fanart"], @"fanart"
                                    ,[movie objectForKey:@"trailer"], @"trailer"
                                    ,[movie objectForKey:@"imdbnumber"], @"imdb"
                                    ,[movie objectForKey:@"playcount"], @"playcount"
                                    ,[movie objectForKey:@"file"], @"file"
                                    , nil] autorelease]];
            }
            _recentlyAddedMovies = [movies retain];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"recentlyAddedMovies"  object:nil];
        }
    }
}

- (void) updateRecentlyAddedMovies:(NSInteger) number
{
    if (![XBMCStateListener connected]) return;
	[self oneUpdateStarted];

    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSArray arrayWithObjects:@"plot", @"director", @"writer"
                                            , @"studio", @"genre", @"year", @"runtime", @"rating"
                                            , @"tagline", @"imdbnumber",@"trailer",
                                            @"lastplayed",@"thumbnail",@"fanart",
                                            @"playcount", @"file", nil]
                                           , @"fields", nil];
    if (number > 0)
    {
        [requestParams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
												  [NSDictionary dictionaryWithObjectsAndKeys:
													[NSNumber numberWithInt:0], @"start", 
												   [NSNumber numberWithInt:number], @"end", nil]
												  , @"limits", nil]];
    }
    
    [requestParams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
											  [NSDictionary dictionaryWithObjectsAndKeys:
												@"none", @"method", nil]
											  , @"sort", nil]];
    
    NSDictionary *request = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              @"VideoLibrary.GetRecentlyAddedMovies", @"cmd", requestParams, @"params",nil] autorelease];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotRecentlyAddedMovies:)];    
}

- (void) updateMovies:(NSInteger) number
{
    if (![XBMCStateListener connected]) return;
	[self oneUpdateStarted];

    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										   [NSArray arrayWithObjects:@"title", @"sorttitle"
											, @"plot", @"director", @"writer"
											, @"studio", @"genre", @"year", @"runtime", @"rating"
											, @"tagline", @"imdbnumber",@"trailer",
											@"lastplayed",@"thumbnail",@"fanart",
											@"playcount", @"file"
											, @"streamDetails", @"cast", nil]
										   , @"fields", nil];
    if (number > 0)
    {
        [requestParams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
												  [NSDictionary dictionaryWithObjectsAndKeys:
													[NSNumber numberWithInt:0], @"start", 
												   [NSNumber numberWithInt:number], @"end", nil]
												  , @"limits", nil]];
    }
    
    [requestParams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
											  [NSDictionary dictionaryWithObjectsAndKeys:
												@"date", @"method", nil]
											  , @"sort", nil]];
	
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"VideoLibrary.GetMovies", @"cmd", requestParams, @"params",nil];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(updateMoviesCoreData:)];    
}

- (void) updateRecentlyAddedMovies
{
    [self updateRecentlyAddedMovies:0];
}


#pragma mark -
#pragma mark AllTVShows

- (void)updateAllTVShowsCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete

{
	//	NSLog(@"AllTVShows update %@", result);
	NSManagedObjectContext *context = [[[NSManagedObjectContext alloc] init] autorelease];
    NSPersistentStoreCoordinator *coordinator = [[ActiveManager shared] persistentStoreCoordinator];
    [context setPersistentStoreCoordinator:coordinator];
    [context setUndoManager:nil];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![[result objectForKey:@"failure"] boolValue])
    {
        NSError *error = nil;
        NSArray* shows = [[result objectForKey:@"result"] objectForKey:@"tvshows"];
        
        NSDictionary *newshows = [shows tvShowKeyedDictionary];
        
		
        NSFetchRequest *showFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *showEntity = [NSEntityDescription entityForName:@"TVShow" inManagedObjectContext:context];
        [showFetchRequest setEntity:showEntity];
        NSArray *showsArray = [context executeFetchRequest:showFetchRequest error:&error];
        [showFetchRequest release];
        if (error) 
        {
			[self oneUpdateFinished];
            NSLog(@"error during update: %@", [error localizedDescription]);
            [pool drain];
            return;
        }
        NSDictionary *oldshows = [showsArray tvShowKeyedDictionary];
        
//        NSFetchRequest *actorFetchRequest = [[NSFetchRequest alloc] init];
//        NSEntityDescription *actorEntity = [NSEntityDescription entityForName:@"Actor" inManagedObjectContext:context];
//        [actorFetchRequest setEntity:actorEntity];
//        NSArray *actorArray = [context executeFetchRequest:actorFetchRequest error:&error];
//        [actorFetchRequest release];
//		
//        NSDictionary *oldActors = [actorArray actorKeyedDictionary];       
        
        NSSet *existingItems = [NSSet setWithArray:[oldshows allKeys]];
        NSSet *newItems = [NSSet setWithArray:[newshows allKeys]];
        
        // Determine which items were added
        NSMutableSet *addedItems = [NSMutableSet setWithSet:newItems];
        [addedItems minusSet:existingItems];
        
        // Determine which items were added
        NSMutableSet *toUpdateItems = [NSMutableSet setWithSet:newItems];
        [toUpdateItems intersectSet:existingItems];       
        
        NSEnumerator *enumerator = [addedItems objectEnumerator];
        id anObject;
        
        NSLog(@"existing shows count %d", [existingItems count]);
        NSLog(@"adding shows count %d", [addedItems count]);
        
        anObject = [enumerator nextObject];
        while (anObject) 
        {
            id newshow = [newshows objectForKey:anObject];
            NSString* label = [newshow valueForKey:@"label"];
            
            if (![label isEqualToString:@""])
            {
				
                TVShow *show;
                show = [NSEntityDescription insertNewObjectForEntityForName:@"TVShow" inManagedObjectContext:context];
				
                NSString* sortLabel = [[label stringByReplacingOccurrencesOfString:@"The " withString:@""]
									   stringByReplacingOccurrencesOfString:@"the " withString:@""];
                [show setValue:label forKey:@"label"];
                [show setValue:sortLabel forKey:@"sortLabel"];
                
                [NSCharacterSet alphanumericCharacterSet];
                if ([_lettersCharSet characterIsMember:[sortLabel characterAtIndex:0]]) {
                    [show setValue:[[sortLabel substringToIndex:1] uppercaseString] forKey:@"firstLetter"];
                }
                else
                {
                    [show setValue:@"#" forKey:@"firstLetter"];
                }
				
                [show setValue:[newshow valueForKey:@"premiered"] forKey:@"premiered"];
                [show setValue:[newshow valueForKey:@"studio"] forKey:@"studio"];
                [show setValue:[NSNumber numberWithInt:[[newshow valueForKey:@"tvshowid"] intValue]] forKey:@"tvshowid"];
                [show setValue:[NSNumber numberWithFloat:[[newshow valueForKey:@"rating"] floatValue]] forKey:@"rating"];
                [show setValue:[NSNumber numberWithInt:[[newshow valueForKey:@"episode"] intValue]] forKey:@"nbepisodes"];
                [show setValue:[newshow valueForKey:@"plot"] forKey:@"plot"];
                [show setValue:[newshow valueForKey:@"genre"] forKey:@"genre"];
                [show setValue:[newshow valueForKey:@"fanart"] forKey:@"fanart"];
                [show setValue:[newshow valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                [show setValue:[newshow valueForKey:@"imdbnumber"] forKey:@"imdbid"];
                [show setValue:[newshow valueForKey:@"episode"] forKey:@"nbepisodes"];
                [show setValue:[newshow valueForKey:@"playcount"] forKey:@"playcount"];
                
//                if ([newshow objectForKey:@"cast"] && [[newshow objectForKey:@"cast"] isKindOfClass:[NSArray class]])
//                {
//                    for (NSDictionary* role in [newshow objectForKey:@"cast"])
//                    {
//                        NSString *actorName = [role valueForKey:@"name"];
//                        NSString *actorRole = [role valueForKey:@"role"];
//                        Actor *actor;
//                        
//                        if ([oldActors objectForKey:actorName] != nil) {
//                            actor = [oldActors objectForKey:actorName];
//                        }
//                        else
//                        {
//                            actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:context];
//                            [actor setValue:actorName forKey:@"name"];
//                        }
//                        ActorRole *newRole = [NSEntityDescription insertNewObjectForEntityForName:@"ActorRole" inManagedObjectContext:context];;
//                        newRole.role = actorRole;
//                        [actor addActorToRoleObject:newRole];
//                        [show addTVShowToRoleObject:newRole];
//                    }
//                }
				
            }
            anObject = [enumerator nextObject];
        }
		
		enumerator = [toUpdateItems objectEnumerator];
        
        anObject = [enumerator nextObject];
        while (anObject) 
        {
            id newshow = [newshows objectForKey:anObject];
			//            NSLog(@"season %@", newseason);
            NSManagedObject *oldseason = [oldshows objectForKey:anObject];
			
            if (![[newshow valueForKey:@"playcount"] isEqual: [oldseason valueForKey:@"playcount"]])
            {
                [oldseason setValue:[newshow valueForKey:@"playcount"] forKey:@"playcount"];
            }
			if (![[newshow valueForKey:@"episode"] isEqual: [oldseason valueForKey:@"nbepisodes"]])
            {
                [oldseason setValue:[newshow valueForKey:@"episode"] forKey:@"nbepisodes"];
            }
			
            anObject = [enumerator nextObject];
        }
        
        if (canDelete)
        {
            // Determine which items were removed
            NSMutableSet *removedItems = [NSMutableSet setWithSet:existingItems];
            [removedItems minusSet:newItems];
            enumerator = [removedItems objectEnumerator];
            
            anObject = [enumerator nextObject];
            while (anObject) 
            {
                [context deleteObject:[oldshows objectForKey:anObject]];
                
                anObject = [enumerator nextObject];
            }
        }
		
		[[[ActiveManager shared] persistentStoreCoordinator] lock];
		[context save:&error];
		if(error) {
			// handle error
		}
		[[[ActiveManager shared] persistentStoreCoordinator] unlock];
		for (NSDictionary* show in shows)
		{
			dispatch_sync(dispatch_get_main_queue(), ^{
			[self updateTVShow:[[show valueForKey:@"tvshowid"] intValue]];
			});
		}
    }
    [pool drain];
	[self oneUpdateFinished];
}

-(void)updateAllTVShowsCoreData:(id)result clean:(BOOL)canDelete
{	
	dispatch_async(_queue, ^{
        [self updateAllTVShowsCoreDataBackgroundThread:result clean:canDelete];});
}

-(void)updateAllTVShowsCoreData:(id)result
{
    [self updateAllTVShowsCoreData:result clean:YES];
}

- (void) updateAllTVShows:(NSInteger) number
{
	if (![XBMCStateListener connected]) return;
	[self oneUpdateStarted];
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										  [NSArray arrayWithObjects:@"title", @"originaltitle"
										   , @"plot", @"cast", @"episode", @"premiered",@"votes", @"file"
										   , @"studio", @"genre", @"rating", @"imdbnumber", @"fanart", @"thumbnail", nil]
										  , @"fields", nil];
    if (number > 0)
    {
        [requestParams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
												 [NSDictionary dictionaryWithObjectsAndKeys:
												  [NSNumber numberWithInt:0], @"start", 
												  [NSNumber numberWithInt:number], @"end", nil]
												 , @"limits", nil]];
    }
    
    [requestParams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
											 [NSDictionary dictionaryWithObjectsAndKeys:
											  @"date", @"method", nil]
											 , @"sort", nil]];
	
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"VideoLibrary.GetTVShows", @"cmd", requestParams, @"params",nil];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(updateAllTVShowsCoreData:)]; 
}

#pragma mark -
#pragma mark TVShow

- (void)updateTVShowCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete

{
//	NSLog(@"Seasons update %@", result);
//	[self oneUpdateFinished];
//	return;
	NSManagedObjectContext *context = [[[NSManagedObjectContext alloc] init] autorelease];
    NSPersistentStoreCoordinator *coordinator = [[ActiveManager shared] persistentStoreCoordinator];
    [context setPersistentStoreCoordinator:coordinator];
    [context setUndoManager:nil];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![[result objectForKey:@"failure"] boolValue])
    {
        NSError *error = nil;
        NSArray* seasons = [[result objectForKey:@"result"] objectForKey:@"seasons"];
        
        NSDictionary *newseasons = [seasons seasonKeyedDictionary];
        
		
        NSFetchRequest *seasonFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *seasonEntity = [NSEntityDescription entityForName:@"Season" inManagedObjectContext:context];
        [seasonFetchRequest setPredicate:[NSPredicate 
										predicateWithFormat:@"tvshowid == %@"
										,[result objectForKey:@"info"]]];
		[seasonFetchRequest setEntity:seasonEntity];
        NSArray *seasonsArray = [context executeFetchRequest:seasonFetchRequest error:&error];
        [seasonFetchRequest release];
        if (error) 
        {
			[self oneUpdateFinished];
            NSLog(@"error during update: %@", [error localizedDescription]);
            [pool drain];
            return;
        }
        NSDictionary *oldseasons = [seasonsArray seasonKeyedDictionary];      
        
        NSSet *existingItems = [NSSet setWithArray:[oldseasons allKeys]];
        NSSet *newItems = [NSSet setWithArray:[newseasons allKeys]];
        
        // Determine which items were added
        NSMutableSet *addedItems = [NSMutableSet setWithSet:newItems];
        [addedItems minusSet:existingItems];
        
        // Determine which items were added
        NSMutableSet *toUpdateItems = [NSMutableSet setWithSet:newItems];
        [toUpdateItems intersectSet:existingItems];       
        
        NSEnumerator *enumerator = [addedItems objectEnumerator];
        id anObject;
        
        anObject = [enumerator nextObject];
        while (anObject) 
        {
            id newseason = [newseasons objectForKey:anObject];
            NSString* label = [newseason valueForKey:@"label"];
            
            if (![label isEqualToString:@""])
            {
                Season *season;
                season = [NSEntityDescription insertNewObjectForEntityForName:@"Season" inManagedObjectContext:context];
				
                [season setValue:label forKey:@"label"];
				
                [season setValue:[result objectForKey:@"info"] forKey:@"tvshowid"];
                [season setValue:[NSNumber numberWithInt:[[newseason valueForKey:@"season"] intValue]] forKey:@"season"];
                [season setValue:[NSNumber numberWithInt:[[newseason valueForKey:@"playcount"] intValue]] forKey:@"playcount"];
                [season setValue:[NSNumber numberWithInt:[[newseason valueForKey:@"episode"] intValue]] forKey:@"nbepisodes"];
                [season setValue:[newseason valueForKey:@"season"] forKey:@"season"];
                [season setValue:[newseason valueForKey:@"fanart"] forKey:@"fanart"];
                [season setValue:[newseason valueForKey:@"thumbnail"] forKey:@"thumbnail"];
				
				NSArray *array = [context fetchObjectsForEntityName:@"TVShow" withPredicate:
								  [NSPredicate predicateWithFormat:@"tvshowid == %@", [result objectForKey:@"info"]]];
				
				if (array == nil || [array count] ==0) {
					[self oneUpdateFinished];
					NSLog(@"Could not find tvshow %@ dealing with season %@"
						  , [result objectForKey:@"info"], [newseason valueForKey:@"season"]);
					[pool drain];
					return;
				}
				TVShow* show = (TVShow*)[array objectAtIndex:0];
				[show addTVShowToSeasonObject:season];
				[season setValue:show forKey:@"SeasonToTVShow"];
            }
            anObject = [enumerator nextObject];
        }
        
        enumerator = [toUpdateItems objectEnumerator];
        
        anObject = [enumerator nextObject];
        while (anObject) 
        {
            id newseason = [newseasons objectForKey:anObject];
			//            NSLog(@"season %@", newseason);
            NSManagedObject *oldseason = [oldseasons objectForKey:anObject];
			
            if (![[newseason valueForKey:@"playcount"] isEqual: [oldseason valueForKey:@"playcount"]])
            {
                [oldseason setValue:[newseason valueForKey:@"playcount"] forKey:@"playcount"];
            }
			if (![[newseason valueForKey:@"episode"] isEqual: [oldseason valueForKey:@"nbepisodes"]])
            {
                [oldseason setValue:[newseason valueForKey:@"episode"] forKey:@"nbepisodes"];
            }
			
            anObject = [enumerator nextObject];
        }
        
        if (canDelete)
        {
            // Determine which items were removed
            NSMutableSet *removedItems = [NSMutableSet setWithSet:existingItems];
            [removedItems minusSet:newItems];
            enumerator = [removedItems objectEnumerator];
            
            anObject = [enumerator nextObject];
            while (anObject) 
            {
                [context deleteObject:[oldseasons objectForKey:anObject]];
                
                anObject = [enumerator nextObject];
            }
        }
		[[[ActiveManager shared] persistentStoreCoordinator] lock];
		[context save:&error];
		if(error) {
			// handle error
		}
		[[[ActiveManager shared] persistentStoreCoordinator] unlock];
		for (NSDictionary* season in seasons)
		{
			dispatch_sync(dispatch_get_main_queue(), ^{ 
				[self updateSeason:[[result objectForKey:@"info"] intValue]
				  season:[[season valueForKey:@"season"] intValue]];
			});
		}
    }
    [pool drain];
	[self oneUpdateFinished];
}

-(void)updateTVShowCoreData:(id)result clean:(BOOL)canDelete
{	
	dispatch_async(_queue, ^{
        [self updateTVShowCoreDataBackgroundThread:result clean:canDelete];});
}

-(void)updateTVShowCoreData:(id)result
{
//	NSLog(@"updateTVShowCoreData: %@", result);
    [self updateTVShowCoreData:result clean:YES];
}

- (void) updateTVShow:(NSInteger) tvshowid
{
	if (![XBMCStateListener connected]) return;
	[self oneUpdateStarted];
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
										  [NSArray arrayWithObjects:@"season", @"showtitle"
										   , @"episode", @"playcount", @"fanart", @"thumbnail", nil]
										  , @"fields"
								   , [NSNumber numberWithInt:tvshowid],@"tvshowid"
										  ,[NSDictionary dictionaryWithObjectsAndKeys:
										   @"date", @"method", nil]
										  , @"sort", nil];
	
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"VideoLibrary.GetSeasons", @"cmd", requestParams, @"params"
							 ,[NSNumber numberWithInt:tvshowid], @"info",nil];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(updateTVShowCoreData:)]; 
}

#pragma mark -
#pragma mark Season

- (void)updateSeasonCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete

{
//	NSLog(@"Season update %@", result);
//	[self oneUpdateFinished];
//	return;
	NSManagedObjectContext *context = [[[NSManagedObjectContext alloc] init] autorelease];
    NSPersistentStoreCoordinator *coordinator = [[ActiveManager shared] persistentStoreCoordinator];
    [context setPersistentStoreCoordinator:coordinator];
    [context setUndoManager:nil];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (![[result objectForKey:@"failure"] boolValue])
    {
        NSError *error = nil;
        NSArray* episodes = [[result objectForKey:@"result"] objectForKey:@"episodes"];
        
        NSDictionary *newepisodes = [episodes episodeKeyedDictionary];
        
		
        NSFetchRequest *episodeFetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *episodeEntity = [NSEntityDescription entityForName:@"Episode" inManagedObjectContext:context];
        [episodeFetchRequest setPredicate:[NSPredicate 
										  predicateWithFormat:@"(tvshowid == %@) AND (season == %@)"
										  ,[[result objectForKey:@"info"] objectForKey:@"tvshowid"]
										   ,[[result objectForKey:@"info"] objectForKey:@"season"]]];
		[episodeFetchRequest setEntity:episodeEntity];
        NSArray *episodesArray = [context executeFetchRequest:episodeFetchRequest error:&error];
        [episodeFetchRequest release];
        if (error) 
        {
			[self oneUpdateFinished];
            NSLog(@"error during update: %@", [error localizedDescription]);
            [pool drain];
            return;
        }
        NSDictionary *oldepisodes = [episodesArray episodeKeyedDictionary];      
        
//        NSFetchRequest *actorFetchRequest = [[NSFetchRequest alloc] init];
//        NSEntityDescription *actorEntity = [NSEntityDescription entityForName:@"Actor" inManagedObjectContext:context];
//        [actorFetchRequest setEntity:actorEntity];
//        NSArray *actorArray = [context executeFetchRequest:actorFetchRequest error:&error];
//        [actorFetchRequest release];
//		
//        NSDictionary *oldActors = [actorArray actorKeyedDictionary];       

        NSSet *existingItems = [NSSet setWithArray:[oldepisodes allKeys]];
        NSSet *newItems = [NSSet setWithArray:[newepisodes allKeys]];
        
        // Determine which items were added
        NSMutableSet *addedItems = [NSMutableSet setWithSet:newItems];
        [addedItems minusSet:existingItems];
        
        // Determine which items were added
        NSMutableSet *toUpdateItems = [NSMutableSet setWithSet:newItems];
        [toUpdateItems intersectSet:existingItems];       
        
        NSEnumerator *enumerator = [addedItems objectEnumerator];
        id anObject;
        
        anObject = [enumerator nextObject];
        while (anObject) 
        {
            id newepisode = [newepisodes objectForKey:anObject];
            NSString* label = [newepisode valueForKey:@"label"];
            
            if (![label isEqualToString:@""])
            {
                Episode *episode;
                episode = [NSEntityDescription insertNewObjectForEntityForName:@"Episode" inManagedObjectContext:context];
				
                [episode setValue:label forKey:@"label"];
				
				[episode setValue:[[result objectForKey:@"info"] objectForKey:@"tvshowid"] forKey:@"tvshowid"];
				[episode setValue:[NSNumber numberWithInt:[[newepisode valueForKey:@"season"] intValue]] forKey:@"season"];
                [episode setValue:[NSNumber numberWithInt:[[newepisode valueForKey:@"episodeid"] intValue]] forKey:@"episodeid"];
                [episode setValue:[NSNumber numberWithInt:[[newepisode valueForKey:@"episode"] intValue]] forKey:@"episode"];

				
                [episode setValue:[newepisode valueForKey:@"director"] forKey:@"director"];
                [episode setValue:[newepisode valueForKey:@"runtime"] forKey:@"runtime"];
                [episode setValue:[newepisode valueForKey:@"writer"] forKey:@"writer"];
                [episode setValue:[newepisode valueForKey:@"firstaired"] forKey:@"firstaired"];
                [episode setValue:[NSNumber numberWithFloat:[[newepisode valueForKey:@"rating"] floatValue]] forKey:@"rating"];
                [episode setValue:[newepisode valueForKey:@"plot"] forKey:@"plot"];
                [episode setValue:[newepisode valueForKey:@"showtitle"] forKey:@"showtitle"];
                [episode setValue:[newepisode valueForKey:@"fanart"] forKey:@"fanart"];
                [episode setValue:[newepisode valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                [episode setValue:[newepisode valueForKey:@"playcount"] forKey:@"playcount"];
                [episode setValue:[newepisode valueForKey:@"file"] forKey:@"file"];
                
//                if ([newepisode objectForKey:@"cast"] && [[newepisode objectForKey:@"cast"] isKindOfClass:[NSArray class]])
//                {
//                    for (NSDictionary* role in [newepisode objectForKey:@"cast"])
//                    {
//                        NSString *actorName = [role valueForKey:@"name"];
//                        NSString *actorRole = [role valueForKey:@"role"];
//                        Actor *actor;
//                        
//                        if ([oldActors objectForKey:actorName] != nil) {
//                            actor = [oldActors objectForKey:actorName];
//                        }
//                        else
//                        {
//                            actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:context];
//                            [actor setValue:actorName forKey:@"name"];
//                        }
//						NSArray *array = [context fetchObjectsForEntityName:@"ActorRole" withPredicate:
//										  [NSPredicate predicateWithFormat:@"tvshowid == %@", [result objectForKey:@"info"]]];
//						if (array == nil || [array count] ==0) {
//							[self oneUpdateFinished];
//							NSLog(@"Could not find tvshow %@ dealing with episode %@"
//								  , [result objectForKey:@"info"], [newepisode valueForKey:@"episode"]);
//							[pool drain];
//							return;
//						}
//                        ActorRole *newRole = [NSEntityDescription insertNewObjectForEntityForName:@"ActorRole" inManagedObjectContext:context];;
//                        newRole.role = actorRole;
//                        [actor addActorToRoleObject:newRole];
//						[newRole setValue:episode forKey:@"name"];
//                        [episode add:newRole];
//                    }
//                }
				
				NSArray *array = [context fetchObjectsForEntityName:@"Season" withPredicate:
								  [NSPredicate 
								   predicateWithFormat:@"(tvshowid == %@) AND (season == %@)"
								   ,[[result objectForKey:@"info"] objectForKey:@"tvshowid"]
								   ,[[result objectForKey:@"info"] objectForKey:@"season"]]];
				
				if (array == nil || [array count] ==0) {
					[self oneUpdateFinished];
					NSLog(@"Could not find tvshow %@ dealing with episode %@"
						  , [result objectForKey:@"info"], [newepisode valueForKey:@"episode"]);
					[pool drain];
					return;
				}
				Season* season = (Season*)[array objectAtIndex:0];
				[season addSeasonToEpisodeObject:episode];
				[season.SeasonToTVShow addTVShowToEpisodeObject:episode];
				episode.EpisodeToTVShow = season.SeasonToTVShow;
				episode.EpisodeToSeason = season;
            }
            anObject = [enumerator nextObject];
        }
        
        enumerator = [toUpdateItems objectEnumerator];
        
        anObject = [enumerator nextObject];
        while (anObject) 
        {
            id newepisode = [newepisodes objectForKey:anObject];
			//            NSLog(@"episode %@", newepisode);
            NSManagedObject *oldepisode = [oldepisodes objectForKey:anObject];
			
            if (![[newepisode valueForKey:@"playcount"] isEqual: [oldepisode valueForKey:@"playcount"]])
            {
                [oldepisode setValue:[newepisode valueForKey:@"playcount"] forKey:@"playcount"];
            }
			if (![[newepisode valueForKey:@"episode"] isEqual: [oldepisode valueForKey:@"nbepisodes"]])
            {
                [oldepisode setValue:[newepisode valueForKey:@"episode"] forKey:@"nbepisodes"];
            }
			
            anObject = [enumerator nextObject];
        }
        
        if (canDelete)
        {
            // Determine which items were removed
            NSMutableSet *removedItems = [NSMutableSet setWithSet:existingItems];
            [removedItems minusSet:newItems];
            enumerator = [removedItems objectEnumerator];
            
            anObject = [enumerator nextObject];
            while (anObject) 
            {
                [context deleteObject:[oldepisodes objectForKey:anObject]];
                
                anObject = [enumerator nextObject];
            }
        }
		[[[ActiveManager shared] persistentStoreCoordinator] lock];
		[context save:&error];
		if(error) {
			// handle error
		}
		[[[ActiveManager shared] persistentStoreCoordinator] unlock];
    }
    [pool drain];
	[self oneUpdateFinished];
}

-(void)updateSeasonCoreData:(id)result clean:(BOOL)canDelete
{	
	dispatch_async(_queue, ^{
        [self updateSeasonCoreDataBackgroundThread:result clean:canDelete];});
}

-(void)updateSeasonCoreData:(id)result
{
	//	NSLog(@"updateTVShowCoreData: %@", result);
    [self updateSeasonCoreData:result clean:YES];
}

- (void) updateSeason:(NSInteger) tvshowid season:(NSInteger)seasonid
{
	if (![XBMCStateListener connected]) return;
	[self oneUpdateStarted];
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
								   [NSArray arrayWithObjects:@"season", @"showtitle"
									, @"episode", @"playcount",@"streamDetails"
									,@"firstaired",@"runtime",@"director",@"file"
									,@"writer",@"rating",@"cast", @"fanart", @"thumbnail", nil]
								   , @"fields"
								   , [NSNumber numberWithInt:tvshowid],@"tvshowid"
								   , [NSNumber numberWithInt:seasonid],@"season"
								   ,[NSDictionary dictionaryWithObjectsAndKeys:
									 @"date", @"method", nil]
								   , @"sort", nil];
	
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"VideoLibrary.GetEpisodes", @"cmd", requestParams, @"params"
							 ,[NSDictionary dictionaryWithObjectsAndKeys:
							   [NSNumber numberWithInt:tvshowid], @"tvshowid"
							   ,[NSNumber numberWithInt:seasonid], @"season", nil], @"info",nil];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(updateSeasonCoreData:)]; 
}


- (void) updateLibrary
{
    [self updateLibrary:0];
}

- (void) updateLibrary:(NSInteger) number
{
    [self updateMovies:0];
    
    [self updateAllTVShows:0];
}

- (void)dealloc {

    TT_RELEASE_SAFELY(_recentlyAddedMovies);
	[self stop];
	// wait for queue to empty
	dispatch_sync(_queue, ^{});
    [super dealloc];
}

@end
