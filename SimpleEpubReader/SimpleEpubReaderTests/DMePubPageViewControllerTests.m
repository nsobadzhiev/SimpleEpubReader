//
//  DMePubPageVIewControllerTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMePubPageViewController.h"
#import "DMTestableePubManager.h"
#import "DMePubItemViewController.h"

@interface DMePubPageViewControllerTests : XCTestCase
{
    DMePubPageViewController* pageController;
}

@end

@implementation DMePubPageViewControllerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitializingAnEpubPageViewController
{
    XCTAssertNoThrow([[DMePubPageViewController alloc] initWithEpubManager:nil], @"Should be able to initialize a DMePubPageViewController without an exception being thrown");
}

- (void)testInitializingAnNonNilEpubPageViewController
{
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:nil];
    XCTAssertNotNil(pageController, @"Calling the initWithEpubManager: methods should result in an non-nil object to be returned");
}

- (void)testEpubPageViewControllerHasPageViewController
{
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:nil];
    [pageController view];  // force the controller to initialize it's view
    XCTAssertNotNil(pageController.pageViewController, @"DMePubPageViewController should contain an UIPageViewController");
}

- (void)testEpubPageViewControllerHasEpubManager
{
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:[[DMePubManager alloc] initWithEpubPath:nil]];
    XCTAssertNotNil(pageController.epubManager, @"DMePubPageViewController should contain a DMePubManager");
}

- (void)testEpubPageViewControllerIsAPageViewControllerDataSource
{
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:nil];
    XCTAssert([pageController conformsToProtocol:@protocol(UIPageViewControllerDataSource)], @"DMePubPageViewController should be a UIPageViewControllerDataSource");
}

- (void)testEpubPageViewControllerReturnsEpubItemViewControllersFromTheDataSourceMethods
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:epubManager];
    DMePubItem* epubItem = [DMePubItem ePubItemWithId:@"1" 
                                            mediaType:@"application/xhtml+xml"
                                                 href:@"index1.html"];
    DMePubItemViewController* itemController = [[DMePubItemViewController alloc] initWithEpubItem:epubItem
                                                                                   andEpubManager:epubManager];
    UIViewController* nextController = [pageController pageViewController:pageController.pageViewController
     viewControllerAfterViewController:itemController];
    XCTAssert([nextController isKindOfClass:[DMePubItemViewController class]], @"DMePubPageViewController should always return DMePubItemViewController objects in it's data source methods");
}

- (void)testEpubPageViewControllerReturnsTheNextEpubItemViewController
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:epubManager];
    DMePubItem* epubItem = [DMePubItem ePubItemWithId:@"1" 
                                            mediaType:@"application/xhtml+xml"
                                                 href:@"index1.html"];
    DMePubItemViewController* itemController = [[DMePubItemViewController alloc] initWithEpubItem:epubItem
                                                                                   andEpubManager:epubManager];
    DMePubItemViewController* nextController = (DMePubItemViewController*)[pageController pageViewController:pageController.pageViewController
                                                                           viewControllerAfterViewController:itemController];
    DMePubItem* nextItem = nextController.epubItem;
    XCTAssertEqualObjects(nextItem.itemID, @"2", @"DMePubPageViewController should return a view controller containing the next epub item");
}

- (void)testEpubPageViewControllerReturnsThePreviousEpubItemViewController
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:epubManager];
    DMePubItem* epubItem = [DMePubItem ePubItemWithId:@"2" 
                                            mediaType:@"application/xhtml+xml"
                                                 href:@"index2.html"];
    DMePubItemViewController* itemController = [[DMePubItemViewController alloc] initWithEpubItem:epubItem
                                                                                   andEpubManager:epubManager];
    DMePubItemViewController* nextController = (DMePubItemViewController*)[pageController pageViewController:pageController.pageViewController
                                                                          viewControllerBeforeViewController:itemController];
    DMePubItem* nextItem = nextController.epubItem;
    XCTAssertEqualObjects(nextItem.itemID, @"1", @"DMePubPageViewController should return a view controller containing the previous epub item");
}

@end
