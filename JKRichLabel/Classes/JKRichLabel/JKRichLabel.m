//
//  JKRichLabel.m
//  JKRichLabel
//
//  Created by 01 on 2017/10/5.
//  Copyright © 2017年 01. All rights reserved.
//

#import "JKRichLabel.h"
#import "JKRichLabelContainer.h"
#import "JKRichLabelLayout.h"


@interface JKRichLabel() <JKAsyncLayerDelegate> {
    NSMutableAttributedString *_innerText;
    JKRichLabelLayout *_layout;
    JKRichLabelLayout *_highlightLayout;
    
    NSMutableParagraphStyle *_paragraph;
    
    UITapGestureRecognizer *_singleTapGR;
    UILongPressGestureRecognizer *_longPressGR;
    
    NSArray<UIView *> *_attachmentViews;
    NSArray<CALayer *> *_attachmentLayers;
    
    NSMutableArray<UIBezierPath *> *_paths;
}

@end

@implementation JKRichLabel

#pragma mark - override

- (instancetype)init {
    if (self = [super init]) {
        [self _initLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _initLabel];
    }
    return self;
}

- (void)setNeedsDisplay {
    [self _update];
    [super setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self _prepareDrawStringWithText];
    if (_innerText.length > 0 &&
        self.bounds.size.height != 0 &&
        self.bounds.size.height != 0) {
        NSAttributedString *str = _innerText.mutableCopy;
        size = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);

        CFRange range = CFRangeMake(0, str.length);
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)str);
        CGSize s = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, range, NULL, size, NULL);
        size = JKTextCeilSize(s);
        CFRelease(frameSetter);
        
        if (!CGSizeEqualToSize(_textSize, size)) {
            self.layer.contents = nil;
        }
        
        _textSize = size;
        _textInsets = UIEdgeInsetsZero;
        [self _removeAttachments];
        [self _update];
        
        return size;
    } else {
        return [super sizeThatFits:size];
    }
}

+ (Class)layerClass {
    return [JKAsyncLayer class];
}

#pragma mark - properties
- (void)setText:(NSString *)text {
    if (_text == text || [_text isEqualToString:text]) return;
    
    _text = text.copy;
    [_innerText replaceCharactersInRange:NSMakeRange(0, _innerText.length) withString:text];
    [self _update];
}

- (void)setFont:(UIFont *)font {
    if (_font == font) return;
    _font = font;
    [self _update];
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) return;
    _textColor = textColor;
    [self _update];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (_attributedText == attributedText || [_attributedText isEqualToAttributedString:attributedText]) return;
    _attributedText = attributedText;
    _innerText = attributedText.mutableCopy;
    [self _update];
}

- (void)setCharacterSpacing:(CGFloat)characterSpacing {
    if (_characterSpacing == characterSpacing || characterSpacing < 0.f) return;
    _characterSpacing = characterSpacing;
    [self _update];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    if (_lineSpacing == lineSpacing || lineSpacing < 0.f) return;
    _lineSpacing = lineSpacing;
    _paragraph.lineSpacing = lineSpacing;
    [self _update];
}

- (void)setLineHeight:(CGFloat)lineHeight {
    if (_lineHeight == lineHeight || lineHeight < 0.f) return;
    _lineHeight = lineHeight;
    _paragraph.minimumLineHeight = lineHeight;
    _paragraph.maximumLineHeight = lineHeight;
    [self _update];
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    if (_paragraphSpacing == paragraphSpacing || paragraphSpacing < 0.f) return;
    _paragraphSpacing = paragraphSpacing;
    _paragraph.paragraphSpacing = paragraphSpacing;
    [self _update];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (_lineBreakMode == lineBreakMode) return;
    _lineBreakMode = lineBreakMode;
    if (lineBreakMode == NSLineBreakByCharWrapping) {
        _paragraph.lineBreakMode = NSLineBreakByCharWrapping;
    } else {
        _paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    }
    [self _update];
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    if (_numberOfLines == numberOfLines) return;
    _numberOfLines = numberOfLines;
    [self _update];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment == textAlignment) return;
    _textAlignment = textAlignment;
    _paragraph.alignment = textAlignment;
    [self _update];
}

- (void)setTextVerticalAlignment:(JKTextVerticalAlignment)textVerticalAlignment {
    if (_textVerticalAlignment == textVerticalAlignment) return;
    _textVerticalAlignment = textVerticalAlignment;
    [self _update];
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    if (_textContainerPath) return;
    _textInsets = textInsets;
    [self _update];
}


- (void)setTextContainerPath:(UIBezierPath *)textContainerPath {
    if (!textContainerPath) return;
    _textContainerPath = textContainerPath;
    [self _update];
}


#pragma mark - JKAsyncLayerDelegate

- (JKAsyncLayerDisplayTask *)newAsyncLayerDisplayTask {
    
    JKAsyncLayerDisplayTask *task = [JKAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer * _Nonnull layer) {
        [self _prepareDrawStringWithText];
        if (!_highlightLayout) [self _createLayout];
        [layer removeAnimationForKey:@"contents"];
    };
    
    __block __weak typeof(self.layer) weakLayer = self.layer;
    __block __weak typeof(self) weakSelf = self;
    task.display = ^(CGContextRef  _Nonnull context, CGSize size, BOOL (^ _Nonnull isCanceled)(void)) {
        if (isCanceled() || _innerText.length == 0) return;
        
        JKRichLabelLayout *drawLayout = _highlightLayout ? _highlightLayout : _layout;
        
        [drawLayout drawInContext:context targetLayer:weakLayer targetView:weakSelf cancel:isCanceled];
        
    };
    task.didDisplay = ^(CALayer * _Nonnull layer, BOOL finished) {
        
        CATransition *transition = [CATransition animation];
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionFade;
        transition.duration = 0.5;
        [layer addAnimation:transition forKey:@"contents"];
        
        [self _hideHighlight];
    };
    
    return task;
}

