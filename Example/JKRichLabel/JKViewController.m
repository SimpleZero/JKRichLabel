//
//  JKViewController.m
//  JKRichLabel
//
//  Created by SimpleZero on 11/07/2017.
//  Copyright (c) 2017 SimpleZero. All rights reserved.
//

#import "JKViewController.h"
#import "JKRichLabelExample.h"

@interface JKViewController ()
@end

@implementation JKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JKRichLabelExample *example = [JKRichLabelExample new];
    [self pushViewController:example animated:NO];
}

@end
