//
//  DMePubURLProtocol.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/2/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubURLProtocol.h"

static NSString* const kEpubUrlScheme = @"epub";
static NSString* kEpubUrlPrefix = @"epub:/";

@interface DMePubFileManager ()

- (BOOL)openEpubWithUrl:(NSURL*)url;
- (void)sendResponseWithData:(NSData*)data
                       error:(NSError**)error;

- (BOOL)handleError:(NSError*)error;
- (void)handleResponse:(NSData*)data;
- (void)handleResponseData:(NSData*)data;
- (void)handleRequestFinished;

@end

@implementation DMePubURLProtocol

- (instancetype)initWithRequest:(NSURLRequest *)request 
                 cachedResponse:(NSCachedURLResponse *)cachedResponse 
                         client:(id<NSURLProtocolClient>)client
{
    self = [super initWithRequest:request
                   cachedResponse:cachedResponse 
                           client:client];
    if (self)
    {
        if ([self openEpubWithUrl:request.URL])
        {
            
        }
        else
        {
            return nil;
        }
    }
    return self;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request 
{
    NSURL* requestUrl = request.URL;
    NSString* urlScheme = requestUrl.scheme;
    return [urlScheme isEqualToString:kEpubUrlScheme];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request 
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b 
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSString* filePath = [self epubFilePath];
    NSString* zipPath = [self zipPath];
    [epubManager openEpubWithPath:filePath];
    NSError* zipError = nil;
    NSData* fileData = [epubManager dataForFileAtPath:zipPath
                                                error:&zipError];
    [self sendResponseWithData:fileData
                         error:&zipError];
}

- (void)stopLoading
{
    // TODO: Make sure no delegate methods are called beyond this point. There 
    // is no async work done here, but still all subsequent delegate method
    // calls should be prevented.
}

- (BOOL)openEpubWithUrl:(NSURL*)url
{
    requestUrl = url;
    epubManager = [[DMePubManager alloc] initWithEpubPath:[self epubFilePath]];
    return YES;
}

- (void)sendResponseWithData:(NSData*)data
                       error:(NSError**)error
{
    if ([self handleError:*error] == NO)
    {
        [self handleResponse:data];
        [self handleResponseData:data];
        [self handleRequestFinished];
    }
}

- (BOOL)handleError:(NSError*)error
{
    if (error != nil)
    {
        [self.client URLProtocol:self
                didFailWithError:error];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)handleResponse:(NSData*)data
{
    NSString* mediaType = [epubManager mimeTypeForPath:[self zipPath]];
    NSURLResponse* response = [[NSURLResponse alloc] initWithURL:requestUrl
                                                        MIMEType:mediaType
                                           expectedContentLength:data.length
                                                textEncodingName:@"utf-8"];
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void)handleResponseData:(NSData*)data
{
    [self.client URLProtocol:self
                 didLoadData:data];
}

- (void)handleRequestFinished
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (NSString*)epubFilePath
{
    NSString* urlString = [requestUrl absoluteString];
    urlString = [urlString stringByReplacingOccurrencesOfString:kEpubUrlPrefix
                                                     withString:@""];
    urlString = [urlString stringByRemovingPercentEncoding];
    while (urlString.length > 0)
    {
        // try to open the epub at that path
        [epubManager openEpubWithPath:urlString];
        if ([epubManager isOpen] == YES)
        {
            if ([urlString characterAtIndex:urlString.length - 1] == '/')
            {
                return [urlString substringToIndex:urlString.length - 1];
            }
            else
            {
                return urlString;
            }
        }
        else
        {
            NSString* lastComponent = [urlString lastPathComponent];
            NSRange lastComponentRange = [urlString rangeOfString:lastComponent];
            NSString* urlWithoutLastComponent = [urlString substringToIndex:lastComponentRange.location];
            urlString = urlWithoutLastComponent;
        }
    }
    return nil;
}

- (NSString*)zipPath
{
    NSString* fullUrl = [[requestUrl absoluteString] stringByRemovingPercentEncoding];
    NSString* epubFilePath = [self epubFilePath];
    NSString* zipPath = nil;
    if (epubFilePath.length > 0)
    {
        NSRange epubFileRange = [fullUrl rangeOfString:epubFilePath];
        // The +1 in the next statement makes sure the path separator ("/") is not
        // included in the result
        NSUInteger zipPathStartIndex = epubFileRange.location + epubFileRange.length + 1;
        if (epubFileRange.location != NSNotFound && zipPathStartIndex < fullUrl.length)
        {
            zipPath = [fullUrl substringFromIndex:zipPathStartIndex];
        }
    }
    return zipPath;
}

@end
