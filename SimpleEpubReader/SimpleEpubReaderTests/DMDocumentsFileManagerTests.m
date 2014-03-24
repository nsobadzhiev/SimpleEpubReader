//
//  DMDocumentsFileManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTestableDocumentsFileManager.h"
#import "DMFileSystemManager.h"
#import "DMTestableFileSystemManager.h"

@interface DMDocumentsFileManagerTests : XCTestCase
{
    DMTestableDocumentsFileManager* fileManager;
}

@end

@implementation DMDocumentsFileManagerTests

- (void)setUp
{
    [super setUp];
    fileManager = [DMTestableDocumentsFileManager new];
}

- (void)tearDown
{
    fileManager = nil;
    [super tearDown];
}

- (void)testAbilityToGetTheFileSystemManager
{
    id<DMFileSystemManager> fileSystemManager = fileManager.fileSystemManager;
    XCTAssertNotNil(fileSystemManager, @"DMDocumentsFileManager should create a file system manager by default");
}

- (void)testAbilityToSetTheFileSystemManager
{
    id<DMFileSystemManager> newFileManager = (id<DMFileSystemManager>)[NSFileManager new];
    fileManager.fileSystemManager = newFileManager;
    id<DMFileSystemManager> fileSystemManager = fileManager.fileSystemManager;
    XCTAssertEqualObjects(fileSystemManager, newFileManager, @"DMDocumentsFileManager should create a file system manager by default");
}

- (void)testFileSystemManagerImplementsProtocolMethods
{
    id<DMFileSystemManager> fileSystemManager = fileManager.fileSystemManager;
    XCTAssert([fileSystemManager respondsToSelector:@selector(contentsOfDirectoryAtPath:error:)], @"File system manager should implement the contentsOfDirectoryAtPath:error: methods");
    XCTAssert([fileSystemManager respondsToSelector:@selector(contentsAtPath:)], @"File system manager should implement the contentsAtPath: methods");
}

- (void)testListingAllFilesInTheDocumentsDirectory
{
    DMTestableFileSystemManager* fileSystemManager = [DMTestableFileSystemManager new];
    NSArray* files = @[@"File1", @"File2", @"File3"];
    fileSystemManager.directoryContents = files;
    fileManager.fileSystemManager = fileSystemManager;
    NSArray* docFiles = [fileManager allDocuments];
    XCTAssertEqualObjects(docFiles, files, @"Should be able to get all files inside the documents directory");
}

- (void)testListingAllFilesInTheDocumentsDirectoryHasTheRightPath
{
    DMTestableFileSystemManager* fileSystemManager = [DMTestableFileSystemManager new];
    fileManager.fileSystemManager = fileSystemManager;
    [fileManager allDocuments];
    NSString* searchDir = [fileSystemManager requestedDirPath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    XCTAssertEqualObjects(searchDir, documentsDirectory, @"Should be able to get all files inside the documents directory");
}

- (void)testReceivingTheCOntentsOfAFile
{
    DMTestableFileSystemManager* fileSystemManager = [DMTestableFileSystemManager new];
    NSData* fileContents = [@"test" dataUsingEncoding:NSUTF8StringEncoding];
    fileSystemManager.fileContents = fileContents;
    fileManager.fileSystemManager = fileSystemManager;
    NSData* contents = [fileManager contentsOfFile:@"testFile"];
    XCTAssertEqualObjects(contents, fileContents, @"Should be able to get the file contents given a file path");
}

@end
