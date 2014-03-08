//
//  DMePubItem.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubItem.h"

@implementation DMePubItem

+ (instancetype)ePubItemWithId:(NSString*)itemID
                     mediaType:(NSString*)mediaType
                          href:(NSString*)path
{
    return [[[self class] alloc] initWithId:itemID
                                  mediaType:mediaType
                                       href:path];
}

- (instancetype)initWithId:(NSString*)itemID
                 mediaType:(NSString*)mediaType
                      href:(NSString*)path
{
    self = [super initWithID:itemID];
    if (self)
    {
        self.mediaType = mediaType;
        self.href = path;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithId:nil
                  mediaType:nil
                       href:nil];
}

@end
