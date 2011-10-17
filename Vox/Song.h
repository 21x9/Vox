//
//  Song.h
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface Song : NSManagedObject

@property (nonatomic, retain) UNKNOWN_TYPE title;
@property (nonatomic, retain) UNKNOWN_TYPE lyrics;
@property (nonatomic, retain) Artist *artist;

@end
