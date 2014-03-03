//
//  DMRootFileParser.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLDocument.h"

@interface DMRootFileParser : NSObject
{
    DDXMLDocument* containerXml;
}

@property (nonatomic, readonly) NSString* mainRootFileLocation;

- (id)initWithContainerXml:(NSData*)containerData;

@end
