
//
//  PSItemModel.m
//  Router cloud
//
//  Created by mac on 14-7-12.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSItemModel.h"
@implementation PSItemModel
- (BOOL)getFileAttributes:(NSString *)filePath
{
    if (filePath==nil) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    if (fileAttributes== nil) {
        return NO;
    }
    //文件的大小
    self.contentSize  = [self contentSizeFromNSNumberToNSString:[fileAttributes objectForKey:NSFileSize]];
    //文件的创建日期
    self.url = filePath;
    NSString *dateStr = [[NSString stringWithFormat:@"%@",[fileAttributes objectForKey:NSFileCreationDate]] substringToIndex:20];
    self.creationDate = dateStr;
    //文件的修改日期
    NSString *modifiedDateStr = [[NSString stringWithFormat:@"%@",[fileAttributes objectForKey:NSFileModificationDate]] substringToIndex:20];
    self.modifiedDate = modifiedDateStr;
    //文件的类型 是目录还是具体文件
    if ([[fileAttributes objectForKey:NSFileType] isEqualToString:NSFileTypeRegular]) {
        if ([self.name hasSuffix:@"mp3"]) {
            self.contentType = ContentTypeMP3;
        }else if ([self.name hasSuffix:@"wma"]){
            self.contentType = ContentTypeWMA;
        }else if ([self.name hasSuffix:@"aac"]){
            self.ContentType = ContentTypeAAC;
        }else if([self.name hasSuffix:@"ogg"]){
            self.contentType = ContentTypeOGG;
        }else if ([self.name hasSuffix:@"mp4"]){
            self.contentType = ContentTypeMP4;
        }else if ([self.name hasSuffix:@"avi"]){
            self.contentType = ContentTypeAVI;
        }else if ([self.name hasSuffix:@"mov"]){
            self.contentType = ContentTypeMOV;
        }else if ([self.name hasSuffix:@"3gp"]){
            self.contentType = ContentType3GP;
        }else if([self.name hasSuffix:@"flv"]){
            self.contentType = ContentTypeFLV;
        }else if([self.name hasSuffix:@"mkv"]){
            self.contentType = ContentTypeMKV;
        }else if ([self.name hasSuffix:@"wmv"]){
            self.contentType = ContentTypeWMV;
        }else if ([self.name hasSuffix:@"jpg"]){
            self.contentType = ContentTypeJPG;
        }else if ([self.name hasSuffix:@"png"]){
            self.contentType = ContentTypePNG;
        }else if ([self.name hasSuffix:@"gif"]){
            self.contentType = ContentTypeGIF;
        }else if ([self.name hasSuffix:@"pdf"]) {
            self.contentType = ContentTypePDF;
        }else if ([self.name hasSuffix:@"txt"]){
            self.contentType = ContentTypeTEXT;
        }else if ([self.name hasSuffix:@"html"]){
            self.contentType = ContentTypeHTML;
        }else if ([self.name hasSuffix:@"doc"] || [self.name hasSuffix:@"docx"]){
            self.contentType = ContentTypeWORD;
        }else if([self.name hasSuffix:@"ppt"] || [self.name hasSuffix:@"pptx"]){
            self.contentType = ContentTypePPT;
        }else if ([self.name hasSuffix:@"xls"] || [self.name hasSuffix:@"xlsx"]){
            self.contentType = ContentTypeXLS;
        }else if([self.name hasSuffix:@"zip"] || [self.name hasSuffix:@"rar"] ||[self.name hasSuffix:@"gz"] || [self.name hasSuffix:@"xz"]){
            self.contentType = ContentTypeZIP;
        }else{
            self.contentType = ContentTypeOther;
        }
    }else{
        self.contentType = ContentTypeFolder;
    }
    
    return YES;
}
- (NSString *)contentSizeFromNSNumberToNSString:(NSNumber *)number
{
    NSString *formattedStr = nil;
    unsigned long long size = number.unsignedLongLongValue;
    if (size==0) {
        formattedStr = NSLocalizedString(@"－－",@"");
    }
    else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
    }else if (size >= 1024 && size < pow(1024, 2)){
        formattedStr = [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
    }else if (size >= pow(1024, 3)){
        formattedStr = [NSString stringWithFormat:@"%.2f GB", (size / pow(1024, 3))];
    }
    return formattedStr;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"url:%@,name:%@,contentType:%d,contentSize:%@,creationDate:%@,modifiedDate:%@",self.url,self.name,self.contentType,self.contentSize,self.creationDate,self.modifiedDate];
}
@end
