//
//  DMTableOfContentsItem.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/11/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTableOfContentsItem : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* path;

- (instancetype)initWithName:(NSString*)name
                     andPath:(NSString*)path;

@end
