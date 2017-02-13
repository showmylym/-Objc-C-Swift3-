//
//  LYMPhotoBrowserWaitingView.h
//  LYMPhotoBrowser
//
//  Created by Jerry on 16-11-6.
//  Copyright (c) 2016年 Leiyiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYMPhotoBrowserConfig.h"

@interface LYMPhotoBrowserWaitingView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) int mode;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setProgress:(CGFloat)progress;

@end
