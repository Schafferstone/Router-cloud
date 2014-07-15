//
//  PSCloudViewController.m
//  Router cloud
//
//  Created by Zpz on 14-7-7.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSCloudViewController.h"
#import "PSButtionView.h"
#import "PSCloudMusicViewController.h"
#import "PSCloudPictureViewController.h"
#import "PSCloudDocumentsViewController.h"
#import "PSCloudFilesViewController.h"
#import "PSCloudCollectionsViewController.h"
#import "PSCloudVideoViewController.h"
#import "PSMusicViewController.h"
#import "PSClient.h"
#import "LEOWebDAVItem.h"
#import "PSItemModel.h"
#import <THProgressView.h>
#import <MKNetworkKit/MKNetworkKit.h>


@interface PSCloudViewController ()
@property (nonatomic, strong) NSMutableArray *localmusicArray;
@property (nonatomic, strong) NSMutableArray *cloudmusicArray;
@property (nonatomic, strong) NSMutableArray *localpicutreArray;
@property (nonatomic, strong) NSMutableArray *cloudpicutreArray;
@property (nonatomic, strong) NSMutableArray *localvideoArray;
@property (nonatomic, strong) NSMutableArray *cloudvideoArray;
@property (nonatomic, strong) NSMutableArray *localdocumentArray;
@property (nonatomic, strong) NSMutableArray *clouddocumentArray;
@property (nonatomic, strong) NSMutableArray *localfileArray;
@property (nonatomic, strong) NSMutableArray *cloudflieArray;
@property (nonatomic) BOOL isFirstRequest;
@end

@implementation PSCloudViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.textColor = [UIColor whiteColor];
        titleView.text = @"云共享";
        self.navigationItem.titleView = titleView;
    }
    return self;
}
#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _localmusicArray = [NSMutableArray new];
    _cloudmusicArray = [NSMutableArray new];
    _localpicutreArray = [NSMutableArray new];
    _cloudpicutreArray = [NSMutableArray new];
    _localvideoArray = [NSMutableArray new];
    _cloudvideoArray = [NSMutableArray new];
    _localdocumentArray = [NSMutableArray new];
    _clouddocumentArray = [NSMutableArray new];
    _localfileArray = [NSMutableArray new];
    _cloudflieArray = [NSMutableArray new];
	// Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 60)];
    if (self.isAccessToCloud) {
        imageView.image = [UIImage imageNamed:@"signal_light.png"];
    }else{
        imageView.image = [UIImage imageNamed:@"signal_blank.png"];
    }
    [self.view addSubview:imageView];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self drawLine];
    [self addButtonView];
    [self addDiskInfo];
    [self requestDataFromLocal];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_head.png"] forBarMetrics:UIBarMetricsDefault];
    if ([PSMusicViewController sharedMusicPlayer]!= nil) {
        [PSMusicViewController sharedMusicPlayer].player = nil;
    }
}

#pragma mark - 添加下划线
- (void)drawLine{
    for (int i = 0; i<160; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(i*2, 60, 1, 1)];
        dot.backgroundColor = [UIColor lightGrayColor];
        dot.alpha = 0.2;
        [self.view addSubview:dot];
    }
    for (int i=0; i<160; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(i*2, 160, 1, 1)];
        dot.alpha = 0.2;
        dot.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dot];
    }
    for (int i=0; i<160; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(i*2, 260, 1, 1)];
        dot.alpha = 0.2;
        dot.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dot];
    }
    for (int i=0; i<100; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(kDEVICEWIDTH/3, 60+i*2, 1, 1)];
        dot.alpha = 0.2;
        dot.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dot];
    }
    for (int i=0; i<100; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(2*kDEVICEWIDTH/3, 60+i*2, 1, 1)];
        dot.alpha = 0.2;
        dot.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dot];
    }
}
#pragma mark - 添加自定义button和button事件
- (void)addButtonView{
    NSArray *imageArray = @[@"host_camera", @"host_music", @"host_video", @"host_text", @"host_file", @"host_collection"];
    NSArray *titleArray = @[@"图片", @"音乐", @"视频", @"文档", @"文件", @"收藏"];
    for (int i=0; i<6; i++) {
        PSButtionView *buttonView = [[PSButtionView alloc] initWithFrame:CGRectMake(i%3*kDEVICEWIDTH/3, 60+i/3*100, kDEVICEWIDTH/3, 100)];
        [buttonView.button setImage:[[UIImage imageNamed:imageArray[i]]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]    forState:UIControlStateNormal];
        buttonView.button.tag = 100+i;
        [buttonView.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        buttonView.titleLabel.text = titleArray[i];
        buttonView.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:buttonView];
    }
}

