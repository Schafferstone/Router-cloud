//
//  PSHomePageViewController.m
//  Router cloud
//
//  Created by Zpz on 14-6-29.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSHomePageViewController.h"
#import "PSMusicViewController.h"
#import "PSCloudViewController.h"
#import "PSButtionView.h"
#import "PSClient.h"
#import <MKNetworkKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <GDataXMLNode.h>

@interface PSHomePageViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *_adScrollView;
    MKNetworkEngine *_engineAd;
    MKNetworkEngine *_engineRouter;
}
@property (nonatomic) BOOL isAccessToCloud;
@property (nonatomic, strong) NSString *totalStorage;
@property (nonatomic, strong) NSString *freeStorage;
@end

@implementation PSHomePageViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setTabBarTitle:@"主页"];
    }
    return self;
}
#pragma mark - view生命周期函数
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加rightBarBarButton
    UIImage *rightItemImage = [[UIImage imageNamed:@"global.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.contentMode = UIViewContentModeScaleAspectFill;
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:rightItemImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(enterWebSetting) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //adScrollView
    self.automaticallyAdjustsScrollViewInsets = YES;
    _adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    _adScrollView.showsVerticalScrollIndicator = NO;
    _adScrollView.contentSize = CGSizeMake(320*3, 150);
    _adScrollView.delegate = self;
    _adScrollView.pagingEnabled = YES;
    _adScrollView.scrollEnabled = YES;
    [_adScrollView setDecelerationRate:0.2];
    _adScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_adScrollView];
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 150)];
        imageView.tag = 300+i;
        //这些图片随后被从网络上请求来的数据覆盖。
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ads_%d.png",i+1]];
        [_adScrollView addSubview:imageView];
    }
    UIView *scrollIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 148, kDEVICEWIDTH/3, 2)];
    scrollIndicator.backgroundColor = [UIColor blueColor];
    scrollIndicator.tag = 100;
    [self.view addSubview:scrollIndicator];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(adchangePage) userInfo:nil repeats:YES];
    //画分割线
    [self drawLine];
    [self addButton];
