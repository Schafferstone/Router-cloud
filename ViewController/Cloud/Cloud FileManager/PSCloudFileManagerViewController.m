//
//  PSCloudFileManagerViewController.m
//  Router cloud
//
//  Created by mac on 14-7-9.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSCloudFileManagerViewController.h"

@interface PSCloudFileManagerViewController ()
{
   
}

@end

@implementation PSCloudFileManagerViewController

#pragma mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Cloud", @"本地"]];
    _segmentedControl.selectedSegmentIndex = 1;
    _segmentedControl.frame = CGRectMake(0, 0, kDEVICEWIDTH, 30);
    [self.view addSubview:_segmentedControl];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
     [_segmentedControl addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    //默认是列表格式
    self.arrgmentType = ArragmentTypeList;
    [self createTabBar];
    _arrangmentView = [[UIView alloc] initWithFrame:CGRectMake(173, kDEVICEHEIGHT-49-140, 100, 140)];
    _arrangmentView.backgroundColor =  [UIColor colorWithRed:48.0/255 green:163.0/255 blue:238.0/255 alpha:1];
    NSArray *titleArray = @[@"按名称排列", @"按类型排列", @"按大小排列", @"按时间排列"];
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        button.frame = CGRectMake(0, i*35, 100, 35);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.textColor = [UIColor whiteColor];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reArrangment:) forControlEvents:UIControlEventTouchUpInside];
        [_arrangmentView addSubview:button];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_arrangmentView];
    _arrangmentView.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _operationView.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _operationView.hidden = YES;
}
- (void)createTabBar
{
    _operationView = [[UIView alloc] initWithFrame:CGRectMake(0, kDEVICEHEIGHT-49, kDEVICEWIDTH, 49)];
    _operationView.backgroundColor = [UIColor colorWithRed:48.0/255 green:163.0/255 blue:238.0/255 alpha:1];
    NSArray *imageArray = @[@"new", @"search", @"refresh", @"sorting", @"matrix"];
    NSArray *titleArray = @[@"新建", @"搜素", @"刷新", @"分类", @"视图"];
    [[UIApplication sharedApplication].keyWindow addSubview:_operationView];
    _operationView.hidden = YES;
    for (int i=0; i<5; i++) {
        UIButton *fileButton = [[UIButton alloc] initWithFrame:CGRectMake(15+64*i, 0, 30, 30)];
        fileButton.tag = 300+i;
        [fileButton setImage:[[UIImage imageNamed:imageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [fileButton addTarget:self action:@selector(fileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *fileLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+64*i, 30, 40, 19)];
        fileLabel.textAlignment = NSTextAlignmentCenter;
        fileLabel.textColor = [UIColor whiteColor];
        fileLabel.text = titleArray[i];
        if (i==4) {
            fileLabel.tag = 100+i;
        }
        [_operationView addSubview:fileButton];
        [_operationView addSubview:fileLabel];
    }
    
}
- (void)fileButtonClicked:(UIButton *)button
{
}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createNavBarItem
{
}
- (void)valueChange:(UISegmentedControl *)segmentedControl
{
}
- (void)reArrangment:(UIButton *)button
{
    
}
@end
