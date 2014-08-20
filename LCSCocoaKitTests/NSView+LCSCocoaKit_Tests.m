//
//  NSView+LCSCocoaKit_Tests.m
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 16.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSView+LCSCocoaKit.h"

@interface NSView_LCSCocoaKit_Tests : XCTestCase

@end

@implementation NSView_LCSCocoaKit_Tests

- (void)testSubviewWithIdentifier
{
    NSView *viewA = [NSView new];
    viewA.identifier = @"viewA";
    
    NSView *viewB = [NSView new];
    viewB.identifier = @"viewB";
    
    NSView *viewC = [NSView new];
    viewC.identifier = @"viewC";
    
    NSView *viewD = [NSView new];
    viewD.identifier = @"viewD";
    
    NSView *viewE = [NSView new];
    viewE.identifier = @"viewE";
    
    [viewA addSubview:viewB];
    [viewA addSubview:viewC];
    
    [viewB addSubview:viewD];
    [viewC addSubview:viewE];
    
    XCTAssertEqual([viewA subviewWithIdentifier:@"viewB"], viewB);
    XCTAssertEqual([viewA subviewWithIdentifier:@"viewC"], viewC);
    XCTAssertEqual([viewA subviewWithIdentifier:@"viewD"], viewD);
    XCTAssertEqual([viewA subviewWithIdentifier:@"viewE"], viewE);

    XCTAssertEqual([viewB subviewWithIdentifier:@"viewD"], viewD);
    XCTAssertEqual([viewC subviewWithIdentifier:@"viewE"], viewE);
    
    XCTAssertNil([viewB subviewWithIdentifier:@"viewE"]);
    XCTAssertNil([viewC subviewWithIdentifier:@"viewD"]);
    
    XCTAssertNil([viewA subviewWithIdentifier:@"non-existant view"]);
    XCTAssertNil([viewA subviewWithIdentifier:@""]);
    XCTAssertNil([viewA subviewWithIdentifier:nil]);
}

@end
