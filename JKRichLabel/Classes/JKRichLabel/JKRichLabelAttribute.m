//
//  JKRichLabelAttribute.m
//  JKRichLabel
//
//  Created by 01 on 2017/10/7.
//  Copyright © 2017年 01. All rights reserved.
//

#import "JKRichLabelAttribute.h"
#import "JKRichLabelText.h"

NSString *const JKTextTruncationToken = @"\u2026";
NSString *const JKTextAttachmentToken = @"\uFFFC";

NSString *const JKTextAttachmentAttributeKey = @"JKTextAttachmentAttributeKey";
NSString *const JKTextSingleTapAttributeKey = @"JKTextSingleTapAttributeKey";
NSString *const JKTextLongPressAttributeKey = @"JKTextLongPressAttributeKey";

NSString *const JKTextHighlightAttributeKey = @"JKTextHighlightAttributeKey";
NSString *const JKTextBorderAttributeKey = @"JKTextBorderAttributeKey";


@implementation JKTextInfo
@end


@implementation JKTextInfoContainer {
    NSMutableArray<NSAttributedString *> *_mutableTexts;
    NSMutableArray<NSValue *> *_mutableRects;
    NSMutableArray<NSValue *> *_mutableRanges;
    
    NSMutableDictionary<NSString *, JKTextAttachment *> *_mutableAttachmentDict;
    NSMutableDictionary<NSString *, JKTextBlock> *_mutableSingleTapDict;
    NSMutableDictionary<NSString *, JKTextBlock> *_mutableLongPressDict;
    
    NSMutableDictionary<NSString *, JKTextHighlight *> *_mutableHighlightDict;
    NSMutableDictionary<NSString *, JKTextBorder *> *_mutableBorderDict;
}

#pragma mark - public

+ (instancetype)infoContainer {
    JKTextInfoContainer *one = [JKTextInfoContainer new];
    one->_mutableTexts = @[].mutableCopy;
    one->_mutableRects = @[].mutableCopy;
    one->_mutableRanges = @[].mutableCopy;
    
    one->_mutableAttachmentDict = @{}.mutableCopy;
    one->_mutableSingleTapDict = @{}.mutableCopy;
    one->_mutableLongPressDict = @{}.mutableCopy;
    
    one->_mutableHighlightDict = @{}.mutableCopy;
    one->_mutableBorderDict = @{}.mutableCopy;
    return one;
}

- (void)addObjectFromInfo:(JKTextInfo *)info {
    [_mutableTexts addObject:info.text];
    [_mutableRects addObject:info.rectValue];
    [_mutableRanges addObject:info.rangeValue];
    
    NSString *key = NSStringFromCGRect(_mutableRects.lastObject.CGRectValue);
    if (info.attachment) {
        [_mutableAttachmentDict setValue:info.attachment forKey:key];
    }
    if (info.singleTap) {
        [_mutableSingleTapDict setValue:[info.singleTap copy] forKey:key];
    }
    if (info.longPress) {
        [_mutableLongPressDict setValue:[info.longPress copy] forKey:key];
    }
    if (info.highlight) {
        [_mutableHighlightDict setValue:info.highlight forKey:key];
    }
    if (info.border) {
        [_mutableBorderDict setValue:info.border forKey:key];
    }
}

- (void)addObjectFromInfoContainer:(JKTextInfoContainer *)infoContainer {
    [_mutableTexts addObjectsFromArray:infoContainer.texts];
    [_mutableRects addObjectsFromArray:infoContainer.rects];
    [_mutableRanges addObjectsFromArray:infoContainer.ranges];
    
    if (infoContainer.attachmentDict) {
        [_mutableAttachmentDict addEntriesFromDictionary:infoContainer.attachmentDict];
    }
    if (infoContainer.singleTapDict) {
        [_mutableSingleTapDict addEntriesFromDictionary:infoContainer.singleTapDict];
    }
    if (infoContainer.longPressDict) {
        [_mutableLongPressDict addEntriesFromDictionary:infoContainer.longPressDict];
    }
    if (infoContainer.highlightDict) {
        [_mutableHighlightDict addEntriesFromDictionary:infoContainer.highlightDict];
    }
    if (infoContainer.borderDict) {
        [_mutableBorderDict addEntriesFromDictionary:infoContainer.borderDict];
    }
}

- (BOOL)canResponseUserActionAtPoint:(CGPoint)point {
    __block BOOL canResponse = NO;
    if (self.rects.count > 0) {
        [self.rects enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = obj.CGRectValue;
            
            if (CGRectContainsPoint(rect, point)) {
                *stop = YES;
                canResponse = YES;
                
                JKTextInfo *info = [JKTextInfo new];
                info.text = self.texts[idx];
                info.rectValue = obj;
                info.rangeValue = self.ranges[idx];
                
                NSString *key = NSStringFromCGRect(rect);
                info.attachment = self.attachmentDict[key];
                info.singleTap = self.singleTapDict[key];
                info.longPress = self.longPressDict[key];
                info.highlight = self.highlightDict[key];
                info.border = self.borderDict[key];
                
                _responseInfo = info;
            }
        }];
        return canResponse;
    }
    return canResponse;
}

