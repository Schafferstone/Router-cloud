//
//  PSClient.m
//  Router cloud
//
//  Created by Zpz on 14-7-7.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSClient.h"

@interface PSClient (){

}

@end
@implementation PSClient
- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
+ (LEOWebDAVClient *)sharedClient{
    static LEOWebDAVClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[LEOWebDAVClient alloc] initWithRootURL:[NSURL URLWithString:kHTTPRouterURL] andUserName:kUSER andPassword:kPASSWORD];
    });
    
    return sharedClient;
}


@end
