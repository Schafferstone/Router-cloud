//
//  PSGuidePageViewController.m
//  Router cloud
//
//  Created by Zpz on 14-6-29.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSGuidePageViewController.h"
#import "PSHomePageViewController.h"
@interface PSGuidePageViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation PSGuidePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDEVICEWIDTH, kDEVICEHEIGHT)];
    _scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kDEVICEWIDTH*4, kDEVICEHEIGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(110, kDEVICEHEIGHT-60, 100, 30)];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:2/255.0 green:197/255.0 blue:254/255.0 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 4;
    [_pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    for (int i=0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kDEVICEWIDTH, 0, kDEVICEWIDTH, kDEVICEHEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d",i+1]];
        if (i==3) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoHomePage)];
            [imageView addGestureRecognizer:tap];
        }
        [_scrollView addSubview:imageView];
        
    }
}
- (void)gotoHomePage
{
    [self createTabBarandNavBar];
}
- (void)createTabBarandNavBar
{
    NSArray *titleArray = @[@"Pisen Cloud", @"惠源提", @"品友会", @"更多"];
    NSArray *imageArray = @[@"home", @"hyt", @"pinyou", @"more"];
    NSArray *classNameArray = @[@"PSHomePageViewController", @"PSHYTViewController", @"PSFCViewController", @"PSMoreViewController"];
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0; i<classNameArray.count; i++) {
        UIViewController *viewController = [NSClassFromString(classNameArray[i]) new];
        if (i==0) {
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
            UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            titleImageView.image = [UIImage imageNamed:@"host_logo"];
            [titleView addSubview:titleImageView];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 44)];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:17.0];
            titleLabel.text = titleArray[i];
            [titleView addSubview:titleLabel];
            viewController.navigationItem.titleView = titleView;
            
        }else{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            titleLabel.text = titleArray[i];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:17.0];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            viewController.navigationItem.titleView = titleLabel;
        }
        UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png",imageArray[i]]];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_active.png",imageArray[i]]];
        if (IOS7) {
            viewController.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            viewController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        }
        else {
            [viewController.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
        }
        [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [array addObject:navigationController];
    }
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = array;
    [UIApplication sharedApplication].delegate.window.rootViewController = tabBarController;
    [tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"header"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarController.tabBar insertSubview:backgroundView atIndex:1];
    
    
}
- (void)pageChange
{
    int currentPage = _pageControl.currentPage;
    _scrollView.contentOffset = CGPointMake(currentPage*320, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/320;
    _pageControl.currentPage = currentPage;
}
@end
