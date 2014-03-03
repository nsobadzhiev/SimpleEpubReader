//
//  ZZArchiveEntry+TestableContainer.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "ZZArchiveEntry+TestableContainer.h"

@implementation ZZArchiveEntry (TestableContainer)

// override to return hardcoded data
- (NSData*)newDataWithError:(NSError**)error
{
    NSString* hardcodedContainer = @"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>    <container xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\"version=\"1.0\">    <rootfiles>    <rootfile full-path=\"OEBPS/content.opf\" media-type=\"application/oebps-package+xml\"/>    </rootfiles>    </container>";
    return [hardcodedContainer dataUsingEncoding:NSUTF8StringEncoding];
}

@end
