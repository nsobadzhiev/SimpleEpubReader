//
//  DMSpineItem.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMContainerItem.h"

@interface DMSpineItem : DMContainerItem

+ (instancetype)spineItemWithID:(NSString*)itemID;

@end
