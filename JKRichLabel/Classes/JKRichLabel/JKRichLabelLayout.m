//
//  JKRichLabelLayout.m
//  JKRichLabel
//
//  Created by 01 on 2017/10/6.
//  Copyright © 2017年 01. All rights reserved.
//

#import "JKRichLabelLayout.h"


@implementation JKRichLabelLayout {
    CGRect _pathBox;
    CTFramesetterRef _frameSetter;
    CTFrameRef _frame;
    
    NSArray<JKRichLabelLine *> *_lines;
    JKTextInfoContainer *_infoContainer;
    
    CGPoint _point;
}

static void JKTextTruncationAttributs(NSMutableDictionary *_Nullable* _Nonnull attrs) {
    JKTextRemoveCustomAttributes(attrs);
    [*attrs removeObjectForKey:NSParagraphStyleAttributeName];
}

#pragma mark - public

+ (instancetype)layoutWithContainer:(JKRichLabelContainer *)container atrributedString:(NSAttributedString *)text {
    return [self layoutWithContainer:container atrributedString:text range:NSMakeRange(0, text.length)];
}

+ (instancetype)layoutWithContainer:(JKRichLabelContainer *)container atrributedString:(NSAttributedString *)text range:(NSRange)range {
    if (!container || !text) return nil;
    if (range.location + range.length > text.length) return nil;
    JKRichLabelLayout *layout = [[self alloc] init];
    layout.isHighlight = NO;
    [layout _layoutWithContainer:container attributedString:text range:range];
    return layout;
}

- (void)drawInContext:(CGContextRef)context targetLayer:(CALayer *)targetLayer targetView:(UIView *)targetView cancel:(BOOL (^)(void))cancel {
    
    if (cancel && cancel()) return;
    
    if (!_frameSetter || !_frame) return;
    
    [self _updateProperties];
    
    if (cancel && cancel()) return;

    if (_infoContainer.attachmentDict.allKeys.count > 0) {
        [self _drawAttachmentsInContext:context targetLayer:targetLayer targetView:targetView];
    }
    if (!_isHighlight && _infoContainer.borderDict.allKeys.count > 0) {
        [self _drawBorderInContext:context];
    }
    if (_isHighlight && _infoContainer.highlightDict.allKeys.count > 0) {
        [self _drawHighightInContext:context];
    }
    [self _drawTextInContext:context];

    
}

#pragma mark - override

- (instancetype)init {
    if (self = [super init]) {
        [self _initLayout];
    }
    return self;
}

- (void)dealloc {
    if (_frameSetter) CFRelease(_frameSetter);
    if (_frame) CFRelease(_frame);
}

#pragma mark - properties

#pragma mark - private

- (void)_initLayout {

}


- (void)_layoutWithContainer:(JKRichLabelContainer *)container attributedString:(NSAttributedString *)text range:(NSRange)range {
    
    _container = container;
    _text = text.mutableCopy;
    _range = range;
    
    _pathBox = container.innerRect;
    [self _configFrame];
}

- (void)_configFrame {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_pathBox];
    if (_container.path) {
        path = _container.path;
        _pathBox = CGPathGetBoundingBox(path.CGPath);
    }
    
    CFRange range = JKTextCFRangeFromNSRange(_range);
    CGSize boundingSize = path.bounds.size;
    
    _frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_text);
    _frame = CTFramesetterCreateFrame(_frameSetter, range, path.CGPath, NULL);
    
    boundingSize = CTFramesetterSuggestFrameSizeWithConstraints(_frameSetter, range, NULL, boundingSize, NULL);

    boundingSize = JKTextCeilSize(boundingSize);
    _textBoundingSize = boundingSize;
    _textBoundingRect = (CGRect){CGPointZero, boundingSize};
}

