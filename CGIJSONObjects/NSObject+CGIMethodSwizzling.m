//
//  NSObject+CGIMethodSwizzling.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 4/2/15.
//  Copyright (c) 2015 DreamCity. All rights reserved.
//

#import "NSObject+CGIMethodSwizzling.h"
#import <objc/runtime.h>

void objc_swapImplementationOfSelectors(Class class, SEL original, SEL replacement)
{
    // Reference: http://nshipster.com/method-swizzling/
    Method originalMethod = class_getInstanceMethod(class, original);
    Method replacementMethod = class_getInstanceMethod(class, replacement);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    original,
                    method_getImplementation(replacementMethod),
                    method_getTypeEncoding(replacementMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class,
                            replacement,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}

@implementation NSObject (CGIMethodSwizzling)

+ (void)swapImplementationOfClassMethodSelector:(SEL)original withSelector:(SEL)replacement
{
    Class metaclass = object_getClass((id)[self class]);
    objc_swapImplementationOfSelectors(metaclass, original, replacement);
}

+ (void)swapImplementationOfInstanceMethodSelector:(SEL)original withSelector:(SEL)replacement
{
    objc_swapImplementationOfSelectors([self class], original, replacement);
}

@end
