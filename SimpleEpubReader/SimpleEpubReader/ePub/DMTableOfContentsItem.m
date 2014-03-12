//
//  DMTableOfContentsItem.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/11/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContentsItem.h"

@implementation DMTableOfContentsItem

- (instancetype)initWithName:(NSString*)name
                     andPath:(NSString*)path
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.path = path;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithName:nil
                      andPath:nil];
}

@end
