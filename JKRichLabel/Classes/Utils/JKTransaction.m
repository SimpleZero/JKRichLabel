//
//  JKTransaction.m
//  JKAsyncLayer
//
//  Created by 01 on 2017/9/23.
//  Copyright © 2017年 01. All rights reserved.
//

#import "JKTransaction.h"

@interface JKTransaction ()
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;
@end

static NSMutableSet *transactionSet = nil;

static void JKRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    if (transactionSet.count == 0) return;
    NSSet *transactions = transactionSet;
    transactionSet = [NSMutableSet new];
    [transactions enumerateObjectsUsingBlock:^(JKTransaction *  _Nonnull transaction, BOOL * _Nonnull stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [transaction.target performSelector:transaction.selector];
#pragma clang diagnostic pop
    }];
}


static void JKTransactionSetup() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transactionSet = [NSMutableSet new];
        CFRunLoopRef runLoop = CFRunLoopGetMain();
        CFRunLoopObserverRef observer;
        observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0xFFFFFF,JKRunLoopObserverCallBack, NULL);
        CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}

@implementation JKTransaction

+ (instancetype)transactionWithTarget:(id)target selector:(SEL)selector {
    JKTransaction *transaction = [JKTransaction new];
    transaction.target = target;
    transaction.selector = selector;
    return transaction;
}

- (void)commit {
    if (!_target || !_selector) return;
    JKTransactionSetup();
    [transactionSet addObject:self];
}

- (NSUInteger)hash {
    long v1 = (long)((void *)_selector);
    long v2 = (long)_target;
    return v1 ^ v2;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isMemberOfClass:self.class]) return NO;
    JKTransaction *other = object;
    return other.selector == _selector && other.target == _target;
}

@end






