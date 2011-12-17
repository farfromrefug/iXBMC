//
//  NSManagedObject+iXBMC.h
//  iXBMC
//
//  Created by Martin Guillon on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSManagedObject (iXBMC)
+ (NSString*)defaultSort;
+ (NSArray*)sorts;
+ (NSArray*)sortNames;

@end
