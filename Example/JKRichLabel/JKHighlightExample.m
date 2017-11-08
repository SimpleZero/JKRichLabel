//
//  JKHighlightExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/8.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKHighlightExample.h"
#import "JKRichLabel.h"

@interface JKHighlightExample ()

@end

@implementation JKHighlightExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);

    JKRichLabel *one = [[JKRichLabel alloc] init];
    one.frame = CGRectMake(0, 80, width, 50);
    one.backgroundColor = [UIColor yellowColor];
    one.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *oneStr = [[NSMutableAttributedString alloc] initWithString:@"one"];
    
    JKTextBorder *oneBorder = [JKTextBorder defaultBorder];
    JKTextHighlight *oneHighlight = [JKTextHighlight new];
    oneHighlight.textColor = [UIColor grayColor];
    oneHighlight.innerColor = [UIColor blackColor];
    oneHighlight.borderColor = oneHighlight.textColor;
    
    oneStr.border = oneBorder;
    oneStr.highlight = oneHighlight;
    
    one.attributedText = oneStr;
    [self.view addSubview:one];
    
    
    JKRichLabel *two = [[JKRichLabel alloc] init];
    two.frame = CGRectMake(0, 180, width, 50);
    two.backgroundColor = [UIColor yellowColor];
    two.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *twoStr = [[NSMutableAttributedString alloc] initWithString:@"two"];
    
    JKTextBorder *twoBorder = [JKTextBorder defaultBorder];
    twoBorder.innerColor = [UIColor grayColor];
    JKTextHighlight *twoHighlight = [JKTextHighlight new];
    twoHighlight.textColor = [UIColor grayColor];
    twoHighlight.innerColor = [UIColor blackColor];
    twoHighlight.borderColor = twoHighlight.textColor;
    
    twoStr.border = twoBorder;
    twoStr.highlight = twoHighlight;
    
    two.attributedText = twoStr;
    [self.view addSubview:two];
    
    
}

@end
