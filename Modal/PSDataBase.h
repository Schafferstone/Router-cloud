//
//  PSDataBase.h
//  Router cloud
//
//  Created by mac on 14-7-12.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOWebDAVItem.h"
@interface PSDataBase : NSObject
+ (PSDataBase *)shareDataBase;
- (void)insertDBWithModel:(LEOWebDAVItem *)item intheTable:(NSString *)table;
- (void)deleteDBWithKey:(NSInteger)key intheTable:(NSString *)table;
- (void)updateDBWithkey:(NSInteger)key withModel:(LEOWebDAVItem *)item intheTable:(NSString *)table;

- (NSMutableArray *)selectDBWithIndexPath:(NSInteger)indexPath;
@end
