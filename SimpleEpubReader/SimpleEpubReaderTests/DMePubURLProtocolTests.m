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
#import "DMTestableePubManager.h"

@interface DMePubURLProtocolTests : XCTestCase <NSURLProtocolClient>
{
    DMTestableePubURLProtocol* urlProtocol;
    NSURLRequest* request;
    NSURLResponse* receivedResponse;
    NSError* responseError;
    BOOL requestFinished;
    NSData* receivedClientData;
}

@end

@implementation DMePubURLProtocolTests

#pragma mark - NSURLProtocolClient

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveResponse:(NSURLResponse *)response cacheStoragePolicy:(NSURLCacheStoragePolicy)policy
{
    receivedResponse = response;
}

- (void)URLProtocol:(NSURLProtocol *)protocol didLoadData:(NSData *)data
{
    receivedClientData = data;
}

- (void)URLProtocolDidFinishLoading:(NSURLProtocol *)protocol
{
    requestFinished = YES;
}

- (void)URLProtocol:(NSURLProtocol *)protocol didFailWithError:(NSError *)error
{
    responseError = error;
}

- (void)URLProtocol:(NSURLProtocol *)protocol didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
}

- (void)URLProtocol:(NSURLProtocol *)protocol didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
}

- (void)URLProtocol:(NSURLProtocol *)protocol wasRedirectedToRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    
}

- (void)URLProtocol:(NSURLProtocol *)protocol cachedResponseIsValid:(NSCachedURLResponse *)cachedResponse
{
    
}

- (void)setUp
{
    [super setUp];
    NSURL* epubUri = [NSURL URLWithString:@"epub://testPath/testEpub.epub"];
    request = [NSURLRequest requestWithURL:epubUri];
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:request
                                                      cachedResponse:nil 
                                                              client:nil];
    receivedResponse = nil;
    responseError = nil;
    requestFinished = NO;
    receivedClientData = nil;
}

- (void)tearDown
{
    receivedClientData = nil;
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

- (void)testFindingTheEpubFilePath
{
    DMTestableArchive* archiver = [[DMTestableArchive alloc] init];
    [archiver setFakeEntries:[NSArray array]];
    NSString* expectedPath = @"/path/to/zip/file";
    archiver.zipLocation = expectedPath;
    NSString* fullPath = @"epub://path/to/zip/file/extra/components/";
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:fullPath];
    DMTestableePubFileManager* epubFilesManager = [[DMTestableePubFileManager alloc] initWithEpubPath:fullPath];
    epubFilesManager.archiver = archiver;
    epubManager.fileManager = epubFilesManager;
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullPath]] 
                                                      cachedResponse:nil 
                                                              client:nil];
    urlProtocol.epubFileManager = epubManager;
    NSString* epubPath = urlProtocol.epubPath;
    XCTAssertEqualObjects(epubPath, expectedPath, @"DMePubURLProtocol should be able to distinguish between the file path and the path insede the zip");
}

- (void)testFindingTheZipFilePath
{
    DMTestableArchive* archiver = [[DMTestableArchive alloc] init];
    [archiver setFakeEntries:[NSArray array]];
    NSString* expectedPath = @"/path/to/zip/file";
    archiver.zipLocation = expectedPath;
    NSString* expectedZipPath = @"extra/components/component.xhtml";
    NSString* fullPath = [expectedPath stringByAppendingPathComponent:expectedZipPath];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:fullPath];
    DMTestableePubFileManager* epubFilesManager = [[DMTestableePubFileManager alloc] initWithEpubPath:fullPath];
    epubFilesManager.archiver = archiver;
    epubManager.fileManager = epubFilesManager;
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullPath]] 
                                                      cachedResponse:nil 
                                                              client:nil];
    urlProtocol.epubFileManager = epubManager;
    NSString* zipPath = urlProtocol.zipPath;
    XCTAssertEqualObjects(zipPath, expectedZipPath, @"DMePubURLProtocol should be able to distinguish between the file path and the path insede the zip");
}

- (void)testGettingAnEmptyZipPath
{
    DMTestableArchive* archiver = [[DMTestableArchive alloc] init];
    [archiver setFakeEntries:[NSArray array]];
    NSString* expectedPath = @"/path/to/zip/file";
    archiver.zipLocation = expectedPath;
    NSString* expectedZipPath = @"";
    NSString* fullPath = [expectedPath stringByAppendingPathComponent:expectedZipPath];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:fullPath];
    DMTestableePubFileManager* epubFilesManager = [[DMTestableePubFileManager alloc] initWithEpubPath:fullPath];
    epubFilesManager.archiver = archiver;
    epubManager.fileManager = epubFilesManager;
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullPath]] 
                                                      cachedResponse:nil 
                                                              client:nil];
    urlProtocol.epubFileManager = epubManager;
    XCTAssertNoThrow(urlProtocol.zipPath, @"Even if the zip path is empty, no exception should be allowed to be thrown");
}

