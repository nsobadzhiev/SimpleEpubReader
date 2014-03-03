//
//  DMContainerTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTestableePubFileManager.h"
#import "DMTestableArchive.h"
#import "DMTestableContainerePubFileManager.h"
#import "ZZArchiveEntry+TestableContainer.h"
#import "DMRootFileParser.h"

@interface DMContainerTests : XCTestCase
{
    DMTestableePubFileManager* epubManager;
}

@end

@implementation DMContainerTests

- (void)setUp
{
    [super setUp];
    epubManager = [[DMTestableePubFileManager alloc] initWithArchiverClass:[DMTestableArchive class]];
}

- (void)tearDown
{
    epubManager = nil;
    [super tearDown];
}

- (void)testePubManagerBeingAbleToRetrieveContainerXml;
{
    NSError* zipError = nil;
    NSData* containerData = nil;
    NSString* zipContentsName = @"/META-INF/container.xml";
    epubManager = [[DMTestableContainerePubFileManager alloc] initWithArchiverClass:[DMTestableArchive class]];
    DMTestableArchive* archiver = (DMTestableArchive*)epubManager.archiver;
    ZZArchiveEntry* testEntry = [ZZArchiveEntry archiveEntryWithFileName:zipContentsName
                                                                compress:NO
                                                             streamBlock:nil];
    [archiver setFakeEntries:@[testEntry]];
    epubManager.archiver = archiver;
    containerData = [epubManager containerXmlWithError:&zipError];
    XCTAssertNotNil(containerData, @"The retrieved container XML should not be nil");
    XCTAssertNil(zipError, @"Retrieving the container.xml should not result in an error");
}

- (void)testReadingTheRootFileXml
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <container xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"version=\"1.0\">    <rootfiles>    <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\"/>    </rootfiles>    </container>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMRootFileParser* rootParser = [[DMRootFileParser alloc] initWithContainerXml:(NSData*)containerData];
    XCTAssertNotNil(rootParser, @"The root file parser should be able to be instantiated");
}

- (void)testReadingTheRootFileLocation
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <container xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"version=\"1.0\">    <rootfiles>    <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\"/>    </rootfiles>    </container>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMRootFileParser* rootParser = [[DMRootFileParser alloc] initWithContainerXml:(NSData*)containerData];
    NSString* rootPath = rootParser.mainRootFileLocation;
    XCTAssertEqualObjects(rootPath, @"OEBPS/content.opf", @"The root parser returned the wrong root path: %@", rootPath);
}

@end
