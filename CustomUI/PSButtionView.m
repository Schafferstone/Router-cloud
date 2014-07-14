//
//  PSButtionView.m
//  Router cloud
//
//  Created by Zpz on 14-7-7.
//  Copyright (c) 2014年 west. All rights reserved.
//

#import "PSButtionView.h"
#define kDEVICEWIDTH [UIScreen mainScreen].bounds.size.width
@implementation PSButtionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(22, 14, 60, 60);
        [self addSubview:_button];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, kDEVICEWIDTH/3, 20)];
        [self addSubview:_titleLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
