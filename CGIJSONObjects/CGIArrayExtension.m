//
//  CGIArrayExtension.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/7/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import "CGIArrayExtension.h"

@implementation NSArray (CGIArrayExtension)

- (NSArray *)select:(BOOL (^)(id))criteria
{
    if (!criteria)
        return nil;
    
    NSMutableArray *outArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self)
        if (criteria(object))
            [outArray addObject:object];
    
    return [outArray copy];
}

@end
