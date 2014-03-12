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
    return [self initWithName:name
                         path:path
                        parent:nil];
}

- (instancetype)initWithName:(NSString *)name 
                        path:(NSString *)path 
                      parent:(DMTableOfContentsItem*)parent
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.path = path;
        self.parent = parent;
        self.level = parent.level + 1;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithName:nil
                         path:nil
                        parent:nil];
}

@end
