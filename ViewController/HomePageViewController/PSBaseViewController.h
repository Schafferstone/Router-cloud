//
//  PSBaseViewController.h
//  Router cloud
//
//  Created by Zpz on 14-7-6.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
//获取设备的物理宽度
#define kDEVICEHEIGHT [UIScreen mainScreen].bounds.size.height
#define kDEVICEWIDTH [UIScreen mainScreen].bounds.size.width
#define ROUTERURL @"http://192.168.222.254/cgi-bin/SysInfo"
#define UPDATEURL @"http://192.168.222.254/cgi-bin/SysUpgrade"
#ifndef kRouterUrl
#define kRouterUrl @"192.168.222.254"
#endif
#define kHTTPRouterURL @"http://192.168.222.254"
#define kPICTUREDIRECTORY @"picture"
#define KMUSICDIRECTORY   @"music"
#define kVIDEODIRECTORY   @"video"
#define kDOCUMENTDIRECTORY  @"document"
#define kCOLLECTIONDIRECTORY  @"collection"

@interface PSBaseViewController : UIViewController
- (void)setTabBarTitle:(NSString *)title;

@end
