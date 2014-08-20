//
//  NSLayoutConstraint+LCSCocoaKit_Tests.m
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 16.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSLayoutConstraint+LCSCocoaKit.h"

@interface NSLayoutConstraint_LCSCocoaKit_Tests : XCTestCase

@end

@implementation NSLayoutConstraint_LCSCocoaKit_Tests

- (void)testIsEqual
{
    NSView *viewA = [NSView new];
    NSView *viewB = [NSView new];

    NSLayoutConstraint *constraintA;
    NSLayoutConstraint *constraintB;
    
    constraintA = [NSLayoutConstraint constraintWithItem:viewA
                                               attribute:NSLayoutAttributeWidth
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:viewB
                                               attribute:NSLayoutAttributeWidth
                                              multiplier:1.0
                                                constant:200.0];
    constraintB = [NSLayoutConstraint constraintWithItem:viewA
                                               attribute:NSLayoutAttributeWidth
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:viewB
                                               attribute:NSLayoutAttributeWidth
                                              multiplier:1.0
                                                constant:200.0];
    
    XCTAssertEqualObjects(constraintA, constraintB);
    
    constraintA = [NSLayoutConstraint constraintWithItem:viewA
                                               attribute:NSLayoutAttributeWidth
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1.0
                                                constant:200.0];
    constraintB = [NSLayoutConstraint constraintWithItem:viewA
                                               attribute:NSLayoutAttributeWidth
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1.0
                                                constant:200.0];
    
    XCTAssertEqualObjects(constraintA, constraintB);
    
    constraintA = [NSLayoutConstraint constraintWithItem:viewA
                                               attribute:NSLayoutAttributeWidth
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1.0
                                                constant:20000000000.0];
    constraintB = [NSLayoutConstraint constraintWithItem:viewA
                                               attribute:NSLayoutAttributeWidth
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1.0
                                                constant:200.0];
    
    XCTAssertNotEqualObjects(constraintA, constraintB);
}

- (void)testSimpleInitializers
{
    NSView *viewA = [NSView new];
    NSView *viewB = [NSView new];
    
    NSLayoutConstraint *constraintSimple;
    NSLayoutConstraint *constraintOriginal;
    
    constraintSimple = [NSLayoutConstraint constraintWithSingleItem:viewA
                                                          attribute:NSLayoutAttributeWidth
                                                           constant:200.0];
    constraintOriginal = [NSLayoutConstraint constraintWithItem:viewA
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:200.0];
    
    XCTAssertEqualObjects(constraintSimple, constraintOriginal);
    
    constraintSimple = [NSLayoutConstraint constraintWithItem:viewA
                                                    attribute:NSLayoutAttributeLeading
                                                  equalToItem:viewB
                                                    attribute:NSLayoutAttributeLeading
                                                     constant:100.0];
    constraintOriginal = [NSLayoutConstraint constraintWithItem:viewA
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:viewB
                                                      attribute:NSLayoutAttributeLeading
                                                     multiplier:1.0
                                                       constant:100.0];
    
    XCTAssertEqualObjects(constraintSimple, constraintOriginal);
    
    constraintSimple = [NSLayoutConstraint constraintWithItem:viewA
                                                    attribute:NSLayoutAttributeTrailing
                                                  equalToItem:viewB
                                                    attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                     constant:100.0];
    constraintOriginal = [NSLayoutConstraint constraintWithItem:viewA
                                                      attribute:NSLayoutAttributeTrailing
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:viewB
                                                      attribute:NSLayoutAttributeTrailing
                                                     multiplier:1.0
                                                       constant:100.0];
    
    XCTAssertEqualObjects(constraintSimple, constraintOriginal);
}

@end
