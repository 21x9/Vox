//
//  AlbumArtSearch.h
//  Vox
//
//  Created by Mark Adams on 10/20/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AlbumArtSearchCompletionBlock)();

@class Song;

@interface AlbumArtSearch : NSObject

- (void)searchAlbumArtForSong:(Song *)song completionBlock:(AlbumArtSearchCompletionBlock)block;

@end
