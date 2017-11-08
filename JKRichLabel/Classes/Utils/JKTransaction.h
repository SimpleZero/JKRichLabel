//
//  JKTransaction.h
//  JKAsyncLayer
//
//  Created by 01 on 2017/9/23.
//  Copyright © 2017年 01. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKTransaction : NSObject

+ (instancetype)transactionWithTarget:(id)target selector:(SEL)selector;

- (void)commit;

@end

NS_ASSUME_NONNULL_END