#pragma mark - properties

- (NSArray<NSAttributedString *> *)texts {
    return _mutableTexts;
}

- (NSArray<NSValue *> *)rects {
    return _mutableRects;
}

- (NSArray<NSValue *> *)ranges {
    return _mutableRanges;
}

- (NSDictionary<NSString *,JKTextAttachment *> *)attachmentDict {
    return _mutableAttachmentDict;
}

- (NSDictionary<NSString *,JKTextBlock> *)singleTapDict {
    return _mutableSingleTapDict;
}

- (NSDictionary<NSString *,JKTextBlock> *)longPressDict {
    return _mutableLongPressDict;
}

- (NSDictionary<NSString *,JKTextHighlight *> *)highlightDict {
    return _mutableHighlightDict;
}

- (NSDictionary<NSString *,JKTextBorder *> *)borderDict {
    return _mutableBorderDict;
}

@end


@implementation JKTextBorder
+ (instancetype)defaultBorder {
    JKTextBorder *one = [JKTextBorder new];
    one->_width = 1.f;
    one->_color = [UIColor blackColor];
    one->_cornerRadius = 5.f;
    one->_insets = UIEdgeInsetsZero;
    return one;
}

+ (instancetype)borderWithWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    JKTextBorder *one = [JKTextBorder defaultBorder];
    if (width >= 0.f) one->_width = width;
    if (cornerRadius >= 0.f) one->_cornerRadius = cornerRadius;
    one->_color = color;
    return one;
}

@end


@implementation JKTextHighlight
@end



@implementation JKTextAttachment {
    CGFloat _fontAsent;
    CGFloat _fontDesent;
}


#pragma mark - rundelegate

static void JKTextRunDelegateDeallocCallback(void *ref) {
//    NSLog(@"%s", __func__);
}

static CGFloat JKTextRunDelegateGetAscentCallback(void *ref) {
    JKTextAttachment *attachment = (__bridge JKTextAttachment *)ref;
    return attachment.runDelegateAsent;
}

static CGFloat JKTextRunDelegateGetDescentCallback(void *ref) {
    JKTextAttachment *attachment = (__bridge JKTextAttachment *)ref;
    return attachment.runDelegateDesent;
}

static CGFloat JKTextRunDelegateGetWidthCallback(void *ref) {
    JKTextAttachment *attachment = (__bridge JKTextAttachment *)ref;
    return attachment.runDelegateWidth;
}

#pragma mark - public
+ (instancetype)attachmentWithContent:(id)content
                          contentSize:(CGSize)contentSize
                          alignToFont:(nullable UIFont *)font {
    JKTextAttachment *attachment = [[self alloc] init];
    attachment->_content = content;
    attachment->_contentSize = contentSize;

    if (!font) font = [UIFont systemFontOfSize:15.f];
    attachment->_fontAsent = font.ascender;
    attachment->_fontDesent = font.descender;

    [attachment _initAttachment];
    return attachment;
}

- (CTRunDelegateRef)runDelegate {
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = JKTextRunDelegateDeallocCallback;
    callbacks.getAscent = JKTextRunDelegateGetAscentCallback;
    callbacks.getDescent = JKTextRunDelegateGetDescentCallback;
    callbacks.getWidth = JKTextRunDelegateGetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge void *)self);
}

#pragma mark - override


#pragma mark - private
- (void)_initAttachment {
    _alignment = JKTextAttachmentAlignmentCenter;
    [self _update];
}

- (void)_update {
    switch (_alignment) {
        case JKTextAttachmentAlignmentTop: {
            _runDelegateAsent = _fontAsent;
            _runDelegateDesent = _contentSize.height - _fontAsent;

            [self _correct];
        } break;
        case JKTextAttachmentAlignmentBottom: {
            _runDelegateAsent = _contentSize.height + _fontDesent;

            _runDelegateDesent = -_fontDesent;
            [self _correct];
        } break;
        default: {
            CGFloat fontHeight = _fontAsent - _fontDesent;
            CGFloat yOffset = _fontAsent - fontHeight * 0.5;
            _runDelegateAsent = _contentSize.height * 0.5 + yOffset;

            _runDelegateDesent = _contentSize.height - _runDelegateAsent;

            [self _correct];
        } break;
    }
    _runDelegateWidth = _contentSize.width;
}

- (void)_correct {
    if (_runDelegateDesent < 0) {
        _runDelegateDesent = 0;
        _runDelegateAsent = _contentSize.height;
    }
}

@end

