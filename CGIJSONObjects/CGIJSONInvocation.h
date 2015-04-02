//
//  CGIJSONInvocation.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/7/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIJSONInvocation : NSObject

@property NSString *method;
@property NSDictionary *arguments;
@property id returnValue;

- (instancetype)initWithInvocation:(NSInvocation *)invocation;

@end
