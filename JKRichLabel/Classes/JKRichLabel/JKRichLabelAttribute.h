//
//  JKRichLabelAttribute.h
//  JKRichLabel
//
//  Created by 01 on 2017/10/7.
//  Copyright © 2017年 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - const

UIKIT_EXTERN NSString *const JKTextTruncationToken;
UIKIT_EXTERN NSString *const JKTextAttachmentToken;

UIKIT_EXTERN NSString *const JKTextAttachmentAttributeKey;
UIKIT_EXTERN NSString *const JKTextSingleTapAttributeKey;
UIKIT_EXTERN NSString *const JKTextLongPressAttributeKey;

UIKIT_EXTERN NSString *const JKTextHighlightAttributeKey;
UIKIT_EXTERN NSString *const JKTextBorderAttributeKey;

#pragma mark - function

static inline NSArray* JKTextCustomAttributeNames() {
    return @[
             JKTextAttachmentAttributeKey,
             JKTextSingleTapAttributeKey,
             JKTextLongPressAttributeKey,
             JKTextHighlightAttributeKey,
             JKTextBorderAttributeKey
             ];
}

static inline void JKTextRemoveCustomAttributes(NSMutableDictionary *_Nullable* _Nonnull attrs) {
    for (NSString *key in JKTextCustomAttributeNames()) {
        [*attrs removeObjectForKey:key];
    }
}

static inline CFRange JKTextCFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

static inline NSRange JKTextNSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

static inline CGRect JKTextTransformatCoordinateSystem(CGRect rect) {
    CGAffineTransform transform = CGAffineTransformMakeScale(1.f, -1.f);
    return CGRectApplyAffineTransform(rect, transform);
}

static inline CGPoint JKTextRoundPoint(CGPoint p) {
    CGFloat x = roundf(p.x);
    CGFloat y = roundf(p.y);
    return CGPointMake(x, y);
}

static inline CGSize JKTextRoundSize(CGSize s) {
    CGFloat w = roundf(s.width);
    CGFloat h = roundf(s.height);
    return CGSizeMake(w, h);
}

static inline CGRect JKTextRoundRect(CGRect r) {
    CGPoint p = JKTextRoundPoint(r.origin);
    CGSize s = JKTextRoundSize(r.size);
    return (CGRect){p, s};
}

static inline CGSize JKTextCeilSize(CGSize s) {
    CGFloat w = ceilf(s.width);
    CGFloat h = ceilf(s.height);
    return CGSizeMake(w, h);
}


#pragma mark - enum

typedef NS_ENUM(NSInteger, JKTextVerticalAlignment) {
    JKTextVerticalAlignmentTop = 0,
    JKTextVerticalAlignmentCenter,
    JKTextVerticalAlignmentBottom
};

typedef NS_ENUM(NSInteger, JKTextAttachmentAlignment) {
    JKTextAttachmentAlignmentTop = 0,
    JKTextAttachmentAlignmentCenter,
    JKTextAttachmentAlignmentBottom
};


#pragma mark - class

@interface JKTextHighlight : NSObject
@property (nullable, nonatomic, strong) UIColor *textColor;
@property (nullable, nonatomic, strong) UIColor *underlineColor;
@property (nullable, nonatomic, strong) UIColor *innerColor;
@property (nullable, nonatomic, strong) UIColor *borderColor;
@end

@interface JKTextBorder : NSObject

// default is 1.f
@property (nonatomic) CGFloat width;
// default is black color
@property (nonatomic, strong) UIColor *color;
// default is 5.f
@property (nonatomic) CGFloat cornerRadius;
// default is UIEdgeInsetsZero
@property (nonatomic) UIEdgeInsets insets;

@property (nullable, nonatomic, strong) UIColor *innerColor;

+ (instancetype)defaultBorder;
+ (instancetype)borderWithWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@end


@interface JKTextAttachment : NSObject

// supported type: UIImage/UIView/CALayer
@property (nonatomic, strong, readonly) id content;

// default is content's size
@property (nonatomic, readonly) CGSize contentSize;

// default is JKTextAttachmentAlignmentCenter
@property (nonatomic) JKTextAttachmentAlignment alignment;

@property (nonatomic, readonly) CGFloat runDelegateAsent;
@property (nonatomic, readonly) CGFloat runDelegateDesent;
@property (nonatomic, readonly) CGFloat runDelegateWidth;

@property (nonatomic, strong) NSDictionary *infoDictionary;

+ (instancetype)attachmentWithContent:(id)content contentSize:(CGSize)contentSize alignToFont:(nullable UIFont *)font;

- (CTRunDelegateRef)runDelegate;

@end



typedef void(^JKTextBlock)(UIView *targetView, NSAttributedString *attributeString, JKTextAttachment *_Nullable attachment);

@interface JKTextInfo : NSObject

@property (nonatomic, strong) NSAttributedString *text;
@property (nonatomic, strong) NSValue *rectValue;
@property (nonatomic, strong) NSValue *rangeValue;

@property (nullable, nonatomic, strong) JKTextAttachment *attachment;
@property (nullable, nonatomic, copy) JKTextBlock singleTap;
@property (nullable, nonatomic, copy) JKTextBlock longPress;

@property (nullable, nonatomic, strong) JKTextHighlight *highlight;
@property (nullable, nonatomic, strong) JKTextBorder *border;

@end

@interface JKTextInfoContainer : NSObject

@property (nonatomic, strong, readonly) NSArray<NSAttributedString *> *texts;
@property (nonatomic, strong, readonly) NSArray<NSValue *> *rects;
@property (nonatomic, strong, readonly) NSArray<NSValue *> *ranges;

@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, JKTextAttachment *> *attachmentDict;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, JKTextBlock> *singleTapDict;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, JKTextBlock> *longPressDict;

@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, JKTextHighlight *> *highlightDict;
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, JKTextBorder *> *borderDict;

@property (nullable, nonatomic, strong, readonly) JKTextInfo *responseInfo;

+ (instancetype)infoContainer;

- (void)addObjectFromInfo:(JKTextInfo *)info;
- (void)addObjectFromInfoContainer:(JKTextInfoContainer *)infoContainer;

- (BOOL)canResponseUserActionAtPoint:(CGPoint)point;

@end



NS_ASSUME_NONNULL_END
