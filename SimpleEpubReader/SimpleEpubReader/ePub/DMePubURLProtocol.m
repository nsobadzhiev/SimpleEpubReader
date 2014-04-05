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

- (BOOL)openEpubWithUrl:(NSURL*)url
{
    requestUrl = url;
    fileManager = [[DMePubFileManager alloc] initWithEpubPath:nil];
    return YES;
}

- (NSString*)epubFilePath
{
    NSString* urlString = [requestUrl absoluteString];
    urlString = [urlString stringByReplacingOccurrencesOfString:kEpubUrlPrefix
                                                     withString:@""];
    while (urlString.length > 0)
    {
        NSString* lastComponent = [urlString lastPathComponent];
        NSRange lastComponentRange = [urlString rangeOfString:lastComponent];
        NSString* urlWithoutLastComponent = [urlString substringToIndex:lastComponentRange.location];
        
        // try to open the epub at that path
        [fileManager openEpubWithPath:urlWithoutLastComponent];
        if (fileManager.fileOpen)
        {
            if ([urlWithoutLastComponent characterAtIndex:urlWithoutLastComponent.length - 1] == '/')
            {
                return [urlWithoutLastComponent substringToIndex:urlWithoutLastComponent.length - 1];
            }
            else
            {
                return urlWithoutLastComponent;
            }
        }
        else
        {
            urlString = urlWithoutLastComponent;
        }
    }
    return nil;
}

@end
