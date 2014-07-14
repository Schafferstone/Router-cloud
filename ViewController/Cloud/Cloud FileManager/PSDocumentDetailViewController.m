//
//  PSDocumentDetailViewController.m
//  Router cloud
//
//  Created by mac on 14-7-14.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSDocumentDetailViewController.h"
#import "PSBaseViewController.h"
@interface PSDocumentDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *_webview;
    UIActivityIndicatorView *_activityIndicator;
}
@end

@implementation PSDocumentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createNavBarItem];
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDEVICEWIDTH, kDEVICEHEIGHT-64)];
    _webview.delegate = self;
    _webview.multipleTouchEnabled = YES;
    _webview.scalesPageToFit = YES;
    NSURL *url = nil;
    if ([self.item.url rangeOfString:@"disk-"].length>0) {
        url = [NSURL URLWithString:self.item.url];
    }else{
        url = [NSURL fileURLWithPath:self.item.url];
    }
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webview];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 120, 60.0, 60.0)];
    [_activityIndicator setCenter:self.view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityIndicator];
}
- (void)createNavBarItem
{
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_head.png"] forBarMetrics:UIBarMetricsDefault];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.item.name;
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"请推出重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    [alertView show];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [_activityIndicator startAnimating];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
}
@end
