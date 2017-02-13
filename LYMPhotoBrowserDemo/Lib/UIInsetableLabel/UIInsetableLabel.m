//
//  UIInsetableLabel.m
//  miqu
//
//  Created by leiyiming on 29/10/2016.
//  Copyright © 2016 CZK. All rights reserved.
//

#import "UIInsetableLabel.h"
#import "UIView+Coordinate.h"

@implementation UIInsetableLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect: UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

#pragma mark - 类方法

+ (UIInsetableLabel *)labelWithFont:(UIFont *)font
                          textColor:(UIColor *)textColor
                      textAlignment:(NSTextAlignment)alignment
                          textInset:(UIEdgeInsets)textInset {
    UIInsetableLabel * label = [[UIInsetableLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.adjustsFontSizeToFitWidth = NO;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textInsets = textInset;
    return label;
}

+ (UIInsetableLabel *)labelWithFont:(UIFont *)font
                          textColor:(UIColor *)textColor
                      textAlignment:(NSTextAlignment)alignment {
    UIInsetableLabel * label = [UIInsetableLabel labelWithFont:font textColor:textColor textAlignment:alignment textInset:UIEdgeInsetsZero];
    return label;
}


+ (UIInsetableLabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    return [UIInsetableLabel labelWithFont:font textColor:textColor textAlignment:NSTextAlignmentLeft];
}

+ (UIInsetableLabel *)labelWithFont:(UIFont *)font {
    return [UIInsetableLabel labelWithFont:font textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentCenter];
}

#pragma mark - 实例方法
- (CGFloat)setTextAndAdjustHeight:(NSString *)text {
    if (text == nil) {
        text = @"";
    }
    self.text = text;
    CGFloat height = [text boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size.height;
    self.height = height + self.textInsets.top + self.textInsets.bottom;
    self.numberOfLines = 0;
    return height;
}

- (CGFloat)setTextAndAdjustWidth:(NSString *)text {
    if (text == nil) {
        text = @"";
    }
    self.text = text;
    CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size.width;
    self.width = width + self.textInsets.left + self.textInsets.right;
    return width;
}

- (CGFloat)setAttributedTextAndAdjustHeight:(NSAttributedString *)attributedString {
    if (attributedString == nil) {
        attributedString = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: self.font}];
    }
    self.attributedText = attributedString;
    CGFloat height = [attributedString boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    self.height = height + self.textInsets.top + self.textInsets.bottom;
    self.numberOfLines = 0;
    return height;
}

- (CGFloat)setAttributedTextAndAdjustWidth:(NSAttributedString *)attributedString {
    if (attributedString == nil) {
        attributedString = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: self.font}];
    }
    self.attributedText = attributedString;
    CGFloat width = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.width;
    self.width = width + self.textInsets.left + self.textInsets.right;
    return width;
}

@end
