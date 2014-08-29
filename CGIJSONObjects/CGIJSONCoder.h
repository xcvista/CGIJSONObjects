//
//  CGIJSONCoder.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGIJSONCoder : NSCoder

+ (id)JSONObjectFromObject:(id)object;
+ (id)objectOfClass:(Class)class fromJSONObject:(id)JSONObject;

@end

@interface CGIJSONCoder (CGIJSONData)

+ (NSData *)JSONDataFromObject:(id)object;
+ (id)objectOfClass:(Class)class fromJSONData:(NSData *)data;

@end
