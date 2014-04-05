//
//  DMTestableePubURLProtocol.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 4/3/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubURLProtocol.h"

@interface DMTestableePubURLProtocol : DMePubURLProtocol

@property (nonatomic, strong) DMePubFileManager* epubFileManager;
@property (nonatomic, readonly) NSString* epubPath;

@end
