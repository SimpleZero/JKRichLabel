//
//  JKRichLabelLayout.h
//  JKRichLabel
//
//  Created by 01 on 2017/10/6.
//  Copyright © 2017年 01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKRichLabelContainer.h"
#import "JKRichLabelLine.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKRichLabelLayout : NSObject

@property (nonatomic, strong, readonly) JKRichLabelContainer *container;
@property (nonatomic, strong, readonly) NSAttributedString *text;
@property (nonatomic, readonly) NSRange range;

@property (nonatomic, strong, readonly) JKTextInfoContainer *infoContainer;

@property (nullable, nonatomic, strong, readonly) NSArray<UIView *> *attachmentViews;
@property (nullable, nonatomic, strong, readonly) NSArray<CALayer *> *attachmentLayers;

@property (nonatomic, readonly) NSRange visibleRange;
@property (nonatomic, readonly) CGRect textBoundingRect;
@property (nonatomic, readonly) CGSize textBoundingSize;
// default is NO
@property (nonatomic) BOOL isHighlight;

+ (instancetype)layoutWithContainer:(JKRichLabelContainer *)container atrributedString:(NSAttributedString *)text;

+ (instancetype)layoutWithContainer:(JKRichLabelContainer *)container atrributedString:(NSAttributedString *)text range:(NSRange)range;

- (void)drawInContext:(nullable CGContextRef)context targetLayer:(CALayer *)targetLayer targetView:(UIView *)targetView cancel:(BOOL (^)(void))cancel;
@end

NS_ASSUME_NONNULL_END
