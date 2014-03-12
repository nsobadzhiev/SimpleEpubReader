//
//  DMTableOfContents.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/11/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLDocument.h"

@interface DMTableOfContents : NSObject
{
    DDXMLDocument* tocDocument;
}

@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSArray* topLevelItems;

- (instancetype)initWithData:(NSData*)tocData;

@end
