//
//  DMePubManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubManager.h"

@interface DMePubManager ()

- (DMRootFileParser*)rootFileParser;

@end

@implementation DMePubManager

- (instancetype)initWithEpubPath:(NSString*)epubPath
{
    self = [super init];
    if (self)
    {
        epubFileManager = [[DMePubFileManager alloc] initWithEpubPath:epubPath];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithEpubPath:nil];
}

- (NSString*)rootFilePath
{
    DMRootFileParser* rootParser = [self rootFileParser];
    return [rootParser mainRootFileLocation];
}

- (NSData*)rootFileDataWithError:(NSError**)error;
{
    NSString* rootFilePath = [self rootFilePath];
    return [self dataForFileAtPath:rootFilePath
                             error:error];
}

- (NSData*)dataForFileAtPath:(NSString*)filePath
                       error:(NSError**)error
{
    return [epubFileManager contentXmlWithName:filePath
                                         error:error];
}

#pragma mark PrivateMethods

- (DMRootFileParser*)rootFileParser
{
    if (rootFileParser == nil)
    {
        NSError* containerFileError = nil;
        NSData* containerXmlData = [epubFileManager containerXmlWithError:&containerFileError];
        if (containerFileError != nil)
        {
            NSLog(@"Failed to retrieve container.xml: %@", containerFileError.localizedDescription);
            return nil;
        }
        rootFileParser = [[DMRootFileParser alloc] initWithContainerXml:containerXmlData];
    }
    return rootFileParser;
}

@end
