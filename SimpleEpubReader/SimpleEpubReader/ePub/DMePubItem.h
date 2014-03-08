//
//  DMePubItem.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMContainerItem.h"

@interface DMePubItem : DMContainerItem

+ (instancetype)ePubItemWithId:(NSString*)itemID
                     mediaType:(NSString*)mediaType
                          href:(NSString*)path;

@property (nonatomic, strong) NSString* mediaType;
@property (nonatomic, strong) NSString* href;   // path to the item

- (instancetype)initWithId:(NSString*)itemID
                 mediaType:(NSString*)mediaType
                      href:(NSString*)path;

@end
