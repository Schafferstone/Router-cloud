//
//  PSFileCollectionViewCell.h
//  Router cloud
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSFileListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fileImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModifyLabel;


@end
