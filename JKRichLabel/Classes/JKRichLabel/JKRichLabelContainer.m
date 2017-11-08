//
//  JKRichLabelContainer.m
//  JKRichLabel
//
//  Created by 01 on 2017/10/5.
//  Copyright © 2017年 01. All rights reserved.
//

#import "JKRichLabelContainer.h"

@implementation JKRichLabelContainer

#pragma mark - public
+ (instancetype)container {
    return [[self alloc] init];
}

#pragma mark - properties

- (CGRect)innerRect {
    CGRect rect = (CGRect){CGPointZero, _size};
    return UIEdgeInsetsInsetRect(rect, _insets);
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    switch (lineBreakMode) {
        
        case NSLineBreakByWordWrapping:
        case NSLineBreakByCharWrapping:
        case NSLineBreakByClipping:
            _lineBreakMode = lineBreakMode;
            break;
        case NSLineBreakByTruncatingHead:
        case NSLineBreakByTruncatingMiddle:
        case NSLineBreakByTruncatingTail:
        default:
            _lineBreakMode = NSLineBreakByTruncatingTail;
            break;
    }
}


@end
