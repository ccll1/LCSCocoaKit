//
//  NSBezierPath+LCSCocoaKit_Tests.m
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 16.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSBezierPath+LCSCocoaKit.h"

@interface NSBezierPath_LCSCocoaKit_Tests : XCTestCase

@end

@implementation NSBezierPath_LCSCocoaKit_Tests

- (void)testPathWithPoints
{
    NSArray *points = @[[NSValue valueWithPoint:NSMakePoint(0.0, 0.0)],
                        [NSValue valueWithPoint:NSMakePoint(5.0, 0.0)],
                        [NSValue valueWithPoint:NSMakePoint(5.0, 5.0)],
                        [NSValue valueWithPoint:NSMakePoint(0.0, 5.0)]
                        ];
    
    NSBezierPath *path = [NSBezierPath pathWithPoints:points closed:NO];
    
    XCTAssertNotNil(path);
    XCTAssertEqual(path.elementCount, 4);
    
    NSArray *reversedPoints = path.allPoints;
    
    XCTAssertEqualObjects(points, reversedPoints);
}

- (void)testIsEqual
{
    NSBezierPath *pathA;
    NSBezierPath *pathB;
    
    pathA = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0.0, 0.0, 100.0, 100.0)];
    pathB = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0.0, 0.0, 50.0, 50.0)];
    
    XCTAssertNotEqualObjects(pathA, pathB);

    pathA = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0.0, 0.0, 100.0, 100.0)];
    pathB = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0.0, 0.0, 100.0, 100.0)];

    XCTAssertEqualObjects(pathA, pathB);

    pathA.lineWidth = 1.0;
    pathB.lineWidth = 2.0;
    
    XCTAssertEqualObjects(pathA, pathB);
}

- (void)testApproximatePathWithMaxLineLength
{
    NSBezierPath *path;
    NSBezierPath *approximatedPath;
    path = [NSBezierPath bezierPathWithRect:NSMakeRect(0.0, 0.0, 100.0, 100.0)];
    
    approximatedPath = [path approximatePathWithMaxLineLength:0.1];
    
    XCTAssertEqualObjects(path, approximatedPath);
}

@end
