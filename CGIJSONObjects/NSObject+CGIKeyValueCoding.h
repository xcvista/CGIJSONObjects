//
//  NSObject+CGIKeyValueDetection.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 4/2/15.
//  Copyright (c) 2015 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CGIKeyValueDetection)

/// @name Key-Value Detection

/*!
 All available keys of the class, as detected using property introspection. Any
 properties declared by superclasses are not included.
 
 You can override this property to add or remove keys.
 
 @availability Available in CGIJSONObjects version 6 and later.
 
 @see \c class_copyPropertyList()
 */
@property (readonly, copy) NSArray *allKeys;

/*!
 Set the class of a key.
 
 Use this method to override default key class detection behavior that is based
 on property introspection. This is useful when a key is an array of objects, by
 setting the class of the key to the class of its member, array decodong can be
 made easier.
 
 By setting the class of a key to <tt>Nil</tt>, you revert its class to its
 default value instead of preventing the class to be encoded. To prevent a key
 from being encoded, override \c -shouldEncodeKey: instead.
 
 @param class Class of the key.
 @param key   Key whose class is to be set.
 
 @availability Available in CGIJSONObjects version 8 and later.
 
 @note Before CGIJSONObjects version 8, a different property class overriding
 mechanism was used that was not compatible with Swift language.
 */
- (void)setClass:(Class)class forkey:(NSString *)key;

/*!
 Get the class of a key.
 
 @param key The key whose class is to be determined.
 
 @return Class of the key.
 
 @availability Available in CGIJSONObjects version 6 and later.
 
 @note Before CGIJSONObjects version 8, this method have a different semantics.
 The old sementics is not available if \c -setClass:forKey is used.
 */
- (Class)classForKey:(NSString *)key;

/*!
 Determine whether a key is a weak reference.
 
 @param key The key to be determined.
 
 @return Whether a key is a weak reference.
 
 @availability Available in CGIJSONObjects version 7 and later.
 */
- (BOOL)isKeyWeakReference:(NSString *)key;

/*!
 Determine whether a key maps to a mutable container type.
 
 @note This method ignores classes set using \c -setClass:forKey: and takes the
 class of the underlying property directly. It is used to determine whether a
 container type should be made mutable before setting to the object.
 
 @param key The key to be determined.
 
 @return Whether a key maps to a mutable container type.
 
 @availability Available in CGIJSONObjects version 7 and later.
 */
- (BOOL)isKeyMutable:(NSString *)key;

@end

@interface NSObject (CGIAssociativeObjects)

/// @name Associated objects

/*!
 Set an associated object to the object.
 
 This method calls \c objc_setAssociatedObject() and uses association policy \c
 OBJC_ASSOCIATION_RETAIN, which is equivalent to a default property declaration.
 
 The use of a selector as a key took advantage of the selector's guarantee of
 being constnat and unique during each run of the application. When implementing
 a category property, use the selector of the getter for the property as the
 selector.
 
 @param object   The object to be associated.
 @param selector Association key.
 
 @see \c objc_setAssociatedObject()
 
 @availability Available in CGIJSONObjects version 8 and later.
 */
- (void)setAssociatedObject:(id)object forSelector:(SEL)selector;

/*!
 Set an associated object to the object.
 
 This method calls \c objc_getAssociatedObject().
 
 The use of a selector as a key took advantage of the selector's guarantee of
 being constnat and unique during each run of the application. When implementing
 a category property, use the selector of the getter for the property as the
 selector.
 
 @param selector Association key.
 
 @return The associated object of the key.
 
 @see \c objc_getAssociatedObject()
 
 @availability Available in CGIJSONObjects version 8 and later.
 */
- (id)associatedObjectForSelector:(SEL)selector;

@end

@interface NSObject (CGIKeyValueCoding)

/// @name Weak key encoding.

/*!
 Determines whether a key should be encoded or not.
 
 Override this method to prevent a key from beign encoded.
 
 @param key The key to be determined.
 
 @return Whether a key should be encoded.
 
 @availability Available in CGIJSONObjects version 7 and later.
 */
- (BOOL)shouldEncodeKey:(NSString *)key;

/*!
 Determines whether weak references should be encoded or not.
 
 The weak reference semantics usually represents references the object need to
 use but not own, so by default weak references are not encoded. However in some
 scenerio like nib loading such references are necessary. Override this property
 to reflect this when needed.
 
 @availability Available in CGIJSONObjects version 7 and later.
 */
@property (readonly, assign) BOOL shouldEncodeWeakReferences;

/// @name Object encoding.

/*!
 Decodes the object using key-value coding information from \c allKeys property
 and \c -classForKey: method.
 
 @param aDecoder A key-value coder in which information is stored.
 
 @return The decoded object.
 
 @availability Available in CGIJSONObjects version 7 and later.
 
 @see \c NSCoding
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

/*!
 Encodes the object using key-value coding information from \c allKeys property.
 
 @param aCoder A key-value coder to which information is stored.
 
 @availability Available in CGIJSONObjects version 7 and later.
 
 @see \c NSCoding
 */
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
