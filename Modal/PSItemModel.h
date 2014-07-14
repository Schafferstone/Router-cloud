//
//  PSItemModel.h
//  Router cloud
//
//  Created by mac on 14-7-12.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ContentType){
    ContentTypeJPG,
    ContentTypePNG,
    ContentTypeGIF,
    ContentTypeMP3,
    ContentTypeWMA,
    ContentTypeAAC,
    ContentTypeOGG,
    ContentTypeMP4,
    ContentTypeAVI,
    ContentTypeMOV,
    ContentTypeMKV,
    ContentType3GP,
    ContentTypeWMV,
    ContentTypeFLV,
    ContentTypeXLS,
    ContentTypeHTML,
    ContentTypePDF,
    ContentTypePPT,
    ContentTypeTEXT,
    ContentTypeWORD,
    ContentTypeZIP,
    ContentTypeFolder,
    ContentTypeOther
};
@interface PSItemModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *contentSize;
@property (nonatomic, strong) NSString *creationDate;
@property (nonatomic, strong) NSString *modifiedDate;
@property (nonatomic) ContentType contentType;
- (BOOL)getFileAttributes:(NSString *)filePath;
@end
