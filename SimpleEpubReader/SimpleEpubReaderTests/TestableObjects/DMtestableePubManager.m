//
//  DMtestableePubManager.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTestableePubManager.h"

@implementation DMTestableePubManager

- (DMePubFileManager*)fileManager
{
    return epubFileManager;
}

- (void)setFileManager:(DMePubFileManager *)fileManager
{
    epubFileManager = fileManager;
}

- (DMRootFileParser*)rootParser
{
    return rootFileParser;
}

- (void)setRootParser:(DMRootFileParser *)rootParser
{
    rootFileParser = rootParser;
}

- (DMContainerFileParser*)contentsXmlParser
{
    return contentsParser;
}

- (void)setContentsXmlParser:(DMContainerFileParser*)newParser
{
    contentsParser = newParser;
}

@end
