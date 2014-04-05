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
#import "DMTableOfContents.h"

@interface DMePubManagerTests : XCTestCase
{
    DMTestableePubManager* epubManager;
}

- (void)setupEpubManagerForTestWithContentsXml:(NSString*)xml;

@end

@implementation DMePubManagerTests

- (void)setUp
{
    [super setUp];
    epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
}

- (void)tearDown
{
    epubManager = nil;
    [super tearDown];
}

- (void)testCreatingEpubManager
{
    XCTAssertNoThrow([[DMePubManager alloc] initWithEpubPath:nil], @"Should be able to create a DMePubManager instance");
}

- (void)testEpubManagerInitializingFileManager
{
    DMePubFileManager* fileManager = epubManager.fileManager;
    XCTAssertNotNil(fileManager, @"ePub Manager should create a DMePubFileManager instance upon creation");
}

- (void)testEpubManagerReturnsTheRootFileLocation
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <container xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"version=\"1.0\">    <rootfiles>    <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\"/>    </rootfiles>    </container>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMRootFileParser* rootParser = [[DMRootFileParser alloc] initWithContainerXml:containerData];
    epubManager.rootParser = rootParser;
    NSString* rootFilePath = [epubManager rootFilePath];
    XCTAssertEqualObjects(rootFilePath, @"OEBPS/content.opf", @"Epub Manager shouldbe able to return the right root file location");
}

- (void)testEpubManagerReadingFileContents
{
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

- (void)testEpubManagerReadingTitle
{
    DMTestableePubFileManager* epubFileManager = [[DMTestableePubFileManager alloc] initWithArchiverClass:[DMTestableArchive class]];
    epubManager.fileManager = epubFileManager;
    
    DMTestableArchive* archiver = (DMTestableArchive*)epubFileManager.archiver;
    NSString* zipContentsName = @"OEBPS/content.opf";
    ZZArchiveEntry* testEntry = [ZZArchiveEntry archiveEntryWithFileName:zipContentsName
                                                                compress:NO
                                                             streamBlock:nil];
    [archiver setFakeEntries:@[testEntry]];
    epubFileManager.archiver = archiver;
    
    NSData* testContentData = [@"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xhtml+xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>" dataUsingEncoding:NSUTF8StringEncoding];
    epubFileManager.hardcodedZipData = testContentData;
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <container xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"version=\"1.0\">    <rootfiles>    <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\"/>    </rootfiles>    </container>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMRootFileParser* rootParser = [[DMRootFileParser alloc] initWithContainerXml:containerData];
    epubManager.rootParser = rootParser;
    
    NSError* rootFileError = nil;
    NSString* epubTitle = [epubManager titleWithError:&rootFileError];
    XCTAssertEqualObjects(epubTitle, @"My Book", @"DMePubManager should be able to return the book title");
    XCTAssertNil(rootFileError, @"Error was returned while retrieving the contents data: %@", rootFileError);
}

- (void)testReadingePubHtmlItemsId
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xhtml+xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    [self setupEpubManagerForTestWithContentsXml:hardcodedContainer];
    NSArray* epubHtmlItems = [epubManager epubHtmlItems];
    XCTAssert(epubHtmlItems.count == 2, @"Failed to parse the HTML items count from the epub container");
    XCTAssertEqualObjects([(DMePubItem*)[epubHtmlItems firstObject] itemID], @"id2778030", @"Failed to retrieve the first item's ID");
    XCTAssertEqualObjects([(DMePubItem*)[epubHtmlItems lastObject] itemID], @"id2528567", @"Failed to retrieve the last item's ID");
}

- (void)testReadingSpineItems
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    [self setupEpubManagerForTestWithContentsXml:hardcodedContainer];
    NSArray* spineItems = [epubManager spineItems];
    XCTAssert(spineItems.count == 2, @"Failed to parse the HTML spine items count");
    XCTAssertEqualObjects([(DMSpineItem*)[spineItems firstObject] itemID], @"id2778030", @"Failed to retrieve the first spine item's ID");
    XCTAssertEqualObjects([(DMSpineItem*)[spineItems lastObject] itemID], @"id2528567", @"Failed to retrieve the last spine item's ID");
}

- (void)testReadingHtmlSpineItems
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    [self setupEpubManagerForTestWithContentsXml:hardcodedContainer];
    NSArray* spineItems = [epubManager filteredSpineItems];
    XCTAssert(spineItems.count == 1, @"Failed to parse the HTML spine items count");
    XCTAssertEqualObjects([(DMSpineItem*)[spineItems firstObject] itemID], @"id2528567", @"Failed to retrieve the last spine item's ID");
}

- (void)testReadingItemForSpine
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    [self setupEpubManagerForTestWithContentsXml:hardcodedContainer];
    NSArray* spineItems = [epubManager filteredSpineItems];
    DMePubItem* epubItem = [epubManager epubItemForSpineElement:(DMSpineItem*)[spineItems firstObject]];
    XCTAssertEqualObjects([epubItem itemID], @"id2528567", @"Failed to retrieve the spine item's ID");
    XCTAssertEqualObjects([epubItem href], @"pr01.html", @"Failed to retrieve the spine item's path");
}

