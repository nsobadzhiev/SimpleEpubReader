//
//  DMTableOfContentsDataSource.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/14/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMePubManager.h"

@class DMTableOfContentsDataSource;

@protocol DMTableOfContentsDelegate <NSObject>

- (void)tableOfContentsDataSource:(DMTableOfContentsDataSource*)source
                didSelectFilePath:(NSString*)path;

@end

@interface DMTableOfContentsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    DMePubManager* epubManager;
}

@property (nonatomic, weak) id<DMTableOfContentsDelegate> delegate;

- (id)initWithEpubPath:(NSString*)path;

@end
