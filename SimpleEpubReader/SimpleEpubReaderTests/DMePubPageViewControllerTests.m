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
#import "DMTestableePubPageViewController.h"
#import "DMTableOfContentsTableViewController.h"
#import "DMBookmarkManager.h"

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

- (void)testTheFirstViewControllerIsTableOfContents
{
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:nil];
    [pageController view];
    NSObject* viewController = [pageController.pageViewController.viewControllers firstObject];
    XCTAssertTrue([viewController isKindOfClass:[DMTableOfContentsTableViewController class]], @"Initially, the table of contents should be shown as the first page");
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

- (void)testEpubPageViewControllerChangesIteratorsWhenChangingEpubManagers
{
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    DMTestableePubPageViewController* epubPageController = [[DMTestableePubPageViewController alloc] initWithEpubManager:epubManager];
    DMePubItemIterator* firstIterator = epubPageController.iterator;
    epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubPageController.epubManager = epubManager;
    DMePubItemIterator* secondIterator = epubPageController.iterator;
    XCTAssertNotEqual(firstIterator, secondIterator, @"DMePubPageViewController should create a new iterator every time it changes it's epub manager");
}

- (void)testEpubPageViewControllerAddsPageControllerAsSubview
{
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:epubManager];
    [pageController view];    // force it to load it's view
    XCTAssert([pageController.view.subviews containsObject:pageController.pageViewController.view], @"DMePubPageViewController should add a UIPageViewController's view as subview");
}

- (void)testEpubPageViewControllerPopulatesPageController
{
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:epubManager];
    [pageController view];    // force it to load it's view
    XCTAssert(pageController.pageViewController.viewControllers.count != 0, @"DMePubPageViewController should populate it's UIPageViewController with screens");
}

- (void)testEpubPageViewControllerSetsNavigationControllerAsOpaque
{
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:nil];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:pageController];
    [navController view];
    [pageController view];
    XCTAssertFalse(pageController.navigationController.navigationBar.translucent, @"The navigation bar should not be translucent so that the page controller does not draw behind it");
}

- (void)testReturningNilAfterLastPage
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:epubManager];
    DMePubItem* epubItem = [DMePubItem ePubItemWithId:@"5" 
                                            mediaType:@"application/xhtml+xml"
                                                 href:@"index5.html"];
    DMePubItemViewController* itemController = [[DMePubItemViewController alloc] initWithEpubItem:epubItem
                                                                                   andEpubManager:epubManager];
    DMePubItemViewController* nextController = (DMePubItemViewController*)[pageController pageViewController:pageController.pageViewController
                                                                           viewControllerAfterViewController:itemController];
    XCTAssertNil(nextController, @"Should return nil after the last page to prevent UIPageViewController from trying to display additional pages");
}

- (void)testFirstPageIsTableOfContents
{
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:nil];
    [pageController view];
    UIViewController* firstPage = [pageController.pageViewController.viewControllers firstObject];
    XCTAssertTrue([firstPage isKindOfClass:[DMTableOfContentsTableViewController class]], @"Should always set the table of contents as the first page");
}

- (void)testReturningToTableOfContentsAfterReachingTheBeginingOfTheBook
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:nil];
    epubManager.contentsXmlParser = containerParser;
    pageController = [[DMePubPageViewController alloc] initWithEpubManager:epubManager];
    [pageController view];
    DMePubItem* epubItem = [DMePubItem ePubItemWithId:@"2" 
                                            mediaType:@"application/xhtml+xml"
                                                 href:@"index2.html"];
    DMePubItemViewController* itemController = [[DMePubItemViewController alloc] initWithEpubItem:epubItem
                                                                                   andEpubManager:epubManager];
    UIViewController* nextController = (DMePubItemViewController*)[pageController pageViewController:pageController.pageViewController
                                                                          viewControllerBeforeViewController:itemController];
    nextController = (DMePubItemViewController*)[pageController pageViewController:pageController.pageViewController
                                                viewControllerBeforeViewController:nextController];
    XCTAssertTrue([nextController isKindOfClass:[DMTableOfContentsTableViewController class]], @"Should return to table of contents after reaching the first page");
}

