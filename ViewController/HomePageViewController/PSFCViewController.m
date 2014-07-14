//
//  PSFCViewController.m
//  Router cloud
//
//  Created by Zpz on 14-6-29.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSFCViewController.h"

@interface PSFCViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@property (nonatomic) BOOL isload;
@end

@implementation PSFCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTabBarTitle:@"品友会"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDEVICEWIDTH, kDEVICEHEIGHT-49)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_isload) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.huiyuanti.com/Html/FriendIndex.html"]]];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _isload = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _isload = YES;
}
@end
