//
//  LYMPhotoBrowserOnePhotoScrollView.h
//  LYMPhotoBrowser
//
//  Created by Jerry on 16-11-6.
//  Copyright (c) 2016年 Leiyiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYMPhotoBrowserWaitingView.h"

@class LYMPhotoBrowserOnePhotoScrollView;

@protocol LYMPhotoBrowserOnePhotoScrollViewDelegate <NSObject>

- (void)oneScrollView:(LYMPhotoBrowserOnePhotoScrollView *)scrollView downloadWithURL:(NSURL *)url image:(UIImage *)image;
- (void)oneScrollView:(LYMPhotoBrowserOnePhotoScrollView *)scrollView didTap:(UITapGestureRecognizer *)tapGesture;

@end

@interface LYMPhotoBrowserOnePhotoScrollView : UIScrollView

@property (nonatomic, weak) id<LYMPhotoBrowserOnePhotoScrollViewDelegate> browserDelegate;
@property (nonatomic) CGFloat progress;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, strong) UIImageView * mainImageView;

- (void)eliminateScale; // 清除缩放
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder; //设置图片
- (BOOL)isScaled; //是否在缩放状态
- (BOOL)hasLoadedImage; //是否加载过图片

@end
