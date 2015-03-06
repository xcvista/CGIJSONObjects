//
//  CGIJSONRPCTests.m
//  CGIJSONRPCTests
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CGIJSONRPC/CGIJSONRPC.h>

@protocol CGIJSONRPCTestProtocol <NSObject>

- (id)testWithArgument:(id)arg another:(id)arg2;

@end

@interface CGIJSONRPCTestTargetClass : NSObject

@property id d;

@end

@implementation CGIJSONRPCTestTargetClass

@synthesize d = _d;

@end

@interface CGIJSONRPCTests : XCTestCase <CGIJSONConnectionDelegate>

@property CGIJSONConnection<CGIJSONRPCTestProtocol> *connection;

@end

@implementation CGIJSONRPCTests

- (void)setUp
{
    self.connection = (id)[[CGIJSONConnection alloc] initWithProtocol:@protocol(CGIJSONRPCTestProtocol)];
    self.connection.delegate = self;
}

- (void)testCall
{
    CGIJSONRPCTestTargetClass *target = [self.connection testWithArgument:@"1" another:@2];
    XCTAssertEqualObjects(target.d, @YES, @"decoding");
}

- (BOOL)connection:(CGIJSONConnection *)connection shouldSendInvocation:(CGIJSONInvocation *)invocation
{
    NSDictionary *args = @{@"Argument": @"1", @"another": @2};
    XCTAssertEqualObjects(invocation.method, @"test", @"invocation.method");
    XCTAssertEqualObjects(invocation.arguments, args, @"invocation.arguments");
    return YES;
}

- (NSURL *)connection:(CGIJSONConnection *)connection URLForRemoteMethod:(NSString *)method
{
    return [[NSBundle bundleForClass:[self class]] URLForResource:@"test" withExtension:@"json"];
}

- (Class)connection:(CGIJSONConnection *)connection classForRemoteMethod:(NSString *)remoteMethod
{
    XCTAssertEqualObjects(remoteMethod, @"test", "MethodParse");
    return [CGIJSONRPCTestTargetClass class];
}

@end
