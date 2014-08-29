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

- (void)testCoding
{
    CGIJSONCodingTestTarget *source = [[CGIJSONCodingTestTarget alloc] init];
    source.string = @"source";
    source.number = 42;
    
    id target = [CGIJSONCoder JSONObjectFromObject:source];
    id targetVerify = @{@"string": @"source",
                        @"number": @42};
    
    XCTAssertEqualObjects(target, targetVerify, @"encoding");
}

- (void)testDecoding
{
    id source = @{@"string": @"dest",
                  @"number": @21};
    CGIJSONCodingTestTarget *target = [CGIJSONCoder objectOfClass:[CGIJSONCodingTestTarget class] fromJSONObject:source];
    
    XCTAssertEqualObjects(target.string, @"dest", @"decoding.string");
    XCTAssertEqual(target.number, 21, @"dest.number");
}

@end
