//
//  JKRichLabelExample.m
//  JKRichLabel_Example
//
//  Created by 01 on 2017/11/7.
//  Copyright © 2017年 SimpleZero. All rights reserved.
//

#import "JKRichLabelExample.h"

@interface JKRichLabelExample ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *clsNames;

@end

@implementation JKRichLabelExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setup];
    [self _configCell];
    [self.tableView reloadData];
}

- (void)_setup {
    self.title = NSStringFromClass(self.class);
    self.titles = @[].mutableCopy;
    self.clsNames = @[].mutableCopy;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JK"];
}

- (void)_configCell {
    [self _addCellTitle:@"Simple Text Alignment" clsName:@"JKAlignmentExample"];
    [self _addCellTitle:@"Line Break Mode" clsName:@"JKLineBreakModeExample"];
    [self _addCellTitle:@"Text Size To Fit" clsName:@"JKSizeToFitExample"];
    [self _addCellTitle:@"Text Path" clsName:@"JKPathExample"];
    [self _addCellTitle:@"Long Text" clsName:@"JKLongTextExample"];
    [self _addCellTitle:@"Single Tap And Long Press" clsName:@"JKHitExample"];
    [self _addCellTitle:@"Link" clsName:@"JKLinkExample"];
    [self _addCellTitle:@"Highlight And Border" clsName:@"JKHighlightExample"];
    [self _addCellTitle:@"WPS" clsName:@"JKWPSExample"];
    [self _addCellTitle:@"Text Other Attributes" clsName:@"JKOtherExample"];
}

- (void)_addCellTitle:(NSString *)title clsName:(NSString *)clsName{
    [self.titles addObject:title];
    [self.clsNames addObject:clsName];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JK"];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class cls = NSClassFromString(_clsNames[indexPath.row]);
    if (cls) {
        UIViewController *vc = [[cls alloc] init];
        vc.title = _titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
