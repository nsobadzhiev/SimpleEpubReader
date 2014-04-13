//
//  DMePubItemIteratorTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMePubItemIterator.h"
#import "DMSpineItem.h"
#import "DMTestableePubManager.h"

@interface DMePubItemIteratorTests : XCTestCase
{
    DMePubItemIterator* epubIterator;
}

@end

@implementation DMePubItemIteratorTests

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

- (void)testCreatingAnIterator
{
    epubIterator = [DMePubItemIterator epubIteratorWithEpubManager:nil];
    XCTAssertNotNil(epubIterator, @"Should be able to create a DMePubItemIterator instance");
}

- (void)testReadingItemForSpine
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.html\" media-type=\"application/xhtml+xml\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    epubIterator = [DMePubItemIterator epubIteratorWithEpubManager:epubManager];
    DMePubItem* epubItem = [epubIterator nextObject];
    XCTAssertEqualObjects([epubItem itemID], @"id2778030", @"Failed to retrieve the spine item's ID");
    XCTAssertEqualObjects([epubItem href], @"index.html", @"Failed to retrieve the spine item's path");
}

- (void)testBeingAbleToSetCurrentIteratorPosition
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>       <itemref idref=\"6\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    epubIterator = [DMePubItemIterator epubIteratorWithEpubManager:epubManager];
    [epubIterator goToItemWithPath:@"index3.html"];
    DMePubItem* epubItem = [epubIterator nextObject];
    XCTAssertEqualObjects([epubItem itemID], @"4", @"Failed to skip to the fourth item");
    XCTAssertEqualObjects([epubItem href], @"index4.html", @"Failed to skip to the fourth item");
}

- (void)testBeingAbleToGetPreviousItem
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>       <itemref idref=\"6\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    epubIterator = [DMePubItemIterator epubIteratorWithEpubManager:epubManager];
    [epubIterator goToItemWithPath:@"index3.html"];
    DMePubItem* epubItem = [epubIterator previousItem];
    XCTAssertEqualObjects([epubItem itemID], @"2", @"Failed to skip to the second item");
    XCTAssertEqualObjects([epubItem href], @"index2.html", @"Failed to skip to the second item");
}

- (void)testIteratingBeyondTheArraySize
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>  	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    epubIterator = [DMePubItemIterator epubIteratorWithEpubManager:epubManager];
    DMePubItem* outOfBoundsItem = nil;
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    XCTAssertNoThrow(outOfBoundsItem = [epubIterator nextObject], @"Accessing an invalid object shouldn't raise an exception");
}

- (void)testReturningNilBeyondTheArraySize
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>  	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    epubIterator = [DMePubItemIterator epubIteratorWithEpubManager:epubManager];
    DMePubItem* outOfBoundsItem = nil;
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    outOfBoundsItem = [epubIterator nextObject];
    XCTAssertNil(outOfBoundsItem, @"Iterator should return nil once all items are iterated");
}

- (void)testBeingAbleToSetCurrentIteratorPositionThatIsBeforeTheCurrentOne
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    epubIterator = [DMePubItemIterator epubIteratorWithEpubManager:epubManager];
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator nextObject];
    [epubIterator goToItemWithPath:@"index3.html"];
    DMePubItem* epubItem = [epubIterator nextObject];
    XCTAssertEqualObjects([epubItem href], @"index4.html", @"Failed to skip to the forth item");
}

- (void)testResetingIteratorAfterReachingTheBegining
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    epubIterator = [DMePubItemIterator epubIteratorWithEpubManager:epubManager];
    [epubIterator goToItemWithPath:@"index3.html"];
    [epubIterator previousItem];
    [epubIterator previousItem];
    [epubIterator previousItem];
    DMePubItem* epubItem = [epubIterator nextObject];
    XCTAssertEqualObjects([epubItem href], @"index1.html", @"If the begining of the array is reached via the previousItem method, the iterator should be ready to return the first item if it is asked for the next object");
}

@end
