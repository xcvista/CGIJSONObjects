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

/*!
 CGIJSONConnection governs automatic remote method calling.
 */
@interface CGIJSONConnection : NSObject

/*!
 The protocol from which access interface is taken.
 */
@property Protocol *remoteProtocol;

/*!
 Format of the remote address.
 */
@property (copy) NSString *serverRoot;

/*!
 Delegate of the connection.
 */
@property (weak) id<CGIJSONConnectionDelegate> delegate;

/*!
 Initialize the connection with a remote protocol.
 
 @param protocol The remote protocol.
 
 @return The newly initialized CGIJSONConnection object.
 */
- (instancetype)initWithProtocol:(Protocol *)protocol;

/*!
 Send an invocation to the server.
 
 @param invocation The invocation to be sent.
 */
- (void)sendInvocation:(CGIJSONInvocation *)invocation;

/// @name Delegate methods

- (Class)classForRemoteMethod:(NSString *)remoteMethod;
- (NSURL *)URLForRemoteMethod:(NSString *)method;

- (BOOL)shouldSendInvocation:(CGIJSONInvocation *)invocation;
- (void)didSendInvocation:(CGIJSONInvocation *)invocation;

- (BOOL)shouldSendRequest:(NSMutableURLRequest *)request;
- (void)didSendRequest:(NSURLRequest *)request;

- (void)didReceiveData:(NSData *)data response:(NSHTTPURLResponse *)response;
- (BOOL)shouldFailWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError **)error;
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
- (BOOL)connection:(CGIJSONConnection *)connection shouldFailWithData:(NSData *)data response:(NSHTTPURLResponse *)response error:(NSError **)error;
- (void)connection:(CGIJSONConnection *)connection didFailWithError:(NSError *)error;

@end