//
//  CGIServer.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import "CGIJSONConnection.h"

#import "CGIJSONInvocation.h"

#import <objc/runtime.h>
#import <CGIJSONObjects/CGIJSONObjects.h>

@implementation CGIJSONConnection

- (instancetype)initWithProtocol:(Protocol *)protocol
{
    if (!(self = [super init]))
        return nil;
    
    self.remoteProtocol = protocol;
    
    return self;
}

- (void)sendInvocation:(CGIJSONInvocation *)invocation
{
    if (![self shouldSendInvocation:invocation])
        return;
    
    NSError *err = nil;
    
    NSURL *URL = [self URLForRemoteMethod:invocation.method];
    if (!URL)
        return;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSData *requesrBody = invocation.arguments ? [NSJSONSerialization dataWithJSONObject:invocation.arguments
                                                                          options:0
                                                                            error:&err] : nil;
    if (!requesrBody && invocation.arguments)
    {
        [self didFailWithError:err];
        return;
    }
    
    if (requesrBody)
    {
        request.HTTPMethod = @"POST";
        request.HTTPBody = requesrBody;
    }
    
    if (![self shouldSendRequest:request])
        return;
    
    err = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseBody = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&err];
    
    [self didSendRequest:request];
    
    if (!responseBody)
    {
        [self didFailWithError:err];
        return;
    }
    
    [self didReceiveData:responseBody response:response];
    
    err = nil;
    id decoded = [NSJSONSerialization JSONObjectWithData:responseBody
                                                 options:0
                                                   error:&err];
    if (!decoded)
    {
        [self didFailWithError:err];
        return;
    }
    
    Class responseClass = [self classForRemoteMethod:invocation.method];
    if (responseClass)
    {
        // We have a class.
        invocation.returnValue = [CGIJSONCoder objectOfClass:responseClass
                                              fromJSONObject:decoded] ?: decoded;
    }
    else
    {
        invocation.returnValue = decoded;
    }
    
    [self didSendInvocation:invocation];
}

#pragma mark - Method forwarding.

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    struct objc_method_description methodDescription = protocol_getMethodDescription(self.remoteProtocol,
                                                                                     aSelector,
                                                                                     YES,
                                                                                     YES);
    if (!sel_isEqual(aSelector, methodDescription.name))
        return nil;
    
    return [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    CGIJSONInvocation *invocation = [[CGIJSONInvocation alloc] initWithInvocation:anInvocation];
    if (!invocation)
        return;
    
    [self sendInvocation:invocation];
    
    if (invocation.returnValue)
    {
        CFTypeRef rv = CFRetain((__bridge CFTypeRef)invocation.returnValue);
        [anInvocation setReturnValue:&rv];
    }
}

#pragma mark - Delegate stubs

- (Class)classForRemoteMethod:(NSString *)remoteMethod
{
    return [self.delegate respondsToSelector:@selector(connection:classForRemoteMethod:)] ?
    [self.delegate connection:self classForRemoteMethod:remoteMethod] :
    Nil;
}

- (NSURL *)URLForRemoteMethod:(NSString *)method
{
    if ([self.delegate respondsToSelector:@selector(connection:URLForRemoteMethod:)])
        return [self.delegate connection:self URLForRemoteMethod:method];
    else
    {
        // Delegate is not declaring a method name, so we have to derive it ourselves.
        NSString *urlString = [self.serverRoot stringByReplacingOccurrencesOfString:@"%@" withString:method];
        return [NSURL URLWithString:urlString];
    }
}

- (BOOL)shouldSendInvocation:(CGIJSONInvocation *)invocation
{
    return [self.delegate respondsToSelector:@selector(connection:shouldSendInvocation:)] ?
    [self.delegate connection:self shouldSendInvocation:invocation] :
    YES;
}

- (void)didSendInvocation:(CGIJSONInvocation *)invocation
{
    if ([self.delegate respondsToSelector:@selector(connection:didSendInvocation:)])
        [self.delegate connection:self didSendInvocation:invocation];
}

- (BOOL)shouldSendRequest:(NSMutableURLRequest *)request
{
    return [self.delegate respondsToSelector:@selector(connection:shouldSendRequest:)] ?
    [self.delegate connection:self shouldSendRequest:request] :
    YES;
}

- (void)didSendRequest:(NSURLRequest *)request
{
    if ([self.delegate respondsToSelector:@selector(connection:didSendRequest:)])
        [self.delegate connection:self didSendRequest:request];
}

- (void)didReceiveData:(NSData *)data response:(NSHTTPURLResponse *)response
{
    if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:response:)])
        [self.delegate connection:self didReceiveData:data response:response];
}

- (void)didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(connection:didFailWithError:)])
        [self.delegate connection:self didFailWithError:error];
}

@end
