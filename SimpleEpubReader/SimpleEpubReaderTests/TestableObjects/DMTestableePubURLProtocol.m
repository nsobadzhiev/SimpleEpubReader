//
//  DMTestableePubURLProtocol.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableePubURLProtocol.h"

@implementation DMTestableePubURLProtocol

- (DMePubManager*)epubFileManager
{
    return epubManager;
}

- (void)setEpubFileManager:(DMePubManager *)epubFileManager
{
    epubManager = epubFileManager;
}

- (NSString*)epubPath
{
    return [super epubFilePath];
}

- (NSString*)zipPath
{
    return [super zipPath];
}

@end
