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
- (void)updateTVShowsCoreData:(id)result;
- (void)updateAndCleanMoviesCoreDataBackgroundThread:(id)result;
- (void)updateNoCleanMoviesCoreDataBackgroundThread:(id)result;
- (void)updateMoviesCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete;

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
    _moviesQueue = [NSOperationQueue new];
    [_moviesQueue setMaxConcurrentOperationCount:1];
    _updating = false;
    [self updateLibrary];
    _updatingTimer = [NSTimer scheduledTimerWithTimeInterval: 600.0
                                                       target: self
                                                     selector: @selector(updateRecentlyAdded)
                                                     userInfo: nil repeats:TRUE];
}

- (void)stop
{
    [_moviesQueue release];
	if (_updatingTimer != nil)
    {
        [_updatingTimer invalidate];
        _updatingTimer = nil;
    }
}

-(void)updateMoviesCoreData:(id)result clean:(BOOL)canDelete
{
    SEL sel = @selector(updateNoCleanMoviesCoreDataBackgroundThread:);
    if (canDelete)
    {
        sel = @selector(updateAndCleanMoviesCoreDataBackgroundThread:);
    }
    /* Operation Queue init (autorelease) */
    
    /* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:sel
                                                                              object:result];
    
    /* Add the operation to the queue */
    [_moviesQueue addOperation:operation];
    [operation release];
}

-(void)updateMoviesCoreData:(id)result
{
    [self updateMoviesCoreData:result clean:YES];
}

- (void)updateMoviesCoreDataBackgroundThread:(id)result clean:(BOOL)canDelete
{
//    if (_updating) return;
//    _updating = true;
    //    NSDate* updateDate = [NSDate date];
	NSManagedObjectContext *context = [[[NSManagedObjectContext alloc] init] autorelease];
    NSPersistentStoreCoordinator *coordinator = [[ActiveManager shared] persistentStoreCoordinator];
//    NSPersistentStore *currentStore = [[coordinator persistentStores] 
//                                                         objectAtIndex:0];
    [context setPersistentStoreCoordinator:coordinator];
    [context setUndoManager:nil];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSLog(@"getMovies: %@",result);
    if (![[result objectForKey:@"failure"] boolValue])
    {
        NSCharacterSet *lettersCharSet = [ NSCharacterSet letterCharacterSet ];
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
                if ([lettersCharSet characterIsMember:[sortLabel characterAtIndex:0]]) {
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
//    _updating = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedLibrary" object:nil];
}

- (void)updateAndCleanMoviesCoreDataBackgroundThread:(id)result
{
    [self updateMoviesCoreDataBackgroundThread:result clean:YES];
}

- (void)updateNoCleanMoviesCoreDataBackgroundThread:(id)result
{
    [self updateMoviesCoreDataBackgroundThread:result clean:NO];
}


- (void)updateTVShowsCoreData:(id)result
{
    
}

- (void)gotRecentlyAdded:(id)result
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
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedLibrary" object:nil];
    }
}

- (void) updateRecentlyAdded:(NSInteger) number
{
    if (![XBMCStateListener connected]) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatingLibrary" object:nil];
    NSMutableDictionary *requestParams = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [NSArray arrayWithObjects:@"plot", @"director", @"writer"
                                            , @"studio", @"genre", @"year", @"runtime", @"rating"
                                            , @"tagline", @"imdbnumber",@"trailer",
                                            @"lastplayed",@"thumbnail",@"fanart",
                                            @"playcount", @"file", nil]
                                           , @"fields", nil] autorelease];
    if (number > 0)
    {
        [requestParams addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                                 [[[NSDictionary alloc] initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:0], @"start", [NSNumber numberWithInt:number], @"end", nil] autorelease]
                                                 , @"limits", nil] autorelease]];
    }
    
    [requestParams addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                             [[[NSDictionary alloc] initWithObjectsAndKeys:
                                              @"none", @"method", nil] autorelease]
                                             , @"sort", nil] autorelease]];
    
    NSDictionary *request = [[[NSDictionary alloc] initWithObjectsAndKeys:
                              @"VideoLibrary.GetRecentlyAddedMovies", @"cmd", requestParams, @"params",nil] autorelease];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotRecentlyAdded:)];    
}

- (void) updateMovies:(NSInteger) number
{
    if (![XBMCStateListener connected]) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatingLibrary" object:nil];
    NSMutableDictionary *requestParams = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     [NSArray arrayWithObjects:@"title", @"sorttitle", @"plot", @"director", @"writer"
                      , @"studio", @"genre", @"year", @"runtime", @"rating"
                      , @"tagline", @"imdbnumber",@"trailer",
                      @"lastplayed",@"thumbnail",@"fanart",
                      @"playcount", @"file"
                      , @"streamDetails", @"cast", nil]
                                   , @"fields", nil] autorelease];
    if (number > 0)
    {
        [requestParams addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                                 [[[NSDictionary alloc] initWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:0], @"start", [NSNumber numberWithInt:number], @"end", nil] autorelease]
                                                 , @"limits", nil] autorelease]];
    }
    
    [requestParams addEntriesFromDictionary:[[[NSDictionary alloc] initWithObjectsAndKeys:
                                             [[[NSDictionary alloc] initWithObjectsAndKeys:
                                              @"date", @"method", nil] autorelease]
                                             , @"sort", nil] autorelease]];

    NSDictionary *request = [[[NSDictionary alloc] initWithObjectsAndKeys:
                             @"VideoLibrary.GetMovies", @"cmd", requestParams, @"params",nil] autorelease];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(updateMoviesCoreData:)];    
}

- (void) updateTVShows:(NSInteger) number
{
    if (![XBMCStateListener connected]) return;
    
   NSDictionary *requestParams = [[[NSDictionary alloc] initWithObjectsAndKeys:
                     [NSArray arrayWithObjects:@"plot", @"director", @"writer"
                      , @"studio", @"genre", @"year", @"runtime", @"rating"
                      , @"tagline", @"imdbnumber", @"cast", nil]
                                   , @"fields", nil] autorelease];
    NSDictionary *request = [[[NSDictionary alloc] initWithObjectsAndKeys:
                             @"VideoLibrary.GetTvShows", @"cmd"
                             , requestParams, @"params",nil] autorelease];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(updateTVShowsCoreData:)];     
   
}

- (void) updateRecentlyAdded
{
    [self updateRecentlyAdded:0];
}

- (void) updateLibrary
{
    [self updateLibrary:0];
}

- (void) updateLibrary:(NSInteger) number
{
    [self updateMovies:0];
    
    [self updateTVShows:0];
}

- (void)dealloc {

    TT_RELEASE_SAFELY(_recentlyAddedMovies);
   
    [super dealloc];
}

@end
