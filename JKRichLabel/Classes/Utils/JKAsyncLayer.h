//
//  JKAsyncLayer.h
//  JKAsyncLayer
//
//  Created by 01 on 2017/9/21.
//  Copyright © 2017年 01. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKAsyncLayerDisplayTask : NSObject
@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);

@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL (^isCanceled)(void));

@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);
@end

@protocol JKAsyncLayerDelegate <NSObject>
@required
- (JKAsyncLayerDisplayTask *)newAsyncLayerDisplayTask;
@end

@interface JKAsyncLayer : CALayer
// default is Yes
@property BOOL displaysAsynchronously;
@end

NS_ASSUME_NONNULL_END
