//
//  DMePubManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMePubFileManager.h"
#import "DMRootFileParser.h"
#import "DMContainerFileParser.h"

@interface DMePubManager : NSObject
{
    DMePubFileManager* epubFileManager;
    DMRootFileParser* rootFileParser;
    DMContainerFileParser* contentsParser;
}

@property (nonatomic, readonly) NSString* rootFilePath;
@property (nonatomic, readonly) NSArray* epubHtmlItems;
@property (nonatomic, readonly) NSArray* spineItems;
@property (nonatomic, readonly) NSArray* filteredSpineItems;
@property (nonatomic, readonly) DMePubItem* navigationItem;

- (instancetype)initWithEpubPath:(NSString*)epubPath;

- (NSData*)dataForFileAtPath:(NSString*)filePath
                       error:(NSError**)error;
- (NSData*)rootFileDataWithError:(NSError**)error;
- (NSString*)titleWithError:(NSError**)error;
- (DMePubItem*)epubItemForSpineElement:(DMSpineItem*)spineItem;

@end
