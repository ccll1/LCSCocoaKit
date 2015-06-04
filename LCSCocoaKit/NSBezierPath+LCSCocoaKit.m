//
//  NSBezierPath+LCSCocoaKit.m
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "NSBezierPath+LCSCocoaKit.h"

//#import <LCSFoundationKit/CGGeometry_LCSFoundationKit.h>

@implementation NSBezierPath (LCSCocoaKit)

+ (NSBezierPath*)pathWithPoints:(NSArray*)points closed:(BOOL)closed
{
    NSBezierPath *path = [NSBezierPath new];
    
    NSPoint firstPoint = [points.firstObject pointValue];
    [path moveToPoint:firstPoint];
    
    for (NSUInteger i = 1; i < points.count; i++) {
        NSPoint point = [points[i] pointValue];
        [path lineToPoint:point];
    }
    
    if (closed) {
        [path closePath];
    }
    
    return path;
}

- (NSBezierPath*)pathWithStraightSegements
{
    NSArray *points = self.allPoints;
    
    return [NSBezierPath pathWithPoints:points closed:NO];
}

- (void)controlPointsPathCp1:(NSBezierPath **)controlPoints1Path cp2:(NSBezierPath **)controlPoints2Path
{
    NSBezierPath *cp1s = [NSBezierPath new];
    NSBezierPath *cp2s = [NSBezierPath new];
    
    NSDictionary *infoDict = @{@"cp1s": cp1s, @"cp2s": cp2s};

    CGPathRef pathCG = self.CGPath;
    
    controlPointsPathLastPoint = CGPointZero;
    CGPathApply(pathCG, (__bridge void *)(infoDict), cgControlPointsPathsApplierFunc);
    controlPointsPathLastPoint = CGPointZero;
    
    *controlPoints1Path = cp1s;
    *controlPoints2Path = cp2s;
}

static CGPoint controlPointsPathLastPoint;

void cgControlPointsPathsApplierFunc(void *info, const CGPathElement *element)
{
    NSDictionary *infoDict = (__bridge NSDictionary *)info;
    NSBezierPath *cp1s = infoDict[@"cp1s"];
    NSBezierPath *cp2s = infoDict[@"cp2s"];
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
        case kCGPathElementAddLineToPoint: // contains 1 point
            controlPointsPathLastPoint = points[0];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            if (CGPointEqualToPoint(controlPointsPathLastPoint, CGPointZero)) {
//                NSLog(@"last point not set!");
            }
            else {
                [cp1s moveToPoint:controlPointsPathLastPoint];
                [cp1s lineToPoint:points[0]];
                
                [cp2s moveToPoint:points[1]];
                [cp2s lineToPoint:points[0]];
            }
            
            controlPointsPathLastPoint = points[1];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            if (CGPointEqualToPoint(controlPointsPathLastPoint, CGPointZero)) {
//                NSLog(@"last point not set!");
            }
            else {
                [cp1s moveToPoint:controlPointsPathLastPoint];
                [cp1s lineToPoint:points[0]];
                
                [cp2s moveToPoint:points[2]];
                [cp2s lineToPoint:points[1]];
            }

            controlPointsPathLastPoint = points[2];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            controlPointsPathLastPoint = CGPointZero;
            break;
    }
}

- (NSBezierPath*)approximatePathWithMaxLineLength:(CGFloat)maxLineLength
{
    NSParameterAssert(maxLineLength > 0.0);
    
    NSBezierPath *newPath = [NSBezierPath new];
    
    NSDictionary *infoDict = @{@"path": newPath, @"maxLineLength": @(maxLineLength)};
    
    CGPathRef pathCG = self.CGPath;
    
    approximatePathLastPoint = CGPointZero;
    CGPathApply(pathCG, (__bridge void *)(infoDict), cgApproximatePathApplierFunc);
    approximatePathLastPoint = CGPointZero;
    
    return newPath;
}

static CGPoint approximatePathLastPoint;

