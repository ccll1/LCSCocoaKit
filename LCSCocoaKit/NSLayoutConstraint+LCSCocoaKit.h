//
//  NSLayoutConstraint+LCSCocoaKit.h
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSLayoutConstraint (LCSCocoaKit)

/**
 *  A convenience method for the lengthy <code>+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c</code>.
 *
 *  - <code>relatedBy</code> is set to <code>NSLayoutRelationEqual</code>.
 *
 *  @return An instance of <code>NSLayoutConstraint</code>.
 */
+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                       equalToItem:(id)view2
                         attribute:(NSLayoutAttribute)attr2
                        multiplier:(CGFloat)multiplier
                          constant:(CGFloat)c;

/**
 *  A convenience method for the lengthy <code>+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c</code>.
 *
 *  - <code>relatedBy</code> is set to <code>NSLayoutRelationEqual</code>.<br/>
 *  - <code>multiplier</code> is set to <code>1.0</code>.<br/>
 *
 *  @return An instance of <code>NSLayoutConstraint</code>.
 */
+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                       equalToItem:(id)view2
                         attribute:(NSLayoutAttribute)attr2
                          constant:(CGFloat)c;

/**
 *  A convenience method for the lengthy <code>+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c</code>.
 *
 *  - <code>relatedBy</code> is set to <code>NSLayoutRelationEqual</code>.<br/>
 *  - <code>view2</code> is set to <code>nil</code>.<br/>
 *  - <code>attr2</code> is set to <code>NSLayoutAttributeNotAnAttribute</code>.<br/>
 *  - <code>multiplier</code> is set to <code>1.0</code>.
 *
 *  @return An instance of <code>NSLayoutConstraint</code>.
 */
+ (instancetype)constraintWithSingleItem:(id)view1
                               attribute:(NSLayoutAttribute)attr1
                                constant:(CGFloat)c;


@end