- (void)testSavingABookmarkAfterTurningPage
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSString* epubPath = @"epubPath";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:epubPath];
    epubManager.contentsXmlParser = containerParser;
    DMTestableePubPageViewController* pageViewController = [[DMTestableePubPageViewController alloc] initWithEpubManager:epubManager];
    DMePubItem* epubItem = [DMePubItem ePubItemWithId:@"2" 
                                            mediaType:@"application/xhtml+xml"
                                                 href:@"index2.html"];
    DMePubItemViewController* itemController = [[DMePubItemViewController alloc] initWithEpubItem:epubItem
                                                                                   andEpubManager:epubManager];
    [pageViewController pageViewController:pageViewController.pageViewController
        viewControllerBeforeViewController:itemController];
    DMBookmarkManager* bookmarkManager = pageViewController.bookmarkManager;
    DMBookmark* bookmark = [[bookmarkManager allBookmarks] firstObject];
    XCTAssertEqualObjects(bookmark.fileSection, @"index1.html", @"Should save a bookmark whenever a page is turned");
}

- (void)testLoadingFromABookmark
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSString* epubPath = @"epubPath";
    NSString* epubSection = @"index2.html";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:epubPath];
    epubManager.contentsXmlParser = containerParser;
    DMBookmark* bookmark = [[DMBookmark alloc] initWithFileName:epubPath
                                                        section:epubSection
                                                       position:nil];
    DMBookmarkManager* bookmarkManager = [[DMBookmarkManager alloc] init];
    [bookmarkManager addBookmark:bookmark];
    DMTestableePubPageViewController* pageViewController = [[DMTestableePubPageViewController alloc] initWithEpubManager:epubManager];
    pageViewController.bookmarkManager = bookmarkManager;
    [pageViewController view];
    [pageViewController loadBookmarkPosition];

    DMePubItemViewController* loadedPage = [pageViewController.pageViewController.viewControllers firstObject];
    DMePubItem* epubItem = loadedPage.epubItem;
    XCTAssertEqualObjects(epubItem.href, epubSection, @"Should loaded the added bookmark and switch directly to it");
}

- (void)testLoadingFromABookmarkAutomatically
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package>    	<metadata>     <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>       	</metadata> <manifest>    <item id=\"1\" href=\"index1.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"2\" href=\"index2.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"3\" href=\"index3.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"4\" href=\"index4.html\" media-type=\"application/xhtml+xml\"/>      <item id=\"5\" href=\"index5.html\" media-type=\"application/xhtml+xml\"/> 	</manifest>  	<spine toc=\"ncxtoc\">        <itemref idref=\"1\"/>     <itemref idref=\"2\"/>     <itemref idref=\"3\"/>     <itemref idref=\"4\"/>     <itemref idref=\"5\"/>    	</spine>        </package>";
    NSString* epubPath = @"epubPath";
    NSString* epubSection = @"index2.html";
    NSData* containerData = [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
    DMContainerFileParser* containerParser = [[DMContainerFileParser alloc] initWithData:containerData];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:epubPath];
    epubManager.contentsXmlParser = containerParser;
    DMBookmark* bookmark = [[DMBookmark alloc] initWithFileName:epubPath
                                                        section:epubSection
                                                       position:nil];
    DMBookmarkManager* bookmarkManager = [[DMBookmarkManager alloc] init];
    [bookmarkManager addBookmark:bookmark];
    DMTestableePubPageViewController* pageViewController = [[DMTestableePubPageViewController alloc] initWithEpubManager:epubManager];
    pageViewController.bookmarkManager = bookmarkManager;
    [pageViewController view];
    
    DMePubItemViewController* loadedPage = [pageViewController.pageViewController.viewControllers firstObject];
    DMePubItem* epubItem = loadedPage.epubItem;
    XCTAssertEqualObjects(epubItem.href, epubSection, @"Should loaded the added bookmark and switch directly to it");
}

@end
