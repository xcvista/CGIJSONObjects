//
//  NSObject+CGIKeyValueDetection.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 4/2/15.
//  Copyright (c) 2015 DreamCity. All rights reserved.
//

#import "NSObject+CGIKeyValueCoding.h"
#import "CGIJSONDefines.h"
#import "NSObject+CGIMethodSwizzling.h"

#import <objc/runtime.h>

@implementation NSObject (CGIKeyValueDetection)

#pragma mark - Key detection

- (NSArray *)allKeys
{
    @synchronized (self)
    {
        NSArray *_allKeys = [self associatedObjectForSelector:@selector(allKeys)];
        if (!_allKeys)
        {
            unsigned propertyCount = 0;
            objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
            NSMutableArray *allKeys = [NSMutableArray arrayWithCapacity:propertyCount];
            
            for (unsigned idx = 0; idx < propertyCount; idx++)
            {
                @autoreleasepool
                {
                    objc_property_t property = properties[idx];
                    [allKeys addObject:@(property_getName(property))];
                }
            }
            
            if (properties)
                free(properties);
            
            [self setAssociatedObject:_allKeys = allKeys.copy
                          forSelector:@selector(allKeys)];
        }
        
        return _allKeys.copy;
    }
}

#pragma mark - Class detection.

- (Class)_detectClassForKey:(NSString *)key
{
    objc_property_t property = class_getProperty([self class], key.UTF8String);
    char *value = property_copyAttributeValue(property, "T");
    
    NSString *attributeString = [[NSString alloc] initWithBytesNoCopy:value
                                                               length:strlen(value)
                                                             encoding:NSUTF8StringEncoding
                                                         freeWhenDone:YES]; // value should be freed after use,
    // so I let NSString take over.
    // It will be okay to use value as long as
    // this NSString is still in scope.
    if (strchr("cislqCISLQfdB", value[0]))
    {
        // Primitive types are encoded in NSNumber.
        return [NSNumber class];
    }
    else if (value[0] == '@')
    {
        // Objects go by themselves.
        if (attributeString.length > 3)
        {
            // We have more details
            return NSClassFromString([attributeString substringWithRange:NSMakeRange(2, attributeString.length - 3)]);
        }
        else
        {
            // id = no detail.
            return Nil;
        }
    }
    else
    {
        // Everything else is contained by NSValue
        return [NSValue class];
    }
}

- (Class)classForKey:(NSString *)key
{
    NSDictionary *classes = [self associatedObjectForSelector:@selector(classForKey:)];
    Class class = NSClassFromString(classes[key]);
    
    if (!class)
    {
        [self setClass:class = [self _detectClassForKey:(key)]
                forkey:key];
    }
    
    return class;
}

- (void)setClass:(Class)class forkey:(NSString *)key
{
    NSMutableDictionary *classes = nil;
    if (!(classes = [self associatedObjectForSelector:@selector(classForKey:)]))
        [self setAssociatedObject:classes = [NSMutableDictionary dictionary]
                      forSelector:@selector(classForKey:)];
    
    NSString *className = NSStringFromClass(class);
    if (className)
        classes[key] = className;
    else
        [classes removeObjectForKey:key];
}

#pragma mark - Weak key handling

- (BOOL)isKeyWeakReference:(NSString *)key
{
    objc_property_t property = class_getProperty([self class], key.UTF8String);
    char *value = property_copyAttributeValue(property, "W");
    if (value)
    {
        free(value);
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Mutable keys

- (BOOL)isKeyMutable:(NSString *)key
{
    NSString *className = NSStringFromClass([self _detectClassForKey:key]);
    return className && [className rangeOfString:@"Mutable"].location != NSNotFound && [className respondsToSelector:@selector(mutableCopyWithZone:)];
}

@end

@implementation NSObject (CGIAssociativeObjects)

- (void)setAssociatedObject:(id)object forSelector:(SEL)selector
{
    objc_setAssociatedObject(self, selector, object, OBJC_ASSOCIATION_RETAIN);
}

- (id)associatedObjectForSelector:(SEL)selector
{
    return objc_getAssociatedObject(self, selector);
}

@end

@implementation NSObject (CGIKeyValueCoding)

- (BOOL)shouldEncodeKey:(NSString *)key
{
    return ![self isKeyWeakReference:key] || self.shouldEncodeWeakReferences;
}

- (BOOL)shouldEncodeWeakReferences
{
    return NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [self init]))
        return nil;
    
    for (NSString *key in self.allKeys)
    {
        if ([self shouldEncodeKey:key])
        {
            id object = [aDecoder decodeObjectOfClass:[self classForKey:key] forKey:key];
            if (object)
            {
                [self setValue:([self isKeyMutable:key]) ? [object mutableCopy] : object forKey:key];
            }
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in self.allKeys)
    {
        if ([self shouldEncodeKey:key])
        {
            id object = [self valueForKey:key];
            [aCoder encodeObject:object forKey:key];
        }
    }
}

@end
