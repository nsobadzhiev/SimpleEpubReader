//
//  DMTableOfContentsDelegateTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTestableTableOfContentsDataSource.h"
#import "DMTestableePubManager.h"

@interface DMTableOfContentsDelegateTests : XCTestCase <DMTableOfContentsDelegate>
{
    DMTestableTableOfContentsDataSource* dataSource;
    NSString* selectedResourcePath;
}

@end

@implementation DMTableOfContentsDelegateTests

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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConformanceToUITableViewDelegate
{
    XCTAssertTrue([DMTableOfContentsDataSource conformsToProtocol:@protocol(UITableViewDelegate)], @"DMTableOfContentsDataSource should conform to UITableViewDelegate");
}

- (void)testCellSelection
{
    dataSource.delegate = self;
    [dataSource tableView:nil
  didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 
                                             inSection:0]];
    XCTAssertEqualObjects(selectedResourcePath, @"pr01.xhtml", @"When a cell is selected the data source should pass the selected file's path to it's delegate");
}

#pragma mark PrivateMethods

- (void)tableOfContentsDataSource:(DMTableOfContentsDataSource*)source
                didSelectFilePath:(NSString*)path
{
    selectedResourcePath = path;
}

@end
