//
//  PSMusicViewController.h
//  Router cloud
//
//  Created by mac on 14-7-8.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PSItemModel.h"
typedef NS_ENUM(NSInteger, PlayType){
    PlayTypeCircle,
    PlayTypeRandom,
    PlayTypeSingle
};

@interface PSMusicViewController : UIViewController
{
//    AVAudioPlayer *_player;
    NSMutableArray *_songArray;
}
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic,assign) NSUInteger currentSong;
@property (nonatomic, strong) NSMutableArray *songArray;
@property (nonatomic, assign) NSUInteger accessType;
+ (PSMusicViewController *)sharedMusicPlayer;
@end
