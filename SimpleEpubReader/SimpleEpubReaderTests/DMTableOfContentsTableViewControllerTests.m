//
//  DMTableOfContentsTableViewControllerTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/16/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTableOfContentsTableViewController.h"
#import "DMTableOfContentsDataSource.h"
#import "DMTestableTableOfContentsDataSource.h"

@interface DMTableOfContentsTableViewControllerTests : XCTestCase
{
    DMTableOfContentsTableViewController* tocController;
}

@end

@implementation DMTableOfContentsTableViewControllerTests

- (void)setUp
{
    [super setUp];
    tocController = [[DMTableOfContentsTableViewController alloc] initWithEpubPath:nil];
}

- (void)tearDown
{
    tocController = nil;
    [super tearDown];
}

- (void)testCreatingATocTableController
{
    // the controller is already initialized in the setup method - just
    // verify that it's not nil
    XCTAssertNotNil(tocController, @"Initializing a TOC controller should not return a nil object");
}

- (void)testHavingTheRightDataSource
{
    XCTAssert([tocController.tableView.dataSource isKindOfClass:[DMTableOfContentsDataSource class]]);
}

- (void)testHavingTheRightDelegate
{
    XCTAssert([tocController.tableView.delegate isKindOfClass:[DMTableOfContentsDataSource class]]);
}

- (void)testBeingADMTableOfContentsDataSourceDelegate
{
    XCTAssertTrue([tocController conformsToProtocol:@protocol(DMTableOfContentsDelegate)], @"Should implement the DMTableOfContentsDelegate protocol");
}

@end
