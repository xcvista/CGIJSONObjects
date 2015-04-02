//
//  CGIMethodSwizzleTest.m
//  CGIJSONObjects
//
//  Created by Maxthon Chan on 4/2/15.
//  Copyright (c) 2015 DreamCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CGIJSONObjects/CGIJSONObjects.h>

@interface CGIMethodSwizzleTest : XCTestCase

@end

@implementation CGIMethodSwizzleTest

- (int)one
{
    return 1;
}

- (int)two
{
    return 2;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swapImplementationOfInstanceMethodSelector:@selector(one) withSelector:@selector(two)];
    });
}

- (void)testSwappedMethods
{
    XCTAssertEqual([self one], 2, @"Swapped one");
    XCTAssertEqual([self two], 1, @"Swapped two");
}


@end
