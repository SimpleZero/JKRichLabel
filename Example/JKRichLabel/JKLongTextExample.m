//
//  JKLongTextExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/8.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKLongTextExample.h"
#import "JKRichLabel.h"

@interface JKLongTextExample ()

@end

@implementation JKLongTextExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    NSMutableString *mutableStr = [NSMutableString new];
    NSString *str = @"This is a long text test. ";
    for (int i = 0; i < 199; i++) {
        [mutableStr appendString:str];
    }
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    JKRichLabel *label = [[JKRichLabel alloc] init];
    label.frame = CGRectMake(0, 0, width, 100);
    label.text = mutableStr;
    label.font = [UIFont systemFontOfSize:18.f];
    label.numberOfLines = 0;
    [label sizeToFit];
    
    scrollView.contentSize = label.bounds.size;
    [scrollView addSubview:label];
    
    [self.view addSubview:scrollView];
}

@end
