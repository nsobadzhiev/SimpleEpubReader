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
    for (DMBookmark* bookmark in bookmarks)
    {
        if ([bookmark.fileName isEqualToString:fileName])
        {
            [bookmarks removeObject:bookmark];
        }
    }
}

- (void)saveBookmarks
{
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
