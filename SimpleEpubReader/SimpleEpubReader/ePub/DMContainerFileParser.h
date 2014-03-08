//
//  DMContainerFileParser.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/6/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLDocument.h"

@interface DMContainerFileParser : NSObject
{
    DDXMLDocument* containerXml;
}

@property (nonatomic, readonly) NSString* epubTitle;
@property (nonatomic, readonly) NSArray* epubHtmlItems;
@property (nonatomic, readonly) NSArray* spineItems;
@property (nonatomic, readonly) NSArray* filteredSpineItems;

- (id)initWithData:(NSData*)containerData;

@end
