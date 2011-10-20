//
//  AlbumArtSearch.m
//  Vox
//
//  Created by Mark Adams on 10/20/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "AlbumArtSearch.h"
#import "Song.h"
#import "Artist.h"

@implementation AlbumArtSearch

- (void)searchAlbumArtForSong:(Song *)song completionBlock:(AlbumArtSearchCompletionBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URLString = [[NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=track.search&track=%@&artist=%@&api_key=47abc44f6b4d0edfb9889d4fe6ec51a5&limit=1&format=json", song.title, song.artist.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:URLString];
        NSData *data = [NSData dataWithContentsOfURL:URL];
        NSError *error = nil;
        NSDictionary *JSONData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
        
        if (!JSONData)
        {
            NSLog(@"Couldn't deserialize json data. %@, %@", error, error.userInfo);
            return;
        }
        
        NSLog(@"%@", JSONData);
        NSString *imageURLString = [[[[[[JSONData valueForKey:@"results"] valueForKey:@"trackmatches"] valueForKey:@"track"] valueForKey:@"image"] objectAtIndex:2] valueForKey:@"#text"];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        song.albumArt = [NSData dataWithContentsOfURL:imageURL];
        block();
    });
}

@end
