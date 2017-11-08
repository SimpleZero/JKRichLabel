#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JKRichLabel.h"
#import "JKRichLabelAttribute.h"
#import "JKRichLabelContainer.h"
#import "JKRichLabelLayout.h"
#import "JKRichLabelLine.h"
#import "JKRichLabelText.h"
#import "JKAsyncLayer.h"
#import "JKTransaction.h"

FOUNDATION_EXPORT double JKRichLabelVersionNumber;
FOUNDATION_EXPORT const unsigned char JKRichLabelVersionString[];

