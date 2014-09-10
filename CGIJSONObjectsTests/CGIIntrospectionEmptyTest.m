//
//  CGIIntrospectionEmptyTest.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 9/10/14.
//  Copyright (c) 2014 Maxthon Chan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CGIJSONObjects/CGIJSONObjects.h>

@interface CGIIntrospectionEmptyTest : XCTestCase

@end

@implementation CGIIntrospectionEmptyTest

- (void)testKeyDetecting
{
    XCTAssert(self.allKeys.count == 0, @"allKeys.count");
    NSSet *set1 = [NSSet setWithArray:@[]];
    NSSet *set2 = [NSSet setWithArray:self.allKeys];
    XCTAssertEqualObjects(set1, set2, @"allKeys");
}

@end
