//
//  CGIIntrospectionSerialization.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import "CGIIntrospectionSerialization.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (CGIIntrospectionSerialization)

- (NSArray *)allKeys
{
    unsigned propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:propertyCount];
    
    for (NSUInteger idx = 0; idx < propertyCount; idx++)
    {
        objc_property_t property = properties[idx];
        [propertyNames addObject:@(property_getName(property))];
    }
    
    free(properties);
    return [propertyNames copy];
}

- (SEL)_overrideSelectorForKey:(NSString *)key
{
    SEL overrideSelector = NSSelectorFromString([NSString stringWithFormat:@"__classForKey%@", key]);
    return [self respondsToSelector:overrideSelector] ? overrideSelector : NULL;
}

- (Class)_overrideClassForKey:(NSString *)key
{
    SEL overrideSelector = [self _overrideSelectorForKey:key];
    if (overrideSelector)
    {
        // Cast objc_msgSend before using.
        Class (*objc_msgSend_Class)(id, SEL) = (void *)objc_msgSend;
        return objc_msgSend_Class(self, overrideSelector);
    }
    else
    {
        return Nil;
    }
}

- (Class)_propertyClassForKey:(NSString *)key
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
    // Check if there is a forced override
    SEL overrideSelector = [self _overrideSelectorForKey:key];
    if (overrideSelector)
    {
        return [self _overrideClassForKey:key];
    }
    else
    {
        return [self _propertyClassForKey:key];
    }
}

- (BOOL)isKeyMutable:(NSString *)key
{
    NSString *className = NSStringFromClass([self _propertyClassForKey:key]);
    return className && [className rangeOfString:@"Mutable" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound;
}

- (BOOL)shouldEncodeKey:(NSString *)key
{
    SEL overrideSelector = [self _overrideSelectorForKey:key];
    BOOL isBlocked = (!overrideSelector || [self _overrideClassForKey:key] != Nil);
    if ([self isKeyWeakReference:key])
    {
        return isBlocked && [self shouldEncodeWeakReferences];
    }
    else
    {
        return isBlocked;
    }
}

- (BOOL)shouldEncodeWeakReferences
{
    return NO;
}

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

#pragma mark - NSCoding (abused)

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
