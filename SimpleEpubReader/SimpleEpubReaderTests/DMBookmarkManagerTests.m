//
//  DMBookmarkManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/15/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMBookmarkManager.h"
#import "DMBookmark.h"

@interface DMBookmarkManagerTests : XCTestCase
{
    DMBookmarkManager* bookmarkManager;
    NSString* bookmarkFileName;
    DMBookmark* bookmark;
}

@end

@implementation DMBookmarkManagerTests

- (void)setUp
{
    [super setUp];
    bookmarkManager = [[DMBookmarkManager alloc] init];
    bookmarkFileName = @"fileName";
    bookmark = [[DMBookmark alloc] initWithFileName:bookmarkFileName
                                            section:@"section"
                                           position:@(3)]; 
}

- (void)tearDown
{
    // DMBookmarkManager uses the NSUserDefaults heavily. Make sure to clear it
    // after each test
    [[NSUserDefaults standardUserDefaults] setObject:[NSData data]
                                              forKey:@"Bookmarks"];
    bookmarkManager = nil;
    [super tearDown];
}

- (void)testAbilityToGetAllBookmarks
{
    XCTAssertTrue([(NSArray*)[bookmarkManager allBookmarks] count] == 0, @"Shuld be able to get an array containing all bookmarks");
}

- (void)testAbilityToAddBookmark
{
    [bookmarkManager addBookmark:bookmark];
    XCTAssertTrue([(NSArray*)[bookmarkManager allBookmarks] count] == 1, @"Shuld be able to add bookmarks");
}

- (void)testAbilityToRemoveBookmark
{
    [bookmarkManager addBookmark:bookmark];
    [bookmarkManager removeBookmark:bookmark];
    XCTAssertTrue([(NSArray*)[bookmarkManager allBookmarks] containsObject:bookmark] == NO, @"Shuld be able to remove bookmarks");
}

- (void)testAbilityToRemoveBookmarkWithEpubPath
{
    [bookmarkManager addBookmark:bookmark];
    [bookmarkManager removeBookmarksForFile:bookmarkFileName];
    XCTAssertTrue([(NSArray*)[bookmarkManager allBookmarks] containsObject:bookmark] == NO, @"Shuld be able to remove bookmarks for a specific file");
}

- (void)testAbilityToSaveBookmarks
{
    [bookmarkManager addBookmark:bookmark];
    XCTAssertNoThrow([bookmarkManager saveBookmarks], @"Should be able to save bookmarks");
}

- (void)testAbilityToLoadBookmarks
{
    [bookmarkManager addBookmark:bookmark];
    XCTAssertNoThrow([bookmarkManager loadBookmarks], @"Should be able to load bookmarks for user defaults");
}

- (void)testPersistingBookmarks
{
    [bookmarkManager addBookmark:bookmark];
    [bookmarkManager saveBookmarks];
    [bookmarkManager removeBookmark:bookmark];  // should not be saved
    [bookmarkManager loadBookmarks];
    XCTAssertEqualObjects([(DMBookmark*)[[bookmarkManager allBookmarks] firstObject] fileName], bookmark.fileName, @"Should be able to load the saved bookmarks");
}

- (void)testLoadingBookmarksWhileInitializing
{
    [bookmarkManager addBookmark:bookmark];
    [bookmarkManager saveBookmarks];
    bookmarkManager = [[DMBookmarkManager alloc] init];
    XCTAssertEqualObjects([(DMBookmark*)[[bookmarkManager allBookmarks] firstObject] fileName], bookmark.fileName, @"Should load bookmarks while initializing");
}

@end
