//
//  DMTestableTableOfContentsDataSource.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/14/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableTableOfContentsDataSource.h"
#import "DMTestableePubManager.h"

@implementation DMTestableTableOfContentsDataSource

- (DMePubManager*)epubManagerObject
{
    return epubManager;
}

- (DMePubManager*)createEpubManagerWithPath:(NSString*)path
{
    if (_epubManagerObject == nil)
    {
        return [[DMTestableePubManager alloc] initWithEpubPath:path];
    }
    else
    {
        return _epubManagerObject;
    }
}

@end
