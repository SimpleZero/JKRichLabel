//
//  JKRichLabelText.m
//  JKRichLabel
//
//  Created by 01 on 2017/10/6.
//  Copyright © 2017年 01. All rights reserved.
//

#import "JKRichLabelText.h"
#import <objc/runtime.h>

@implementation NSAttributedString (JKRichLabel)
- (CGSize)getSize {
    CGSize boundingSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    return [self boundingRectWithSize:boundingSize
                              options:NSStringDrawingUsesLineFragmentOrigin|
            NSStringDrawingUsesFontLeading|
            NSStringDrawingUsesDeviceMetrics|
            NSStringDrawingTruncatesLastVisibleLine
                              context:nil].size;
}

- (CGFloat)getWidth {
    return [self getSize].width;
}

- (CGFloat)getHeight {
    return [self getSize].height;
}
@end


@implementation NSMutableAttributedString (JKRichLabel)

static void const * JKTextHighlightKey = &JKTextHighlightKey;
static void const * JKTextBorderKey = &JKTextBorderKey;
static void const * JKTextSingleTapKey = &JKTextSingleTapKey;
static void const * JKTextLongPressKey = &JKTextLongPressKey;


- (void)setHighlight:(JKTextHighlight *)highlight {
    if (!highlight) return;
    objc_setAssociatedObject(self, JKTextHighlightKey, highlight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:JKTextHighlightAttributeKey value:highlight range:NSMakeRange(0, self.length)];
}

- (JKTextHighlight *)highlight {
    return objc_getAssociatedObject(self, JKTextHighlightKey);
}

- (void)setBorder:(JKTextBorder *)border {
    if (!border) return;
    objc_setAssociatedObject(self, JKTextBorderKey, border, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:JKTextBorderAttributeKey value:border range:NSMakeRange(0, self.length)];
}

- (JKTextBorder *)border {
    return objc_getAssociatedObject(self, JKTextBorderKey);
}

- (void)setSingleTap:(JKTextBlock)singleTap {
    if (!singleTap) return;
    objc_setAssociatedObject(self, JKTextSingleTapKey, [singleTap copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:JKTextSingleTapAttributeKey value:self.singleTap range:NSMakeRange(0, self.length)];
}

- (JKTextBlock)singleTap {
    return objc_getAssociatedObject(self, JKTextSingleTapKey);
}

- (void)setLongPress:(JKTextBlock)longPress {
    if (!longPress) return;
    objc_setAssociatedObject(self, JKTextLongPressKey, [longPress copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addAttribute:JKTextLongPressAttributeKey value:self.longPress range:NSMakeRange(0, self.length)];
}

- (JKTextBlock)longPress {
    return objc_getAssociatedObject(self, JKTextLongPressKey);
}


- (void)setUnderlineStyle:(NSUnderlineStyle)style color:(UIColor *)color {
    NSMutableDictionary *attrs = @{}.mutableCopy;
    [attrs setValue:@(style) forKey:NSUnderlineStyleAttributeName];
    [attrs setValue:color forKey:NSUnderlineColorAttributeName];
    [self addAttributes:attrs range:NSMakeRange(0, self.length)];
}

- (void)setDefaultUnderlineStyleAndColor {
    [self setUnderlineStyle:NSUnderlineStyleSingle color:[UIColor blackColor]];
}

- (void)setDefaultLinkColor {
    UIColor *linkColor = [UIColor blueColor];
    [self setUnderlineStyle:NSUnderlineStyleSingle color:linkColor];
    [self addAttribute:NSForegroundColorAttributeName value:linkColor range:NSMakeRange(0, self.length)];
}

- (void)setDefaultLink {
    [self setDefaultLinkColor];
    self.singleTap = ^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, JKTextAttachment * _Nullable attachment) {
        NSURL *url = [NSURL URLWithString:attributeString.string];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    };
}

- (void)setDefaultLinkWithSucceed:(dispatch_block_t)sBlock failed:(dispatch_block_t)fBlock {
    [self setDefaultLinkColor];
    self.singleTap = ^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, JKTextAttachment * _Nullable attachment) {
        NSURL *url = [NSURL URLWithString:attributeString.string];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    !sBlock ? : sBlock();
                } else {
                    !fBlock ? : fBlock();
                }
            }];
        }
    };
}

- (void)jk_setFont:(id)font {
    [self jk_setFont:font inRange:NSMakeRange(0, self.length)];
}

- (void)jk_setFont:(id)font inRange:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (void)jk_setTextColor:(UIColor *)color {
    [self jk_setTextColor:color inRange:NSMakeRange(0, self.length)];
}

- (void)jk_setTextColor:(UIColor *)color inRange:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}


- (instancetype)initWithString:(NSString *)str singleTap:(nullable JKTextBlock)singleTap {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
    if (singleTap) {
        one.singleTap = singleTap;
    }
    return one;
}

- (instancetype)initWithString:(NSString *)str singleTap:(nullable JKTextBlock)singleTap longPress:(nullable JKTextBlock)longPress {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str singleTap:singleTap];
    if (longPress) {
        one.longPress = longPress;
    }
    return one;
}

- (instancetype)initWithAttributeString:(NSAttributedString *)str singleTap:(nullable JKTextBlock)singleTap {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    
    if (singleTap) {
        one.singleTap = singleTap;
    }
    return one;
}

- (instancetype)initWithAttributeString:(NSAttributedString *)str singleTap:(nullable JKTextBlock)singleTap longPress:(nullable JKTextBlock)longPress {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttributeString:str singleTap:singleTap];
    if (longPress) {
        one.longPress = longPress;
    }
    return one;
}

- (instancetype)initWithAttachment:(JKTextAttachment *)attachment singleTap:(nullable JKTextBlock)singleTap {
    NSMutableAttributedString *attachmentToken = [[NSMutableAttributedString alloc] initWithString:JKTextAttachmentToken];
    
    NSMutableDictionary *attrs = @{}.mutableCopy;
    [attrs setObject:attachment forKey:JKTextAttachmentAttributeKey];
    if (singleTap) {
        attachmentToken.singleTap = singleTap;
    }
    
    CTRunDelegateRef runDelegate = attachment.runDelegate;
    
    [attrs setValue:(__bridge id _Nullable)(runDelegate) forKey:(__bridge_transfer NSString *)kCTRunDelegateAttributeName];
    
    [attachmentToken addAttributes:attrs range:NSMakeRange(0, attachmentToken.length)];
    CFRelease(runDelegate);
    
    return attachmentToken;
}

- (instancetype)initWithAttachment:(JKTextAttachment *)attachment singleTap:(nullable JKTextBlock)singleTap longPress:(nullable JKTextBlock)longPress {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttachment:attachment singleTap:singleTap];
    if (longPress) {
        one.longPress = longPress;
    }
    return one;
}

- (void)appendString:(NSString *)text {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:text];
    [self appendAttributedString:str];
}

- (void)appendAttachment:(JKTextAttachment *)attachment {
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithAttachment:attachment singleTap:nil];
    [self appendAttributedString:one];
}

@end
