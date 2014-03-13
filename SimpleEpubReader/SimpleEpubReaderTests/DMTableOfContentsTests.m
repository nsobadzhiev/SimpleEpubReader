//
//  DMTableOfContentsTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/11/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTableOfContents.h"
#import "DMTableOfContentsItem.h"

@interface DMTableOfContentsTests : XCTestCase

@end

@implementation DMTableOfContentsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testAbilityToInstantiateTocParser
{
    NSData* tocData = [NSData data];
    XCTAssertNoThrow([[DMTableOfContents alloc] initWithData:tocData], @"Should be able to instantiate a TableOfContentsObject");
}

- (void)testAbilityToCreateNilTocInstance
{
    NSString* tocString = @"";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    XCTAssertNil(toc, @"If there is no valid XML in the data provided, DMTableOfContents should return nil");
}

- (void)testAbilityToCreateNonNilTocInstance
{
    NSString* tocString = @"<nav></nav>";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    XCTAssertNotNil(toc, @"Should be able to instantiate a TableOfContentsObject");
}

- (void)testRetrievingTocTitle
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:epub=\"http://www.idpf.org/2007/ops\" xml:lang=\"en\"	lang=\"en\">	<head>   <title>Accessible EPUB 3</title>    <link rel=\"stylesheet\" type=\"text/css\" href=\"css/epub.css\" />	</head> </html>";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    NSString* tocTitle = [toc title];
    XCTAssertEqualObjects(tocTitle, @"Accessible EPUB 3", @"%@ does not match the expected title - Accessible EPUB 3", tocTitle);
}

- (void)testRetrievingTocTopLevelItems
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <h2>Table of Contents</h2>    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    </ol>    </li>    <li><a href=\"ch01.xhtml\">1. Introduction</a>    </li>    </ol>    </nav>	</body>    </html>";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    NSArray* topItems = [toc topLevelItems];
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[topItems firstObject] name], @"Preface", @"%@ does not match the expected item name - Preface", [(DMTableOfContentsItem*)[topItems firstObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[topItems firstObject] path], @"pr01.xhtml", @"%@ does not match the expected item path - pr01.xhtml", [(DMTableOfContentsItem*)[topItems firstObject] path]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[topItems lastObject] name], @"1. Introduction", @"%@ does not match the expected item name - 1. Introduction", [(DMTableOfContentsItem*)[topItems firstObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[topItems lastObject] path], @"ch01.xhtml", @"%@ does not match the expected item path - ch01.xhtml", [(DMTableOfContentsItem*)[topItems firstObject] path]);
}

- (void)testRetrievingAllTocItems
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    <li><a href=\"pr01s05.xhtml\">Acknowledgments</a></li>    </ol>    </li>    </ol>    </nav>	</body>    </html>";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    NSArray* tocItems = [toc allItems];
    XCTAssertEqual(tocItems.count, 3, @"%lu is a wrong toc items count", (unsigned long)tocItems.count);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems firstObject] name], @"Preface", @"%@ does not match the expected item name", [(DMTableOfContentsItem*)[tocItems firstObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems firstObject] path], @"pr01.xhtml", @"%@ does not match the expected item path", [(DMTableOfContentsItem*)[tocItems firstObject] path]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems objectAtIndex:1] name], @"Conventions Used in This Book", @"%@ does not match the expected item name", [(DMTableOfContentsItem*)[tocItems objectAtIndex:1] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems objectAtIndex:1] path], @"pr01.xhtml#I_sect1_d1e137", @"%@ does not match the expected item path", [(DMTableOfContentsItem*)[tocItems objectAtIndex:1] path]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems lastObject] name], @"Acknowledgments", @"%@ does not match the expected item name", [(DMTableOfContentsItem*)[tocItems lastObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocItems lastObject] path], @"pr01s05.xhtml", @"%@ does not match the expected item path", [(DMTableOfContentsItem*)[tocItems lastObject] path]);
}

- (void)testRetrievingTocItemsLevel
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    <li><a href=\"pr01s05.xhtml\">Acknowledgments</a></li>    </ol>    </li>    </ol>    </nav>	</body>    </html>";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    NSArray* tocItems = [toc allItems];
    XCTAssertEqual([(DMTableOfContentsItem*)[tocItems firstObject] level], 1, @"This item should be from level 0 in the toc list");
    XCTAssertEqual([(DMTableOfContentsItem*)[tocItems objectAtIndex:1] level], 2, @"This item should be from level 1 in the toc list");
    XCTAssertEqual([(DMTableOfContentsItem*)[tocItems objectAtIndex:2] level], 2, @"This item should be from level 1 in the toc list");
}

- (void)testRetrievingParentForItem
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    <li><a href=\"pr01s05.xhtml\">Acknowledgments</a></li>    </ol>    </li>    </ol>    </nav>	</body>    </html>";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    NSArray* tocItems = [toc allItems];
    DMTableOfContentsItem* parent = [tocItems firstObject];
    XCTAssertEqualObjects(parent, [(DMTableOfContentsItem*)[tocItems objectAtIndex:1] parent], @"Item 1 does not have the right parent");
    XCTAssertEqualObjects(parent, [(DMTableOfContentsItem*)[tocItems objectAtIndex:2] parent], @"Item 2 does not have the right parent");
}

- (void)testRetrievingTocItemsForParent
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    <li><a href=\"pr01s05.xhtml\">Acknowledgments</a></li>    </ol>    </li>    </ol>    </nav>	</body>    </html>";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    NSArray* tocItems = [toc allItems];
    NSArray* tocChildren = [toc subItemsForItem:[tocItems firstObject]];
    XCTAssertEqual(tocChildren.count, 2, @"%lu is a wrong toc subitems count", (unsigned long)tocItems.count);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocChildren firstObject] name], @"Conventions Used in This Book", @"%@ does not match the expected item name", [(DMTableOfContentsItem*)[tocItems objectAtIndex:1] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocChildren firstObject] path], @"pr01.xhtml#I_sect1_d1e137", @"%@ does not match the expected item path", [(DMTableOfContentsItem*)[tocItems objectAtIndex:1] path]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocChildren lastObject] name], @"Acknowledgments", @"%@ does not match the expected item name", [(DMTableOfContentsItem*)[tocItems lastObject] name]);
    XCTAssertEqualObjects([(DMTableOfContentsItem*)[tocChildren lastObject] path], @"pr01s05.xhtml", @"%@ does not match the expected item path", [(DMTableOfContentsItem*)[tocItems lastObject] path]);
}

- (void)testRetrievingItemsForParentWithNoChildren
{
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    <li><a href=\"pr01s05.xhtml\">Acknowledgments</a></li>    </ol>    </li>    </ol>    </nav>	</body>    </html>";
    NSData* tocData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* toc = [[DMTableOfContents alloc] initWithData:tocData];
    NSArray* tocItems = [toc allItems];
    NSArray* tocChildren = [toc subItemsForItem:[tocItems lastObject]];
    XCTAssertNil(tocChildren, @"A leaf item should ahve no children");
}

@end
