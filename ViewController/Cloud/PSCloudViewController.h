//
//  PSCloudViewController.h
//  Router cloud
//
//  Created by Zpz on 14-7-7.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSBaseViewController.h"
#import "PSItemModel.h"
@interface PSCloudViewController : PSBaseViewController
@property (nonatomic) BOOL isAccessToCloud;
@property (nonatomic, copy) NSString *totalStorage;
@property (nonatomic, copy) NSString *freeStorage;
@end
