//
//  Song.m
//  Vox
//
//  Created by Mark Adams on 10/19/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "Song.h"
#import "Artist.h"


@implementation Song

@dynamic albumArt;
@dynamic lyrics;
@dynamic title;
@dynamic uppercaseFirstLetter;
@dynamic artist;

- (NSString *)uppercaseFirstLetter
{
    [self willAccessValueForKey:@"uppercaseFirstLetter"];
    
    if (![self valueForKey:@"title"])
        return @" ";
    
    NSString *uppercaseNameString = [[self valueForKey:@"title"] uppercaseString];
    NSString *uppercaseLetter = [uppercaseNameString substringWithRange:[uppercaseNameString rangeOfComposedCharacterSequenceAtIndex:0]];
    [self didAccessValueForKey:@"uppercaseFirstLetter"];
    
    return uppercaseLetter;
}

@end
