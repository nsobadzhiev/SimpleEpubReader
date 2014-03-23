//
//  DMePubItemIterator.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMePubManager.h"
#import "DMSpineItem.h"

@interface DMePubItemIterator : NSEnumerator
{
    DMePubManager* epubManager;
    NSEnumerator* spineItemsIterator;
    NSInteger currentSpineItemIndex;
}

+ (instancetype)epubIteratorWithEpubManager:(DMePubManager*)epubManager;

- (instancetype)initWithEpubManager:(DMePubManager*)epubManager;

- (BOOL)goToItemWithPath:(NSString*)path;
- (DMePubItem*)previousItem;
- (DMePubItem*)currentItem;

@end
