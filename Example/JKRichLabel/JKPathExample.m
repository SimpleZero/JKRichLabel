//
//  JKPathExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/8.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKPathExample.h"
#import "JKRichLabel.h"

@interface JKPathExample ()

@end

@implementation JKPathExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JKRichLabel *one = [[JKRichLabel alloc] init];
    one.frame = CGRectMake(20, 100, 152, 152);
    one.textVerticalAlignment = JKTextVerticalAlignmentTop;
    one.numberOfLines = 0;
    one.textContainerPath = [UIBezierPath bezierPathWithOvalInRect:one.bounds];
    one.backgroundColor = [UIColor grayColor];
    one.text = @"燕子去了，有再来的时候；杨柳枯了，有再青的时候；桃花谢了，有再开的时候。但是，聪明的，你告诉我，我们的日子为什么一去不复返呢？";
    [self.view addSubview:one];
}
@end
