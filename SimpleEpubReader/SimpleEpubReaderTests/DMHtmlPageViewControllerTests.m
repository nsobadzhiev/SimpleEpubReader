//
//  DMHtmlPageViewControllerTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMHtmlPageViewController.h"

@interface DMHtmlPageViewControllerTests : XCTestCase
{
    DMHtmlPageViewController* htmlPageController;
}

@end

@implementation DMHtmlPageViewControllerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializingAnHtmlPageViewController
{
    XCTAssertNoThrow([[DMHtmlPageViewController alloc] initWithData:nil], @"Should be able to call initWithData: on %@", [[self class] description]);
}

- (void)testInitializingANonNilHtmlPageViewController
{
    htmlPageController = [[DMHtmlPageViewController alloc] initWithData:nil];
    XCTAssertNotNil(htmlPageController, @"DMHtmlPageViewController shouldn't be nil after initializing it");
}

- (void)testHtmlPageViewControllersViewIsAWebView
{
    htmlPageController = [[DMHtmlPageViewController alloc] initWithData:nil];
    XCTAssert([htmlPageController.view isKindOfClass:[UIWebView class]], @"DMHtmlPageViewController shouldn't be nil after initializing it");
}

- (void)testNavigationBeingDisabledForTheWebView
{
    htmlPageController = [[DMHtmlPageViewController alloc] initWithData:nil];
    UIWebView* webView = (UIWebView*)htmlPageController.view;
    XCTAssert(webView.canGoBack == NO, @"Going back should be disabled");
    XCTAssert(webView.canGoForward == NO, @"Going forward should be disabled");
}

- (void)testAbilityToSetFilePath
{
    htmlPageController = [[DMHtmlPageViewController alloc] initWithData:nil];
    XCTAssertNoThrow(htmlPageController.filePath = @"testPath", @"DMHtmlPageViewController should have a filePath property");
}

- (void)testWebViewDelegateIsHtmlPageViewController
{
    htmlPageController = [[DMHtmlPageViewController alloc] initWithData:nil];
    UIWebView* webView = (UIWebView*)htmlPageController.view;
    XCTAssertEqualObjects(webView.delegate, htmlPageController, @"The HTML page view controller should be a delegate to the web view");
}

//- (void)testHtmlPageViewControllerBlockingHyperlinks
//{
//    htmlPageController = [[DMHtmlPageViewController alloc] initWithData:nil];
//    BOOL willStartLoading = [htmlPageController webView:(UIWebView*)htmlPageController.view
//                             shouldStartLoadWithRequest:nil 
//                                         navigationType:UIWebViewNavigationTypeOther];
//    XCTAssertFalse(willStartLoading, @"The HTML page view controller should suppress hyperlinks within the document");
//}

@end
