//
//  DMRootFileParser.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

//<?xml version="1.0" encoding="utf-8" standalone="no"?>
//<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
//<rootfiles>
//<rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
//</rootfiles>
//</container>


#import "DMRootFileParser.h"

static NSString* const k_containerTagName = @"container";
static NSString* const k_rootFilesTagName = @"rootfiles";
static NSString* const k_rootFileTagName = @"rootfile";
static NSString* const k_rootFileFullPathTagName = @"full-path";

@interface DMRootFileParser ()

- (DDXMLNode*)childForName:(NSString*)name
                    inNode:(DDXMLNode*)node;

@end

@implementation DMRootFileParser

- (id)initWithContainerXml:(NSData*)containerData
{
    self = [super init];
    if (self)
    {
        NSError* parseError = nil;
        containerXml = [[DDXMLDocument alloc] initWithData:containerData
                                                   options:0
                                                     error:&parseError];
        if (parseError != nil)
        {
            NSLog(@"Failed to parse container XML: %@", parseError.description);
            return nil;
        }
    }
    return self;
}

- (NSString*)mainRootFileLocation
{
    DDXMLNode* containerElement = [self childForName:k_containerTagName
                                              inNode:containerXml];
    DDXMLNode* rootFilesElement = [self childForName:k_rootFilesTagName
                                              inNode:containerElement];
    DDXMLNode* rootFileElement = [self childForName:k_rootFileTagName
                                             inNode:rootFilesElement];
    DDXMLNode* rootPathNode = [(DDXMLElement*)rootFileElement attributeForName:k_rootFileFullPathTagName];
    NSString* rootPath = [rootPathNode stringValue];
    return rootPath;
}

- (DDXMLNode*)childForName:(NSString*)name
                    inNode:(DDXMLNode*)node
{
    for (DDXMLNode* child in [node children])
    {
        if ([child.name isEqualToString:name])
        {
            return child;
        }
    }
    return nil;
}

@end
