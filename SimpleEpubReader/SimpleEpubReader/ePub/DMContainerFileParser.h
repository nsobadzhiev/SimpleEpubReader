//
//  DMContainerFileParser.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/6/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLDocument.h"
#import "DMePubItem.h"
#import "DMSpineItem.h"

@interface DMContainerFileParser : NSObject
{
    DDXMLDocument* containerXml;
    
    NSArray* epubHtmlItems;
    NSArray* epubItems;
    NSArray* spineItems;
}

@property (nonatomic, readonly) NSString* epubTitle;
@property (nonatomic, readonly) NSArray* epubItems;
@property (nonatomic, readonly) NSArray* epubHtmlItems;
@property (nonatomic, readonly) NSArray* spineItems;
@property (nonatomic, readonly) NSArray* filteredSpineItems;
@property (nonatomic, readonly) DMePubItem* navigationItem;

- (id)initWithData:(NSData*)containerData;

- (DMePubItem*)epubItemForSpineElement:(DMSpineItem*)spineItem;

@end
