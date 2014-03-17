//
//  DMHtmlPageViewController.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/17/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DMHtmlPageViewController.h"

@interface DMHtmlPageViewController ()

@end

@implementation DMHtmlPageViewController

- (instancetype)initWithData:(NSData *)_htmlData
{
    self = [super initWithNibName:@"DMHtmlPageViewController"
                           bundle:nil];
    if (self)
    {
        htmlData = _htmlData;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithData:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIWebView* webView = (UIWebView*)self.view;
    [webView loadData:htmlData
             MIMEType:nil
     textEncodingName:@"utf-8"
              baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType
{
    return NO;
}

@end
