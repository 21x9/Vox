//
//  Song.h
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Artist;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *lyrics;
@property (nonatomic, retain) NSData *albumArt;
@property (nonatomic, retain) Artist *artist;

@end
