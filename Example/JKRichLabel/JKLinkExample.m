//
//  JKLinkExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/8.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKLinkExample.h"
#import "JKRichLabel.h"

@interface JKLinkExample ()

@end

@implementation JKLinkExample

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    JKRichLabel *tip = [[JKRichLabel alloc] init];
    tip.frame = CGRectMake(0, 120, width, 50);
    tip.textColor = [UIColor whiteColor];
    tip.backgroundColor = [UIColor blackColor];
    tip.text = @"各种Link的实现方法 JKLinkExample.m";
    tip.font = [UIFont systemFontOfSize:16.f];
    [self.view addSubview:tip];
    
    {
        JKRichLabel *one = [[JKRichLabel alloc] init];
        one.frame = CGRectMake(0, 200, width, 50);
        one.backgroundColor = [UIColor greenColor];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"http://www.jianshu.com/u/02a488e1e71e"];
        [str setDefaultLink];
        one.attributedText = str;
        [self.view addSubview:one];
    }
    
    {
        UIView *v = self.view.subviews.lastObject;
        CGFloat maxY = CGRectGetMaxY(v.frame);
        JKRichLabel *one = [[JKRichLabel alloc] init];
        one.frame = CGRectMake(0, maxY + 10, width, 50);
        one.backgroundColor = [UIColor grayColor];
        __weak typeof(self) weakSelf = self;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"自定义方法" singleTap:^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, JKTextAttachment * _Nullable attachment) {
            [weakSelf showMessage:attributeString.string];
        }];
        [str setDefaultLinkColor];
        one.attributedText = str;
        [self.view addSubview:one];
    }
}


- (void)showMessage:(NSString *)msg {
    
    UILabel *label = [UILabel new];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.75];
    label.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    [self.view addSubview:label];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = label.frame;
        frame.origin.y = 64;
        label.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = label.frame;
            frame.origin.y = -64;
            label.frame = frame;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}



@end