#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    point = JKTextRoundPoint(point);
    BOOL canResponse = [_layout.infoContainer canResponseUserActionAtPoint:point];
    JKTextInfo *info = _layout.infoContainer.responseInfo;
    if (canResponse && info.highlight) {
        [self _showHighlightWithInfo:info];
        [self _update];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}


#pragma mark - GR
- (void)singleTapAction:(UITapGestureRecognizer *)gr {
    CGPoint point = [gr locationInView:self];
    
    BOOL canResponse = [_layout.infoContainer canResponseUserActionAtPoint:point];
    if (canResponse) {
        JKTextInfo *info = _layout.infoContainer.responseInfo;
        if (info.singleTap) {
            info.singleTap(self, info.text, info.attachment);
        }
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gr {
    CGPoint point = [gr locationInView:self];
    
    BOOL canResponse = [_layout.infoContainer canResponseUserActionAtPoint:point];
    if (canResponse) {
        JKTextInfo *info = _layout.infoContainer.responseInfo;
        if (info.longPress) {
            info.longPress(self, info.text, info.attachment);
        }
    }
}

#pragma mark - private

- (void)_initLabel {
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    
    _innerText = [NSMutableAttributedString new];
    _characterSpacing = 0.5f;
    _lineSpacing = 1.5f;
    _lineBreakMode = NSLineBreakByTruncatingTail;
    _textAlignment = NSTextAlignmentNatural;
    _textVerticalAlignment = JKTextVerticalAlignmentCenter;
    _numberOfLines = 1;
    _textInsets = UIEdgeInsetsZero;
    
    _paragraph = [[NSMutableParagraphStyle alloc] init];
    _paragraph.lineSpacing = _lineSpacing;
    _paragraph.alignment = _textAlignment;
    _paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    _singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [self addGestureRecognizer:_singleTapGR];
    _longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:_longPressGR];
    
}

- (void)_prepareDrawStringWithText {
    if (_innerText.length <= 0 || !_innerText) return;
    
    NSMutableAttributedString *drawString = _innerText.mutableCopy;
    
    NSMutableDictionary *attrs = @{}.mutableCopy;
    [attrs setValue:_paragraph forKey:NSParagraphStyleAttributeName];
    [attrs setValue:@(_characterSpacing) forKey:NSKernAttributeName];
    if (_font) {
        [attrs setValue:_font forKey:NSFontAttributeName];
    }
    if (_textColor) {
        [attrs setValue:_textColor forKey:NSForegroundColorAttributeName];
    }
    
    [drawString addAttributes:attrs range:NSMakeRange(0, drawString.length)];
    
    _innerText = drawString;
}

- (JKRichLabelContainer *)_createContainer {
    JKRichLabelContainer *container = [JKRichLabelContainer container];
    container.size = self.bounds.size;
    container.insets = _textInsets;
    
    container.maxNumberOfRows = _numberOfLines;
    container.lineBreakMode = _lineBreakMode;
    container.path = _textContainerPath;
    container.verticalAlignment = _textVerticalAlignment;
    
    return container;
}

- (void)_updateAttachments {
    [self _removeAttachments];
    JKRichLabelLayout *layout = _highlightLayout ? _highlightLayout : _layout;
    _attachmentViews = layout.attachmentViews;
    _attachmentLayers = layout.attachmentLayers;
}

- (void)_removeAttachments {
    for (UIView *view in _attachmentViews) {
        [view removeFromSuperview];
    }
    for (CALayer *layer in _attachmentLayers) {
        [layer removeFromSuperlayer];
    }
}

- (void)_update {
    [self.layer setNeedsDisplay];
}

- (void)_showHighlightWithInfo:(JKTextInfo *)info {
    JKTextHighlight *highlight = info.highlight;
    NSMutableAttributedString *text = _innerText.mutableCopy;
    if (highlight.textColor) {
        [text addAttribute:NSForegroundColorAttributeName value:highlight.textColor range:info.rangeValue.rangeValue];
    }
    if (highlight.underlineColor) {
        [text addAttribute:NSUnderlineColorAttributeName value:highlight.underlineColor range:info.rangeValue.rangeValue];
    }
    [self _createHighlightLayoutWithText:text];
}

- (void)_hideHighlight {
    if (_highlightLayout) {
        _highlightLayout = nil;
        [self _update];
    }
}

- (void)_createLayout {
    JKRichLabelContainer *container = [self _createContainer];
    _layout = [JKRichLabelLayout layoutWithContainer:container atrributedString:_innerText];
    [self _updateAttachments];
    _textSize = _layout.textBoundingSize;
}

- (void)_createHighlightLayoutWithText:(NSAttributedString *)text {
    JKRichLabelContainer *container = [self _createContainer];
    _highlightLayout = [JKRichLabelLayout layoutWithContainer:container atrributedString:text];
    _highlightLayout.isHighlight = YES;
    [self _updateAttachments];
    _textSize = _highlightLayout.textBoundingSize;
}

@end
