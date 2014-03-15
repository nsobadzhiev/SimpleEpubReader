//
//  DMTableOfContentsDataSource.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/14/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTestableTableOfContentsDataSource.h"
#import "DMTestableePubManager.h"

@interface DMTableOfContentsDataSourceTests : XCTestCase
{
    DMTestableTableOfContentsDataSource* dataSource;
}

@end

@implementation DMTableOfContentsDataSourceTests

- (void)setUp
{
    [super setUp];
    dataSource = [[DMTestableTableOfContentsDataSource alloc] initWithEpubPath:nil];
    NSString* tocString = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>    <!DOCTYPE html>    <html>	<body>    <nav epub:type=\"toc\" id=\"toc\">    <ol>    <li><a href=\"pr01.xhtml\">Preface</a>    <ol>    <li><a href=\"pr01.xhtml#I_sect1_d1e137\">Conventions Used in This Book</a></li>    <li><a href=\"pr01s05.xhtml\">Acknowledgments</a></li>    </ol>    </li>    </ol>    </nav>	</body>    </html>";
    NSData* containerData = [tocString dataUsingEncoding:NSUTF8StringEncoding];
    DMTableOfContents* navigationParser = [[DMTableOfContents alloc] initWithData:containerData];
    [(DMTestableePubManager*)dataSource.epubManagerObject setNavParser:navigationParser];
}

- (void)tearDown
{
    dataSource = nil;
    [super tearDown];
}

- (void)testDataSourceInitializesEpubManager
{
    XCTAssertNotNil(dataSource.epubManagerObject, @"Data source should create an epubManager instance upon initialization");
}

- (void)testConformanceToUITableViewDataSource
{
    XCTAssertTrue([DMTableOfContentsDataSource conformsToProtocol:@protocol(UITableViewDataSource)], @"DMTableOfContentsDataSource should conform to UITableViewDataSource");
}

- (void)testConformanceToUITableViewDelegate
{
    XCTAssertTrue([DMTableOfContentsDataSource conformsToProtocol:@protocol(UITableViewDelegate)], @"DMTableOfContentsDataSource should conform to UITableViewDelegate");
}

- (void)testReturningTheRightAmountOfSections
{
    NSUInteger numSections = [dataSource numberOfSectionsInTableView:nil];
    XCTAssertTrue(numSections == 1, @"There should be only one section");
}

- (void)testReturningTheRightAmountOfCells
{
    NSUInteger numRows = [dataSource tableView:nil numberOfRowsInSection:0];
    XCTAssertTrue(numRows == 3, @"There should be three items in the TOC");
}

- (void)testCreatingTocCellsWithCorrectClass
{
    UITableViewCell* tocCell = [dataSource tableView:nil
                               cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 
                                                                        inSection:0]];
    XCTAssertTrue([tocCell isMemberOfClass:[UITableViewCell class]], @"Toc cells should be objects of class UITableViewCell");
}

- (void)testCreatingTocCellOne
{
    UITableViewCell* tocCell = [dataSource tableView:nil
                               cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 
                                                                        inSection:0]];
    XCTAssertEqualObjects(@"Preface", tocCell.textLabel.text, @"The cell title should match the first entry in the navigation document");
}

- (void)testCreatingTocCellTwo
{
    UITableViewCell* tocCell = [dataSource tableView:nil
                               cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 
                                                                        inSection:0]];
    XCTAssertEqualObjects(@"Conventions Used in This Book", tocCell.textLabel.text, @"The cell title should match the first entry in the navigation document");
}

@end