- (void)testReadingTheNavigationItem
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>	<manifest>    <item id=\"htmltoc\" properties=\"nav\" media-type=\"application/xhtml+xml\" href=\"bk01-toc.xhtml\"/>    <item media-type=\"text/css\" id=\"epub-css\" href=\"css/epub.css\"/>	</manifest>    </package>";
    [self setupEpubManagerForTestWithContentsXml:hardcodedContainer];
    DMePubItem* navItem = [epubManager navigationItem];
    XCTAssertEqualObjects([navItem itemID], @"htmltoc", @"Failed to retrieve the nav item's ID");
    XCTAssertEqualObjects([navItem href], @"bk01-toc.xhtml", @"Failed to retrieve the nav item's path");
}

/** 
 * Navigation file tests
 */


- (void)testRetrievingTocTitle
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:epub=\"http://www.idpf.org/2007/ops\" xml:lang=\"en\"	lang=\"en\">	<head>   <title>Accessible EPUB 3</title>    <link rel=\"stylesheet\" type=\"text/css\" href=\"css/epub.css\" />	</head> </html>";
    [self setupEpubManagerForTestWithNavigationXml:tocString];
    NSString* tocTitle = [epubManager navigationTitle];
    XCTAssertEqualObjects(tocTitle, @"Accessible EPUB 3", @"%@ does not match the expected title - Accessible EPUB 3", tocTitle);
}

- (void)testRetrievingTocTopLevelItems
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <h2>Table of Contents</h2>    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    </ol>    </li>    <li><a href=\"ch01.xhtml\">1. Introduction</a>    </li>    </ol>    </nav>	</body>    </html>";
    [self setupEpubManagerForTestWithNavigationXml:tocString];
    NSArray* topItems = [epubManager navigationTopLevelItems];
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[topItems firstObject] name], @"Preface", @"%@ does not match the expected item name - Preface", [(DMTableOfContentsItem*)[topItems firstObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[topItems firstObject] path], @"pr01.xhtml", @"%@ does not match the expected item path - pr01.xhtml", [(DMTableOfContentsItem*)[topItems firstObject] path]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[topItems lastObject] name], @"1. Introduction", @"%@ does not match the expected item name - 1. Introduction", [(DMTableOfContentsItem*)[topItems firstObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[topItems lastObject] path], @"ch01.xhtml", @"%@ does not match the expected item path - ch01.xhtml", [(DMTableOfContentsItem*)[topItems firstObject] path]);
}

- (void)testRetrievingAllTocItems
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    <li><a href=\"pr01s05.xhtml\">Acknowledgments</a></li>    </ol>    </li>    </ol>    </nav>	</body>    </html>";
    [self setupEpubManagerForTestWithNavigationXml:tocString];
    NSArray* tocItems = [epubManager allNavigationItems];
    XCTAssertEqual(tocItems.count, 3, @"%lu is a wrong toc items count", (unsigned long)tocItems.count);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems firstObject] name], @"Preface", @"%@ does not match the expected item name", [(DMTableOfContentsItem*)[tocItems firstObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems firstObject] path], @"pr01.xhtml", @"%@ does not match the expected item path", [(DMTableOfContentsItem*)[tocItems firstObject] path]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems objectAtIndex:1] name], @"Conventions Used in This Book", @"%@ does not match the expected item name", [(DMTableOfContentsItem*)[tocItems objectAtIndex:1] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems objectAtIndex:1] path], @"pr01.xhtml#I_sect1_d1e137", @"%@ does not match the expected item path", [(DMTableOfContentsItem*)[tocItems objectAtIndex:1] path]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems lastObject] name], @"Acknowledgments", @"%@ does not match the expected item name", [(DMTableOfContentsItem*)[tocItems lastObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems lastObject] path], @"pr01s05.xhtml", @"%@ does not match the expected item path", [(DMTableOfContentsItem*)[tocItems lastObject] path]);
}

- (void)testIndicatingNoOpenFile
{
    epubManager = [[DMTestableePubManager alloc] initWithEpubPath:@"no/such/file"];
    XCTAssertFalse(epubManager.isOpen, @"The isOpen property should indicate that no file has been open");
}

- (void)testIndicatingOpenFile
{
    DMTestableePubFileManager* epubFileManager = [[DMTestableePubFileManager alloc] initWithArchiverClass:[DMTestableArchive class]];
    epubManager.fileManager = epubFileManager;
    
    DMTestableArchive* archiver = (DMTestableArchive*)epubFileManager.archiver;
    NSString* zipContentsName = @"OEBPS/content.opf";
    ZZArchiveEntry* testEntry = [ZZArchiveEntry archiveEntryWithFileName:zipContentsName
                                                                compress:NO
                                                             streamBlock:nil];
    [archiver setFakeEntries:@[testEntry]];
    XCTAssertTrue(epubManager.isOpen, @"The isOpen property should indicate that a file has been open");
}

#pragma mark Utility Methods

- (void)setupEpubManagerForTestWithContentsXml:(NSString*)xml
{
    NSData* containerData = [xml dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    epubManager.contentsXmlParser = containerParser;
}

- (void)setupEpubManagerForTestWithNavigationXml:(NSString *)xml
{
    NSData* containerData = [xml dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* navigationParser = [[DMTableOfContents alloc] initWithData:containerData];
    epubManager.navParser = navigationParser;
}

@end
