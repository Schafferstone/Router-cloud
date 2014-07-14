//
//  PSCloudFileManagerViewController.h
//  Router cloud
//
//  Created by mac on 14-7-9.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSBaseViewController.h"
#import "LEOWebDAVClient.h"
#import "LEOWebDAVPropertyRequest.h"
#import "LEOWebDAVDownloadRequest.h"
#import "LEOWebDAVItem.h"
#import "PSItemModel.h"
#import "PSClient.h"
#import "PSFileGridCollectionViewCell.h"
#import "PSFileListCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#define kPICTUREDIRECTORY @"picture"
#define KMUSICDIRECTORY   @"music"
#define kVIDEODIRECTORY   @"video"
#define kDOCUMENTDIRECTORY  @"document"
#define kFILEDIRECTORY    @"file"
#define kCOLLECTIONDIRECTORY  @"collection"
static NSString *FileListCellIdentifier = @"FileListCell";
static NSString *FileGridCellIdentifier = @"FileGridCell";
typedef NS_ENUM(NSUInteger, ArragmentType)
{
    ArragmentTypeList,
    ArragmentTypeGrid
};

@interface PSCloudFileManagerViewController : PSBaseViewController
{
    UISegmentedControl *_segmentedControl;
//    NSMutableArray *_localArray;
//    NSMutableArray *_cloudArray;
    UIView *_operationView;
    UIView *_arrangmentView;
    
}
@property (nonatomic, strong) NSMutableArray *localArray;
//@property (nonatomic, strong) AQGridView *gridView;
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic) NSUInteger arrgmentType;
@property (nonatomic) BOOL isAccessToCloud;
- (void)valueChange:(UISegmentedControl *)segmentedControl;
- (void)fileButtonClicked:(UIButton *)button;
- (void)createNavBarItem;
- (void)reArrangment:(UIButton *)button;
@end
