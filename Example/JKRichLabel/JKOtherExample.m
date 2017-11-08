//
//  JKOtherExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/7.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKOtherExample.h"
#import "JKRichLabel.h"

@interface JKOtherExample ()

@end

@implementation JKOtherExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
//    introduction
    {
        JKRichLabel *one = [[JKRichLabel alloc] init];
        one.frame = CGRectMake(0, 80, width, 130);
        one.backgroundColor = [UIColor grayColor];
        one.textVerticalAlignment = JKTextVerticalAlignmentTop;
        one.numberOfLines = 0;
        one.text = @"default attributes introduction\n\ncharacterSpacing : 0.5f\nlineSpacing : 1.5f\nnumberOfLines : 1\ntextAlignment : NSTextAlignmentNatural\ntextVerticalAlignment : JKTextVerticalAlignmentCenter";
        [self.view addSubview:one];
    }
    
//    insets
    {
        JKRichLabel *one = [[JKRichLabel alloc] init];
        CGFloat maxY = CGRectGetMaxY(self.view.subviews.lastObject.frame);
        one.frame = CGRectMake(0, maxY + 10, width, 50);
        one.backgroundColor = [UIColor grayColor];
        one.textVerticalAlignment = JKTextVerticalAlignmentTop;
        one.numberOfLines = 0;
        one.textInsets = UIEdgeInsetsMake(8, 10, 0, 10);
        one.text = @"one.textInsets = UIEdgeInsetsMake(8, 10, 0, 10);";
        [self.view addSubview:one];
    }
//    characterSpacing
    {
        JKRichLabel *one = [[JKRichLabel alloc] init];
        CGFloat maxY = CGRectGetMaxY(self.view.subviews.lastObject.frame);
        one.frame = CGRectMake(0, maxY + 10, width, 20);
        one.backgroundColor = [UIColor grayColor];
        one.numberOfLines = 0;
        one.characterSpacing = 5;
        one.text = @"one.characterSpacing = 5;";
        [self.view addSubview:one];
    }
//    lineSpacing
    {
        JKRichLabel *one = [[JKRichLabel alloc] init];
        CGFloat maxY = CGRectGetMaxY(self.view.subviews.lastObject.frame);
        one.frame = CGRectMake(0, maxY + 10, width, 40);
        one.backgroundColor = [UIColor grayColor];
        one.numberOfLines = 0;
        one.lineSpacing = 5;
        one.text = @"one.lineSpacing = 5;\none.lineSpacing = 5;";
        [self.view addSubview:one];
    }

}

@end
