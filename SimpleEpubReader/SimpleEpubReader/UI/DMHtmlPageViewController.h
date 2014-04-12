//
//  DMHtmlPageViewController.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMHtmlPageViewController : UIViewController <UIWebViewDelegate>
{
    NSData* htmlData;
}

@property (nonatomic, strong) NSString* filePath;

- (instancetype)initWithData:(NSData*)htmlData;

@end
