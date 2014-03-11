//
//  DMContainerFileTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/6/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMContainerFileParser.h"
#import "DMePubItem.h"
#import "DMSpineItem.h"

@interface DMContainerFileTests : XCTestCase
{
    DMContainerFileParser* containerParser;
}

@end

@implementation DMContainerFileTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBeingAbleToInitContainerParser
{
    NSData* containerData = [NSData data];
    XCTAssertNoThrow([[DMContainerFileParser alloc] initWithData:(NSData*)containerData], 
                     @"Should be able to use the initWithData method to initialize a DMContainerFileParser");
}

- (void)testReadingInvalidContainerFile
{
    NSString* hardcodedContainer = @"Not a valid XML";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    XCTAssertNil(containerParser, @"The container file parser init method must NOT return nil if provided with a valid XML");
}

- (void)testReadingTheContainerFile
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xhtml+xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    XCTAssertNotNil(containerParser, @"The container file parser init method must NOT return nil if provided with a valid XML");
}

- (void)testReadingePubTitle
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xhtml+xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    NSString* epubTitle = [containerParser epubTitle];
    XCTAssertEqualObjects(epubTitle, @"My Book", @"Failed to get the epub title name");
}

- (void)testReadingePubHtmlItemsId
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xhtml+xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    NSArray* epubHtmlItems = [containerParser epubHtmlItems];
    XCTAssert(epubHtmlItems.count == 2, @"Failed to parse the HTML items count from the epub container");
    XCTAssertEqualObjects([(DMePubItem*)[epubHtmlItems firstObject] itemID], @"id2778030", @"Failed to retrieve the first item's ID");
    XCTAssertEqualObjects([(DMePubItem*)[epubHtmlItems lastObject] itemID], @"id2528567", @"Failed to retrieve the last item's ID");
}

- (void)testReadingePubHtmlItemsMediaType
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xhtml+xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    NSArray* epubHtmlItems = [containerParser epubHtmlItems];
    XCTAssertEqualObjects([(DMePubItem*)[epubHtmlItems firstObject] mediaType], @"application/xhtml+xml", @"Incorrect item media type");
    XCTAssertEqualObjects([(DMePubItem*)[epubHtmlItems lastObject] mediaType], @"application/xhtml+xml", @"Incorrect item media type");
}

- (void)testReadingePubHtmlItemsPath
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xhtml+xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    NSArray* epubHtmlItems = [containerParser epubHtmlItems];
    XCTAssertEqualObjects([(DMePubItem*)[epubHtmlItems firstObject] href], @"index.html", @"Incorrect item media path");
    XCTAssertEqualObjects([(DMePubItem*)[epubHtmlItems lastObject] href], @"pr01.html", @"Incorrect item media path");
}

- (void)testFilteringNonHtmlItems
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    NSArray* epubHtmlItems = [containerParser epubHtmlItems];
    XCTAssert([epubHtmlItems count] == 1 && [[[epubHtmlItems firstObject] itemID] isEqualToString:@"id2528567"], @"The first (non HTML) item should have been ignored");
}

- (void)testReadingSpineItems
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    NSArray* spineItems = [containerParser spineItems];
    XCTAssert(spineItems.count == 2, @"Failed to parse the HTML spine items count");
    XCTAssertEqualObjects([(DMSpineItem*)[spineItems firstObject] itemID], @"id2778030", @"Failed to retrieve the first spine item's ID");
    XCTAssertEqualObjects([(DMSpineItem*)[spineItems lastObject] itemID], @"id2528567", @"Failed to retrieve the last spine item's ID");
}

- (void)testReadingHtmlSpineItems
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    NSArray* spineItems = [containerParser filteredSpineItems];
    XCTAssert(spineItems.count == 1, @"Failed to parse the HTML spine items count");
    XCTAssertEqualObjects([(DMSpineItem*)[spineItems firstObject] itemID], @"id2528567", @"Failed to retrieve the last spine item's ID");
}

- (void)testReadingItemForSpine
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    NSArray* spineItems = [containerParser filteredSpineItems];
    DMePubItem* epubItem = [containerParser epubItemForSpineElement:(DMSpineItem*)[spineItems firstObject]];
    XCTAssertEqualObjects([epubItem itemID], @"id2528567", @"Failed to retrieve the spine item's ID");
    XCTAssertEqualObjects([epubItem href], @"pr01.html", @"Failed to retrieve the spine item's path");
}

@end
