//
//  JKAlignmentExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/7.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKAlignmentExample.h"
#import "JKRichLabel.h"

@interface JKAlignmentExample ()

@end

@implementation JKAlignmentExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = 50;
    
    NSArray<NSString *> *texts = @[
                       @"左上",
                       @"左中",
                       @"左下",
                       @"中上",
                       @"中中",
                       @"中下",
                       @"右上",
                       @"右中",
                       @"右下"
                       ];
    
    NSArray<NSNumber *> *hAlignments = @[
                             @(NSTextAlignmentLeft),
                             @(NSTextAlignmentLeft),
                             @(NSTextAlignmentLeft),
                             @(NSTextAlignmentCenter),
                             @(NSTextAlignmentCenter),
                             @(NSTextAlignmentCenter),
                             @(NSTextAlignmentRight),
                             @(NSTextAlignmentRight),
                             @(NSTextAlignmentRight)
                             ];
    
    NSArray<NSNumber *> *vAlignments = @[
                             @(JKTextVerticalAlignmentTop),
                             @(JKTextVerticalAlignmentCenter),
                             @(JKTextVerticalAlignmentBottom),
                             @(JKTextVerticalAlignmentTop),
                             @(JKTextVerticalAlignmentCenter),
                             @(JKTextVerticalAlignmentBottom),
                             @(JKTextVerticalAlignmentTop),
                             @(JKTextVerticalAlignmentCenter),
                             @(JKTextVerticalAlignmentBottom)
                             ];
    
    CGRect frame = CGRectZero;
    for (int i = 0; i < texts.count; i++) {
        JKRichLabel *label = [[JKRichLabel alloc] init];
        if (i == 0) {
            frame = CGRectMake(0, 80, width, height);
        } else {
            UIView *v = self.view.subviews.lastObject;
            CGFloat maxY = CGRectGetMaxY(v.frame);
            frame = CGRectMake(0, maxY + 10, width, height);
        }
        label.frame = frame;
        label.backgroundColor = [UIColor grayColor];
        label.text = texts[i];
        label.textAlignment = hAlignments[i].integerValue;
        label.textVerticalAlignment = vAlignments[i].integerValue;
        [self.view addSubview:label];
    }
}

@end
