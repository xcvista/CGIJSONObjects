//
//  CGIIntrospectionTest.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CGIJSONObjects/CGIJSONObjects.h>

@interface CGIIntrospectionTest : XCTestCase

@property (weak) id object;
@property int number;
@property NSString *string;
@property NSArray *array;

@end

@implementation CGIIntrospectionTest

- (void)setUp
{
    [super setUp];
    
    [self setClass:[NSNull class] forkey:@"array"];
}

- (void)testKeyDetecting
{
    XCTAssert(self.allKeys.count == 4, @"allKeys.count");
    NSSet *set1 = [NSSet setWithArray:@[@"object", @"number", @"string", @"array"]];
    NSSet *set2 = [NSSet setWithArray:self.allKeys];
    XCTAssertEqualObjects(set1, set2, @"allKeys");
}

- (void)testKeyClassDetecting
{
    XCTAssertEqual([self classForKey:@"object"], (Class)Nil, @"classForKey:id");
    XCTAssertEqual([self classForKey:@"number"], [NSNumber class], @"classForKey:int");
    XCTAssertEqual([self classForKey:@"string"], [NSString class], @"classForKey:string");
    XCTAssertEqual([self classForKey:@"array"], [NSNull class], @"classForKey:array (override)");
}

- (void)testKeyWeakness
{
    XCTAssertEqual([self isKeyWeakReference:@"object"], YES, @"isWeak:object");
    XCTAssertEqual([self isKeyWeakReference:@"string"], NO, @"isWeak:string");
    XCTAssertEqual([self shouldEncodeKey:@"object"], NO, @"shouldEncode:object");
    XCTAssertEqual([self shouldEncodeKey:@"string"], YES, @"shouldEncode:string");
}

@end
