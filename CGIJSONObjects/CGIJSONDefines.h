//
//  CGIJSONDefines.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 4/2/15.
//  Copyright (c) 2015 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdarg.h>

FOUNDATION_STATIC_INLINE NS_FORMAT_FUNCTION(1, 2)
/*!
 Returns an \c NSString object initialized by using a given format string as a
 template into which the remaining argument values are substituted according to
 the current locale.
 
 Invokes <tt>-[NSString initWithString:]</tt> internally.
 
 @param format Format string.
 @param ...    Arguments.
 
 @return An \c NSString object initialized by using format as a template into
 which the values in the arguments are substituted according to the current
 locale.
 
 @note This function was part of the now-disgraced MSToolbox project.
 
 @see <tt>-[NSString initWithString:]</tt>
 
 @availability Available in CGIJSONObjects versions 2-5, version 8 and later.
 */
NSString *CGISTR(NSString *format, ...)
{
    if (!format)
        return nil;
    
    va_list args;
    va_start(args, format);
    NSString *value = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    return value;
}

