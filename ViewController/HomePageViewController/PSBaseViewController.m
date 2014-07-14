//
//  PSBaseViewController.m
//  Router cloud
//
//  Created by Zpz on 14-7-6.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSBaseViewController.h"

@interface PSBaseViewController ()

@end

@implementation PSBaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)setTabBarTitle:(NSString *)title{
    self.tabBarItem.title = title;
}

@end
