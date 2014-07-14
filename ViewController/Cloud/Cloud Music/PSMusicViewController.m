//
//  PSMusicViewController.m
//  Router cloud
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSMusicViewController.h"
#import "PSCloudMusicViewController.h"

@interface PSMusicViewController ()
{
    
}
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animation;

@property (nonatomic) NSUInteger currentSong;
@end

@implementation PSMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _player = [[AVAudioPlayer alloc] init];
        _songArray = [NSMutableArray new];
    }
    return self;
}

+ (PSMusicViewController *)sharedMusicPlayer
{
    static PSMusicViewController *musicViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicViewController = [[PSMusicViewController alloc] initWithNibName:@"PSMusicViewController" bundle:nil];
    });
    return musicViewController;
}
#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置音频会话支持后台播放
//    [_customNavBar setBackgroundImage:[UIImage imageNamed:@"cloud_music_nav_back.png"] forBarMetrics:UIBarMetricsDefault];
    
//    [self.leftBarButtonItem setImage:];
//    [self.rightBarButtonItem setImage:[[UIImage imageNamed:@"music_list.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    NSMutableArray *imageArray = [NSMutableArray new];
    for (int i=1; i<9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animation_%d",i]];
        [imageArray addObject:image];
    }
    _animation.animationImages = imageArray;
    [self animationStart];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}
- (void)createNavigationBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cloud_music_nav_back.png"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"music_list.png"]imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(jmpToCloudMusic)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self createNavigationBar];
}

#pragma mark - navigationbar的事件
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)jmpToCloudMusic{
    PSCloudMusicViewController *cloudMusicViewController = [PSCloudMusicViewController new];
//    cloudMusicViewController.leftItemName = _songArray[_currentSong];
//    cloudMusicViewController.leftItemName = @"song";
    [self.navigationController pushViewController:cloudMusicViewController animated:YES];
}


#pragma mark - 播放相关的设置
- (IBAction)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {
            
        }
            break;
        case 103:
        {
            
        }
            break;
        case 104:
        {
            
        }
            break;
        case 105:
        {
            if(!_player.isPlaying){
                [_player play];
                [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            }else{
                [_player pause];
                [sender setImage:[UIImage imageNamed:@"play_current"] forState:UIControlStateNormal];
            }
        }
            break;
        case 106:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)startPlaying{
    
}
- (void)animationStart{
    [_animation setAnimationDuration:0.8];
    [_animation setAnimationRepeatCount:0];
    [_animation startAnimating];
}
- (void)dealloc
{
    NSLog(@"音乐播放页销毁");
}

@end
