//
//  DMePubItemViewController.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMHtmlPageViewController.h"
#import "DMePubItem.h"
#import "DMePubManager.h"

@interface DMePubItemViewController : DMHtmlPageViewController

@property (nonatomic, strong) DMePubItem* epubItem;
@property (nonatomic, strong) DMePubManager* epubManager;

- (instancetype)initWithEpubItem:(DMePubItem*)epubItem
                  andEpubManager:(DMePubManager*)epubManager;

@end
