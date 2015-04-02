//
//  CGIJSONCoder.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import "CGIJSONCoder.h"
#import "NSObject+CGIKeyValueCoding.h"

@interface CGIJSONCoder ()

@property id JSONObject;

@end

@implementation CGIJSONCoder

+ (id)JSONObjectFromObject:(id)object
{
    if ([object isKindOfClass:[NSArray class]])
    {
        // Arrays: deep enumerating.
        
        NSArray *source = object;
        NSMutableArray *dest = [NSMutableArray arrayWithCapacity:source.count];
        
        for (id sourceObject in source)
        {
            id destObject = [self JSONObjectFromObject:sourceObject];
            [dest addObject:destObject ?: [NSNull null]];
        }
        
        return [dest copy];
    }
    else if ([object isKindOfClass:[NSSet class]])
    {
        // Sets: convert to arrays and deep enumerating
        NSSet *source = object;
        NSMutableArray *dest = [NSMutableArray arrayWithCapacity:source.count];
        
        for (id sourceObject in source)
        {
            id destObject = [self JSONObjectFromObject:sourceObject];
            [dest addObject:destObject ?: [NSNull null]];
        }
        
        return [dest copy];
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        // Dictionaries: deep enumerating.
        
        NSDictionary *source = object;
        NSMutableDictionary *dest = [NSMutableDictionary dictionaryWithCapacity:source.count];
        
        for (id key in source)
        {
            id destObject = [self JSONObjectFromObject:source[key]];
            [dest setObject:destObject ?: [NSNull null] forKey:key];
        }
        
        return [dest copy];
    }
    else if ([object isKindOfClass:[NSString class]] ||
             [object isKindOfClass:[NSNumber class]] ||
             [object isKindOfClass:[NSNull class]])
    {
        // Strings, numbers and null: copy & keep.
        return [object copy];
    }
    else if ([object isKindOfClass:[NSData class]])
    {
        // Data: use Base-64 string.
        
        NSData *source = object;
        return [source base64EncodedDataWithOptions:NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn];
    }
    else if ([object isKindOfClass:[NSDate class]])
    {
        // Date: use milliseconds from UNIX epoch
        NSDate *source = object;
        return @((NSUInteger)([source timeIntervalSince1970] * 1000));
    }
    else
    {
        // Other: let it decide.
        CGIJSONCoder *coder = [[self alloc] init];
        coder.JSONObject = [NSMutableDictionary dictionaryWithCapacity:[object allKeys].count];
        [object encodeWithCoder:coder];
        return coder.JSONObject;
    }
}

+ (id)objectOfClass:(Class)class fromJSONObject:(id)JSONObject
{
    if ([JSONObject isKindOfClass:[NSArray class]])
    {
        if ([class isSubclassOfClass:[NSArray class]])
        {
            // This array ave no determined class, pass it through
            return [JSONObject copy];
        }
        else if ([class isSubclassOfClass:[NSSet class]])
        {
            // This array is converted from a set.
            NSArray *source = JSONObject;
            NSMutableSet *dest = [NSMutableSet setWithCapacity:source.count];
            
            for (id sourceObject in source)
            {
                [dest addObject:sourceObject];
            }
            
            return [dest copy];
        }
        else
        {
            // We have an array of something
            NSArray *source = JSONObject;
            NSMutableArray *dest = [NSMutableArray arrayWithCapacity:source.count];
            
            for (id sourceObject in source)
            {
                [dest addObject:[self objectOfClass:class fromJSONObject:sourceObject]];
            }
            
            return [dest copy];
        }
    }
    else if ([JSONObject isKindOfClass:[NSDictionary class]])
    {
        // Dictionaries: can be an object encoded into this, or an outright dictionary.
        if ([class isSubclassOfClass:[NSDictionary class]])
        {
            // Raw dictionary, pass it through
            return [JSONObject copy];
        }
        else
        {
            // We have something.
            CGIJSONCoder *decoder = [[CGIJSONCoder alloc] init];
            decoder.JSONObject = JSONObject;
            id dest = [[[class alloc] initWithCoder:decoder] awakeAfterUsingCoder:decoder];
            return dest;
        }
    }
    else if ([JSONObject isKindOfClass:[NSString class]] && [class isSubclassOfClass:[NSData class]])
    {
        // Data stored as string
        return [[NSData alloc] initWithBase64EncodedString:JSONObject options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    else if ([JSONObject isKindOfClass:[NSNumber class]] && [class isSubclassOfClass:[NSDate class]])
    {
        // Date stored as number
        return [NSDate dateWithTimeIntervalSince1970:[JSONObject doubleValue] / 1000.0];
    }
    else
    {
        // Everything else is passed on
        return JSONObject;
    }
}

- (BOOL)allowsKeyedCoding
{
    return YES;
}

- (void)encodeObject:(id)objv forKey:(NSString *)key
{
    self.JSONObject[key] = [[self class] JSONObjectFromObject:objv];
}

- (id)decodeObjectOfClass:(Class)aClass forKey:(NSString *)key
{
    return [[self class] objectOfClass:aClass fromJSONObject:self.JSONObject[key]];
}

@end

@implementation CGIJSONCoder (CGIJSONData)

+ (NSData *)JSONDataFromObject:(id)object
{
    return [NSJSONSerialization dataWithJSONObject:[self JSONObjectFromObject:object]
                                           options:0
                                             error:NULL];
}

+ (id)objectOfClass:(Class)class fromJSONData:(NSData *)data
{
    return [self objectOfClass:class
                fromJSONObject:[NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:NULL]];
}

@end
