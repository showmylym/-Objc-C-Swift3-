//
//  LYMPhotoBrowserOnePhotoScrollView.m
//  LYMPhotoBrowser
//
//  Created by Jerry on 16-11-6.
//  Copyright (c) 2016年 Leiyiming. All rights reserved.
//

#import "LYMPhotoBrowserOnePhotoScrollView.h"
#import "UIImageView+WebCache.h"
#import "LYMPhotoBrowserConfig.h"
#import "UIView+Coordinate.h"

@interface LYMPhotoBrowserOnePhotoScrollView ()
<UIScrollViewDelegate>

@property (nonatomic, weak) LYMPhotoBrowserWaitingView * waitingView;
@property (nonatomic, readwrite) BOOL hasLoadedImage; //是否已经加载过图片
@property (nonatomic) BOOL isCompletedLoad; //是否已完成图片加载
@property (nonatomic, strong) UITapGestureRecognizer * doubleTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer * singleTapGesture;


@end

@implementation LYMPhotoBrowserOnePhotoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        //构造tap手势
        [self constructTapGesture];
        //构造imageView
        [self constructImageView];
    }
    return self;
}

#pragma mark - Construct
- (void)constructTapGesture {
    // 单击图片，回调销毁相册
    self.singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoSingleTapped:)];
    
    // 双击放大图片
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDoubleTapped:)];
    self.doubleTapGesture.numberOfTapsRequired = 2;
    
    [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    
    [self addGestureRecognizer:self.singleTapGesture];
    [self addGestureRecognizer:self.doubleTapGesture];
}

- (void)constructImageView {
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:self.mainImageView];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImageView.clipsToBounds = YES;
}

#pragma mark - Public methods
// 清除缩放
- (void)eliminateScale {
    //重置为1倍的状态
    [self setZoomScale:1.0 animated:NO];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    self.hasLoadedImage = YES;
    if (url) {
        //url不为nil时才添加进度条view
        LYMPhotoBrowserWaitingView *waiting = [[LYMPhotoBrowserWaitingView alloc] init];
        [self addSubview:waiting];
        waiting.bounds = CGRectMake(0, 0, 70, 70);
        [waiting setXToCenterHorizontally];
        [waiting setYToCenterVertically];
        waiting.mode = LYMPhotoBrowserWaitingViewProgressMode;
        _waitingView = waiting;
        
        __weak typeof(self) weakSelf = self;
        [self.mainImageView sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageHighPriority | SDWebImageAvoidAutoSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            weakSelf.progress = (CGFloat)receivedSize / expectedSize;
            NSLog(@"相册下载图片进度%ld%%", (long)(weakSelf.progress * 100));
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [_waitingView removeFromSuperview];
            if (error) {
                UILabel *label = [[UILabel alloc] init];
                label.bounds = CGRectMake(0, 0, 160, 30);
                label.center = CGPointMake(weakSelf.bounds.size.width * 0.5, weakSelf.bounds.size.height * 0.5);
                label.text = @"图片加载失败";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
                label.layer.cornerRadius = 5;
                label.clipsToBounds = YES;
                label.textAlignment = NSTextAlignmentCenter;
                [weakSelf addSubview:label];
            } else {
                //需要先reload Frame，再赋值image。否则image会先全屏，再reload frame，会有闪屏的效果
                weakSelf.mainImageView.image = image;
                [weakSelf reloadContentFrame];
                weakSelf.isCompletedLoad = YES;
                //启用缩放
                self.maximumZoomScale = 2.0;
                self.minimumZoomScale = 0.5;
                //有返回图，并且图的url是网络地址，则回调下载完成代理方法
                if (image && [url.absoluteString rangeOfString:@"http"].location == 0) {
                    //回调下载的高清图片给代理对象
                    if ([weakSelf.browserDelegate respondsToSelector:@selector(oneScrollView:downloadWithURL:image:)]) {
                        [weakSelf.browserDelegate oneScrollView:weakSelf downloadWithURL:imageURL image:image];
                    }
                }
            }
        }];
    } else {
        self.mainImageView.image = placeholder;
        [self reloadContentFrame];
        self.isCompletedLoad = YES;
        //启用缩放
        self.maximumZoomScale = 2.0;
        self.minimumZoomScale = 0.5;
    }
}

- (BOOL)isScaled {
    return self.zoomScale != 1.0;
}

#pragma mark - Private methods
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _waitingView.progress = progress;
}

- (void)reloadContentFrame {
    self.mainImageView.width = self.width;
    CGSize imageSize = self.mainImageView.image.size;
    if (imageSize.width != 0.0) {
        self.mainImageView.height = self.mainImageView.width * (imageSize.height / imageSize.width);
        [self.mainImageView setYToCenterVertically];
        self.contentSize = self.mainImageView.frame.size;
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollView contentSize:%@", NSStringFromCGSize(scrollView.contentSize));
    
    CGPoint centerPointNew = CGPointMake(scrollView.contentSize.width / 2, scrollView.contentSize.height / 2);
    // 竖着长的 就是垂直居中
    if (self.mainImageView.width <= scrollView.width) {
        centerPointNew.x = scrollView.width / 2.0;
    }
    // 横着长的  就是水平居中
    if (self.mainImageView.height <= scrollView.height) {
        centerPointNew.y = scrollView.height / 2.0;
    }
    self.mainImageView.center = centerPointNew;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale < 1.0) {
        [scrollView setZoomScale:1.0 animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mainImageView;
}

#pragma mark - TapGesture handler
- (void)photoSingleTapped:(UITapGestureRecognizer *)tapGesture {
    if ([self.browserDelegate respondsToSelector:@selector(oneScrollView:didTap:)]) {
        [self.browserDelegate oneScrollView:self didTap:tapGesture];
    }
}

- (void)photoDoubleTapped:(UITapGestureRecognizer *)recognizer {
    //未完成原图加载，不处理双击逻辑
    if (!_isCompletedLoad) {
        return ;
    }
    //如果当前在缩放状态，则双击后回到1.0的scale比例；否则放大到scale为2.0的比例
    CGFloat scale = self.isScaled ? 1.0 : self.maximumZoomScale;
    if (scale == 1.0) {
        [self setZoomScale:scale animated:YES];
    } else {
        CGPoint tapLocationPoint = [recognizer locationInView:self.mainImageView];
        [self zoomToRect:CGRectMake(tapLocationPoint.x, tapLocationPoint.y, 0, 0) animated:YES];
    }
}

@end
