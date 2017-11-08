//
//  JKLineBreakModeExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/8.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKLineBreakModeExample.h"
#import "JKRichLabel.h"

@interface JKLineBreakModeExample ()

@end

@implementation JKLineBreakModeExample

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    JKRichLabel *tip = [[JKRichLabel alloc] init];
    tip.frame = CGRectMake(0, 80, width, 140);
    tip.textColor = [UIColor whiteColor];
    tip.backgroundColor = [UIColor redColor];
    tip.numberOfLines = 0;
    tip.text = @"不支持:\nNSLineBreakByTruncatingHead, NSLineBreakByTruncatingMiddle\n纯文本支持这两种属性很简单，当有附件时，代码复杂度增加很多，这里没做适配。为保持统一，纯文本也不支持这两种属性。当使用这两种属相时，默认转成NSLineBreakByTruncatingTail";
    tip.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:tip];
    
    
    NSArray<NSString *> *modes = @[
                                   @"NSLineBreakByWordWrapping",
                                   @"NSLineBreakByCharWrapping",
                                   @"NSLineBreakByClipping",
                                   @"NSLineBreakByTruncatingHead",
                                   @"NSLineBreakByTruncatingTail",
                                   @"NSLineBreakByTruncatingMiddle"
                                   ];

    CGRect frame = CGRectZero;
    for (int i = 0; i < 6; i++) {
        JKRichLabel *one = [[JKRichLabel alloc] init];
        if (i == 0) {
            frame = CGRectMake(0, 250, width, 50);
        } else {
            UIView *v = self.view.subviews.lastObject;
            CGFloat maxY = CGRectGetMaxY(v.frame);
            frame = CGRectMake(0, maxY + 10, width, 50);
        }
        one.frame = frame;
        one.backgroundColor = [UIColor grayColor];
        one.text = [NSString stringWithFormat:@"%@\nThis is a functional test text. This is a functional test text. This is a functional test text.This is a functional test text. This is a functional test text. ", modes[i]];
        one.lineBreakMode = i;
        one.numberOfLines = 0;
        [self.view addSubview:one];
    }
}

@end
