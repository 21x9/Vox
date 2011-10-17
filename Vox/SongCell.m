//
//  SongCell.m
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "SongCell.h"
#import "Song.h"
#import "Artist.h"

@implementation SongCell

@synthesize song;

- (void)setSong:(Song *)aSong
{
    if (song == aSong)
        return;
    
    song = aSong;
    
    self.textLabel.text = song.title;
    self.detailTextLabel.text = song.artist.name;
    self.imageView.image = [UIImage imageWithData:song.albumArt];
}

@end
