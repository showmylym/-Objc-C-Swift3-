//
//  LYMPhotoBrowserConfig.h
//  LYMPhotoBrowser
//
//  Created by Jerry on 16-11-6.
//  Copyright (c) 2016年 Leiyiming. All rights reserved.
//


typedef enum {
    LYMPhotoBrowserWaitingViewModeLoopDiagram, // 环形
    LYMPhotoBrowserWaitingViewModePieDiagram // 饼型
} LYMPhotoBrowserWaitingViewMode;

// 图片保存成功提示文字
#define LYMPhotoBrowserSaveImageSuccessText  @"保存成功"

// 图片保存失败提示文字
#define LYMPhotoBrowserSaveImageFailText     @"保存失败"

// 图片保存进度提示文字
#define LYMPhotoBrowserSaveingImage          @"保存中"

// browser背景颜色
#define LYMPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define LYMPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define LYMPhotoBrowserShowImageAnimationDuration 0.2

// browser中隐藏图片动画时长
#define LYMPhotoBrowserHideImageAnimationDuration 0.2

// browser中缩放图片动画时长
#define LYMPhotoBrowserScaleImageAnimationDuration 0.2

// 图片下载进度指示进度显示样式（LYMPhotoBrowserWaitingViewModeLoopDiagram 环形，LYMPhotoBrowserWaitingViewModePieDiagram 饼型）
#define LYMPhotoBrowserWaitingViewProgressMode LYMPhotoBrowserWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define LYMPhotoBrowserWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define LYMPhotoBrowserWaitingViewItemMargin 16
