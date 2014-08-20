//
//  NSBezierPath+LCSCocoaKit.h
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

@interface NSBezierPath (LCSCocoaKit)

+ (NSBezierPath*)pathWithPoints:(NSArray*)points closed:(BOOL)closed;

/**
 *  Creates and returns a new instance of <code>NSBezierPath</code> where all curved segments are just straight lines.
 *
 *  @return A new path with only straigt segments.
 */
- (NSBezierPath*)pathWithStraightSegements;

/**
 *  Creates paths for the receiver's control points as seen in most graphic applications. The two paths are returned by reference.
 *
 *  @param controlPoints1Path On return, contains a path with straigt lines between each point of a curved segment and the respective control point 1.
 *  @param controlPoints2Path On return, contains a path with straigt lines between each point of a curved segment and the respective control point 2.
 */
- (void)controlPointsPathCp1:(NSBezierPath **)controlPoints1Path cp2:(NSBezierPath **)controlPoints2Path;

/**
 *  Creates and returns a new instance of <code>NSBezierPath</code> where all curved segments of the receiver are approximated into straight line segments with the given maximum length.
 *
 *  The returned path will only consist of straigt lines. Any curved segment of the receiver will be converted into a series of straigt segments, where each segment is guaranteed have a length less or equal than <code>maxLineLength</code> and greater than <code>maxLineLength / 2.0 </code>.
 *
 *  @param maxLineLength The maximum length of approximated curved segments. Must be greater than <code>0.0</code>.
 *
 *  @return A new path with only straight segments.
 */
- (NSBezierPath*)approximatePathWithMaxLineLength:(CGFloat)maxLineLength;

/**
 *  Creates and returns a Core Graphics representation of the receiver.
 */
@property (nonatomic,readonly) CGPathRef CGPath;

/**
 *  Returns an array of CGPoints making up all the "corner" points of the receiver, that is, without any control points.
 */
@property (nonatomic,readonly) NSArray *allPoints;

/**
 *  Tests two paths for equality. The paths are only equal if they have equal element count and equal elements. Other path properties, like line width, winding rule and so on are not tested.
 *
 *  @param anObject Another instance of NSBezierPath
 *
 *  @return YES if the two objects have equal path elements, NO otherwise.
 */
- (BOOL)isEqual:(id)anObject;

@end
