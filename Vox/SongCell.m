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

@interface SongCell ()

@property (strong, nonatomic) UIImage *placeholderImage;

@end

#pragma mark -

@implementation SongCell

@synthesize song;

@synthesize placeholderImage;

- (UIImage *)placeholderImage
{
    if (!placeholderImage)
        placeholderImage = [UIImage imageNamed:@"AlbumPlaceholder"];
    
    return placeholderImage;
}

- (void)setSong:(Song *)aSong
{
    song = aSong;
    
    self.textLabel.text = song.title;
    self.detailTextLabel.text = song.artist.name;
    self.imageView.image = [UIImage imageWithData:song.albumArt];
    
    if (!song.title && !song.artist)
    {
        self.textLabel.text = NSLocalizedString(@"New Song", @"New Song");
        self.detailTextLabel.text = @" ";
    }
}

@end
