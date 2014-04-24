//
//  DMBookmarkManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/15/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMBookmarkManager.h"

static NSString* const k_bookmarksUserDefaultsKey = @"Bookmarks";

@implementation DMBookmarkManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadBookmarks];
        if (bookmarks == nil)
        {
            bookmarks = [[NSMutableArray alloc] initWithCapacity:30];
        }
    }
    return self;
}

- (NSArray*)allBookmarks
{
    return [NSArray arrayWithArray:bookmarks];
}

- (void)addBookmark:(DMBookmark*)bookmark
{
    [bookmarks addObject:bookmark];
}

- (void)removeBookmark:(DMBookmark*)bookmark
{
    [bookmarks removeObject:bookmark];
}

- (void)removeBookmarksForFile:(NSString*)fileName
{
    DMBookmark* bookmarkToRemove = [self bookmarkForPath:fileName];
    if (bookmarkToRemove)
    {
        [bookmarks removeObject:bookmarkToRemove];
    }
}

- (DMBookmark*)bookmarkForPath:(NSString*)path
{
    for (DMBookmark* bookmark in bookmarks)
    {
        if ([bookmark.fileName isEqualToString:path])
        {
            return bookmark;
        }
    }
    return nil;
}

- (void)saveBookmarks
{
    // TODO: Saving bookmarks might overwrite some changed made by
    // other bookmark managers
    NSData* encodedBookmarks = [NSKeyedArchiver archivedDataWithRootObject:bookmarks];
    [[NSUserDefaults standardUserDefaults] setObject:encodedBookmarks
                                              forKey:k_bookmarksUserDefaultsKey];
}

- (void)loadBookmarks
{
    NSData* encodedBookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:k_bookmarksUserDefaultsKey];
    if (encodedBookmarks != nil && [encodedBookmarks isKindOfClass:[NSData class]])
    {
        bookmarks = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:encodedBookmarks];
    }
}

@end