- (void)_updateProperties {
    
    CGPoint point = CGPointZero;
    
    switch (_container.verticalAlignment) {
        case JKTextVerticalAlignmentCenter:
            point.y = (_pathBox.size.height - _textBoundingSize.height) * 0.5;

            break;
        case JKTextVerticalAlignmentBottom:
            point.y = (_pathBox.size.height - _textBoundingSize.height);

            break;
        default:
            break;
    }
    _point = point;
    
    CFArrayRef ctLines = CTFrameGetLines(_frame);
    NSUInteger rows = CFArrayGetCount(ctLines);
    if (_container.maxNumberOfRows > 0) {
        rows = MIN(rows, _container.maxNumberOfRows);
    }
    
    CTLineTruncationType type = kCTLineTruncationEnd;
    if (_container.lineBreakMode == NSLineBreakByTruncatingHead) {
        type = kCTLineTruncationStart;
    } else if (_container.lineBreakMode == NSLineBreakByTruncatingMiddle) {
        type = kCTLineTruncationMiddle;
    }
    
    CGPoint lineOrigins[rows];
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, rows), lineOrigins);
    NSMutableArray<JKRichLabelLine *> *lines = @[].mutableCopy;
    
    JKTextInfoContainer *infoContainer = [JKTextInfoContainer infoContainer];
    
    for (int i = 0; i < rows; i++) {
        
        CGPoint origin = lineOrigins[i];
        CGPoint position = CGPointZero;
        position.x = _pathBox.origin.x + origin.x;
        position.y = _pathBox.size.height + _pathBox.origin.y - origin.y;
        CTLineRef ctLine = CFArrayGetValueAtIndex(ctLines, i);
        
        JKRichLabelLine *line = [JKRichLabelLine lineWithCTLine:ctLine position:position point:_point];
        line.index = i;
        [line configTextInfoWithWholeText:_text];
        
        if (i == rows - 1) {
            
            NSRange lastRange = line.range;
            if (lastRange.location + lastRange.length < _text.length ||
                rows < CFArrayGetCount(ctLines)) {
                if (_container.lineBreakMode == NSLineBreakByTruncatingTail) {
                    line = [self _createTruncatedLineFromLine:line];
                }
            }
        }
        
        [lines addObject:line];
        
        [infoContainer addObjectFromInfoContainer:line.infoContainer];
    }
    
    if (lines.count <= 0) return;
    
    _lines = lines;
    _infoContainer = infoContainer;
    
    [self _releaseC];
    
}

- (JKRichLabelLine *)_createTruncatedLineFromLine:(JKRichLabelLine *)targetLine {
    CTLineRef line = targetLine.CTLine;
    CGPoint position = targetLine.position;
    
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    NSUInteger runCount = CFArrayGetCount(runs);
    if (runCount <= 0) return nil;
    
    CFRange range = CTLineGetStringRange(line);
    NSMutableAttributedString *lastText = targetLine.text.mutableCopy;
    
    /*
    BOOL loop = YES;
    do {
        NSString *lastChar = [lastText.string substringFromIndex:lastText.length - 1];
        if ([lastChar isEqualToString:@"\n"] ||
            [lastChar isEqualToString:@"\t"] ||
            [lastChar isEqualToString:@" "]) {
            [lastText deleteCharactersInRange:NSMakeRange(lastText.length - 1, 1)];
        } else {
            loop = NO;
        }
    } while (loop);
     */
    
    
    if (range.length <= 1) return targetLine;
    
    NSMutableDictionary *attrs = nil;
    CFDictionaryRef cfAttrs = NULL;
    
    if (runCount > 0) {
        CTRunRef run = CFArrayGetValueAtIndex(runs, runCount - 1);
        cfAttrs = CTRunGetAttributes(run);
        if (cfAttrs) {
            attrs = ((__bridge NSDictionary *)cfAttrs).mutableCopy;
            JKTextTruncationAttributs(&attrs);
        }
    }
    
    NSAttributedString *truncationToken = [[NSAttributedString alloc] initWithString:JKTextTruncationToken attributes:attrs];
    
    CGFloat truncationWidth = [truncationToken getWidth];
    
    BOOL loop = YES;
    do {
        CGFloat remainWidth = [lastText getWidth];
        if (remainWidth + truncationWidth > _pathBox.size.width) {
            [lastText deleteCharactersInRange:NSMakeRange(lastText.length - 1, 1)];
        } else {
            loop = NO;
            [lastText appendAttributedString:truncationToken];
        }
    } while (loop);
    
    CTLineRef truncatedLine = CTLineCreateWithAttributedString((CFAttributedStringRef)lastText);
    
    JKRichLabelLine *patchLine = [JKRichLabelLine lineWithCTLine:truncatedLine position:position point:_point];
    patchLine.index = targetLine.index;
    [patchLine configTextInfoWithWholeText:_text];
    
    CFRelease(truncatedLine);
    
    return patchLine;
}

