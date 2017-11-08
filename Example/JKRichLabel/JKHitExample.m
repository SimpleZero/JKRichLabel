//
//  JKHitExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/8.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKHitExample.h"
#import "JKRichLabel.h"

@interface JKHitExample ()

@end

@implementation JKHitExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    JKRichLabel *label = [[JKRichLabel alloc] init];
    label.frame = CGRectMake(0, 150, width, 50);
    label.backgroundColor = [UIColor grayColor];
    
    __weak typeof(self) weakSelf = self;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"这是一段可相应单击和长按的文字" singleTap:^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, JKTextAttachment * _Nullable attachment) {
        [weakSelf showMessage:@"单击"];
    } longPress:^(UIView * _Nonnull targetView, NSAttributedString * _Nonnull attributeString, JKTextAttachment * _Nullable attachment) {
        [weakSelf showMessage:@"长按"];
    }];
    
    label.attributedText = str;
    [self.view addSubview:label];
                                      
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
