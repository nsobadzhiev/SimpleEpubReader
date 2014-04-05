//
//  DMePubURLProtocolTests.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/2/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DMTestableePubURLProtocol.h"
#import "DMTestableArchive.h"
#import "DMTestableePubFileManager.h"

@interface DMePubURLProtocolTests : XCTestCase
{
    DMTestableePubURLProtocol* urlProtocol;
    NSURLRequest* request;
}

@end

@implementation DMePubURLProtocolTests

- (void)setUp
{
    [super setUp];
    NSURL* epubUri = [NSURL URLWithString:@"epub://testPath/testEpub.epub"];
    request = [NSURLRequest requestWithURL:epubUri];
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:request
                                                      cachedResponse:nil 
                                                              client:nil];
}

- (void)tearDown
{
    urlProtocol = nil;
    [super tearDown];
}

- (void)testCanInitWithRequestReturnsYesForEpubUrls
{
    NSURL* epubUri = [NSURL URLWithString:@"epub://testPath"];
    NSURLRequest* epubRequest = [NSURLRequest requestWithURL:epubUri];
    BOOL canHandleUrl = [DMePubURLProtocol canInitWithRequest:epubRequest];
    XCTAssertTrue(canHandleUrl, @"DMePubURLProtocol should be configured to handle the epub custom URL schema");
}

- (void)testCanInitWithRequestReturnsNoForNonEpubUrls
{
    NSURL* epubUri = [NSURL URLWithString:@"file://testPath"];
    NSURLRequest* fileRequest = [NSURLRequest requestWithURL:epubUri];
    BOOL canHandleUrl = [DMePubURLProtocol canInitWithRequest:fileRequest];
    XCTAssertFalse(canHandleUrl, @"DMePubURLProtocol should be configured to ignore URLs other than epub:// to avoid breaking them");
}

- (void)testReturningTheSameCanonicalRepresentationOfRequests
{
    // create a copy of the request because otherwise if the canonicalRequestForRequest
    // changes a property of the original request, the following check will pass wrongfully
    NSURLRequest* requestCopy = [request copy];
    NSURLRequest* canonicalRequest = [DMePubURLProtocol canonicalRequestForRequest:request];
    XCTAssertEqualObjects(requestCopy, canonicalRequest, @"DMePubURLProtocol should return the request unmodified when asked for it's canonical represesntation");
}

- (void)testRequestIsCacheEquivalentCallsSuper
{
    NSURL* secondUri = [NSURL URLWithString:@"epub://secondPath/testEpub.epub"];
    NSURLRequest* secondRequest = [NSURLRequest requestWithURL:secondUri];
    XCTAssertTrue(([DMePubURLProtocol requestIsCacheEquivalent:request toRequest:secondRequest] == 
                  [NSURLProtocol requestIsCacheEquivalent:request toRequest:secondRequest]), 
                  @"DMePubURLProtocol should have the same behaviour as it's superclass in the requestIsCacheEquivalent: method");
}

- (void)testHasAEpubFileManager
{
    DMePubFileManager* fileManager = urlProtocol.epubFileManager;
    XCTAssertNotNil(fileManager, @"DMePubURLProtocol should have an initialized DMePubFileManager");
}

- (void)testFindingTheEpubFilePath
{
    DMTestableArchive* archiver = [[DMTestableArchive alloc] init];
    [archiver setFakeEntries:[NSArray array]];
    NSString* expectedPath = @"/path/to/zip/file";
    archiver.zipLocation = expectedPath;
    DMTestableePubFileManager* fileManager = [[DMTestableePubFileManager alloc] initWithEpubPath:@"epub://path/to/zip/file/extra/components/"];
    fileManager.archiver = archiver;
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"epub://path/to/zip/file/extra/components/"]] 
                                                      cachedResponse:nil 
                                                              client:nil];
    urlProtocol.epubFileManager = fileManager;
    NSString* epubPath = urlProtocol.epubPath;
    XCTAssertEqualObjects(epubPath, expectedPath, @"DMePubURLProtocol should be able to distinguish between the file path and the path insede the zip");
}

@end
