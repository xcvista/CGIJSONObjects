//
//  CGIServer.h
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Protocol;
@class CGIJSONInvocation;

@protocol CGIJSONConnectionDelegate;

@interface CGIJSONConnection : NSObject

@property Protocol *remoteProtocol;
@property (copy) NSString *serverRoot;
@property (weak) id<CGIJSONConnectionDelegate> delegate;

- (instancetype)initWithProtocol:(Protocol *)protocol;
- (void)sendInvocation:(CGIJSONInvocation *)invocation;

- (Class)classForRemoteMethod:(NSString *)remoteMethod;
- (NSURL *)URLForRemoteMethod:(NSString *)method;

- (BOOL)shouldSendInvocation:(CGIJSONInvocation *)invocation;
- (void)didSendInvocation:(CGIJSONInvocation *)invocation;

- (BOOL)shouldSendRequest:(NSMutableURLRequest *)request;
- (void)didSendRequest:(NSURLRequest *)request;

- (void)didReceiveData:(NSData *)data response:(NSHTTPURLResponse *)response;
- (void)didFailWithError:(NSError *)error;

@end

@protocol CGIJSONConnectionDelegate <NSObject>

@optional
- (Class)connection:(CGIJSONConnection *)connection classForRemoteMethod:(NSString *)remoteMethod;
- (NSURL *)connection:(CGIJSONConnection *)connection URLForRemoteMethod:(NSString *)method;

- (BOOL)connection:(CGIJSONConnection *)connection shouldSendInvocation:(CGIJSONInvocation *)invocation;
- (void)connection:(CGIJSONConnection *)connection didSendInvocation:(CGIJSONInvocation *)invocation;

- (BOOL)connection:(CGIJSONConnection *)connection shouldSendRequest:(NSMutableURLRequest *)request;
- (void)connection:(CGIJSONConnection *)connection didSendRequest:(NSURLRequest *)request;

- (void)connection:(CGIJSONConnection *)connection didReceiveData:(NSData *)data response:(NSHTTPURLResponse *)response;
- (void)connection:(CGIJSONConnection *)connection didFailWithError:(NSError *)error;

@end