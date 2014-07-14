//
//  PSDataBase.m
//  Router cloud
//
//  Created by mac on 14-7-12.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSDataBase.h"
#import <FMDB.h>
@implementation PSDataBase
{
    FMDatabase *_dataBase;
}
+ (PSDataBase *)shareDataBase
{
    static PSDataBase *shareDataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataBase = [[PSDataBase alloc] init];
    });
    return shareDataBase;
}
- (id)init
{
    self = [super init];
    if (self) {
        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Cloud.db"];
        _dataBase = [FMDatabase databaseWithPath:dbPath];
        if (![_dataBase open]) {
            NSLog(@"open database error");
            return nil;
        }
        if (![_dataBase executeUpdate:@"create table if not exists Picture (indexPath integer primary key autoincrement, name text, contentSize text, modifiedDate text, url text)"]) {
            NSLog(@"create Picture table error!");
            return nil;
        }
        if (![_dataBase executeUpdate:@"create table if not exists Muisc (indexPath integer primary key autoincrement, name text, contentSize text, modifiedDate text, url text)"]) {
            NSLog(@"create Music table error!");
            return nil;
        }
        if (![_dataBase executeUpdate:@"create table if not exists Video (indexPath integer primary key autoincrement, name text, contentSize text, modifiedDate text, url text)"]) {
            NSLog(@"create Video table error");
            return nil;
        }
        if (![_dataBase executeUpdate:@"create table if not exists Document (indexPath integer primary key autoincrement, name text, contentSize text, modifiedDate text, url text)"]) {
            NSLog(@"create Document table error");
            return nil;
        }
        if (![_dataBase executeUpdate:@"create table if not exists file (indexPath integer primary key autoincrement, name text, contentSize text, modifiedDate text, url text, type integer)"]) {
            NSLog(@"create Document table error");
            return nil;
        }
        [_dataBase close];
    }
    return self;
}
- (void)insertDBWithModel:(LEOWebDAVItem *)item intheTable:(NSString *)table;
{
    if (![_dataBase open]) {
        NSLog(@"open database error in insert progressing");
        return ;
    }
    NSString *updateData = [NSString stringWithFormat:@"insert into '%@' (name, contentSize, modifiedDate, url, type) values('%@','%@','%@','%@','%@')", table, item.displayName, item.contentSize, item.modifiedDate, item.url, [NSNumber numberWithInt:item.type]];
    if (![_dataBase executeUpdate:updateData]) {
        NSLog(@"%@ insert error",table);
        return;
    }
    [_dataBase close];
}
- (void)deleteDBWithKey:(NSInteger)key intheTable:(NSString *)table
{
    if (![_dataBase open]) {
        NSLog(@"open database error in insert progressing");
        return ;
    }
}
@end
