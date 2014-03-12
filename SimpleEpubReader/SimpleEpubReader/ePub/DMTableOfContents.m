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

- (DMTableOfContentsItem*)tocItemFromXmlNode:(DDXMLElement*)xmlElement
                                  parentItem:(DMTableOfContentsItem*)parent;
- (DDXMLElement*)rootListItem;
- (NSArray*)tocItemsFromXmlNode:(DDXMLElement*)xmlElement
                      recursive:(BOOL)recursive
                     parentItem:(DMTableOfContentsItem*)parent;

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

- (NSArray*)subItemsForItem:(DMTableOfContentsItem*)item
{
    return item.subItems;
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
    DDXMLElement* topLevelListElement = [self rootListItem];
    return [self tocItemsFromXmlNode:topLevelListElement
                           recursive:NO
                          parentItem:nil];
}

- (NSArray*)allItems
{
    DDXMLElement* topLevelListElement = [self rootListItem];
    return [self tocItemsFromXmlNode:topLevelListElement
                           recursive:YES
                          parentItem:nil];
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
                                  parentItem:(DMTableOfContentsItem*)parent;
{
    NSString* itemName = [xmlElement stringValue];
    DDXMLNode* itemPathNode = [xmlElement attributeForName:k_htmlHrefAttr];
    NSString* itemPath = [itemPathNode stringValue];
    DMTableOfContentsItem* tocItem = [[DMTableOfContentsItem alloc] initWithName:itemName
                                                                         path:itemPath
                                                                          parent:parent];
    return tocItem;
}

- (DDXMLElement*)rootListItem
{
    DDXMLElement* bodyElement = [self bodyElement];
    DDXMLElement* navElement = (DDXMLElement*)[bodyElement childForName:k_htmlNavTag];
    return navElement;
}

- (NSArray*)tocItemsFromXmlNode:(DDXMLElement*)xmlElement
                      recursive:(BOOL)recursive
                     parentItem:(DMTableOfContentsItem*)parent;
{
    DDXMLElement* topLevelListElement = (DDXMLElement*)[xmlElement childForName:k_htmlOrderedListTag];
    NSArray* topLevelListItems = [topLevelListElement elementsForName:k_htmlListItemTag];
    NSMutableArray* topLevelItems = [NSMutableArray arrayWithCapacity:topLevelListItems.count];
    for (DDXMLNode* listItem in topLevelListItems)
    {
        DDXMLElement* aItem = (DDXMLElement*)[listItem childForName:k_htmlLinkTag];
        DDXMLElement* spanItem = (DDXMLElement*)[listItem childForName:k_htmlSpanTag];
        DMTableOfContentsItem* tocItem = [self tocItemFromXmlNode:aItem
                                                       parentItem:parent];
        if (tocItem == nil)
        {
            tocItem = [self tocItemFromXmlNode:spanItem
                                    parentItem:parent];
        }
        if (tocItem != nil)
        {
            [topLevelItems addObject:tocItem];
            if (recursive == YES)
            {
                NSArray* subItems = [self tocItemsFromXmlNode:(DDXMLElement*)listItem
                                                    recursive:recursive
                                                   parentItem:tocItem];
                if (subItems.count > 0)
                {
                    tocItem.subItems = subItems;
                    [topLevelItems addObjectsFromArray:subItems];
                }
            }
        }
    }
    return [NSArray arrayWithArray:topLevelItems];
}

@end
