//
//  NSObject+CGIMethodSwizzling.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 4/2/15.
//  Copyright (c) 2015 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT
/*!
 Swap implementation of two selectors.
 
 @param original    Original selector to be swapped.
 @param replacement New selector to be swapped.
 
 @warning You must be extremely careful when swizzling methods. Refer to Mattt
 Thompson's <a href="http://nshipster.com/method-swizzling/">swizzling guide</a>
 for details.
 
 @availability Available in CGIJSONObjects version 8 and later.
 */
void objc_swapImplementationOfSelectors(Class class, SEL original, SEL replacement);

@interface NSObject (CGIMethodSwizzling)

/// @name Method swizzling

/*!
 Swap implementation of two class method selectors.
 
 @param original    Original selector to be swapped.
 @param replacement New selector to be swapped.
 
 @warning You must be extremely careful when swizzling methods. Refer to Mattt
 Thompson's <a href="http://nshipster.com/method-swizzling/">swizzling guide</a>
 for details.
 
 @availability Available in CGIJSONObjects version 8 and later.
*/
+ (void)swapImplementationOfClassMethodSelector:(SEL)original withSelector:(SEL)replacement;

/*!
 Swap implementation of two instance method selectors.
 
 @param original    Original selector to be swapped.
 @param replacement New selector to be swapped.
 
 @warning You must be extremely careful when swizzling methods. Refer to Mattt
 Thompson's <a href="http://nshipster.com/method-swizzling/">swizzling guide</a>
 for details.
 
 @availability Available in CGIJSONObjects version 8 and later.
 */
+ (void)swapImplementationOfInstanceMethodSelector:(SEL)original withSelector:(SEL)replacement;

@end
