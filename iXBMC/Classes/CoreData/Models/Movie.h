//
//  Movie.h
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActorRole, Genre;

@interface Movie : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * runtime;
@property (nonatomic, retain) NSNumber * playcount;
@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSString * trailer;
@property (nonatomic, retain) NSDate * dateAddedLocal;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * imdbid;
@property (nonatomic, retain) NSString * plotoutline;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * studio;
@property (nonatomic, retain) NSString * sortLabel;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * writer;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * fanart;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * movieid;
@property (nonatomic, retain) NSString * firstLetter;
@property (nonatomic, retain) NSSet* MovieToGenre;
@property (nonatomic, retain) NSSet* MovieToRole;

@end
