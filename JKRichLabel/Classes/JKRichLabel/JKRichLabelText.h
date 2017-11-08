//
//  JKRichLabelText.h
//  JKRichLabel
//
//  Created by 01 on 2017/10/6.
//  Copyright © 2017年 01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKRichLabelAttribute.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSAttributedString (JKRichLabel)
- (CGSize)getSize;
- (CGFloat)getWidth;
- (CGFloat)getHeight;
@end


@interface NSMutableAttributedString (JKRichLabel)

@property (nullable, nonatomic, strong) JKTextHighlight *highlight;
@property (nullable, nonatomic, strong) JKTextBorder *border;

@property (nullable, nonatomic, copy) JKTextBlock singleTap;
@property (nullable, nonatomic, copy) JKTextBlock longPress;

- (void)setUnderlineStyle:(NSUnderlineStyle)style color:(UIColor *)color;

// default style is NSUnderlineStyleSingle, default color is blackColor
- (void)setDefaultUnderlineStyleAndColor;

- (void)setDefaultLinkColor;
- (void)setDefaultLink;
- (void)setDefaultLinkWithSucceed:(dispatch_block_t)sBlock
                           failed:(dispatch_block_t)fBlock
NS_AVAILABLE_IOS(10_0)
NS_EXTENSION_UNAVAILABLE_IOS("");


- (void)jk_setFont:(UIFont *)font;
- (void)jk_setFont:(UIFont *)font inRange:(NSRange)range;

- (void)jk_setTextColor:(UIColor *)color;
- (void)jk_setTextColor:(UIColor *)color inRange:(NSRange)range;


- (instancetype)initWithString:(NSString *)str
                     singleTap:(nullable JKTextBlock)singleTap;

- (instancetype)initWithAttributeString:(NSAttributedString *)str
                              singleTap:(nullable JKTextBlock)singleTap;

- (instancetype)initWithAttachment:(JKTextAttachment *)attachment
                         singleTap:(nullable JKTextBlock)singleTap;



- (instancetype)initWithString:(NSString *)str
                     singleTap:(nullable JKTextBlock)singleTap
                     longPress:(nullable JKTextBlock)longPress;

- (instancetype)initWithAttributeString:(NSAttributedString *)str
                              singleTap:(nullable JKTextBlock)singleTap
                              longPress:(nullable JKTextBlock)longPress;

- (instancetype)initWithAttachment:(JKTextAttachment *)attachment
                         singleTap:(nullable JKTextBlock)singleTap
                         longPress:(nullable JKTextBlock)longPress;

- (void)appendString:(NSString *)text;
- (void)appendAttachment:(JKTextAttachment *)attachment;


@end

NS_ASSUME_NONNULL_END
