//
//  JKSizeToFitExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/7.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKSizeToFitExample.h"
#import "JKRichLabel.h"

@interface JKSizeToFitExample ()

@end

@implementation JKSizeToFitExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);

    JKRichLabel *tip = [[JKRichLabel alloc] init];
    tip.frame = CGRectMake(0, 80, width, 50);
    tip.textColor = [UIColor whiteColor];
    tip.backgroundColor = [UIColor redColor];
    tip.text = @"点击空白处，下方label可自适应大小";
    tip.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:tip];
    
    {
        JKRichLabel *one = [[JKRichLabel alloc] init];
        one.frame = CGRectMake(0, 200, width, 50);
        one.numberOfLines = 0;
        one.backgroundColor = [UIColor grayColor];
        one.text = @"To be or not to be, that's a question.";
        [self.view addSubview:one];
    }
    
    {
        UIView *lastV = self.view.subviews.lastObject;
        CGFloat maxY = CGRectGetMaxY(lastV.frame);
        JKRichLabel *one = [[JKRichLabel alloc] init];
        one.frame = CGRectMake(0, maxY + 10, width, 50);
        one.numberOfLines = 0;
        one.backgroundColor = [UIColor grayColor];
        one.text = @"To be or not to be, that's a question.\nTo be or not to be, that's a question.\nTo be or not to be, that's a question.\nTo be or not to be, that's a question.\nTo be or not to be, that's a question.\n";
        [self.view addSubview:one];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (int i = 1; i < self.view.subviews.count; i++) {
        UIView *view = self.view.subviews[i];
        [view sizeToFit];
    }
}

@end
