//
//  LYMPhotoBrowser.h
//  LYMPhotoBrowser
//
//  Created by Jerry on 16-11-6.
//  Copyright (c) 2016年 Leiyiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYMPhotoBrowser;

@protocol LYMPhotoBrowserDelegate <NSObject>

@required
/**
 *  动画起始位置的图片容器view
 */
- (UIView * _Nullable)photoBrowser:(LYMPhotoBrowser * _Nonnull)browser animationViewForIndex:(NSInteger)index;
- (UIImage * _Nullable)photoBrowser:(LYMPhotoBrowser * _Nonnull)browser placeholderImageForIndex:(NSInteger)index;
- (NSURL * _Nullable)photoBrowser:(LYMPhotoBrowser * _Nonnull)browser highQualityImageURLForIndex:(NSInteger)index;

@optional
/**
 *  高清图下载完成，将图片回调给前端
 */
- (void)photoBrowser:(LYMPhotoBrowser * _Nonnull)browser imageDownloadComplete:(UIImage * _Nonnull)image withURL:(NSURL * _Nonnull)url atIndex:(NSInteger)index;

@end


@interface LYMPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, readonly) NSInteger currentImageIndex;
@property (nonatomic, readonly) NSInteger imageCount;

@property (nonatomic, weak) id<LYMPhotoBrowserDelegate> _Nullable delegate;


/**
 初始化方法。图片url用代理方法中给定的url

 @param totalCount 图片总数量
 @param currentIndex 当前位置
 @param delegate 代理对象
 */
- (instancetype _Nonnull)initWithTotalImageCount:(NSInteger)totalCount
                                         current:(NSInteger)currentIndex
                                        delegate:(id<LYMPhotoBrowserDelegate> _Nullable)delegate;

/**
 初始化方法。代理为nil，图片url用参数中传入的值。

 @param photosURL 默认图片url
 @param currentIndex 当前选中位置
 */
- (instancetype _Nonnull)initWithPhotosURL:(NSArray<NSURL *> * _Nonnull )photosURL
                                   current:(NSInteger)currentIndex;

- (void)show;
- (void)setImageIndexLabelHidden:(BOOL)isHidden;
- (void)setSaveButtonHidden:(BOOL)isHidden;

@end
