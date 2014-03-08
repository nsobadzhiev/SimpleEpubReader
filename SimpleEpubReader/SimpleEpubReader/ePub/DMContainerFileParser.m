//
//  DMContainerFileParser.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/6/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMContainerFileParser.h"
#import "DDXMLNode+ChildForName.h"
#import "DMePubItem.h"
#import "DMSpineItem.h"

// XML root elements
static NSString* const k_packageTagName = @"package";
static NSString* const k_manifestTagName = @"manifest";
static NSString* const k_metaDataTagName = @"metadata";
static NSString* const k_spineTagName = @"spine";
static NSString* const k_titleTagName = @"dc:title";
static NSString* const k_xhtmlItemAttrValue = @"application/xhtml+xml";

// Manifest item attributes
static NSString* const k_manifestItemAttrName = @"media-type";
static NSString* const k_itemIdAttrName = @"id";
static NSString* const k_hrefAttrName = @"href";

// Spine item attributes
static NSString* const k_itemIdRefAttrName = @"idref";

@interface DMContainerFileParser ()

- (DDXMLElement*)packageElement;
- (DDXMLElement*)manifestElement;
- (DDXMLElement*)metadataElement;
- (DDXMLElement*)spineElement;

- (BOOL)itemsArray:(NSArray*)items
        containsId:(NSString*)itemID;

@end

@implementation DMContainerFileParser

- (id)init
{
    self = [self initWithData:nil];
    return self;
}

- (id)initWithData:(NSData*)containerData
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

- (NSString*)epubTitle
{
    DDXMLElement* metadataElement = [self metadataElement];
    DDXMLNode* titleNode = [metadataElement childForName:k_titleTagName];
    NSString* title = [titleNode stringValue];
    return title;
}

- (NSArray*)epubHtmlItems
{
    NSArray* manifestEntries = [[self manifestElement] children];
    NSMutableArray* epubItems = [NSMutableArray arrayWithCapacity:manifestEntries.count];
    for (DDXMLElement* item in manifestEntries)
    {
        DDXMLNode* mediaTypeNode = [item attributeForName:k_manifestItemAttrName];
        NSString* itemMediaType = [mediaTypeNode stringValue];
        if ([itemMediaType isEqualToString:k_xhtmlItemAttrValue])
        {
            DDXMLNode* itemIdNode = [item attributeForName:k_itemIdAttrName];
            NSString* itemId = [itemIdNode stringValue];
            
            DDXMLNode* hrefNode = [item attributeForName:k_hrefAttrName];
            NSString* itemPath = [hrefNode stringValue];
            
            DMePubItem* epubItem = [DMePubItem ePubItemWithId:itemId mediaType:itemMediaType href:itemPath];
            [epubItems addObject:epubItem];
        }
    }
    return epubItems;
}

- (NSArray*)spineItems
{
    NSArray* spineEntries = [[self spineElement] children];
    NSMutableArray* spineItems = [NSMutableArray arrayWithCapacity:spineEntries.count];
    for (DDXMLElement* item in spineEntries)
    {
        DDXMLNode* itemIdNode = [item attributeForName:k_itemIdRefAttrName];
        NSString* itemId = [itemIdNode stringValue];
        
        DMSpineItem* spineItem = [DMSpineItem spineItemWithID:itemId];
        [spineItems addObject:spineItem];
    }
    return spineItems;
}

- (NSArray*)filteredSpineItems
{
    NSArray* allItems = self.epubHtmlItems;
    NSArray* spineItems = self.spineItems;
    NSMutableArray* filteredSpine = [NSMutableArray arrayWithCapacity:allItems.count];
    for (DMSpineItem* spineItem in spineItems)
    {
        if ([self itemsArray:allItems
                  containsId:spineItem.itemID] == YES)
        {
            [filteredSpine addObject:spineItem];
        }
    }
    return [NSArray arrayWithArray:filteredSpine];
}

#pragma mark PrivateMethods

- (DDXMLElement*)packageElement
{
    DDXMLElement* packageElement = (DDXMLElement*)[containerXml childForName:k_packageTagName];
    return packageElement;
}

- (DDXMLElement*)manifestElement
{
    DDXMLElement* packageElement = [self packageElement];
    DDXMLElement* manifestElement = (DDXMLElement*)[packageElement childForName:k_manifestTagName];
    return manifestElement;
}

- (DDXMLElement*)metadataElement
{
    DDXMLElement* packageElement = [self packageElement];
    DDXMLElement* metaDataElement = (DDXMLElement*)[packageElement childForName:k_metaDataTagName];
    return metaDataElement;
}

- (DDXMLElement*)spineElement
{
    DDXMLElement* packageElement = [self packageElement];
    DDXMLElement* spineElement = (DDXMLElement*)[packageElement childForName:k_spineTagName];
    return spineElement;
}

- (BOOL)itemsArray:(NSArray*)items
        containsId:(NSString*)itemID
{
    for (DMContainerItem* item in items)
    {
        if ([item.itemID isEqualToString:itemID])
        {
            return YES;
        }
    }
    return NO;
}

@end