- (void)_drawTextInContext:(CGContextRef)context {
    
    CGContextSaveGState(context); {

        CGContextTranslateCTM(context, _point.x, _point.y);
        CGContextTranslateCTM(context, 0, _container.size.height);
        CGContextScaleCTM(context, 1, -1);

        for (JKRichLabelLine *line in _lines) {
            CGContextSetTextMatrix(context, CGAffineTransformIdentity);
            CGContextSetTextPosition(context, line.position.x, _container.size.height - line.position.y);
            CTLineDraw(line.CTLine, context);
        }

    } CGContextRestoreGState(context);
    
}

- (void)_drawAttachmentsInContext:(CGContextRef)context targetLayer:(CALayer *)targetLayer targetView:(UIView *)targetView {
    
    
    __block NSMutableArray<UIView *> *mutableAttachmentViews = @[].mutableCopy;
    __block NSMutableArray<CALayer *> *mutableAttachmentLayers = @[].mutableCopy;
    [_infoContainer.rects enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = obj.CGRectValue;
        
        NSString *key = NSStringFromCGRect(rect);
        JKTextAttachment *attachment = _infoContainer.attachmentDict[key];
        
        if (attachment) {
            if ([attachment.content isKindOfClass:[UIImage class]]) {
                
                CGContextSaveGState(context); {
                    UIImage *image = (UIImage *)attachment.content;

                    CGContextTranslateCTM(context, 0, CGRectGetMaxY(rect) + CGRectGetMinY(rect));
                    CGContextScaleCTM(context, 1, -1);
                    CGContextDrawImage(context, rect, image.CGImage);
                } CGContextRestoreGState(context);

                
            } else if ([attachment.content isKindOfClass:[CALayer class]]) {
                CALayer *layer = (CALayer *)attachment.content;
                dispatch_async(dispatch_get_main_queue(), ^{
                    layer.frame = rect;
                    [layer setNeedsDisplay];
                    [targetLayer addSublayer:layer];
                    [mutableAttachmentLayers addObject:layer];
                });
            } else if ([attachment.content isKindOfClass:[UIView class]]) {
                UIView *view = (UIView *)attachment.content;
                dispatch_async(dispatch_get_main_queue(), ^{
                    view.frame = rect;
                    [view setNeedsDisplay];
                    [targetView addSubview:view];
                    [mutableAttachmentViews addObject:view];
                });
            }
        }

    }];
    
    if (mutableAttachmentLayers.count <= 0) mutableAttachmentLayers = nil;
    if (mutableAttachmentViews.count <= 0) mutableAttachmentViews = nil;
    
    _attachmentLayers = mutableAttachmentLayers;
    _attachmentViews = mutableAttachmentViews;
}

- (void)_drawBorderInContext:(CGContextRef)context {
    [_infoContainer.rects enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = obj.CGRectValue;
        NSString *key = NSStringFromCGRect(rect);
        JKTextBorder *border = _infoContainer.borderDict[key];
        
        if (border) {
            
            CGFloat inset = -2.f;
            UIEdgeInsets insets = UIEdgeInsetsMake(inset, inset, inset, inset);
            CGRect pathRect = UIEdgeInsetsInsetRect(rect, insets);
            pathRect = UIEdgeInsetsInsetRect(pathRect, border.insets);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:border.cornerRadius];
            [border.color setStroke];
            path.lineWidth = border.width;
            [path stroke];
            
            if (border.innerColor) {
                [border.innerColor setFill];
                [path fill];
            }
        }
        
    }];
}

- (void)_drawHighightInContext:(CGContextRef)context {
    [_infoContainer.rects enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = obj.CGRectValue;
        NSString *key = NSStringFromCGRect(rect);
        JKTextHighlight *highlight = _infoContainer.highlightDict[key];
        
        if (highlight) {
            
            JKTextBorder *border = _infoContainer.borderDict[key];
            CGRect pathRect = rect;
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];
            if (border) {
                CGFloat inset = -2.f;
                UIEdgeInsets insets = UIEdgeInsetsMake(inset, inset, inset, inset);
                pathRect = UIEdgeInsetsInsetRect(rect, insets);
                pathRect = UIEdgeInsetsInsetRect(pathRect, border.insets);
                path = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:border.cornerRadius];
                
                if (highlight.borderColor) {
                    [highlight.borderColor setStroke];
                } else {
                    [border.color setStroke];
                }
                path.lineWidth = border.width;
                [path stroke];
            }
            
            [highlight.innerColor setFill];
            [path fill];
        }
    }];
}

- (void)_releaseC {
    if (_frameSetter)  {
        CFRelease(_frameSetter);
        _frameSetter = NULL;
    }
    if (_frame)  {
        CFRelease(_frame);
        _frame = NULL;
    }
}

@end
