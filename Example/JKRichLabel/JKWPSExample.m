//
//  JKWPSExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/8.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKWPSExample.h"
#import "JKRichLabel.h"

@interface JKWPSExample ()

@end

@implementation JKWPSExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    
    JKRichLabel *label = [[JKRichLabel alloc] init];
    label.frame = CGRectMake(10, 100, width - 20, 350);
    label.backgroundColor = [UIColor grayColor];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Hello World\n\n"];
    [str jk_setFont:[UIFont systemFontOfSize:30]];
    [str jk_setTextColor:[UIColor blueColor]];
    
    CGSize size = CGSizeMake(50, 50);
    
    {
        [str appendString:@"这是一张图片\t"];

        UIImage *img = [UIImage imageNamed:@"JK"];
        JKTextAttachment *attachment = [JKTextAttachment attachmentWithContent:img contentSize:size alignToFont:nil];
        [str appendAttachment:attachment];
        [str appendString:@"\n"];
    }
    
    {
        [str appendString:@"这是一个layer\t"];
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor purpleColor].CGColor;
        JKTextAttachment *attachment = [JKTextAttachment attachmentWithContent:layer contentSize:size alignToFont:nil];
        [str appendAttachment:attachment];
        [str appendString:@"\n"];
    }
    
    {
        [str appendString:@"这是一个view\t"];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor orangeColor];
        JKTextAttachment *attachment = [JKTextAttachment attachmentWithContent:view contentSize:size alignToFont:nil];
        [str appendAttachment:attachment];
    }
    
    label.attributedText = str;
    label.numberOfLines = 0;
    label.lineSpacing = 10;
    
    [self.view addSubview:label];

}

@end
