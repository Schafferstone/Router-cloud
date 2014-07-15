//
//  PSFilesViewController.m
//  Router cloud
//
//  Created by mac on 14-7-9.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSCloudFilesViewController.h"

@interface PSCloudFilesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LEOWebDAVRequestDelegate>

{
    NSMutableArray *_cloudArray;
    NSMutableArray *_localArray;
}
@end

@implementation PSCloudFilesViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self createNavBar];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 31, kDEVICEWIDTH, kDEVICEHEIGHT-64-49-31) collectionViewLayout:layout];
    [layout setItemSize:CGSizeMake(kDEVICEWIDTH, 80)];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[PSFileListCollectionViewCell class] forCellWithReuseIdentifier:FileListCellIdentifier];
    [_collectionView registerClass:[PSFileGridCollectionViewCell class] forCellWithReuseIdentifier:FileGridCellIdentifier];
    _cloudArray = [NSMutableArray new];
    _localArray = [NSMutableArray arrayWithArray:self.localArray];
    self.localArray = nil;
    [self requestDataFromRouter];
}
- (void)createNavBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_head.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarMetricsDefault target:self action:@selector(returnToHomePage)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"本地·文件";
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
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
- (void)valueChange:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 44)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Cloud·文件";
        self.navigationItem.titleView = titleLabel;
    }else{
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 100, 44)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"本地·文件";
        self.navigationItem.titleView = titleLabel;
    }
    [_collectionView reloadData];
}
- (void)returnToHomePage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
- (void)request:(LEOWebDAVRequest *)request didSucceedWithResult:(id)result
{
    isFirst = YES;
    if ([request isKindOfClass:[LEOWebDAVPropertyRequest class]]) {
        for (LEOWebDAVItem *item in result) {
            
            if (item.type == LEOWebDAVItemTypeCollection) {
                LEOWebDAVPropertyRequest *newReuqest = [[LEOWebDAVPropertyRequest alloc] initWithPath:item.href];
                newReuqest.delegate = self;
                [[PSClient sharedClient] enqueueRequest:newReuqest];
                if ([item.displayName rangeOfString:@"disk"].length>0) {
                    continue;
                }
                PSItemModel *itemModel = [PSItemModel new];
                itemModel.name = item.displayName;
                itemModel.url = item.url;
                itemModel.contentSize = item.contentSize;
                itemModel.contentType = ContentTypeFolder;
                itemModel.creationDate = item.creationDate;
                itemModel.modifiedDate = item.modifiedDate;
                [_cloudArray addObject:itemModel];
            }else{
                if ([item.displayName rangeOfString:@"aac"].length>0) {
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeAAC;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }else if ([item.displayName rangeOfString:@"ogg"].length>0){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeOGG;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];

                }else if ([item.displayName rangeOfString:@"wma"].length>0){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeWMA;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"mp3"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeMP3;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"jpg"] || [item.displayName hasSuffix:@"JPG"]){
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
                    
                }else if ([item.displayName hasSuffix:@"avi"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeAVI;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"mov"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeMOV;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"3gp"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentType3GP;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"flv"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeFLV;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"mkv"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeMKV;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"wmv"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeWMV;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"mp4"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeMP4;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                    
                }else if ([item.displayName hasSuffix:@"ppt"] || [item.displayName hasSuffix:@"pptx"]) {
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypePPT;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }else if ([item.displayName hasSuffix:@"xls"] || [item.displayName hasSuffix:@"xlsx"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeXLS;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }else if ([item.displayName hasSuffix:@"pdf"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypePDF;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }else if ([item.displayName hasSuffix:@"doc"] || [item.displayName hasSuffix:@"docx"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeWORD;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }else if ([item.displayName hasSuffix:@"html"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeHTML;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }else if([item.displayName hasSuffix:@"text"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeTEXT;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }else if([item.displayName hasSuffix:@"zip"] || [item.displayName hasSuffix:@"rar"]
                         || [item.displayName hasSuffix:@"gz"] || [item.displayName hasSuffix:@"xz"]
                         || [item.displayName hasSuffix:@"bz"]){
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeZIP;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }else{
                    PSItemModel *itemModel = [PSItemModel new];
                    itemModel.name = item.displayName;
                    itemModel.url = item.url;
                    itemModel.contentSize = item.contentSize;
                    itemModel.contentType = ContentTypeOther;
                    itemModel.creationDate = item.creationDate;
                    itemModel.modifiedDate = item.modifiedDate;
                    [_cloudArray addObject:itemModel];
                }
            }
        }
        
        
        [_collectionView reloadData];
    }
}
#pragma mark - CollectionViewDataSourceAndDelegate
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *localFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if (self.arrgmentType == ArragmentTypeList) {
        PSFileListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FileListCellIdentifier forIndexPath:indexPath];
        if (_segmentedControl.selectedSegmentIndex==0)
        {
            PSItemModel *item = [_cloudArray objectAtIndex:indexPath.row];
            cell.fileNameLabel.text = item.name;
            cell.contentSizeLabel.text = item.contentSize;
            cell.lastModifyLabel.text = item.modifiedDate;
            if (item.contentType == ContentTypePNG || item.contentType == ContentTypeJPG || item.contentType == ContentTypeGIF){
                [cell.fileImageView setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"file_picture.png"]];
            }else{
                [self configureCellForFileImage:cell withFileType:item.contentType];
            }
        }else
        {
            PSItemModel *item = [_localArray objectAtIndex:indexPath.row];
            cell.fileNameLabel.text = item.name;
            NSString *urlstr = [NSString stringWithFormat:@"%@/%@",localFilePath, item.name];
            [item getFileAttributes:urlstr];
            cell.contentSizeLabel.text = item.contentSize;
            cell.lastModifyLabel.text = item.modifiedDate;
            if (item.contentType == ContentTypePNG || item.contentType == ContentTypeJPG || item.contentType == ContentTypeGIF){
                [cell.fileImageView setImageWithURL:[NSURL fileURLWithPath:item.url] placeholderImage:[UIImage imageNamed:@"file_picture.png"]];
            }else{
                [self configureCellForFileImage:cell withFileType:item.contentType];
            }
        }
        return cell;
    }else{
        PSFileGridCollectionViewCell *cell = (PSFileGridCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:FileGridCellIdentifier forIndexPath:indexPath];
        if (_segmentedControl.selectedSegmentIndex==0)
        {
            PSItemModel *item = [_cloudArray objectAtIndex:indexPath.row];
            cell.fileNameLabel.text = item.name;
            if (item.contentType == ContentTypePNG || item.contentType == ContentTypeJPG || item.contentType == ContentTypeGIF){
                [cell.fileImageView setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"file_picture.png"]];
            }else{
                [self configureCellForFileImage:cell withFileType:item.contentType];
            }
        }else
        {
            PSItemModel *item = [_localArray objectAtIndex:indexPath.row];
            cell.fileNameLabel.text = item.name;
            NSString *urlstr = [NSString stringWithFormat:@"%@/%@",localFilePath, item.name];
            [item getFileAttributes:urlstr];
            if (item.contentType == ContentTypePNG || item.contentType == ContentTypeJPG || item.contentType == ContentTypeGIF){
                [cell.fileImageView setImageWithURL:[NSURL fileURLWithPath:item.url] placeholderImage:[UIImage imageNamed:@"file_picture.png"]];
            }else{
                [self configureCellForFileImage:cell withFileType:item.contentType];
            }
        }
        
        return cell;
    }
    
}
- (void)configureCellForFileImage:(UICollectionViewCell *)cell withFileType:(ContentType)type
{
    if ([cell isKindOfClass:[PSFileListCollectionViewCell class]]) {
        PSFileListCollectionViewCell *listCell = (PSFileListCollectionViewCell *)cell;
        if (type == ContentTypeXLS) {
            listCell.fileImageView.image = [UIImage imageNamed:@"file_excel.png"];
        }else if (type == ContentTypeHTML){
            listCell.fileImageView.image = [UIImage imageNamed:@"file_html.png"];
        }else if (type == ContentTypeAAC || type == ContentTypeOGG || type == ContentTypeMP3 || type == ContentTypeWMA){
            listCell.fileImageView.image = [UIImage imageNamed:@"file_music.png"];
        }else if (type == ContentTypeAVI || type == ContentTypeMOV || type == ContentTypeMP4 || type == ContentType3GP || type == ContentTypeFLV || type == ContentTypeWMV || type == ContentTypeMKV){
            listCell.fileImageView.image = [UIImage imageNamed:@"file_video.png"];
        }else if (type == ContentTypePDF){
            listCell.fileImageView.image = [UIImage imageNamed:@"file_pdf.png"];
        }else if(type == ContentTypePPT){
            listCell.fileImageView.image = [UIImage imageNamed:@"file_ppt.png"];
        }else if (type == ContentTypeTEXT){
            listCell.fileImageView.image = [UIImage imageNamed:@"file_text.png"];
        }else if (type == ContentTypeWORD){
            listCell.fileImageView.image = [UIImage imageNamed:@"file_word.png"];
        }else if (type == ContentTypeZIP){
            listCell.fileImageView.image = [UIImage imageNamed:@"file_zip.png"];
        }else if (type == ContentTypeFolder){
            listCell.fileImageView.image = [UIImage imageNamed:@"folder.png"];
        }else{
            listCell.fileImageView.image = [UIImage imageNamed:@"other.png"];
        }
    }else{
        PSFileGridCollectionViewCell *gridCell = (PSFileGridCollectionViewCell *)cell;
        if (type == ContentTypeXLS) {
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_excel.png"];
        }else if (type == ContentTypeHTML){
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_html.png"];
        }else if (type == ContentTypeAAC || type == ContentTypeWMA || type == ContentTypeMP3 || type == ContentTypeOGG){
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_music.png"];
        }else if (type == ContentTypeAVI || type == ContentTypeMOV || type == ContentTypeMP4 || type == ContentType3GP || type == ContentTypeFLV || type == ContentTypeWMV){
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_video.png"];
        }else if (type == ContentTypePDF){
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_pdf.png"];
        }else if(type == ContentTypePPT){
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_ppt.png"];
        }else if (type == ContentTypeTEXT){
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_text.png"];
        }else if (type == ContentTypeWORD){
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_word.png"];
        }else if (type == ContentTypeZIP){
            gridCell.fileImageView.image = [UIImage imageNamed:@"file_zip.png"];
        }else if (type == ContentTypeFolder){
            gridCell.fileImageView.image = [UIImage imageNamed:@"folder.png"];
        }else{
            gridCell.fileImageView.image = [UIImage imageNamed:@"other.png"];
        }
        
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
                        if (item.contentType == ContentTypePNG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeJPG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeGIF) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeWORD) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypePPT) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeXLS) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypePDF) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeTEXT) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeHTML) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeMP3) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeAAC) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeWMA) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeOGG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeMP4) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeAVI) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeMOV) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeWMV) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentType3GP) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeMKV) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeFLV) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeZIP) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeOther) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _cloudArray) {
                        if (item.contentType == ContentTypeFolder) {
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
                        if (item.contentType == ContentTypePNG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeJPG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeGIF) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeWORD) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypePPT) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeXLS) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypePDF) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeTEXT) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeHTML) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeMP3) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeAAC) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeWMA) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeOGG) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeMP4) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeAVI) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeMOV) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeWMV) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentType3GP) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeMKV) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeFLV) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeZIP) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeOther) {
                            [imageArray addObject:item];
                        }
                    }
                    for (PSItemModel *item in _localArray) {
                        if (item.contentType == ContentTypeFolder) {
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
