# JKRichLabel

[![CI Status](http://img.shields.io/travis/SimpleZero/JKRichLabel.svg?style=flat)](https://travis-ci.org/SimpleZero/JKRichLabel)
[![Version](https://img.shields.io/cocoapods/v/JKRichLabel.svg?style=flat)](http://cocoapods.org/pods/JKRichLabel)
[![License](https://img.shields.io/cocoapods/l/JKRichLabel.svg?style=flat)](http://cocoapods.org/pods/JKRichLabel)
[![Platform](https://img.shields.io/cocoapods/p/JKRichLabel.svg?style=flat)](http://cocoapods.org/pods/JKRichLabel)

## Example

![](http://upload-images.jianshu.io/upload_images/329694-ad60df888e372a77.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


To run the example project, clone the repo, and run `pod install` from the Example directory first.


+ JKAlignmentExample

```
NSArray<NSString *> *texts = @[
@"左上",
@"左中",
@"左下",
@"中上",
@"中中",
@"中下",
@"右上",
@"右中",
@"右下"
];

NSArray<NSNumber *> *hAlignments = @[
@(NSTextAlignmentLeft),
@(NSTextAlignmentLeft),
@(NSTextAlignmentLeft),
@(NSTextAlignmentCenter),
@(NSTextAlignmentCenter),
@(NSTextAlignmentCenter),
@(NSTextAlignmentRight),
@(NSTextAlignmentRight),
@(NSTextAlignmentRight)
];

NSArray<NSNumber *> *vAlignments = @[
@(JKTextVerticalAlignmentTop),
@(JKTextVerticalAlignmentCenter),
@(JKTextVerticalAlignmentBottom),
@(JKTextVerticalAlignmentTop),
@(JKTextVerticalAlignmentCenter),
@(JKTextVerticalAlignmentBottom),
@(JKTextVerticalAlignmentTop),
@(JKTextVerticalAlignmentCenter),
@(JKTextVerticalAlignmentBottom)
];

CGRect frame = CGRectZero;
for (int i = 0; i < texts.count; i++) {
JKRichLabel *label = [[JKRichLabel alloc] init];
if (i == 0) {
frame = CGRectMake(0, 80, width, height);
} else {
UIView *v = self.view.subviews.lastObject;
CGFloat maxY = CGRectGetMaxY(v.frame);
frame = CGRectMake(0, maxY + 10, width, height);
}
label.frame = frame;
label.backgroundColor = [UIColor grayColor];
label.text = texts[i];
label.textAlignment = hAlignments[i].integerValue;
label.textVerticalAlignment = vAlignments[i].integerValue;
[self.view addSubview:label];
}
```

+ JKLineBreakModeExample

```
NSArray<NSString *> *modes = @[
@"NSLineBreakByWordWrapping",
@"NSLineBreakByCharWrapping",
@"NSLineBreakByClipping",
@"NSLineBreakByTruncatingHead",
@"NSLineBreakByTruncatingTail",
@"NSLineBreakByTruncatingMiddle"
];

CGRect frame = CGRectZero;
for (int i = 0; i < 6; i++) {
JKRichLabel *one = [[JKRichLabel alloc] init];
if (i == 0) {
frame = CGRectMake(0, 250, width, 50);
} else {
UIView *v = self.view.subviews.lastObject;
CGFloat maxY = CGRectGetMaxY(v.frame);
frame = CGRectMake(0, maxY + 10, width, 50);
}
one.frame = frame;
one.backgroundColor = [UIColor grayColor];
one.text = [NSString stringWithFormat:@"%@\nThis is a functional test text. This is a functional test text. This is a functional test text.This is a functional test text. This is a functional test text. ", modes[i]];
one.lineBreakMode = i;
one.numberOfLines = 0;
[self.view addSubview:one];
}
```


+ JKSizeToFitExample
```
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

```

+ JKPathExample
```
JKRichLabel *one = [[JKRichLabel alloc] init];
one.frame = CGRectMake(20, 100, 152, 152);
one.textVerticalAlignment = JKTextVerticalAlignmentTop;
one.numberOfLines = 0;
one.textContainerPath = [UIBezierPath bezierPathWithOvalInRect:one.bounds];
one.backgroundColor = [UIColor grayColor];
one.text = @"燕子去了，有再来的时候；杨柳枯了，有再青的时候；桃花谢了，有再开的时候。但是，聪明的，你告诉我，我们的日子为什么一去不复返呢？";
[self.view addSubview:one];
```

+ JKLongTextExample

```
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
```

+ JKHitExample
```
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
```

+ JKLinkExample
```
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
```

+ JKHighlightExample
```

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

```

+ JKWPSExample
```

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
```

+ JKOtherExample
```

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
```

## Requirements

## Installation

JKRichLabel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JKRichLabel'
```

## Author

SimpleZero, what_time@qq.com

## License

JKRichLabel is available under the MIT license. See the LICENSE file for more info.
