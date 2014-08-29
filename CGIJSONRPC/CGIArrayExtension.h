//
//  CGIArrayExtension.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/7/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CGIArrayExtension)

- (NSArray *)select:(BOOL (^)(id object))criteria;

@end
