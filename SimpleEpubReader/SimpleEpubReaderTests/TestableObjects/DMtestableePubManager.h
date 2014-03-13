//
//  DMtestableePubManager.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMePubManager.h"
#import "DMTestableePubFileManager.h"

@interface DMTestableePubManager : DMePubManager

@property (nonatomic, strong) DMePubFileManager* fileManager;
@property (nonatomic, strong) DMRootFileParser* rootParser;

@end
