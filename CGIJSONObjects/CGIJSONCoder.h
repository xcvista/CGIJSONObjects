//
//  CGIJSONCoder.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 CGIJSONCoder is a loosely-defined coder that encodes objects both conforming to
 \c NSCoding directly and by proxy through CGIJSONObjects' implmenetation of
 neneric object archiving.
 */
@interface CGIJSONCoder : NSCoder

/// @name Encoding objects

/*!
 Create a JSON-friendly object from an generic object.
 
 @param object The generic object input
 
 @return The JSON-friendly object.
 */
+ (id)JSONObjectFromObject:(id)object;

/*!
 Create an object from an JSON-friendly object.
 
 @param class      Class of the created object(s).
 @param JSONObject The JSON-friendly object.
 
 @return The created object.
 */
+ (id)objectOfClass:(Class)class fromJSONObject:(id)JSONObject;

@end

@interface CGIJSONCoder (CGIJSONData)

/// @name Encoding objects into JSON data

/*!
 Create JSON data from an generic object.
 
 @param object The generic object input
 
 @return The JSON data object.
*/
+ (NSData *)JSONDataFromObject:(id)object;

/*!
 Create an object from JSON data.
 
 @param class      Class of the created object(s).
 @param data       The JSON data object.
 
 @return The created object.
 */
+ (id)objectOfClass:(Class)class fromJSONData:(NSData *)data;

@end
