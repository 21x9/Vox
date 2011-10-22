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
    NSString *uppercaseTitle = [[self valueForKey:@"title"] uppercaseString];
    
    if (!uppercaseTitle)
        return @" ";
    
    __block NSString *stringToReturn = nil;
    
    [uppercaseTitle enumerateSubstringsInRange:[uppercaseTitle rangeOfComposedCharacterSequenceAtIndex:0] options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if ([substring rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].length)
            stringToReturn = @"#";
        else
            stringToReturn = substring;
    }];
    
    [self didAccessValueForKey:@"uppercaseFirstLetter"];
    
    return stringToReturn;
}

@end
