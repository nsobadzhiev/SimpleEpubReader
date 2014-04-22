//
//  DMBookmarkManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/15/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMBookmark.h"

@interface DMBookmarkManager : NSObject
{
    NSMutableArray* bookmarks;
}

@property (nonatomic, readonly) NSArray* allBookmarks;

- (void)addBookmark:(DMBookmark*)bookmark;
- (void)removeBookmark:(DMBookmark*)bookmark;
- (void)removeBookmarksForFile:(NSString*)fileName;

- (void)saveBookmarks;
- (void)loadBookmarks;

@end
