//
//  DMePubItemIterator.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubItemIterator.h"

@implementation DMePubItemIterator

+ (instancetype)epubIteratorWithEpubManager:(DMePubManager*)epubManager
{
    return [[DMePubItemIterator alloc] initWithEpubManager:epubManager];
}

- (instancetype)initWithEpubManager:(DMePubManager*)_epubManager
{
    self = [super init];
    if (self)
    {
        epubManager = _epubManager;
        spineItemsIterator = [[epubManager spineItems] objectEnumerator];
        currentSpineItemIndex = -1;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithEpubManager:nil];
}

- (id)nextObject
{
    if (currentSpineItemIndex > (NSInteger)([[epubManager spineItems] count] - 2))
    {
        return nil;
    }
    DMSpineItem* currentSpineItem = [[epubManager spineItems] objectAtIndex:++currentSpineItemIndex];
    return [epubManager epubItemForSpineElement:currentSpineItem];
}

- (BOOL)goToItemWithPath:(NSString*)path
{
    currentSpineItemIndex = -1;     // reset the index in order to be able to 
                                    // find items that have already been iterated
    DMePubItem* epubItem = nil;
    while (epubItem = [self nextObject]) 
    {
        if ([epubItem.href isEqualToString:path])
        {
            return YES;
        }
    }
    return NO;
}

- (DMePubItem*)previousItem
{
    if (currentSpineItemIndex < 1)
    {
        return nil;
    }
    DMSpineItem* currentSpineItem = [[epubManager spineItems] objectAtIndex:--currentSpineItemIndex];
    return [epubManager epubItemForSpineElement:currentSpineItem];
}

@end
