//
//  NSLayoutConstraint+SimpleInitializers.m
//  Stack
//
//  Created by Christoph Lauterbach on 30.07.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "NSLayoutConstraint+LCSCocoaKit.h"

@implementation NSLayoutConstraint (LCSCocoaKit)

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                       equalToItem:(id)view2
                         attribute:(NSLayoutAttribute)attr2
                        multiplier:(CGFloat)multiplier
                          constant:(CGFloat)c
{
    return [[self class] constraintWithItem:view1
                                  attribute:attr1
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view2
                                  attribute:attr2
                                 multiplier:multiplier
                                   constant:c];
}

+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                       equalToItem:(id)view2
                         attribute:(NSLayoutAttribute)attr2
                          constant:(CGFloat)c
{
    return [[self class] constraintWithItem:view1
                                  attribute:attr1
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:view2
                                  attribute:attr2
                                 multiplier:1.0
                                   constant:c];
}

+ (instancetype)constraintWithSingleItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                          constant:(CGFloat)c;
{
    return [[self class] constraintWithItem:view1
                                  attribute:attr1
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0
                                   constant:c];
}
@end
