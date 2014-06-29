//
//  PSAppDelegate.m
//  Router cloud
//
//  Created by Zpz on 14-6-29.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSAppDelegate.h"
#import "PSHomePageViewController.h"
#import "PSGuidePageViewController.h"
@implementation PSAppDelegate
@synthesize tabBarController = _tabBarController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"] isEqualToString:@"1"]) {
        PSHomePageViewController *homePageVC = [[PSHomePageViewController alloc] initWithNibName:@"PSHomePageViewController" bundle:nil];
        self.window.rootViewController = homePageVC;
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        PSGuidePageViewController *guidePageVC = [PSGuidePageViewController new];
        self.window.rootViewController = guidePageVC;
    }
    [self.window makeKeyAndVisible];
    return YES;
}


@end