void cgApproximatePathApplierFunc(void *info, const CGPathElement *element)
{
    NSDictionary *infoDict = (__bridge NSDictionary *)info;
    NSBezierPath *path = infoDict[@"path"];
    CGFloat maxLineLength = [infoDict[@"maxLineLength"] doubleValue];
    
    CGPoint *elementPoints = element->points;
    CGPathElementType type = element->type;
    
    if (type == kCGPathElementMoveToPoint) {
        [path moveToPoint:elementPoints[0]];
        approximatePathLastPoint = elementPoints[0];
    }
    else if (type == kCGPathElementAddLineToPoint) {
        [path lineToPoint:elementPoints[0]];
        approximatePathLastPoint = elementPoints[0];
    }
    else if (type == kCGPathElementCloseSubpath) {
        [path closePath];
        approximatePathLastPoint = CGPointZero;
    }
    else {
        CGPoint p0 = approximatePathLastPoint;
        CGPoint cp0;
        CGPoint cp1;
        CGPoint p1;
        
        if (type == kCGPathElementAddQuadCurveToPoint) {
            cp0 = elementPoints[0];
            cp1 = elementPoints[0];
            p1 = elementPoints[1];
        }
        else {
            cp0 = elementPoints[0];
            cp1 = elementPoints[1];
            p1 = elementPoints[2];
        }
        
        NSMutableArray *newPoints = [NSMutableArray new];
        
        approximatePathSegment(p0, cp0, cp1, p1, p0, 0.0, p1, 1.0, maxLineLength, newPoints);
        
        for (NSValue *pointValue in newPoints) {
            CGPoint newPoint = pointValue.pointValue;
            [path lineToPoint:newPoint];
        }
        
        approximatePathLastPoint = p1;
    }
}

void approximatePathSegment(CGPoint p0,
                            CGPoint cp0,
                            CGPoint cp1,
                            CGPoint p1,
                            CGPoint pt0,
                            CGFloat t0,
                            CGPoint pt1,
                            CGFloat t1,
                            CGFloat maxLineLength,
                            NSMutableArray *points)
{
    CGFloat distance = sqrt(pow(pt0.x - pt1.x, 2.0) + pow(pt0.y - pt1.y, 2.0));
    CGFloat t05 = (t0 + t1) / 2.0;
    
    if (distance <= maxLineLength) {
        [points addObject:[NSValue valueWithPoint:pt1]];
    }
    else if (t05 > t0 && t05 < t1) {
        CGPoint pt05 = pointOnCurve(p0, cp0, cp1, p1, t05);
        
        approximatePathSegment(p0, cp0, cp1, p1, pt0, t0, pt05, t05, maxLineLength, points);
        approximatePathSegment(p0, cp0, cp1, p1, pt05, t05, pt1, t1, maxLineLength, points);
    }
}

CGPoint pointOnCurve(CGPoint p0, CGPoint cp0, CGPoint cp1, CGPoint p1, CGFloat t)
{
    CGPoint a;
    CGPoint b;
    CGPoint c;
    CGPoint d;
    CGPoint e;
    
    CGPoint p;
    
    a.x = ((1 - t) * p0.x) + (t * cp0.x);
    a.y = ((1 - t) * p0.y) + (t * cp0.y);
    b.x = ((1 - t) * cp0.x) + (t * cp1.x);
    b.y = ((1 - t) * cp0.y) + (t * cp1.y);
    c.x = ((1 - t) * cp1.x) + (t * p1.x);
    c.y = ((1 - t) * cp1.y) + (t * p1.y);
    
    d.x = ((1 - t) * a.x) + (t * b.x);
    d.y = ((1 - t) * a.y) + (t * b.y);
    
    e.x = ((1 - t) * b.x) + (t * c.x);
    e.y = ((1 - t) * b.y) + (t * c.y);
    
    p.x = ((1 - t) * d.x) + (t * e.x);
    p.y = ((1 - t) * d.y) + (t * e.y);
    
    return p;
}

