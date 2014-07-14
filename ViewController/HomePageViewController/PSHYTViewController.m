//
//  PSHYTViewController.m
//  Router cloud
//
//  Created by Zpz on 14-6-29.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSHYTViewController.h"

@interface PSHYTViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@property (nonatomic) BOOL isload;
@end

@implementation PSHYTViewController
- (id)init
{
    self = [super init];
    if (self) {
        [self setTabBarTitle:@"惠源提"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDEVICEWIDTH, kDEVICEHEIGHT-49)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_isload) {
        [self loadWebView];
    }
}
- (void)loadWebView
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.huiyuanti.com/Html/CludIndex.html"]]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _isload = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _isload = NO;
}
@end
