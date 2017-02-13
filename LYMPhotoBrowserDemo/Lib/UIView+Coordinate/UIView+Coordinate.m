//
//  UIView+Coordinate.m
//  Jerry
//
//  Created by Jerry on 7/9/15.
//  Copyright (c) 2016 innogeek. All rights reserved.
//

#import "UIView+Coordinate.h"

@implementation UIView (Coordinate)

+ (UIView *)view {
    UIView * view = [UIView viewWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    return view;
}

+ (UIView *)viewWithFrame:(CGRect)frame {
    UIView * view = [[UIView alloc] initWithFrame:frame];
    return view;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}



- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}



- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}



- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}



- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}



- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}



- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}



- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}



- (CGFloat)bottomMargin {
    if (self.superview == nil) {
        NSAssert(NO, @"要用方法%s快捷设置水平居中，必须先addSubview", __func__);
    }
    return self.superview.height - self.height - self.y;
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    if (self.superview == nil) {
        NSAssert(NO, @"要用方法%s快捷设置水平居中，必须先addSubview", __func__);
    }
    self.y = self.superview.height - self.height - bottomMargin;
}



- (void)setXToCenterHorizontally {
    if (self.superview == nil) {
        NSAssert(NO, @"要用方法%s快捷设置水平居中，必须先addSubview", __func__);
    }
    self.x = (self.superview.width - self.width) / 2.0;
}

- (void)setYToCenterVertically {
    if (self.superview == nil) {
        NSAssert(NO, @"要用方法%s快捷设置垂直居中，必须先addSubview", __func__);
    }
    self.y = (self.superview.height - self.height) / 2.0;
}



- (CGFloat)rightMargin {
    if (self.superview == nil) {
        NSAssert(NO, @"要用方法%s快捷设置垂直居中，必须先addSubview", __func__);
    }
    return self.superview.width - self.width - self.x;
}

- (void)setRightMargin:(CGFloat)rightMargin {
    if (self.superview == nil) {
        NSAssert(NO, @"要用方法%s快捷设置垂直居中，必须先addSubview", __func__);
    }
    self.x = self.superview.width - self.width - rightMargin;
}



- (void)setupCornerRadius:(CGFloat)cornerRadius {
    [self setupCornerRadius:cornerRadius shouldRasterImage:NO];
}

- (void)setupCornerRadius:(CGFloat)cornerRadius shouldRasterImage:(BOOL)shouldRasterImage {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = shouldRasterImage;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)setupBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

@end
