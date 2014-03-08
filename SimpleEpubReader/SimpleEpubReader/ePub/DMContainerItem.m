//
//  DMContainerItem.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMContainerItem.h"

@implementation DMContainerItem

- (instancetype)init
{
    return [self initWithID:nil];
}

- (instancetype)initWithID:(NSString*)itemID
{
    self = [super init];
    if (self)
    {
        self.itemID = itemID;
    }
    return self;
}

@end