- (void)buttonClick:(UIButton *)button{
    switch (button.tag) {
        case 100:
        {
            PSCloudPictureViewController *cloudPictureViewController = [PSCloudPictureViewController new];
            cloudPictureViewController.localArray = _localpicutreArray;
            [self.navigationController pushViewController:cloudPictureViewController animated:YES];
        }
            break;
        case 101:
        {
            PSCloudMusicViewController *cloudMusicViewController = [PSCloudMusicViewController new];
            cloudMusicViewController.localArray = _localmusicArray;
            [self.navigationController pushViewController:cloudMusicViewController animated:YES];
        }
            break;
        case 102:
        {
            PSCloudVideoViewController *videoViewController = [PSCloudVideoViewController new];
            [self.navigationController pushViewController:videoViewController animated:YES];
        }
            break;
        case 103:
        {
            PSCloudDocumentsViewController *documentsViewController = [PSCloudDocumentsViewController new];
            documentsViewController.localArray = _localdocumentArray;
            [self.navigationController pushViewController:documentsViewController animated:YES];
        }
            break;
        case 104:
        {
            PSCloudFilesViewController *filesViewContriller = [PSCloudFilesViewController new];
            filesViewContriller.localArray = _localfileArray;
            [self.navigationController pushViewController:filesViewContriller animated:YES];
        }
            break;
        case 105:
        {
//            PSCloudCollectionsViewController *collectionViewController = [PSCloudCollectionsViewController new];
//            [self.navigationController pushViewController:collectionViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 添加本地空间和cloud空间信息
- (void)addDiskInfo{
    //cloud disk information
    UIView *cloudDiskView = [[UIView alloc] initWithFrame:CGRectMake(0, 265, kDEVICEWIDTH, 70)];
    UIImageView *cloudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 30, 30)];
    cloudImageView.image = [UIImage imageNamed:@"cloud_blue"];
    [cloudDiskView addSubview:cloudImageView];
    
    UILabel *cloudLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 1, 55, 30)];
    cloudLabel.textColor = [UIColor blueColor];
    cloudLabel.textAlignment = NSTextAlignmentLeft;
    cloudLabel.text = @"Cloud:";
    [cloudDiskView addSubview:cloudLabel];
    
    UILabel *cloudDiskCapacityLabel = [[UILabel alloc] initWithFrame:CGRectMake(111, 1, 70, 30)];
    cloudDiskCapacityLabel.textAlignment = NSTextAlignmentLeft;
    cloudDiskCapacityLabel.textColor = [UIColor blueColor];
    [cloudDiskView addSubview:cloudDiskCapacityLabel];

    UILabel *cloudDiskFreeCapacityLabel =[[UILabel alloc] initWithFrame:CGRectMake(185, 1, 60, 30)];
    cloudDiskFreeCapacityLabel.textColor = [UIColor blueColor];
    cloudDiskFreeCapacityLabel.textAlignment = NSTextAlignmentLeft;
    cloudDiskFreeCapacityLabel.text = @"可用:";
    [cloudDiskView addSubview:cloudDiskFreeCapacityLabel];
    UILabel *cloudFreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(226, 1, 64, 30)];
    cloudFreeLabel.textAlignment = NSTextAlignmentLeft;
    cloudFreeLabel.textColor = [UIColor blueColor];
    [cloudDiskView addSubview:cloudFreeLabel];
    THProgressView *cloudProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(25, 35, kDEVICEWIDTH-50, 20)];
    cloudProgressView.progressTintColor = [UIColor blueColor];
    CGFloat total = 0;
    CGFloat free = 0;
    if ([self.totalStorage rangeOfString:@"GB"].location!=NSNotFound) {
        total = [self.totalStorage floatValue];
    }
    if ([self.freeStorage rangeOfString:@"GB"].location != NSNotFound) {
        free = [self.freeStorage floatValue];
    }
    if (total!=0) {
        cloudProgressView.progress = (total-free)/total;
    }
    [cloudDiskView addSubview:cloudProgressView];
    
    //local disk information
    UIView *localDiskView = [[UIView alloc] initWithFrame:CGRectMake(0, 310, kDEVICEWIDTH, 70)];
    [self.view addSubview:localDiskView];
    UIImageView *localDiskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 30, 30)];
    localDiskImageView.image = [UIImage imageNamed:@"local_yellow"];
    [localDiskView addSubview:localDiskImageView];
    
    UILabel *localLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 1, 45, 30)];
    localLabel.textColor = [UIColor blueColor];
    localLabel.textAlignment = NSTextAlignmentLeft;
    localLabel.text = @"本地:";
    [localDiskView addSubview:localLabel];
    NSString *path = NSHomeDirectory();
    UILabel *localDiskCapacityLabel = [[UILabel alloc] initWithFrame:CGRectMake(101, 1, 70, 30)];
    localDiskCapacityLabel.textAlignment = NSTextAlignmentLeft;
    localDiskCapacityLabel.textColor = [UIColor blueColor];
    CGFloat localTotal = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:path error:Nil] objectForKey:NSFileSystemSize] floatValue]/1024/1024/1024;
    localDiskCapacityLabel.text = [NSString stringWithFormat:@"%.1fGB", localTotal];
    [localDiskView addSubview:localDiskCapacityLabel];
    
    UILabel *localDiskFreeCapacityLabel =[[UILabel alloc] initWithFrame:CGRectMake(185, 1, 60, 30)];
    localDiskFreeCapacityLabel.textColor = [UIColor blueColor];
    localDiskFreeCapacityLabel.textAlignment = NSTextAlignmentLeft;
    localDiskFreeCapacityLabel.text = @"可用:";
    [localDiskView addSubview:localDiskFreeCapacityLabel];
    UILabel *localFreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(226, 1, 64, 30)];
    localFreeLabel.textAlignment = NSTextAlignmentLeft;
    localFreeLabel.textColor = [UIColor blueColor];
    CGFloat localFree = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:path error:Nil] objectForKey:NSFileSystemFreeSize] floatValue]/1024/1024/1024;
    localFreeLabel.text = [NSString stringWithFormat:@"%.1fGB",localFree];
    [localDiskView addSubview:localFreeLabel];
    THProgressView *localProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(25, 35, kDEVICEWIDTH-50, 20)];
    localProgressView.progressTintColor = [UIColor yellowColor];
    localProgressView.progress = (localTotal-localFree)/localTotal;
    [localDiskView addSubview:localProgressView];
    if (self.isAccessToCloud) {
        cloudFreeLabel.text = self.freeStorage;
        cloudDiskCapacityLabel.text = self.totalStorage;
        [self.view addSubview:cloudDiskView];
        localDiskView.frame = CGRectMake(0, 340, kDEVICEWIDTH, 70);
    }
