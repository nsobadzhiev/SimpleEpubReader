//
//  DMTestableePubURLProtocol.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableePubURLProtocol.h"

@implementation DMTestableePubURLProtocol

- (DMePubFileManager*)epubFileManager
{
    return fileManager;
}

- (void)setEpubFileManager:(DMePubFileManager *)epubFileManager
{
    fileManager = epubFileManager;
}

- (NSString*)epubPath
{
    return [super epubFilePath];
}

@end
