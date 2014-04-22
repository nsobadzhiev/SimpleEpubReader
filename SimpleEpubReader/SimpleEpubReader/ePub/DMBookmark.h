//
//  DMBookmark.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSNumber BookmarkPosition;

@interface DMBookmark : NSObject <NSCoding>

@property (nonatomic, strong) NSString* fileName;
@property (nonatomic, strong) BookmarkPosition* filePosition;
@property (nonatomic, strong) NSString* fileSection;

- (instancetype)initWithFileName:(NSString*)fileName
                         section:(NSString*)section
                        position:(BookmarkPosition*)position;

@end
