//
//  DMTestableTableOfContentsDataSource.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/14/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMTableOfContentsDataSource.h"

@interface DMTestableTableOfContentsDataSource : DMTableOfContentsDataSource

@property (nonatomic, strong) DMePubManager* epubManagerObject;

@end
