//
//  JKRichLabelContainer.h
//  JKRichLabel
//
//  Created by 01 on 2017/10/5.
//  Copyright © 2017年 01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKRichLabelText.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKRichLabelContainer : NSObject

@property (nullable, nonatomic, copy) UIBezierPath *path;

@property (nonatomic) CGSize size;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic, readonly) CGRect innerRect;

@property (nonatomic) NSUInteger maxNumberOfRows;
@property (nonatomic) NSLineBreakMode lineBreakMode;
@property (nonatomic) JKTextVerticalAlignment verticalAlignment;

+ (instancetype)container;

@end

NS_ASSUME_NONNULL_END
