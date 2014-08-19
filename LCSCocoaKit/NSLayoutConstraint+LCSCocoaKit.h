//
//  NSLayoutConstraint+SimpleInitializers.h
//  Stack
//
//  Created by Christoph Lauterbach on 30.07.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSLayoutConstraint (LCSCocoaKit)

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                       equalToItem:(id)view2
                         attribute:(NSLayoutAttribute)attr2
                        multiplier:(CGFloat)multiplier
                          constant:(CGFloat)c;

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                       equalToItem:(id)view2
                         attribute:(NSLayoutAttribute)attr2
                          constant:(CGFloat)c;

+ (instancetype)constraintWithSingleItem:(id)view1
                               attribute:(NSLayoutAttribute)attr1
                                constant:(CGFloat)c;


@end

