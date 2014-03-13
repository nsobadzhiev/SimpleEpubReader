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

@interface DMePubManager : NSObject
{
    DMePubFileManager* epubFileManager;
    DMRootFileParser* rootFileParser;
}

@property (nonatomic, readonly) NSString* rootFilePath;

- (instancetype)initWithEpubPath:(NSString*)epubPath;

- (NSData*)dataForFileAtPath:(NSString*)filePath
                       error:(NSError**)error;
- (NSData*)rootFileDataWithError:(NSError**)error;

@end
