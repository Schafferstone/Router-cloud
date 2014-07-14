//
//  PSAppDelegate.m
//  Router cloud
//
//  Created by Zpz on 14-6-29.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSAppDelegate.h"
#import "PSGuidePageViewController.h"
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define kPICTUREDIRECTORY @"picture"
#define KMUSICDIRECTORY   @"music"
#define kVIDEODIRECTORY   @"video"
#define kDOCUMENTDIRECTORY  @"document"
#define kCOLLECTIONDIRECTORY  @"collection"

@implementation PSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_head.png"] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"] isEqualToString:@"1"]) {
        [self createTabBarandNavBar];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        PSGuidePageViewController *guidePageVC = [PSGuidePageViewController new];
        self.window.rootViewController = guidePageVC;
        [self createDirectory];
    }
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark- TabBarController
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
    self.window.rootViewController = tabBarController;
    [tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"header"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarController.tabBar insertSubview:backgroundView atIndex:0];


}

- (void)createDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSArray *pathArray = @[kPICTUREDIRECTORY, KMUSICDIRECTORY, kVIDEODIRECTORY, kDOCUMENTDIRECTORY, kCOLLECTIONDIRECTORY];
    for (int i=0; i<pathArray.count; i++) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentPath,pathArray[i]];
        NSLog(@"%@",filePath);
        if (![fileManager fileExistsAtPath:filePath]) {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
}
@end
