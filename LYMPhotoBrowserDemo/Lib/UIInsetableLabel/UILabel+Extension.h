//
//  UILabel+Extension.h
//  iWantMarry
//
//  Created by leiyiming on 1/27/16.
//  Copyright © 2016 CZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (UILabel * _Nonnull)labelWithFont:(UIFont * _Nonnull)font textColor:(UIColor * _Nonnull)textColor textAlignment:(NSTextAlignment)alignment;
+ (UILabel * _Nonnull)labelWithFont:(UIFont * _Nonnull)font textColor:(UIColor * _Nonnull)textColor;
+ (UILabel * _Nonnull)labelWithFont:(UIFont * _Nonnull)font;

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
