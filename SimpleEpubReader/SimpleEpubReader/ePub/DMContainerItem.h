//
//  DMContainerItem.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMContainerItem : NSObject

@property (nonatomic, strong) NSString* itemID;

- (instancetype)initWithID:(NSString*)itemID;

@end