- (NSArray*)allPoints
{
    NSMutableArray *points = [NSMutableArray new];
    
    NSUInteger elementCount = self.elementCount;
    for (NSUInteger i = 0; i < elementCount; i++) {
        NSPoint segmentPoints[3];
        NSBezierPathElement segmentType = [self elementAtIndex:i associatedPoints:segmentPoints];
        
        switch(segmentType) {
            case NSMoveToBezierPathElement: // contains 1 point
            case NSLineToBezierPathElement: // contains 1 point
                [points addObject:[NSValue valueWithPoint:segmentPoints[0]]];
                break;
                
            case NSCurveToBezierPathElement: // contains 2 points
                [points addObject:[NSValue valueWithPoint:segmentPoints[2]]];
                break;
                
            case NSClosePathBezierPathElement:
                break;
        }
        
    }
    
    return [points copy];
}

- (CGPathRef)CGPath
{
    CGPathRef immutablePath = NULL;
    
    NSInteger elementCount = self.elementCount;

    if (elementCount == 0) {
        return immutablePath;
    }
    
    CGMutablePathRef    path = CGPathCreateMutable();
    NSPoint             points[3];
    BOOL                didClosePath = YES;
    
    for (NSUInteger i = 0; i < elementCount; i++) {
        switch ([self elementAtIndex:i associatedPoints:points]) {
            case NSMoveToBezierPathElement:
                CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                break;
                
            case NSLineToBezierPathElement:
                CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                didClosePath = NO;
                break;
                
            case NSCurveToBezierPathElement:
                CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                      points[1].x, points[1].y,
                                      points[2].x, points[2].y);
                didClosePath = NO;
                break;
                
            case NSClosePathBezierPathElement:
                CGPathCloseSubpath(path);
                didClosePath = YES;
                break;
        }
    }
    
    if (!didClosePath) {
        CGPathCloseSubpath(path);
    }
    
    immutablePath = CGPathCreateCopy(path);
    CGPathRelease(path);
    
    CFAutorelease(immutablePath);
    
    return immutablePath;
}

- (BOOL)isEqual:(id)anObject
{
    if (self == anObject)
        return YES;
    if (![anObject isKindOfClass: [NSBezierPath class]])
        return NO;
    
    NSBezierPath *aPath = (NSBezierPath *)anObject;
    
    if (self.elementCount != aPath.elementCount) {
        return NO;
    }
    
//    if (!eq(self.lineWidth, aPath.lineWidth) ||
//        !eq(self.flatness, aPath.flatness) ||
//        !eq(self.miterLimit, aPath.miterLimit) ||
//        self.lineCapStyle != aPath.lineCapStyle ||
//        self.lineJoinStyle != aPath.lineJoinStyle ||
//        self.windingRule != aPath.windingRule ||
//        self.elementCount != aPath.elementCount) {
//        return NO;
//    }

    NSInteger i;
    NSBezierPathElement type1;
    NSPoint pts1[3];
    NSBezierPathElement type2;
    NSPoint pts2[3];
    
    for (i = 0; i < self.elementCount; i++)
    {
        type1 = [self elementAtIndex: i associatedPoints: pts1];
        type2 = [aPath elementAtIndex: i associatedPoints: pts2];

        if (type1 != type2) {
            return NO;
        }
        
        if (!eq(pts1[0].x, pts2[0].x) || !eq(pts1[0].y, pts2[0].y)) {
            return NO;
        }
        
        if (type1 == NSCurveToBezierPathElement) {
            if (!eq(pts1[1].x, pts2[1].x) || !eq(pts1[1].y, pts2[1].y))
            {
                return NO;
            }
            if (!eq(pts1[2].x, pts2[2].x) || !eq(pts1[2].y, pts2[2].y))
            {
                return NO;
            }
        }
    }
    
    return YES;
}

static BOOL eq(double d1, double d2)
{
    if (fabs(d1 - d2) < 0.000001)
        return YES;
    return NO;
}

@end
