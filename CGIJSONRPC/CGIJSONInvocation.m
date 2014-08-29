//
//  CGIJSONInvocation.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/7/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import "CGIJSONInvocation.h"
#import "CGIArrayExtension.h"

#import <CGIJSONObjects/CGIJSONObjects.h>

@implementation CGIJSONInvocation

- (instancetype)initWithInvocation:(NSInvocation *)invocation
{
    if (!(self = [super init]))
        return nil;
    
    // Parse the method name
    if (!invocation.selector)
        return self = nil;
    
    NSString *methodName = NSStringFromSelector(invocation.selector);
    NSMutableArray *validArguments = [[methodName componentsSeparatedByString:@":"] select:^BOOL(NSString *object)
    {
        return object.length > 0;
    }].mutableCopy;
    
    NSString *headString = validArguments[0];
    NSRange splitRange = [headString rangeOfString:@"With"];
    if (splitRange.location != NSNotFound)
    {
        self.method = [headString substringToIndex:splitRange.location];
        validArguments[0] = [headString substringFromIndex:NSMaxRange(splitRange)];
    }
    else
    {
        self.method = headString;
    }
    
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithCapacity:validArguments.count];
    
    for (NSUInteger idx = 2; idx < validArguments.count + 2; idx++)
    {
        const char *type = [invocation.methodSignature getArgumentTypeAtIndex:idx];
        id object = nil;
        
        if (type[0] == '@')
        {
            // Object: encode and store;
            id original = nil;
            [invocation getArgument:&original atIndex:idx];
            object = [CGIJSONCoder JSONObjectFromObject:original];
        }
        else
        {
            // Something else: use NSValue (and it will give me NSNumber when appropriate)
            NSUInteger align, size;
            NSGetSizeAndAlignment(type, &size, &align);
            void *buffer = malloc(size);
            [invocation getArgument:buffer atIndex:idx];
            object = [NSValue valueWithBytes:buffer objCType:type];
            free(buffer);
        }
        
        args[validArguments[idx - 2]] = object;
    }
    
    self.arguments = [args copy];
    
    return self;
}

@end
