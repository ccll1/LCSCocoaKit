//
//  NSUserDefaults+LCSCocoaKit_Tests.m
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 16.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSUserDefaults+LCSCocoaKit.h"

@interface NSUserDefaults_LCSCocoaKit_Tests : XCTestCase

@end

@implementation NSUserDefaults_LCSCocoaKit_Tests

- (void)testColor
{
    NSColor *color;
    NSColor *fetchedColor;
    
    color = [NSColor redColor];
    
    [[NSUserDefaults standardUserDefaults] setColor:color forKey:@"color"];
    fetchedColor = [[NSUserDefaults standardUserDefaults] colorForKey:@"color"];
    
    XCTAssertEqualObjects(color, fetchedColor);
    
    [[NSUserDefaults standardUserDefaults] setColor:nil forKey:@"color"];
    fetchedColor = [[NSUserDefaults standardUserDefaults] colorForKey:@"color"];
    
    XCTAssertEqualObjects(nil, fetchedColor);
}

@end
