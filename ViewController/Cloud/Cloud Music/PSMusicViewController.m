//
//  PSMusicViewController.m
//  Router cloud
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSMusicViewController.h"
#import "PSCloudMusicViewController.h"

@interface PSMusicViewController ()<AVAudioPlayerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animation;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;


@property (nonatomic) NSInteger currentPlayType;
@end

@implementation PSMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:@""] error:nil];
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
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    _player.delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCurrentTimeAndProgress) userInfo:nil repeats:YES];
    [self getTotalTime];
    self.currentPlayType = PlayTypeCircle;
    self.playTypeLabel.text = @"循环播放";
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
- (void)createNavigationBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cloud_music_nav_back.png"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    if (self.accessType == AccessTypeDirect) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"music_list.png"]imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(jmpToCloudMusic)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.accessType == AccessTypeDirect) {
        [_player stop];
        [_animation stopAnimating];
        [self.playerButton setImage:[UIImage imageNamed:@"play_current"] forState:UIControlStateNormal];
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleView.textColor = [UIColor whiteColor];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.text = @"云音乐";
        self.navigationItem.titleView = titleView;
    }else{
        [self startPlaying];
        [self.playerButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self getCurrentSongName];
    }

    self.tabBarController.tabBar.hidden = YES;
    [self createNavigationBar];
}
#pragma mark - getCurrentTime  and getTotalTime getCurrentSongName
- (void)getCurrentTimeAndProgress
{
    self.currentTime.textColor = [UIColor whiteColor];
    self.currentTime.textAlignment = NSTextAlignmentLeft;
    self.currentTime.text = [NSString stringWithFormat:@"%.2d:%.2d",(int)_player.currentTime/60,(int)_player.currentTime%60];
    self.progressSlider.value = _player.currentTime/_player.duration;
}
- (void)getTotalTime
{
    self.totalLabel.textColor = [UIColor whiteColor];
    self.totalLabel.text = [NSString stringWithFormat:@"%.2d:%.2d",(int)_player.duration/60,(int)_player.duration%60];
}
- (void)getCurrentSongName
{
    PSItemModel *item = [self.songArray objectAtIndex:self.currentSong];
    NSURL *fileURL = nil;
    if ([item.url rangeOfString:@"Documents"].length>0) {
        fileURL = [NSURL fileURLWithPath:item.url];
    }else{
        fileURL = [NSURL URLWithString:item.url];
    }
    AVURLAsset *avURLAsset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    for (NSString *format in [avURLAsset availableMetadataFormats]) {
        for (AVMetadataItem *metadata in [avURLAsset metadataForFormat:format]) {
            if ([metadata.commonKey isEqualToString:@"artist"]) {
                self.artistLabel.text = (NSString *)metadata.value;
            }
            if ([metadata.commonKey isEqualToString:@"title"]) {
                UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
                titleView.textColor = [UIColor whiteColor];
                titleView.textAlignment = NSTextAlignmentCenter;
                titleView.text = (NSString *)metadata.value;
                self.navigationItem.titleView = titleView;
            }
        }
    }
}
#pragma mark - navigationbar的事件
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)jmpToCloudMusic{
    PSCloudMusicViewController *cloudMusicViewController = [PSCloudMusicViewController sharedCloudMusic];
    [self.navigationController pushViewController:cloudMusicViewController animated:YES];
}


#pragma mark - 播放相关的设置

- (IBAction)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            if (self.currentPlayType == PlayTypeCircle) {
                [sender setImage:[UIImage imageNamed:@"play_random.png"] forState:UIControlStateNormal];
                self.currentPlayType = PlayTypeRandom;
                self.playTypeLabel.text = @"随机播放";
            }else if(self.currentPlayType == PlayTypeRandom){
                [sender setImage:[UIImage imageNamed:@"play_single.png"] forState:UIControlStateNormal];
                self.currentPlayType = PlayTypeSingle;
                self.playTypeLabel.text = @"单曲循环";
            }else{
                [sender setImage:[UIImage imageNamed:@"play_circle.png"] forState:UIControlStateNormal];
                self.currentPlayType = PlayTypeCircle;
                self.playTypeLabel.text = @"循环播放";
            }
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
            if (self.currentPlayType == PlayTypeCircle) {
                if (self.currentSong == 0) {
                    self.currentSong = self.songArray.count-1;
                }else{
                    self.currentSong -= 1;
                }
            }else if (self.currentPlayType == PlayTypeRandom){
                self.currentSong = arc4random()%self.songArray.count;
            }
            [self startPlaying];
        }
            break;
        case 105:
        {
            if(!_player.isPlaying){
                [_player play];
                [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                [self getCurrentSongName];
                [_animation startAnimating];
            }else{
                [_player pause];
                [sender setImage:[UIImage imageNamed:@"play_current"] forState:UIControlStateNormal];
            }
        }
            break;
        case 106:
        {
            if (self.currentPlayType == PlayTypeCircle) {
                if (self.currentSong==self.songArray.count-1) {
                    self.currentSong = 0;
                }else{
                    self.currentSong += 1;
                }
            }else if (self.currentPlayType == PlayTypeRandom){
                self.currentSong = arc4random()%self.songArray.count;
            }
            [self startPlaying];
        }
            break;
        default:
            break;
    }
}

- (void)startPlaying{
    if (self.songArray.count == 0) {
        return;
    }
    _player = nil;
    PSItemModel *item = [self.songArray objectAtIndex:self.currentSong];
    if ([item.url rangeOfString:@"Documents"].length>0) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:item.url] error:nil];
    }else{
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:item.url] error:nil];
    }
    [self getCurrentSongName];
    [self getTotalTime];
    _player.delegate = self;
    [_player prepareToPlay];
    [_player play];
}
- (IBAction)progressSlider:(UISlider *)sender {
    _player.currentTime = sender.value * _player.duration;
}
- (void)animationStart{
    [_animation setAnimationDuration:0.8];
    [_animation setAnimationRepeatCount:0];
    [_animation startAnimating];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.currentPlayType == PlayTypeCircle) {
        if (self.currentSong==self.songArray.count-1) {
            self.currentSong = 0;
        }else{
            self.currentSong++;
        }
    }else if (self.currentPlayType == PlayTypeRandom){
        self.currentSong = arc4random()%self.songArray.count;
    }
    [self startPlaying];
}

@end
