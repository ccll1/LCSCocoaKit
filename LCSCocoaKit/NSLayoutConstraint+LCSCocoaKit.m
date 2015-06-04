//
//  NSLayoutConstraint+LCSCocoaKit.m
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
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

//- (BOOL)isEqual:(id)other
//{
//    if (other == self) {
//        return YES;
//    } else if (![self isMemberOfClass:[other class]]) {
//        return NO;
//    } else {
//        NSLayoutConstraint *otherConstraint = other;
//        return (self.constant == otherConstraint.constant &&
//                self.multiplier == otherConstraint.multiplier &&
//                self.relation == otherConstraint.relation &&
//                self.firstAttribute == otherConstraint.firstAttribute &&
//                self.firstItem == otherConstraint.firstItem &&
//                self.secondAttribute == otherConstraint.secondAttribute &&
//                self.secondItem == otherConstraint.secondItem);
//    }
//}

@end
