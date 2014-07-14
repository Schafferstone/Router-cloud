//
//  PSClient.h
//  Router cloud
//
//  Created by Zpz on 14-7-7.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOWebDAVItem.h"
#import "LEOWebDAVClient.h"
#import "LEOWebDAVDownloadRequest.h"
#define kHTTPRouterURL @"http://192.168.222.254"
#define kUSER @"pisen"
#define kPASSWORD @"123456"

@interface PSClient : NSObject
//@property (nonatomic, copy) NSString *xmlStr;
+ (LEOWebDAVClient *)sharedClient;
@end
