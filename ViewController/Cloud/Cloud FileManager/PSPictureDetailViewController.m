//
//  PSPictureDetailViewController.m
//  Router cloud
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSPictureDetailViewController.h"
#import "PSBaseViewController.h"
#import <ZoomTransitionProtocol.h>
@interface PSPictureDetailViewController ()<ZoomTransitionProtocol>
{
    UIImageView *_imageView;
}
@end

@implementation PSPictureDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kDEVICEWIDTH-20, kDEVICEHEIGHT-80)];
    [self.view addSubview:_imageView];
    _imageView.image = self.image;
    _imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [_imageView addGestureRecognizer:longPress];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = self.name;
    self.navigationItem.titleView = titleView;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)viewForZoomTransition
{
    return _imageView;
}
@end
