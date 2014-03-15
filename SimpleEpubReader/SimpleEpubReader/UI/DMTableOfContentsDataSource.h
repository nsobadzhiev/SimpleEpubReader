//
//  DMTableOfContentsDataSource.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/14/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMePubManager.h"

@interface DMTableOfContentsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    DMePubManager* epubManager;
}

- (id)initWithEpubPath:(NSString*)path;

@end
