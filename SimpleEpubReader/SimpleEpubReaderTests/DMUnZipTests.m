//
//  DMUnZipTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 2/24/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTestableArchive.h"
#import "DMTestableePubFileManager.h"

@interface DMUnZipTests : XCTestCase
{
    DMTestableArchive* archiver;
}

@end

@implementation DMUnZipTests

- (void)setUp
{
    [super setUp];
    archiver = [[DMTestableArchive alloc] init];
}

- (void)tearDown
{
    archiver = nil;
    [super tearDown];
}

- (void)testEpubManagerOpensArchive
{
    DMTestableePubFileManager* epubManager = [[DMTestableePubFileManager alloc] initWithArchiverClass:[archiver class]];
    archiver = (DMTestableArchive*)epubManager.zipArchiver;
    XCTAssertNotNil(archiver, @"The ePub file manager should open the file upon initialization");
}

- (void)testEpubManagerFindsContentXml
{
    NSString* zipContentsName = @"/META-INF/container.xml";
    DMTestableePubFileManager* epubManager = [[DMTestableePubFileManager alloc] initWithArchiverClass:[archiver class]];
    archiver = (DMTestableArchive*)epubManager.archiver;
    ZZArchiveEntry* testEntry = [ZZArchiveEntry archiveEntryWithFileName:zipContentsName
                                                                compress:NO
                                                             streamBlock:nil];
    [archiver setFakeEntries:@[testEntry]];
    epubManager.archiver = archiver;
    NSError* zipError = nil;
    [epubManager contentXmlWithName:zipContentsName
                              error:&zipError];
    XCTAssertNil(zipError, @"The ePub manager should not modify the error parameter if retrieving contents is successful");
}

- (void)testEpubManagerReturnsErrorIfNoContents
{
    NSString* zipContentsName = @"/META-INF/test.xml";
    DMTestableePubFileManager* epubManager = [[DMTestableePubFileManager alloc] initWithArchiverClass:[archiver class]];
    archiver = (DMTestableArchive*)epubManager.archiver;
    ZZArchiveEntry* testEntry = [ZZArchiveEntry archiveEntryWithFileName:zipContentsName
                                                                compress:NO
                                                             streamBlock:nil];
    [archiver setFakeEntries:@[testEntry]];
    epubManager.archiver = archiver;
    NSError* zipError = nil;
    [epubManager contentXmlWithName:zipContentsName
                              error:&zipError];
    XCTAssertNil(zipError, @"The ePub manager should not modify the error parameter if retrieving contents is successful");
}

@end
