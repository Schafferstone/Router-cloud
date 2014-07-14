//
//  PSCollectionsViewController.m
//  Router cloud
//
//  Created by mac on 14-7-9.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSCloudCollectionsViewController.h"

@interface PSCloudCollectionsViewController ()
//<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LEOWebDAVRequestDelegate>

{
    UICollectionView *_collectionView;
    NSMutableArray *_cloudArray;
}
@end

@implementation PSCloudCollectionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//	[self createNavBar];
//    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 31, kDEVICEWIDTH, kDEVICEHEIGHT-64-49-31) collectionViewLayout:layout];
//    [layout setItemSize:CGSizeMake(kDEVICEWIDTH, 80)];
//    _collectionView.dataSource = self;
//    _collectionView.delegate = self;
//    _collectionView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_collectionView];
//    [_collectionView registerClass:[PSFileListCollectionViewCell class] forCellWithReuseIdentifier:FileListCellIdentifier];
//    [_collectionView registerClass:[PSFileGridCollectionViewCell class] forCellWithReuseIdentifier:FileGridCellIdentifier];
//    _cloudArray = [NSMutableArray new];
    
}
//
//- (void)valueChange:(UISegmentedControl *)segmentedControl
//{
//    [_collectionView reloadData];
//}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
//    //新建按钮不能用
//    UIButton *button = (UIButton *)[_operationView viewWithTag:300];
//    button.enabled = NO;
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    if (_arrangmentView.hidden==NO) {
//        _arrangmentView.hidden = YES;
//    }
//    [[PSClient sharedClient] cancelDelegate];
//    [[PSClient sharedClient] cancelRequest];
//}
//- (void)createNavBar{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_head.png"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarMetricsDefault target:self action:@selector(returnToHomePage)];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 44)];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"Cloud·文件";
//    self.navigationItem.titleView = titleLabel;
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//}
//- (void)returnToHomePage
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//#pragma mark - buttonclicked
//- (void)fileButtonClicked:(UIButton *)button
//{
//    switch (button.tag) {
//        case 300:
//        {
//            
//        }
//            break;
//        case 301:
//        {
//            
//        }
//            break;
//        case 302:
//        {
//            if (self.arrgmentType == ArragmentTypeList) {
//                
//            }else {
//                
//            }
//        }
//            break;
//        case 303:
//        {
//            if (_arrangmentView.hidden==NO) {
//                _arrangmentView.hidden = YES;
//            }else{
//                _arrangmentView.hidden = NO;
//            }
//            
//        }
//            break;
//        case 304:
//        {
//            if (self.arrgmentType == ArragmentTypeList) {
//                UILabel * titleLabel= (UILabel *)[button.superview viewWithTag:104];
//                titleLabel.text = @"列表";
//                [button setImage:[[UIImage imageNamed:@"list.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//                self.arrgmentType = ArragmentTypeGrid;
//                [_collectionView reloadData];
//            }else{
//                UILabel * titleLabel= (UILabel *)[button.superview viewWithTag:104];
//                titleLabel.text = @"视图";
//                [button setImage:[[UIImage imageNamed:@"matrix.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//                self.arrgmentType = ArragmentTypeList;
//                [_collectionView reloadData];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    
//}
//
//- (void)reArrangment:(UIButton *)button
//{
//    [_arrangmentView removeFromSuperview];
//}
@end
