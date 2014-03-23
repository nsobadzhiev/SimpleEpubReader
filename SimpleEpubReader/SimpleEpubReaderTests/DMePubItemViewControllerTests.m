//
//  DMePubItemViewControllerTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMePubItemViewController.h"
#import "DMHtmlPageViewController.h"
#import "DMePubItem.h"

@interface DMePubItemViewControllerTests : XCTestCase

@end

@implementation DMePubItemViewControllerTests

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

- (void)testBeingAHtmlPageViewControllerSubclass
{
    DMePubItemViewController* epubItemController = [[DMePubItemViewController alloc] init];
    XCTAssertTrue([epubItemController isKindOfClass:[DMHtmlPageViewController class]], @"DMePubItemViewController should be a DMHtmlPageViewController subclass");
}

- (void)testRetrievingTheEpubItemDataAfterInit
{
    DMePubItem* item = [[DMePubItem alloc] initWithID:@"testID"];
    DMePubItemViewController* epubItemController = [[DMePubItemViewController alloc] initWithEpubItem:item
                                                                                       andEpubManager:nil];
    DMePubItem* retrievedItem = epubItemController.epubItem;
    XCTAssertEqualObjects(item, retrievedItem, @"Should be able to get the epub item after initializing");
}

- (void)testRetrievingTheEpubManagerAfterInit
{
    DMePubManager* manager = [[DMePubManager alloc] initWithEpubPath:nil];
    DMePubItemViewController* epubItemController = [[DMePubItemViewController alloc] initWithEpubItem:nil
                                                                                       andEpubManager:manager];
    DMePubManager* retrievedManager = epubItemController.epubManager;
    XCTAssertEqualObjects(manager, retrievedManager, @"Should be able to get the epub manager after initializing");
}

@end
