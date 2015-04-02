//
//  CGIJSONCodingTest.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 7/3/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CGIJSONObjects/CGIJSONObjects.h>

@interface CGIJSONCodingTestTarget : NSObject

@property NSString *string;
@property int number;

@end

@implementation CGIJSONCodingTestTarget

@end

@interface CGIJSONCodingTest : XCTestCase

@end

@implementation CGIJSONCodingTest

- (void)testObjectCoding
{
    CGIJSONCodingTestTarget *source = [[CGIJSONCodingTestTarget alloc] init];
    source.string = @"source";
    source.number = 42;
    
    id target = [CGIJSONCoder JSONObjectFromObject:source];
    id targetVerify = @{@"string": @"source",
                        @"number": @42};
    
    XCTAssertEqualObjects(target, targetVerify, @"encoding");
}

- (void)testObjectDecoding
{
    id source = @{@"string": @"dest",
                  @"number": @21};
    CGIJSONCodingTestTarget *target = [CGIJSONCoder objectOfClass:[CGIJSONCodingTestTarget class] fromJSONObject:source];
    
    XCTAssertEqualObjects(target.string, @"dest", @"decoding.string");
    XCTAssertEqual(target.number, 21, @"dest.number");
}

- (void)testArrayCoding
{
    id source = @[@"1", @"2", @"3"];
    id target = [CGIJSONCoder JSONObjectFromObject:source];
    
    XCTAssertEqualObjects(source, target, @"encoding.stringArray");
}

- (void)testArrayDecoding
{
    id source = @[@"1", @"2", @"3"];
    id target = [CGIJSONCoder objectOfClass:[NSString class]
                             fromJSONObject:source];
    
    XCTAssertEqualObjects(source, target, @"decoding.stringArray");
}

@end
