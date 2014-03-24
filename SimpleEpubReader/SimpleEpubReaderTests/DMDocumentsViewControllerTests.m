//
//  DMDocumentsViewController.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMDocumentsViewController.h"
#import "DMDocumentsFileManager.h"
#import "DMTestableFileSystemManager.h"

@interface DMDocumentsViewControllerTests : XCTestCase
{
    DMDocumentsViewController* documentsController;
}

@end

@implementation DMDocumentsViewControllerTests

- (void)setUp
{
    [super setUp];
    DMTestableFileSystemManager* fileSystemManager = [DMTestableFileSystemManager new];
    NSArray* files = @[@"File1", @"File2", @"File3"];
    fileSystemManager.directoryContents = files;
    DMDocumentsFileManager* fileManager = [DMDocumentsFileManager new];
    fileManager.fileSystemManager = fileSystemManager;
    documentsController = [[UIStoryboard storyboardWithName:@"Main"
                                                     bundle:nil] instantiateViewControllerWithIdentifier:@"DocumentsController"];
    documentsController = [DMDocumentsViewController new];
    documentsController.fileManager = fileManager;
}

- (void)tearDown
{
    documentsController = nil;
    [super tearDown];
}

- (void)testDMDocumentsViewControllerIsATableViewController
{
    XCTAssert([documentsController isKindOfClass:[UITableViewController class]], @"DMDocumentsViewController should be a UITableViewController subclass");
}

- (void)testDMDocumentsViewControllerIsATableViewDataSource
{
    XCTAssert([documentsController conformsToProtocol:@protocol(UITableViewDataSource)], @"DMDocumentsViewController should be a UITableViewDataSource");
}

- (void)testDMDocumentsViewControllerIsATableViewDelegate
{
    XCTAssert([documentsController conformsToProtocol:@protocol(UITableViewDelegate)], @"DMDocumentsViewController should be a UITableViewDelegate");
}

- (void)testDMDocumentsViewControllerHasADmDocumentsFileManager
{
    DMDocumentsFileManager* documentsManager = documentsController.fileManager;
    XCTAssertNotNil(documentsManager, @"DMDocumentsViewController should have a file manager");
}

- (void)testReturningTheRightAmountOfCells
{
    NSUInteger numRows = [documentsController tableView:documentsController.tableView
                                  numberOfRowsInSection:0];
    XCTAssert(numRows == 3, @"There should have been three items in the table");
}

- (void)testReturningTheRightAmountOfSections
{
    NSUInteger numSections = [documentsController numberOfSectionsInTableView:documentsController.tableView];
    XCTAssert(numSections == 1, @"There should have been only one section");
}

- (void)testReturningCellsContainingTheRightFileName
{
    UITableViewCell* firstCell = [documentsController tableView:documentsController.tableView
                                          cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                   inSection:0]];
    XCTAssertEqualObjects(firstCell.textLabel.text, @"File1", @"The cell should have the file name as the title label text");
}

@end
