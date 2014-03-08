//
//  DMSpineItem.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMSpineItem.h"

@implementation DMSpineItem

+ (instancetype)spineItemWithID:(NSString*)itemID
{
    return [[DMSpineItem alloc] initWithID:itemID];
}

- (instancetype)init
{
    return [self initWithID:nil];
}

@end
