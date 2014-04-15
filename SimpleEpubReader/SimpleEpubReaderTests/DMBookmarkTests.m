//
//  DMBookmarkTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMBookmark.h"

@interface DMBookmarkTests : XCTestCase
{
    DMBookmark* bookmark;
}

@end

@implementation DMBookmarkTests

- (void)setUp
{
    [super setUp];
    bookmark = [[DMBookmark alloc] init];
}

- (void)tearDown
{
    bookmark = nil;
    [super tearDown];
}

- (void)testBookmarkHasFileName
{
    XCTAssertNoThrow([bookmark fileName], @"A Bookmark should reference a file");
}

- (void)testBookmarkHasFilePosition
{
    XCTAssertNoThrow([bookmark filePosition], @"A Bookmark should reference a position within a file");
}

- (void)testBookmarkHasFileSection
{
    XCTAssertNoThrow([bookmark fileSection], @"A Bookmark should reference a file section");
}

- (void)testBookmarkConformsToNSCoding
{
    XCTAssertTrue([bookmark conformsToProtocol:@protocol(NSCoding)], @"Should conform to NSCoding in order to support serialization");
}

- (void)testDecodingABookmark
{
    NSString* fileName = @"testFileName";
    NSString* fileSection = @"testFileSection";
    NSNumber* filePosition = [NSNumber numberWithInt:11];
    NSMutableData* encodedBookmark = [NSMutableData data];
    NSKeyedArchiver* encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:encodedBookmark];
    [encoder encodeObject:fileName forKey:@"bookmarkFileName"];
    [encoder encodeObject:fileSection forKey:@"bookmarkFileSection"];
    [encoder encodeObject:filePosition forKey:@"bookmarkFilePosition"];
    [encoder finishEncoding];
    NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:encodedBookmark];
    DMBookmark* decodedBookmark = [[DMBookmark alloc] initWithCoder:decoder];
    XCTAssertEqualObjects(decodedBookmark.fileName, fileName, @"Should be able to decode the file name of a previously serialized bookmark");
    XCTAssertEqualObjects(decodedBookmark.fileSection, fileSection, @"Should be able to decode the file section of a previously serialized bookmark");
    XCTAssertEqualObjects(decodedBookmark.filePosition, filePosition, @"Should be able to decode the file position of a previously serialized bookmark");
}

- (void)testEncodingABookmark
{
    NSMutableData* encodedBookmark = [NSMutableData data];
    NSKeyedArchiver* encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:encodedBookmark];
    NSString* bookmarkFileName = @"testFile";
    NSString* bookmarkFileSection = @"testSection";
    BookmarkPosition* bookmarkFilePosition = [NSNumber numberWithInt:2];
    bookmark.fileName = bookmarkFileName;
    bookmark.fileSection = bookmarkFileSection;
    bookmark.filePosition = bookmarkFilePosition;
    [bookmark encodeWithCoder:encoder];
    [encoder finishEncoding];
    NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:encodedBookmark];
    XCTAssertEqualObjects([decoder decodeObjectForKey:@"bookmarkFileName"], bookmarkFileName, @"Should be able to encode the file name of a bookmark");
    XCTAssertEqualObjects([decoder decodeObjectForKey:@"bookmarkFileSection"], bookmarkFileSection, @"Should be able to decode the file section of a bookmark");
    XCTAssertEqualObjects([decoder decodeObjectForKey:@"bookmarkFilePosition"], bookmarkFilePosition, @"Should be able to decode the file position of a bookmark");
}

@end
