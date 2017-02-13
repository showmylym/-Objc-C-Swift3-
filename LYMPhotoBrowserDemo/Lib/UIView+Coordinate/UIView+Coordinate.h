//
//  UIView+Coordinate.h
//  Jerry
//
//  Created by Jerry on 7/9/15.
//  Copyright (c) 2016 innogeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Coordinate)

+ (UIView *)view;
+ (UIView *)viewWithFrame:(CGRect)frame;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

/**
 *  获取控件底部的纵坐标y
 */
- (CGFloat)bottom;
/**
 *  设置控件底部的纵坐标y
 */
- (void)setBottom:(CGFloat)bottom;


/**
 *  获取控件右边缘离父容器左边缘的边距
 */
- (CGFloat)right;
/**
 *  设置控件右边缘离父容器左边缘的边距
 */
- (void)setRight:(CGFloat)right;


- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;


- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;


///父视图中水平居中
- (void)setXToCenterHorizontally;
///父视图中垂直居中
- (void)setYToCenterVertically;


/**
 *  获取控件底部离父容器底部的边距
 */
- (CGFloat)bottomMargin;
/**
 *  设置控件底部离父容器底部的边距
 */
- (void)setBottomMargin:(CGFloat)bottomMargin;


/**
 *  获取控件右侧离父容器右边的边距
 */
- (CGFloat)rightMargin;
/**
 *  设置控件右侧离父容器右边的边距
 */
- (void)setRightMargin:(CGFloat)rightMargin;

///设置圆角
- (void)setupCornerRadius:(CGFloat)cornerRadius;
///设置圆角
- (void)setupCornerRadius:(CGFloat)cornerRadius shouldRasterImage:(BOOL)shouldRasterImage;
///设置边框
- (void)setupBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
