//
//  Artist.h
//  Vox
//
//  Created by Mark Adams on 10/19/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Song;

@interface Artist : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uppercaseFirstLetter;
@property (nonatomic, retain) NSSet *songs;
@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
