//
//  UIInsetableLabel.h
//  miqu
//
//  Created by leiyiming on 29/10/2016.
//  Copyright © 2016 CZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInsetableLabel : UILabel

// 控制字体与控件边界的间隙
@property (nonatomic) UIEdgeInsets textInsets;
+ (UIInsetableLabel * _Nonnull)labelWithFont:(UIFont * _Nonnull)font
                                   textColor:(UIColor * _Nonnull)textColor
                               textAlignment:(NSTextAlignment)alignment
                                   textInset:(UIEdgeInsets)textInset;

+ (UIInsetableLabel * _Nonnull)labelWithFont:(UIFont * _Nonnull)font
                                   textColor:(UIColor * _Nonnull)textColor
                               textAlignment:(NSTextAlignment)alignment;

+ (UIInsetableLabel * _Nonnull)labelWithFont:(UIFont * _Nonnull)font
                                   textColor:(UIColor * _Nonnull)textColor;

+ (UIInsetableLabel * _Nonnull)labelWithFont:(UIFont * _Nonnull)font;
    
/**
 *  设置文本，让label根据宽来自适应高度
 *
 *  @return 返回高度
 */
- (CGFloat)setTextAndAdjustHeight:(NSString * _Nullable)text;
/**
 *  设置消息，让label根据高来自适应宽度
 *
 *  @return 返回宽度
 */
- (CGFloat)setTextAndAdjustWidth:(NSString * _Nullable)text;

- (CGFloat)setAttributedTextAndAdjustHeight:(NSAttributedString * _Nullable)attributedString;
- (CGFloat)setAttributedTextAndAdjustWidth:(NSAttributedString * _Nullable)attributedString;

@end
