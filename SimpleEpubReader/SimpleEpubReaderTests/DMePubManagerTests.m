//
//  DMePubManagerTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTestableePubManager.h"
#import "DMePubFileManager.h"
#import "DMRootFileParser.h"
#import "DMTestableArchive.h"

@interface DMePubManagerTests : XCTestCase
{
    DMTestableePubManager* epubManager;
}

@end

@implementation DMePubManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreatingEpubManager
{
    XCTAssertNoThrow([[DMePubManager alloc] initWithEpubPath:nil], @"Should be able to create a DMePubManager instance");
}

- (void)testEpubManagerInitializingFileManager
{
    epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    DMePubFileManager* fileManager = epubManager.fileManager;
    XCTAssertNotNil(fileManager, @"ePub Manager should create a DMePubFileManager instance upon creation");
}

- (void)testEpubManagerReturnsTheRootFileLocation
{
    epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <container xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"version=\"1.0\">    <rootfiles>    <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\"/>    </rootfiles>    </container>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMRootFileParser* rootParser = [[DMRootFileParser alloc] initWithContainerXml:containerData];
    epubManager.rootParser = rootParser;
    NSString* rootFilePath = [epubManager rootFilePath];
    XCTAssertEqualObjects(rootFilePath, @"OEBPS/content.opf", @"Epub Manager shouldbe able to return the right root file location");
}

- (void)testEpubManagerReadingFileContents
{
    epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    
    DMTestableePubFileManager* epubFileManager = [[DMTestableePubFileManager alloc] initWithArchiverClass:[DMTestableArchive class]];
    epubManager.fileManager = epubFileManager;
    
    DMTestableArchive* archiver = (DMTestableArchive*)epubFileManager.archiver;
    NSString* zipContentsName = @"OEBPS/content.opf";
    ZZArchiveEntry* testEntry = [ZZArchiveEntry archiveEntryWithFileName:zipContentsName
                                                                compress:NO
                                                             streamBlock:nil];
    [archiver setFakeEntries:@[testEntry]];
    epubFileManager.archiver = archiver;
    
    NSData* testContentData = [@"test content" dataUsingEncoding:NSUTF8StringEncoding];
    epubFileManager.hardcodedZipData = testContentData;
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <container xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"version=\"1.0\">    <rootfiles>    <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\"/>    </rootfiles>    </container>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMRootFileParser* rootParser = [[DMRootFileParser alloc] initWithContainerXml:containerData];
    epubManager.rootParser = rootParser;
    
    NSString* rootFilePath = [epubManager rootFilePath];
    NSError* readError = nil;
    NSData* rootFileData = [epubManager dataForFileAtPath:rootFilePath
                                                    error:&readError];
    XCTAssertEqualObjects(rootFileData, testContentData, @"DMePubManager should be able to return the content data as NSData");
    XCTAssertNil(readError, @"Error was returned while retrieving the contents data: %@", readError);
}

- (void)testEpubManagerReadingTheRootFileContents
{
    epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    
    DMTestableePubFileManager* epubFileManager = [[DMTestableePubFileManager alloc] initWithArchiverClass:[DMTestableArchive class]];
    epubManager.fileManager = epubFileManager;
    
    DMTestableArchive* archiver = (DMTestableArchive*)epubFileManager.archiver;
    NSString* zipContentsName = @"OEBPS/content.opf";
    ZZArchiveEntry* testEntry = [ZZArchiveEntry archiveEntryWithFileName:zipContentsName
                                                                compress:NO
                                                             streamBlock:nil];
    [archiver setFakeEntries:@[testEntry]];
    epubFileManager.archiver = archiver;
    
    NSData* testContentData = [@"test content" dataUsingEncoding:NSUTF8StringEncoding];
    epubFileManager.hardcodedZipData = testContentData;
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <container xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"version=\"1.0\">    <rootfiles>    <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\"/>    </rootfiles>    </container>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMRootFileParser* rootParser = [[DMRootFileParser alloc] initWithContainerXml:containerData];
    epubManager.rootParser = rootParser;
    
    NSError* rootFileError = nil;
    NSData* rootFileData = [epubManager rootFileDataWithError:&rootFileError];
    XCTAssertEqualObjects(rootFileData, testContentData, @"DMePubManager should be able to return the content data as NSData");
    XCTAssertNil(rootFileError, @"Error was returned while retrieving the contents data: %@", rootFileError);
}

@end
