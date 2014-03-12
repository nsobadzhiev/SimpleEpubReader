//
//  DMTableOfContents.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/11/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContents.h"
#import "DDXMLNode+ChildForName.h"
#import "DMTableOfContentsItem.h"

static NSString* const k_htmlTag = @"html";
static NSString* const k_htmlHeadTag = @"head";
static NSString* const k_htmlBodyTag = @"body";
static NSString* const k_htmlTitleTag = @"title";
static NSString* const k_htmlOrderedListTag = @"ol";
static NSString* const k_htmlListItemTag = @"li";
static NSString* const k_htmlLinkTag = @"a";
static NSString* const k_htmlSpanTag = @"span";
static NSString* const k_htmlHrefAttr = @"href";
static NSString* const k_htmlNavTag = @"nav";

@interface DMTableOfContents ()

- (DDXMLElement*)htmlElement;
- (DDXMLElement*)headElement;
- (DDXMLElement*)bodyElement;

- (DMTableOfContentsItem*)tocItemFromXmlNode:(DDXMLElement*)xmlElement;

@end

@implementation DMTableOfContents

- (instancetype)initWithData:(NSData*)tocData
{
    self = [super init];
    if (self)
    {
        NSError* parseError = nil;
        tocDocument = [[DDXMLDocument alloc] initWithData:tocData
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

- (instancetype)init
{
    return [self initWithData:nil];
}

- (NSString*)title
{
    DDXMLElement* headElement = [self headElement];
    DDXMLNode* titleElement = [headElement childForName:k_htmlTitleTag];
    return [titleElement stringValue];
}

- (DDXMLElement*)htmlElement
{
    for (DDXMLElement* child in [tocDocument children])
    {
        if ([child.name isEqualToString:k_htmlTag] &&
            child.children.count > 0)
        {
            return child;
        }
    }
    return nil;
}

- (NSArray*)topLevelItems
{
    DDXMLElement* bodyElement = [self bodyElement];
    DDXMLElement* navElement = (DDXMLElement*)[bodyElement childForName:k_htmlNavTag];
    DDXMLElement* topLevelListElement = (DDXMLElement*)[navElement childForName:k_htmlOrderedListTag];
    NSArray* topLevelListItems = [topLevelListElement elementsForName:k_htmlListItemTag];
    NSMutableArray* topLevelItems = [NSMutableArray arrayWithCapacity:topLevelListItems.count];
    for (DDXMLNode* listItem in topLevelListItems)
    {
        DDXMLElement* aItem = (DDXMLElement*)[listItem childForName:k_htmlLinkTag];
        DDXMLElement* spanItem = (DDXMLElement*)[listItem childForName:k_htmlSpanTag];
        DMTableOfContentsItem* tocItem = [self tocItemFromXmlNode:aItem];
        if (tocItem == nil)
        {
            tocItem = [self tocItemFromXmlNode:spanItem];
        }
        if (tocItem != nil)
        {
            [topLevelItems addObject:tocItem];
        }
    }
    return [NSArray arrayWithArray:topLevelItems];
}

- (DDXMLElement*)headElement
{
    DDXMLElement* htmlElement = [self htmlElement];
    return (DDXMLElement*)[htmlElement childForName:k_htmlHeadTag];
}

- (DDXMLElement*)bodyElement
{
    DDXMLElement* htmlElement = [self htmlElement];
    return (DDXMLElement*)[htmlElement childForName:k_htmlBodyTag];
}

- (DMTableOfContentsItem*)tocItemFromXmlNode:(DDXMLElement*)xmlElement
{
    NSString* itemName = [xmlElement stringValue];
    DDXMLNode* itemPathNode = [xmlElement attributeForName:k_htmlHrefAttr];
    NSString* itemPath = [itemPathNode stringValue];
    DMTableOfContentsItem* tocItem = [[DMTableOfContentsItem alloc] initWithName:itemName
                                                                         andPath:itemPath];
    return tocItem;
}

@end
