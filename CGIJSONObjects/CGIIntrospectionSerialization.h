//
//  CGIIntrospectionSerialization.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define CGIClassForKey(_key, _class) \
- (Class)__classForKey ##_key \
{ \
    return objc_getClass(#_class); \
}

#define CGINoEncodingKey(_key) \
- (Class)__classForKey ##_key \
{ \
    return Nil; \
}

@interface NSObject (CGIIntrospectionSerialization)

//! All keys defined in this class.
@property (readonly, copy) NSArray *allKeys;

//! Class for a given key.
- (Class)classForKey:(NSString *)key;

//! Whether a key should be encoded.
- (BOOL)shouldEncodeKey:(NSString *)key;

@property (readonly, assign) BOOL shouldEncodeWeakReferences;

- (BOOL)isKeyWeakReference:(NSString *)key;

- (BOOL)isKeyMutable:(NSString *)key;

//! @name NSCoding methods

// They are declared here because we do support them (in some way),
// But we don't declare us conforming to the protocol
// because in reality only a subset of features are used
// and they are abused.

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
