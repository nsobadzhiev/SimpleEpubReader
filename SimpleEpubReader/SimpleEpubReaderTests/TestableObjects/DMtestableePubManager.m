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

- (void)setContentsXml:(NSString *)contentsXml
{
    if (contentsXml != _contentsXml)
    {
        _contentsXml = contentsXml;
        NSData* containerData = [contentsXml dataUsingEncoding:NSUTF8StringEncoding];
        DMContainerFileParser* parser = [[DMContainerFileParser alloc] initWithData:containerData];
        self.contentsXmlParser = parser;
    }
}

- (DMContainerFileParser*)contentsParser
{
    if (contentsParser == nil)
    {
        if (self.contentsXml)
        {
            NSData* containerData = [self.contentsXml dataUsingEncoding:NSUTF8StringEncoding];
            DMContainerFileParser* parser = [[DMContainerFileParser alloc] initWithData:containerData];
            self.contentsXmlParser = parser;
        }
        else
        {
            NSError* contentsFileError = nil;
            NSData* contentsData = [self rootFileDataWithError:&contentsFileError];
            if (contentsFileError != nil)
            {
                NSLog(@"Failed to retrieve container.xml: %@", contentsFileError.localizedDescription);
                return nil;
            }
            contentsParser = [[DMContainerFileParser alloc] initWithData:contentsData];
        }
    }
    return contentsParser;
}

- (DMTableOfContents*)navParser
{
    return navigationParser;
}

- (void)setNavParser:(DMTableOfContents*)navParser
{
    navigationParser = navParser;
}

@end
