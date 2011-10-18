//
//  NSManagedObject+IsNew.m
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "NSManagedObject+IsNew.h"

@implementation NSManagedObject (IsNew)

- (BOOL)isNew
{
    return [self committedValuesForKeys:nil].count == 0;
}

@end
