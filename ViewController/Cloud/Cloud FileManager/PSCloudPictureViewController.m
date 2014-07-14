//
//  PSCloudPictureViewController.m
//  Router cloud
//
//  Created by mac on 14-7-9.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSCloudPictureViewController.h"


#import "PSPictureDetailViewController.h"
@interface PSCloudPictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LEOWebDAVRequestDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_cloudArray;
    NSMutableArray *_localArray;
}
@end

@implementation PSCloudPictureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavBar];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 31, kDEVICEWIDTH, kDEVICEHEIGHT-64-49-31) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [layout setItemSize:CGSizeMake(kDEVICEWIDTH, 80)];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[PSFileListCollectionViewCell class] forCellWithReuseIdentifier:FileListCellIdentifier];
    [_collectionView registerClass:[PSFileGridCollectionViewCell class] forCellWithReuseIdentifier:FileGridCellIdentifier];
    _cloudArray = [NSMutableArray new];
    _localArray = [[NSMutableArray alloc] initWithArray:self.localArray];
    self.localArray = nil;
    [self requestDataFromRouter];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *button = (UIButton *)[_operationView viewWithTag:300];
    button.enabled = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_arrangmentView.hidden==NO) {
        _arrangmentView.hidden = YES;
    }
    [[PSClient sharedClient] cancelDelegate];
    [[PSClient sharedClient] cancelRequest];
}
#pragma mark - createNavBar
- (void)createNavBar
{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"本地·图片";
    self.navigationItem.titleView = titleView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(openCameraDevice)];
}
- (void)valueChange:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 44)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Cloud·图片";
        self.navigationItem.titleView = titleLabel;
    }else{
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 44)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"本地·图片";
        self.navigationItem.titleView = titleLabel;
    }
    [_collectionView reloadData];
}
- (void)openCameraDevice
{

}

#pragma mark - 从cloud里读取图片
- (void)requestDataFromRouter
{
    LEOWebDAVClient *client = [PSClient sharedClient];
    
    LEOWebDAVPropertyRequest *request = [[LEOWebDAVPropertyRequest alloc] initWithPath:@"/"];
    request.delegate = self;
    [client enqueueRequest:request];
}
#pragma mark - LEOWebDAVRequestDelegate
bool isFirst;
- (void)request:(LEOWebDAVRequest *)request didFailWithError:(NSError *)error
{
    if (!isFirst) {
        NSLog(@"error:%@",[error description]);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"获取磁盘信息失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        isFirst = YES;
    }
}
//static bool isSecond;
- (void)request:(LEOWebDAVRequest *)request didSucceedWithResult:(id)result
{
    isFirst = YES;
    if ([request isKindOfClass:[LEOWebDAVPropertyRequest class]]) {
            for (LEOWebDAVItem *item in result) {
                if (item.type == LEOWebDAVItemTypeCollection) {
//                    if (!isSecond) {
                        LEOWebDAVPropertyRequest *newReuqest = [[LEOWebDAVPropertyRequest alloc] initWithPath:item.href];
                        newReuqest.delegate = self;
                        [[PSClient sharedClient] enqueueRequest:newReuqest];
//                        isSecond = YES;
//                    }
                }else{
                    if ([item.displayName hasSuffix:@"jpg"] || [item.displayName hasSuffix:@"JPG"]) {
                        PSItemModel *itemModel = [PSItemModel new];
                        itemModel.name = item.displayName;
                        itemModel.url = item.url;
                        itemModel.contentSize = item.contentSize;
                        itemModel.contentType = ContentTypeJPG;
                        itemModel.creationDate = item.creationDate;
                        itemModel.modifiedDate = item.modifiedDate;
                        [_cloudArray addObject:itemModel];
                    }else if ([item.displayName hasSuffix:@"png"] || [item.displayName hasSuffix:@"PNG"]){
                        PSItemModel *itemModel = [PSItemModel new];
                        itemModel.name = item.displayName;
                        itemModel.url = item.url;
                        itemModel.contentSize = item.contentSize;
                        itemModel.contentType = ContentTypePNG;
                        itemModel.creationDate = item.creationDate;
                        itemModel.modifiedDate = item.modifiedDate;
                        [_cloudArray addObject:itemModel];
                    }else if ([item.displayName hasSuffix:@"gif"] || [item.displayName hasSuffix:@"GIF"]){
                        PSItemModel *itemModel = [PSItemModel new];
                        itemModel.name = item.displayName;
                        itemModel.url = item.url;
                        itemModel.contentSize = item.contentSize;
                        itemModel.contentType = ContentTypeGIF;
                        itemModel.creationDate = item.creationDate;
                        itemModel.modifiedDate = item.modifiedDate;
                        [_cloudArray addObject:itemModel];
                    }
                }
            }
            
        NSLog(@"%@",_cloudArray);
        [_collectionView reloadData];
    }
}



#pragma mark - CollectionViewDataSourceAndDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *localFilePath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],kPICTUREDIRECTORY];
    
    if (self.arrgmentType == ArragmentTypeList) {
        
        PSFileListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FileListCellIdentifier forIndexPath:indexPath];
        if (_segmentedControl.selectedSegmentIndex== 0)
        {
            PSItemModel *item = [_cloudArray objectAtIndex:indexPath.row];
            cell.fileNameLabel.text = item.name;
            cell.contentSizeLabel.text = item.contentSize;
            cell.lastModifyLabel.text = item.modifiedDate;
            [cell.fileImageView setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"file_picture.png"]];
        }else
        {
            PSItemModel *item = [_localArray objectAtIndex:indexPath.row];
            cell.fileNameLabel.text = item.name;
            NSString *urlstr = [NSString stringWithFormat:@"%@/%@",localFilePath, item.name];
            [item getFileAttributes:urlstr];
            cell.contentSizeLabel.text = item.contentSize;
            cell.lastModifyLabel.text = item.modifiedDate;
            [cell.fileImageView setImageWithURL:[NSURL fileURLWithPath:urlstr] placeholderImage:[UIImage imageNamed:@"file_picture.png"]];
        }
        return cell;
    }else{
        
        PSFileGridCollectionViewCell *cell = (PSFileGridCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FileGridCellIdentifier forIndexPath:indexPath];
        if (_segmentedControl.selectedSegmentIndex==0)
        {
            PSItemModel *item = [_cloudArray objectAtIndex:indexPath.row];
            cell.fileNameLabel.text = item.name;
            [cell.fileImageView setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"file_picture.png"]];
        }else
        {
            PSItemModel *item = [_localArray objectAtIndex:indexPath.row];
            cell.fileNameLabel.text = item.name;
            NSString *urlstr = [NSString stringWithFormat:@"%@/%@",localFilePath, item.name];
            [item getFileAttributes:urlstr];
            [cell.fileImageView setImageWithURL:[NSURL fileURLWithPath:urlstr] placeholderImage:[UIImage imageNamed:@"file_picture.png"]];
        }
        return cell;
    }
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_segmentedControl.selectedSegmentIndex==0) {
        return _cloudArray.count;
    }else{
        return _localArray.count;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size ;
    if (self.arrgmentType == ArragmentTypeList)
    {
        size = CGSizeMake(kDEVICEWIDTH, 90);
    }else
    {
        size = CGSizeMake(100, 120);
    }
    return size;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PSPictureDetailViewController *pictureDetailViewController = [PSPictureDetailViewController new];
    pictureDetailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    if (self.arrgmentType == ArragmentTypeList) {
        PSFileListCollectionViewCell *cell = (PSFileListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        pictureDetailViewController.image = cell.fileImageView.image;
    }else{
        PSFileGridCollectionViewCell *cell = (PSFileGridCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        pictureDetailViewController.image = cell.fileImageView.image;
    }
    [self presentViewController:pictureDetailViewController animated:YES completion:nil];
}
#pragma mark - buttonclicked
- (void)fileButtonClicked:(UIButton *)button
{
    switch (button.tag) {
        case 300:
        {
            
        }
            break;
        case 301:
        {
            
        }
            break;
        case 302:
        {
            [_collectionView reloadData];
        }
            break;
        case 303:
        {
            if (_arrangmentView.hidden==NO) {
                _arrangmentView.hidden = YES;
            }else{
                _arrangmentView.hidden = NO;
            }
        }
            break;
        case 304:
        {
            if (self.arrgmentType == ArragmentTypeList) {
                UILabel * titleLabel= (UILabel *)[button.superview viewWithTag:104];
                titleLabel.text = @"列表";
                [button setImage:[[UIImage imageNamed:@"list.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                self.arrgmentType = ArragmentTypeGrid;
                [_collectionView reloadData];
            }else{
                UILabel * titleLabel= (UILabel *)[button.superview viewWithTag:104];
                titleLabel.text = @"视图";
                [button setImage:[[UIImage imageNamed:@"matrix.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                self.arrgmentType = ArragmentTypeList;
                [_collectionView reloadData];
            }
        }
            break;
        default:
            break;
    }

}
- (void)reArrangment:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {//按名称
            if (_segmentedControl.selectedSegmentIndex==0) {
               NSArray *sortedArray = [_cloudArray sortedArrayUsingComparator:^NSComparisonResult(PSItemModel *item1, PSItemModel *item2) {
                   return [item1.name compare:item2.name options:NSNumericSearch];
                }];
                if (_cloudArray.count != 0) {
                    [_cloudArray removeAllObjects];
                }
                [_cloudArray addObjectsFromArray:sortedArray];
                [_collectionView reloadData];
            }else{
               NSArray *sortedArray = [_localArray sortedArrayUsingComparator:^NSComparisonResult(PSItemModel *item1, PSItemModel *item2) {
                   return [item1.name compare:item2.name options:NSNumericSearch];
                }];
                if (_localArray.count != 0) {
                    [_localArray removeAllObjects];
                }
                [_localArray addObjectsFromArray:sortedArray];
                [_collectionView reloadData];
            }
        }
            break;
        case 101:
        {//按类型
            if (_segmentedControl.selectedSegmentIndex == 0) {
                NSMutableArray *imageArray = [NSMutableArray new];
                if (_cloudArray.count!=0) {
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeJPG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypePNG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeGIF) {
                            [imageArray addObject:item];
                        }
                    }
                    [_cloudArray removeAllObjects];
                    [_cloudArray addObjectsFromArray:imageArray];
                }
                [_collectionView reloadData];
            }else{
                NSMutableArray *imageArray = [NSMutableArray new];
                if (_localArray.count!=0) {
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeJPG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypePNG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeGIF) {
                            [imageArray addObject:item];
                        }
                    }
                    [_localArray removeAllObjects];
                    [_localArray addObjectsFromArray:imageArray];
                }
                [_collectionView reloadData];
            }
        }
            break;
        case 102:
        {//大小
            if (_segmentedControl.selectedSegmentIndex==0) {
                NSArray *sortedArray = [_cloudArray sortedArrayUsingComparator:^NSComparisonResult(PSItemModel *item1, PSItemModel *item2) {
                    if ([self range:item1.contentSize] > [self range:item2.contentSize]) {
                        return NSOrderedDescending;
                    }else if ([self range:item1.contentSize] < [self range:item2.contentSize]){
                        return NSOrderedAscending;
                    }
                    return NSOrderedSame;
                }];
                if (_cloudArray.count != 0) {
                    [_cloudArray removeAllObjects];
                }
                [_cloudArray addObjectsFromArray:sortedArray];
                [_collectionView reloadData];
            }else{
                NSArray *sortedArray = [_localArray sortedArrayUsingComparator:^NSComparisonResult(PSItemModel *item1, PSItemModel *item2) {
                    if ([self range:item1.contentSize] > [self range:item2.contentSize]) {
                        return NSOrderedDescending;
                    }else if ([self range:item1.contentSize] < [self range:item2.contentSize]){
                        return NSOrderedAscending;
                    }
                    return NSOrderedSame;
                }];
                if (_localArray.count != 0) {
                    [_localArray removeAllObjects];
                }
                [_localArray addObjectsFromArray:sortedArray];
                [_collectionView reloadData];
            }

        }
            break;
        case 103:
        {//时间
            if (_segmentedControl.selectedSegmentIndex==0) {
                NSArray *sortedArray = [_cloudArray sortedArrayUsingComparator:^NSComparisonResult(PSItemModel *item1, PSItemModel *item2) {
                    return [[self date:item1.modifiedDate] compare:[self date:item2.modifiedDate]];
                }];
                if (_cloudArray.count != 0) {
                    [_cloudArray removeAllObjects];
                }
                [_cloudArray addObjectsFromArray:sortedArray];
                [_collectionView reloadData];
            }else{
                NSArray *sortedArray = [_localArray sortedArrayUsingComparator:^NSComparisonResult(PSItemModel *item1, PSItemModel *item2) {
                    return [[self date:item1.modifiedDate] compare:[self date:item2.modifiedDate]];
                }];
                if (_localArray.count != 0) {
                    [_localArray removeAllObjects];
                }
                [_localArray addObjectsFromArray:sortedArray];
                [_collectionView reloadData];
            }

        }
            break;
            
        default:
            break;
    }
    _arrangmentView.hidden = YES;
}

//转换同一大小单位
-(float)range:(NSString*)str{
    float value=0;
    if ([str rangeOfString:@"MB"].location!=NSNotFound) {
        value=[str floatValue]*1024.0;
    }else if ([str rangeOfString:@"KB"].location!=NSNotFound){
        value=[str floatValue];
    }
    return value;
}
//转换回时间格式
- (NSDate *)date:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}
@end
