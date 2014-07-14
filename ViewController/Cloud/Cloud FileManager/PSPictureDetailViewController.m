//
//  PSPictureDetailViewController.m
//  Router cloud
//
//  Created by mac on 14-7-11.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSPictureDetailViewController.h"
@interface PSPictureDetailViewController ()

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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds   ];
    [self.view addSubview:imageView];
    imageView.image = self.image;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [imageView addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