- (void)testAbilityToCallStartLoading
{
    XCTAssertNoThrow([urlProtocol startLoading], @"There should be a startLoading method available");
}

- (void)testStartLoadingIsFetchingData
{
    DMTestableArchive* archiver = [[DMTestableArchive alloc] init];
    [archiver setFakeEntries:[NSArray array]];
    NSString* expectedPath = @"/path/to/zip/file";
    archiver.zipLocation = expectedPath;
    NSString* expectedZipPath = @"extra/components/component.xhtml";
    NSString* fullPath = [expectedPath stringByAppendingPathComponent:expectedZipPath];
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:fullPath];
    DMTestableePubFileManager* epubFilesManager = [[DMTestableePubFileManager alloc] initWithEpubPath:fullPath];
    NSData* hardcodedData = [NSData data];
    epubFilesManager.hardcodedZipData = hardcodedData;
    epubFilesManager.archiver = archiver;
    epubManager.fileManager = epubFilesManager;
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullPath]] 
                                                      cachedResponse:nil 
                                                              client:self];
    urlProtocol.epubFileManager = epubManager;
    
    [urlProtocol startLoading];
    XCTAssertEqualObjects(hardcodedData, receivedClientData, @"DMePubURLProtocol should pass the zip data to it's client");
}

- (void)testReceivingResponseObject
{
    DMTestableArchive* archiver = [[DMTestableArchive alloc] init];
    [archiver setFakeEntries:[NSArray array]];
    NSString* expectedPath = @"/path/to/zip/file";
    archiver.zipLocation = expectedPath;
    NSString* expectedZipPath = @"index.xhtml";
    NSString* fullPath = [expectedPath stringByAppendingPathComponent:expectedZipPath];
    DMTestableePubFileManager* epubFileManager = [[DMTestableePubFileManager alloc] initWithEpubPath:fullPath];
    NSData* hardcodedData = [NSData data];
    epubFileManager.hardcodedZipData = hardcodedData;
    epubFileManager.archiver = archiver;
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.xhtml\" media-type=\"media1\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:fullPath];
    epubManager.contentsXml = hardcodedContainer;
    epubManager.fileManager = epubFileManager;
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullPath]] 
                                                      cachedResponse:nil 
                                                              client:self];
    urlProtocol.epubFileManager = epubManager;
    [urlProtocol startLoading];
    XCTAssertEqualObjects(receivedResponse.MIMEType, @"media1", @"DMePubURLProtocol should create a response object and pass it to it's clinet via the URLProtocol:didReceiveResponse:cacheStoragePolicy:");
}

- (void)testReceivingResponseError
{
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"epub://path/to/zip/file"]] 
                                                      cachedResponse:nil 
                                                              client:self];
    [urlProtocol startLoading];
    XCTAssertNotNil(responseError, @"An error object should be returned from the delegate for missing files");
}

- (void)testReceivingRequestFinishedNotification
{
    DMTestableArchive* archiver = [[DMTestableArchive alloc] init];
    [archiver setFakeEntries:[NSArray array]];
    NSString* expectedPath = @"/path/to/zip/file";
    archiver.zipLocation = expectedPath;
    NSString* expectedZipPath = @"index.xhtml";
    NSString* fullPath = [expectedPath stringByAppendingPathComponent:expectedZipPath];
    DMTestableePubFileManager* epubFileManager = [[DMTestableePubFileManager alloc] initWithEpubPath:fullPath];
    NSData* hardcodedData = [NSData data];
    epubFileManager.hardcodedZipData = hardcodedData;
    epubFileManager.archiver = archiver;
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <package xmlns=\"http://www.idpf.org/2007/opf\" version=\"2.0\" unique-identifier=\"bookid\">    <metadata>    <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">My Book</dc:title>    <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>    <meta name=\"cover\" content=\"cover-image\"/>    </metadata>    <manifest>    <item id=\"id2778030\" href=\"index.xhtml\" media-type=\"media1\"/>   <item id=\"id2528567\" href=\"pr01.html\" media-type=\"application/xhtml+xml\"/>    </manifest>    <spine toc=\"ncxtoc\">    <itemref idref=\"id2778030\"/>    <itemref idref=\"id2528567\"/>    </spine>    </package>";
    DMTestableePubManager* epubManager = [[DMTestableePubManager alloc] initWithEpubPath:fullPath];
    epubManager.contentsXml = hardcodedContainer;
    epubManager.fileManager = epubFileManager;
    urlProtocol = [[DMTestableePubURLProtocol alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullPath]] 
                                                      cachedResponse:nil 
                                                              client:self];
    urlProtocol.epubFileManager = epubManager;
    [urlProtocol startLoading];
    XCTAssertTrue(requestFinished, @"The URL protocol should notify it's client that the request has finished by calling the URLProtocolDidFinishLoading: method");
}

@end
