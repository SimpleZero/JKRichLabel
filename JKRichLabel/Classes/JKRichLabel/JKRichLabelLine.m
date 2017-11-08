//
//  JKRichLabelLine.m
//  JKRichLabel
//
//  Created by 01 on 2017/10/6.
//  Copyright © 2017年 01. All rights reserved.
//

#import "JKRichLabelLine.h"

@implementation JKRichLabelLine {
    CGFloat _baselineGlyph;
}

#pragma mark - override
- (void)dealloc {
    if (_CTLine) CFRelease(_CTLine);
}

- (instancetype)init {
    if (self = [super init]) {
        _lineWidth = _ascent = _descent = _leading = _baselineGlyph = _trailingWhitespaceWidth = 0;
        _range = NSMakeRange(0, 0);
    }
    return self;
}

#pragma mark - public

+ (instancetype)lineWithCTLine:(CTLineRef)CTLine position:(CGPoint)position point:(CGPoint)point {
    JKRichLabelLine *line = [[JKRichLabelLine alloc] init];
    line->_position = position;
    line->_point = point;
    [line setCTLine:CTLine];
    return line;
}

- (void)configTextInfoWithWholeText:(NSAttributedString *)wholeText {
    
    if (NSEqualRanges(_range, NSMakeRange(0, 0))) return;
    
    _text = [wholeText attributedSubstringFromRange:_range];
    
    CFArrayRef runs = CTLineGetGlyphRuns(_CTLine);
    CFIndex runCount = CFArrayGetCount(runs);
    if (runCount == 0) return;
    
    JKTextInfo *info = [JKTextInfo new];
    JKTextInfoContainer *infoContainer = [JKTextInfoContainer infoContainer];
    
    for (CFIndex i = 0; i < runCount; i++) {
        
        CTRunRef run = CFArrayGetValueAtIndex(runs, i);
        NSDictionary *attrs = (id)CTRunGetAttributes(run);
        
        CFRange cfRange = CTRunGetStringRange(run);
        NSRange range = JKTextNSRangeFromCFRange(cfRange);
        
        NSAttributedString *runText = [wholeText attributedSubstringFromRange:range];
        CGRect rect = [self _calculateRunRect:run];
        JKTextAttachment *attachment = attrs[JKTextAttachmentAttributeKey];
        
        JKTextBlock singleTap = attrs[JKTextSingleTapAttributeKey];
        JKTextBlock longPress = attrs[JKTextLongPressAttributeKey];
        
        JKTextHighlight *highlight = attrs[JKTextHighlightAttributeKey];
        JKTextBorder *border = attrs[JKTextBorderAttributeKey];
        
        info.text = runText;
        info.rangeValue = [NSValue valueWithRange:range];
        info.rectValue = [NSValue valueWithCGRect:rect];
        info.attachment = attachment;
        info.singleTap = singleTap;
        info.longPress = longPress;
        info.highlight = highlight;
        info.border = border;
        
        [infoContainer addObjectFromInfo:info];        
    }
    _infoContainer = infoContainer;
}

#pragma mark - properties

- (void)setCTLine:(CTLineRef _Nonnull)CTLine {
    if (_CTLine == CTLine) return;
    
    if (CTLine) CFRetain(CTLine);
    if (_CTLine) CFRelease(_CTLine);
    
    _CTLine = CTLine;
    
    if (_CTLine) {

        _lineWidth = CTLineGetTypographicBounds(_CTLine, &_ascent, &_descent, &_leading);
        CFRange range = CTLineGetStringRange(_CTLine);
        _range = JKTextNSRangeFromCFRange(range);
        if (CTLineGetGlyphCount(_CTLine) > 0) {
            CFArrayRef runs = CTLineGetGlyphRuns(_CTLine);
            CTRunRef run = CFArrayGetValueAtIndex(runs, 0);
            CGPoint position;
            CTRunGetPositions(run, CFRangeMake(0, 1), &position);
            _baselineGlyph = position.x;
        } else {
            _baselineGlyph = 0;
        }
        _trailingWhitespaceWidth = CTLineGetTrailingWhitespaceWidth(_CTLine);
    }
    
    [self _layoutBounds];
}

- (CGSize)size {
    return _bounds.size;
}

- (CGFloat)width {
    return CGRectGetWidth(_bounds);
}

- (CGFloat)height {
    return CGRectGetHeight(_bounds);
}

- (CGFloat)top {
    return CGRectGetMinY(_bounds);
}

- (CGFloat)bottom {
    return CGRectGetMaxY(_bounds);
}

- (CGFloat)left {
    return CGRectGetMinX(_bounds);
}

- (CGFloat)right {
    return CGRectGetMaxX(_bounds);
}


#pragma mark - private

- (void)_layoutBounds {
    _bounds = CGRectMake(_position.x, _position.y - _ascent, _lineWidth, _ascent + _descent);
    _bounds.origin.x += _baselineGlyph;
}

#pragma mark - private
- (CGRect)_calculateRunRect:(CTRunRef)run {
    
    CGPoint runPosition = CGPointZero;
    CTRunGetPositions(run, CFRangeMake(0, 1), &runPosition);

    CGFloat ascent, descent, leading, runWidth;
    runWidth = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
    
    runPosition.x += (_position.x + _point.x);
    runPosition.y = _position.y - runPosition.y + _point.y;
    CGRect runRect = CGRectMake(runPosition.x, runPosition.y - ascent, runWidth, ascent + descent);
    return JKTextRoundRect(runRect);
}

@end
