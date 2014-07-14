//
//  PSMusicViewController.h
//  Router cloud
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PSMusicViewController : UIViewController
{
//    AVAudioPlayer *_player;
    NSMutableArray *_songArray;
}
@property (nonatomic, strong) AVAudioPlayer *player;
+ (PSMusicViewController *)sharedMusicPlayer;
@end