//    cloudDiskView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    
}

- (void)requestDataFromLocal
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *nameArray = @[kPICTUREDIRECTORY, kVIDEODIRECTORY, kDOCUMENTDIRECTORY];
    for (int i=0; i<nameArray.count; i++) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],nameArray[i]];
        NSArray *fileArray = [fileManager subpathsOfDirectoryAtPath:filePath error:nil];
        if (fileArray.count != 0) {
            for (NSString *filename in fileArray) {
                PSItemModel *item = [PSItemModel new];
                item.name = filename;
                switch (i) {
                    case 0:
                        [_localpicutreArray addObject:item];
                        break;
                    case 1:{
                        if (!([filename rangeOfString:@"DS_Store"].length>0)) {
                            [_localvideoArray addObject:item];
                        }
                    }
                        break;
                    case 2:{
                        [_localdocumentArray addObject:item];
                    }
                        break;
                    default:
                        break;
                }
                
            }
        }
    }
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *fileArray = [fileManager subpathsOfDirectoryAtPath:filePath error:nil];
    if (fileArray.count!=0) {
        for (NSString *filename in fileArray) {
            PSItemModel *item = [PSItemModel new];
            item.name = filename;
            if (![item.name hasSuffix:@"DS_Store"]) {
               [_localfileArray addObject:item];
            }
        }
    }
}



@end