//    [self checkLineToRouter];
//    [self requestAdPicture];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_head.png"] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - 广告翻页
static int currentPage;
- (void)adchangePage{
    _adScrollView.contentOffset = CGPointMake(currentPage%3*320, 0);
    UIView *scrollIndicator = (UIView *)[_adScrollView viewWithTag:100];
    scrollIndicator.frame = CGRectMake(_adScrollView.contentOffset.x, 148, kDEVICEWIDTH/3, 2);
    currentPage++;
}
#pragma mark - 添加rightBarButtonItem事件
- (void)enterWebSetting{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kHTTPRouterURL]];
}
#pragma mark - 画分割线
- (void)drawLine{
    for (int i=0; i<160; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(i*2, 250, 1, 1)];
        dotView.alpha = 0.2;
        dotView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dotView];
    }
    for (int i=0; i<160; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(i*2, 340, 1, 1)];
        dotView.alpha = 0.2;
        dotView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dotView];
    }
    for (int i=0; i<95; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(kDEVICEWIDTH/3, 150+i*2, 1, 1)];
        dotView.alpha = 0.2;
        dotView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dotView];
    }
    for (int i=0; i<95; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(2*kDEVICEWIDTH/3, 150+i*2, 1, 1)];
        dotView.alpha = 0.2;
        dotView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dotView];
    }

}
#pragma mark - 添加button
- (void)addButton{
    NSArray *imageArray = @[@"cloud_share", @"music_share", @"video_share", @"camera_share"];
    NSArray *titleArray = @[@"云共享", @"云音乐", @"云视频", @"即拍即传", @"......"];
    for (int i=0; i<5; i++) {
        PSButtionView *buttonView = [[PSButtionView alloc] initWithFrame:CGRectMake(i%3*kDEVICEWIDTH/3, 150+i/3*90, kDEVICEWIDTH/3, 90)];
        buttonView.button.tag = 200+i;
        if (i<4) {
            [buttonView.button setImage:[[UIImage imageNamed:imageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [buttonView.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [buttonView.button setTitle:@"更多精彩敬请期待" forState:UIControlStateNormal];
            buttonView.button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            buttonView.button.tintColor = [UIColor blackColor];
        }
        
        buttonView.titleLabel.textColor = [UIColor blackColor];
        buttonView.titleLabel.textAlignment = NSTextAlignmentCenter;
        buttonView.titleLabel.text = titleArray[i];
        [self.view addSubview:buttonView];
    }

    
}

#pragma mark - 添加button事件响应
- (void)buttonClick:(UIButton *)button{
    switch (button.tag) {
        case 200:
        {
            PSCloudViewController *cloudViewContorller = [PSCloudViewController new];
            cloudViewContorller.isAccessToCloud = self.isAccessToCloud;
            cloudViewContorller.totalStorage = self.totalStorage;
            cloudViewContorller.freeStorage = self.freeStorage;
            [self.navigationController pushViewController:cloudViewContorller animated:YES];
        }
            break;
        case 201:
        {
            PSMusicViewController *musicViewController = [[PSMusicViewController alloc] initWithNibName:@"PSMusicViewController" bundle:nil];
            musicViewController.accessType = AccessTypeDirect;
            [self.navigationController pushViewController:musicViewController animated:YES];
        }
            break;
        case 202:
        {
            
        }
            break;
        case 203:
        {
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.2 animations:^{
        UIView *scrollIndicator = (UIView *)[self.view viewWithTag:100];
        scrollIndicator.frame = CGRectMake(scrollView.contentOffset.x/3, 148, kDEVICEWIDTH/3, 2);
    }];
}

#pragma mark - 检查是否连接路由器
- (void)checkLineToRouter{
    _engineRouter = [[MKNetworkEngine alloc] initWithHostName:kRouterUrl customHeaderFields:nil];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:@"<getSysInfo><Storage></Storage></getSysInfo>" forKey:@"data"];
    MKNetworkOperation *operation = [_engineRouter operationWithPath:@"cgi-bin/SysInfo" params:param httpMethod:@"POST"];
    operation.freezable = YES;
    __block NSString *xmlStr = nil;
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        xmlStr =[[NSString alloc]initWithData:completedOperation.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",xmlStr);
        [self parseXML:xmlStr];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"未能获取cloud信息" delegate:self cancelButtonTitle:@"直接进入" otherButtonTitles:@"重新连接", nil];
        [alertView show];
    }];
    [_engineRouter enqueueOperation:operation];
}
#pragma mark - 解析从could请求到XML信息
- (void)parseXML:(NSString *)xml{
    GDataXMLDocument *xmlDocument = [[GDataXMLDocument alloc] initWithXMLString:xml encoding:NSUTF8StringEncoding error:nil];
    if (!xmlDocument) {
        return;
    }
    self.isAccessToCloud = YES;
    NSArray *array = [xmlDocument nodesForXPath:@"/getSysInfo/Storage/Section" error:nil];
    for (GDataXMLElement *storageElement in array) {
        NSLog(@"%@",[storageElement attributeForName:@"volume"].stringValue);
        
        self.totalStorage = [storageElement attributeForName:@"total"].stringValue;
        self.freeStorage = [storageElement attributeForName:@"free"].stringValue;
    }
}
#pragma mark - 进行wifi连接选择
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        //进入路由器设置页面;
    }
}
//从官网请求广告图片
- (void)requestAdPicture{
    _engineAd = [[MKNetworkEngine alloc] initWithHostName:@"wcf.v3.huiyuanti.com:9216"];
    MKNetworkOperation *operation = [_engineAd operationWithPath:@"B2CApp/Product.svc/GetAdverts?code=appad000"];
    operation.freezable = YES;
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:completedOperation.responseData options:0 error:nil];
        NSArray *imageArray = jsonDic[@"Data"][0][@"Items"];
        int i = 0;
        for (NSDictionary *item in imageArray) {
            UIImageView *imageView = (UIImageView *)[_adScrollView viewWithTag:300+i];
            [imageView setImageWithURL:[NSURL URLWithString:item[@"ImageUrl"]]];
            i++;
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    [_engineAd enqueueOperation:operation];
}

@end
