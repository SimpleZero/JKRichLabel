//
//  JKRichLabelLine.h
//  JKRichLabel
//
//  Created by 01 on 2017/10/6.
//  Copyright © 2017年 01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "JKRichLabelAttribute.h"
#import "JKRichLabelText.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKRichLabelLine : NSObject

+ (instancetype)lineWithCTLine:(CTLineRef)CTLine position:(CGPoint)position point:(CGPoint)point;

- (void)configTextInfoWithWholeText:(NSAttributedString *)wholeText;

@property (nonatomic, readonly) NSAttributedString *text;
@property (nonatomic, readonly) CGPoint point;
@property (nonatomic, readonly) CTLineRef CTLine;
@property (nonatomic) NSUInteger index;
@property (nonatomic, readonly) NSRange range;

@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat bottom;
@property (nonatomic, readonly) CGFloat left;
@property (nonatomic, readonly) CGFloat right;

@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGFloat ascent;
@property (nonatomic, readonly) CGFloat descent;
@property (nonatomic, readonly) CGFloat leading;
@property (nonatomic, readonly) CGFloat lineWidth;
@property (nonatomic, readonly) CGFloat trailingWhitespaceWidth;

@property (nonatomic, strong, readonly) JKTextInfoContainer *infoContainer;

@end

NS_ASSUME_NONNULL_END

