//
//  UILabel+Extension.m
//  iWantMarry
//
//  Created by leiyiming on 1/27/16.
//  Copyright © 2016 CZK. All rights reserved.
//

#import "UILabel+Extension.h"
#import "UIView+Coordinate.h"

@implementation UILabel (Extension)

#pragma mark - 初始化扩展
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)alignment {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.adjustsFontSizeToFitWidth = NO;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    return [UILabel labelWithFont:font textColor:textColor textAlignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithFont:(UIFont *)font {
    return [UILabel labelWithFont:font textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
}

#pragma mark - 宽高扩展
- (CGFloat)setTextAndAdjustHeight:(NSString *)text {
    if (text == nil) {
        text = @"";
    }
    self.text = text;
    CGFloat height = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size.height;
    self.height = height;
    self.numberOfLines = 0;
    return height;
}

- (CGFloat)setTextAndAdjustWidth:(NSString *)text {
    if (text == nil) {
        text = @"";
    }
    self.text = text;
    CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size.width;
    self.width = width;
    return width;
}

- (CGFloat)setAttributedTextAndAdjustHeight:(NSAttributedString *)attributedString {
    if (attributedString == nil) {
        attributedString = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: self.font}];
    }
    self.attributedText = attributedString;
    CGFloat height = [attributedString boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    self.height = height;
    self.numberOfLines = 0;
    return height;
}

- (CGFloat)setAttributedTextAndAdjustWidth:(NSAttributedString *)attributedString {
    if (attributedString == nil) {
        attributedString = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: self.font}];
    }
    self.attributedText = attributedString;
    CGFloat width = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.width;
    self.width = width;
    return width;
}

@end
