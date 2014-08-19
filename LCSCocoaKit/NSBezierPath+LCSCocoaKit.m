#import "NSBezierPath+LCSCocoaKit.h"

//#import "LCGSHelperFunctions.h"

@interface NSBezierPath (LCSCocoaKitPrivate)

+ (NSBezierPath*)pathFromSVGPolygonOrPolyline:(NSXMLElement*)svgElement;
+ (NSBezierPath*)pathFromSVGPath:(NSXMLElement*)svgElement;

- (void)applyLineWidthPropertyFromSVGElement:(NSXMLElement*)svgElement;
- (void)applyLineCapPropertyFromSVGElement:(NSXMLElement*)svgElement;
- (void)applyLineJoinPropertyFromSVGElement:(NSXMLElement*)svgElement;
- (void)applyMiterLimitPropertyFromSVGElement:(NSXMLElement*)svgElement;



@end

@implementation NSBezierPath (LCSCocoaKit)

CGFloat interpolateYForXBetweenPoints(CGPoint p0, CGPoint p1, CGFloat x);

+ (NSBezierPath*)pathFromSVGElement:(NSXMLElement*)svgElement
{
    NSBezierPath *path;
    
    if ([svgElement.name isEqualToString:@"rect"]) {
        CGRect rect;
        rect.origin.x = [svgElement attributeForName:@"x"].stringValue.doubleValue;
        rect.origin.y = [svgElement attributeForName:@"y"].stringValue.doubleValue;
        rect.size.width = [svgElement attributeForName:@"width"].stringValue.doubleValue;
        rect.size.height = [svgElement attributeForName:@"height"].stringValue.doubleValue;
        
        CGPoint radius;
        radius.x = [svgElement attributeForName:@"rx"].stringValue.doubleValue;
        radius.y = [svgElement attributeForName:@"ry"].stringValue.doubleValue;
        
        path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius.x yRadius:radius.y];
    }
    else if ([svgElement.name isEqualToString:@"circle"]) {
        CGPoint center;
        center.x = [svgElement attributeForName:@"cx"].stringValue.doubleValue;
        center.y = [svgElement attributeForName:@"cy"].stringValue.doubleValue;
        
        CGFloat radius = [svgElement attributeForName:@"r"].stringValue.doubleValue;
        
        CGRect rect = CGRectMake(center.x - radius, center.y - radius, radius * 2.0, radius * 2.0);
        
        path = [NSBezierPath bezierPathWithOvalInRect:rect];
    }
    else if ([svgElement.name isEqualToString:@"ellipse"]) {
        CGPoint center;
        center.x = [svgElement attributeForName:@"cx"].stringValue.doubleValue;
        center.y = [svgElement attributeForName:@"cy"].stringValue.doubleValue;
        
        CGFloat radiusX = [svgElement attributeForName:@"rx"].stringValue.doubleValue;
        CGFloat radiusY = [svgElement attributeForName:@"ry"].stringValue.doubleValue;
        
        CGRect rect = CGRectMake(center.x - radiusX, center.y - radiusY, radiusX * 2.0, radiusY * 2.0);
        
        path = [NSBezierPath bezierPathWithOvalInRect:rect];
    }
    else if ([svgElement.name isEqualToString:@"line"]) {
        CGPoint p1;
        p1.x = [svgElement attributeForName:@"x1"].stringValue.doubleValue;
        p1.y = [svgElement attributeForName:@"y1"].stringValue.doubleValue;
        CGPoint p2;
        p2.x = [svgElement attributeForName:@"x2"].stringValue.doubleValue;
        p2.y = [svgElement attributeForName:@"y2"].stringValue.doubleValue;
        
        path = [NSBezierPath new];
        [path moveToPoint:p1];
        [path lineToPoint:p2];
    }
    else if ([svgElement.name isEqualToString:@"polygon"] || [svgElement.name isEqualToString:@"polyline"]) {
        path = [NSBezierPath pathFromSVGPolygonOrPolyline:svgElement];
    }
    else if ([svgElement.name isEqualToString:@"path"]) {
        path = [NSBezierPath pathFromSVGPath:svgElement];
    }
    
    return path;
}

+ (NSBezierPath*)pathFromSVGPolygonOrPolyline:(NSXMLElement*)svgElement
{
    NSBezierPath *path = [NSBezierPath new];
    
    NSScanner *scanner = [NSScanner scannerWithString:[svgElement attributeForName:@"points"].stringValue];
    scanner.caseSensitive = YES;
    NSCharacterSet *commaAndwhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:@", \t\r\n"];
    scanner.charactersToBeSkipped = commaAndwhitespaceCharacters;
    
    while (!scanner.isAtEnd) {
        BOOL didScan = NO;
        
        CGPoint point;
        
        didScan = [scanner scanDouble:&point.x];
        if (!didScan) {
            return nil;
        }
        
        didScan = [scanner scanDouble:&point.y];
        if (!didScan) {
            return nil;
        }
        
        if (path.elementCount == 0) {
            [path moveToPoint:point];
        }
        else {
            [path lineToPoint:point];
        }
    }
    
    if ([svgElement.name isEqualToString:@"polygon"]) {
        [path closePath];
    }
    
    return path;
}

+ (NSBezierPath*)pathFromSVGPath:(NSXMLElement*)svgElement
{
    NSBezierPath *path = [NSBezierPath new];
    
    NSScanner *scanner = [NSScanner scannerWithString:[svgElement attributeForName:@"d"].stringValue];
    scanner.caseSensitive = YES;
    
    NSCharacterSet *commandCharacters = [NSCharacterSet characterSetWithCharactersInString:@"MmZzLlHhVvCcSsQqTtAa"];
    NSCharacterSet *commaAndwhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:@", \t\r\n"];
    scanner.charactersToBeSkipped = commaAndwhitespaceCharacters;
    
    NSString *currentCommand;
    [scanner scanCharactersFromSet:commandCharacters intoString:&currentCommand];
    
    NSAssert([currentCommand caseInsensitiveCompare:@"m"] == NSOrderedSame , @"Path data must start with 'move to' command!");
    
    scanner.scanLocation = 0;
    
    while (!scanner.isAtEnd) {
        [scanner scanCharactersFromSet:commandCharacters intoString:&currentCommand];
        CGPoint coordinate = {0.0, 0.0};
        
        if ([currentCommand isEqualToString:@"M"]) {
            [scanner scanDouble:&coordinate.x];
            [scanner scanDouble:&coordinate.y];
            
            [path moveToPoint:coordinate];
        }
        else if ([currentCommand isEqualToString:@"m"]) {
            [scanner scanDouble:&coordinate.x];
            [scanner scanDouble:&coordinate.y];
            
            [path relativeMoveToPoint:coordinate];
        }
        else if ([currentCommand isEqualToString:@"L"]) {
            [scanner scanDouble:&coordinate.x];
            [scanner scanDouble:&coordinate.y];
            
            [path lineToPoint:coordinate];
        }
        else if ([currentCommand isEqualToString:@"l"]) {
            [scanner scanDouble:&coordinate.x];
            [scanner scanDouble:&coordinate.y];
            
            [path relativeLineToPoint:coordinate];
        }
        else if ([currentCommand isEqualToString:@"H"]) {
            coordinate.y = path.currentPoint.y;
            while ([scanner scanDouble:&coordinate.x]) {
                [path lineToPoint:coordinate];
            }
        }
        else if ([currentCommand isEqualToString:@"h"]) {
            while ([scanner scanDouble:&coordinate.x]) {
                [path relativeLineToPoint:coordinate];
            }
        }
        else if ([currentCommand isEqualToString:@"V"]) {
            coordinate.x = path.currentPoint.x;
            while ([scanner scanDouble:&coordinate.y]) {
                [path lineToPoint:coordinate];
            }
        }
        else if ([currentCommand isEqualToString:@"v"]) {
            while ([scanner scanDouble:&coordinate.y]) {
                [path relativeLineToPoint:coordinate];
            }
        }
        else if ([currentCommand isEqualToString:@"C"]) {
            CGPoint controlPoint1 = {0, 0};
            [scanner scanDouble:&controlPoint1.x];
            [scanner scanDouble:&controlPoint1.y];
            
            CGPoint controlPoint2 = {0, 0};
            [scanner scanDouble:&controlPoint2.x];
            [scanner scanDouble:&controlPoint2.y];
            
            [scanner scanDouble:&coordinate.x];
            [scanner scanDouble:&coordinate.y];
            
            [path curveToPoint:coordinate controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        }
        else if ([currentCommand isEqualToString:@"c"]) {
            CGPoint controlPoint1 = {0, 0};
            [scanner scanDouble:&controlPoint1.x];
            [scanner scanDouble:&controlPoint1.y];
            
            CGPoint controlPoint2 = {0, 0};
            [scanner scanDouble:&controlPoint2.x];
            [scanner scanDouble:&controlPoint2.y];
            
            [scanner scanDouble:&coordinate.x];
            [scanner scanDouble:&coordinate.y];
            
            [path relativeCurveToPoint:coordinate controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        }
        else if ([currentCommand isEqualToString:@"Z"] || [currentCommand isEqualToString:@"z"]) {
            [path closePath];
        }
        else {
            NSException *exception = [NSException exceptionWithName:@"not implemented" reason:@"command not implemented" userInfo:@{@"command": currentCommand}];
            @throw exception;
        }
    }
    
    return path;
}

- (void)applyPropertiesFromSVGElement:(NSXMLElement*)svgElement
{
    NSArray *allowedElementNames = @[@"rect", @"line", @"circle", @"ellipse", @"polygon", @"polyline", @"path"];
    NSParameterAssert([allowedElementNames containsObject:svgElement.name]);
    
    [self applyLineWidthPropertyFromSVGElement:svgElement];
    [self applyLineCapPropertyFromSVGElement:svgElement];
    [self applyLineJoinPropertyFromSVGElement:svgElement];
    [self applyMiterLimitPropertyFromSVGElement:svgElement];
}

- (void)applyLineWidthPropertyFromSVGElement:(NSXMLElement*)svgElement
{
    NSString *strokeWidthString = [svgElement attributeForName:@"stroke-width"].stringValue;
    
    if (strokeWidthString) {
        self.lineWidth = strokeWidthString.doubleValue;
    }
}

- (void)applyLineCapPropertyFromSVGElement:(NSXMLElement*)svgElement
{
    NSString *strokeLineCapString = [svgElement attributeForName:@"stroke-linecap"].stringValue;
    if ([strokeLineCapString isEqualToString:@"butt"]) {
        self.lineCapStyle = NSButtLineCapStyle;
    }
    else if ([strokeLineCapString isEqualToString:@"round"]) {
        self.lineCapStyle = NSRoundLineCapStyle;
    }
    else if ([strokeLineCapString isEqualToString:@"square"]) {
        self.lineCapStyle = NSSquareLineCapStyle;
    }
}

- (void)applyLineJoinPropertyFromSVGElement:(NSXMLElement*)svgElement
{
    NSString *strokeLineJoinString = [svgElement attributeForName:@"stroke-linejoin"].stringValue;

    if ([strokeLineJoinString isEqualToString:@"miter"]) {
        self.lineCapStyle = NSMiterLineJoinStyle;
    }
    else if ([strokeLineJoinString isEqualToString:@"round"]) {
        self.lineCapStyle = NSRoundLineJoinStyle;
    }
    else if ([strokeLineJoinString isEqualToString:@"bevel"]) {
        self.lineCapStyle = NSBevelLineJoinStyle;
    }
}

- (void)applyMiterLimitPropertyFromSVGElement:(NSXMLElement*)svgElement
{
    NSString *strokeMiterLimitString = [svgElement attributeForName:@"stroke-miterlimit"].stringValue;
    
    if (strokeMiterLimitString) {
        self.miterLimit = strokeMiterLimitString.doubleValue;
    }
}

+ (NSBezierPath*)pathWithPoints:(NSArray*)points closed:(BOOL)closed
{
    NSBezierPath *path = [NSBezierPath new];
    
    CGPoint firstPoint = [points.firstObject CGPointValue];
    [path moveToPoint:firstPoint];
    
    for (NSUInteger i = 1; i < points.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        [path lineToPoint:point];
    }
    
    if (closed) {
        [path closePath];
    }
    
    return path;
}

- (NSBezierPath*)pathWithStraightSegements
{
    NSArray *points = [self allPoints];
    
    return [NSBezierPath pathWithPoints:points closed:NO];
}

void cgStraightPathApplierFunc (void *info, const CGPathElement *element)
{
    NSBezierPath *path = (__bridge NSBezierPath*)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [path moveToPoint:points[0]];
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            [path lineToPoint:points[0]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [path lineToPoint:points[1]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [path lineToPoint:points[2]];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            [path closePath];
            break;
    }
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
    CGFloat distance = distanceBetweenPoints(pt0, pt1);
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

CGFloat distanceBetweenPoints(CGPoint p0, CGPoint p1)
{
    return sqrt(pow(p0.x - p1.x, 2.0) + pow(p0.y - p1.y, 2.0));
}

- (NSArray*)allPoints
{
    NSMutableArray *points = [NSMutableArray new];
    
    CGPathApply(self.CGPath, (__bridge void *)(points), cgAllPointsOnPathApplierFunc);

    return [points copy];
}

void cgAllPointsOnPathApplierFunc(void *info, const CGPathElement *element)
{
    NSMutableArray *points = (__bridge NSMutableArray *)info;

    CGPoint *segmentPoints = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
        case kCGPathElementAddLineToPoint: // contains 1 point
            [points addObject:[NSValue valueWithPoint:segmentPoints[0]]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [points addObject:[NSValue valueWithPoint:segmentPoints[1]]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [points addObject:[NSValue valueWithPoint:segmentPoints[2]]];
            break;
        case kCGPathElementCloseSubpath:
            break;
    }
}

static CGFloat findPathHeightAtX_y;
static CGPoint findPathHeightAtXLastPoint;

void cgFindPathHeightAtXApplierFunc(void *info, const CGPathElement *element)
{
    NSDictionary *infoDict = (__bridge NSDictionary *)info;
    CGFloat x = [infoDict[@"x"] doubleValue];
    CGFloat maxLineLength = [infoDict[@"maxLineLength"] doubleValue];
    
    CGPoint *elementPoints = element->points;
    CGPathElementType type = element->type;
    
    if (type == kCGPathElementMoveToPoint) {
        findPathHeightAtXLastPoint = elementPoints[0];
    }
    else if (type == kCGPathElementAddLineToPoint) {
        if (findPathHeightAtXLastPoint.x <= x && elementPoints[0].x >= x) {
            findPathHeightAtX_y = interpolateYForXBetweenPoints(findPathHeightAtXLastPoint, elementPoints[0], x);
        }
        
        findPathHeightAtXLastPoint = elementPoints[0];
    }
    else if (type == kCGPathElementCloseSubpath) {
        findPathHeightAtXLastPoint = CGPointZero;
    }
    else {
        CGPoint p0 = findPathHeightAtXLastPoint;
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
        
        if (p0.x <= x && p1.x >= x) {
            NSMutableArray *newPoints = [NSMutableArray new];
            
            approximatePathSegment(p0, cp0, cp1, p1, p0, 0.0, p1, 1.0, maxLineLength, newPoints);
            
            for (NSUInteger i = 0; i < newPoints.count - 1; i++) {
                p0 = [newPoints[i] CGPointValue];
                p1 = [newPoints[i+1] CGPointValue];
                
                if (p0.x <= x && p1.x >= x) {
                    findPathHeightAtX_y = interpolateYForXBetweenPoints(p0, p1, x);
                }
            }
        }
        
        findPathHeightAtXLastPoint = p1;
    }
}

CGFloat interpolateYForXBetweenPoints(CGPoint p0, CGPoint p1, CGFloat x)
{
    if (p0.x == p1.x) {
        return (p0.y + p1.y) / 2.0;
    }
    
    CGFloat xFactor = (x - p0.x) / (p1.x - p0.x);
    CGFloat yDiff = p1.y - p0.y;
    
    return p0.y + xFactor * yDiff;
}

- (CGPathRef)CGPath
{
    CGPathRef           immutablePath = NULL;
    
    // Then draw the path elements.
    NSInteger numElements = [self elementCount];
    if (numElements == 0) {
        return immutablePath;
    }
    
    CGMutablePathRef    path = CGPathCreateMutable();
    NSPoint             points[3];
    BOOL                didClosePath = YES;
    
    for (NSUInteger i = 0; i < numElements; i++)
    {
        switch ([self elementAtIndex:i associatedPoints:points])
        {
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
    
    if (!didClosePath)
        CGPathCloseSubpath(path);
    
    immutablePath = CGPathCreateCopy(path);
    CGPathRelease(path);
    
    return immutablePath;
}

- (BOOL)isEqual:(id)anObject
{
    NSInteger i;
    NSBezierPathElement type1;
    NSPoint pts1[3];
    NSBezierPathElement type2;
    NSPoint pts2[3];
    
    if (self == anObject)
        return YES;
    if (![anObject isKindOfClass: [NSBezierPath class]])
        return NO;
    
    NSBezierPath *aPath = (NSBezierPath *)anObject;
    if (!eq(self.lineWidth, aPath.lineWidth))
    {
        NSLog(@"different lineWidth %g %g", self.lineWidth, aPath.lineWidth);
        return NO;
    }
    if (!eq(self.flatness, aPath.flatness))
    {
        NSLog(@"different flatness %g %g", self.flatness, aPath.flatness);
        return NO;
    }
    if (!eq(self.miterLimit, aPath.miterLimit))
    {
        NSLog(@"different miterLimit %g %g", self.miterLimit, aPath.miterLimit);
        return NO;
    }
    if (self.lineCapStyle != aPath.lineCapStyle)
    {
        NSLog(@"different lineCapStyle %lu %lu", (unsigned long)self.lineCapStyle, (unsigned long)aPath.lineCapStyle);
        return NO;
    }
    if (self.lineJoinStyle != aPath.lineJoinStyle)
    {
        NSLog(@"different lineJoinStyle %lu %lu", (unsigned long)self.lineJoinStyle, (unsigned long)aPath.lineJoinStyle);
        return NO;
    }
    if (self.windingRule != aPath.windingRule)
    {
        NSLog(@"different winding rule %lu %lu", (unsigned long)self.windingRule, (unsigned long)aPath.windingRule);
        return NO;
    }
    
    if (self.elementCount != aPath.elementCount)
    {
        NSLog(@"different element count %ld %ld", (long)self.elementCount, (long)aPath.elementCount);
        return NO;
    }
    
    for (i = 0; i < self.elementCount; i++)
    {
        type1 = [self elementAtIndex: i associatedPoints: pts1];
        type2 = [aPath elementAtIndex: i associatedPoints: pts2];
        if (type1 != type2)
        {
            NSLog(@"different type count %lu %lu", (unsigned long)type1, (unsigned long)type2);
            return NO;
        }
        
        if (!eq(pts1[0].x, pts2[0].x) || !eq(pts1[0].y, pts2[0].y))
        {
            NSLog(@"different point %@ %@", NSStringFromPoint(pts1[0]), NSStringFromPoint(pts2[0]));
            return NO;
        }
        
        if (type1 == NSCurveToBezierPathElement)
        {
            if (!eq(pts1[1].x, pts2[1].x) || !eq(pts1[1].y, pts2[1].y))
            {
                NSLog(@"different point %@ %@", NSStringFromPoint(pts1[1]), NSStringFromPoint(pts2[1]));
                return NO;
            }
            if (!eq(pts1[2].x, pts2[2].x) || !eq(pts1[2].y, pts2[2].y))
            {
                NSLog(@"different point %@ %@", NSStringFromPoint(pts1[2]), NSStringFromPoint(pts2[2]));
                return NO;
            }
        }
    }
    
    return YES;
}

static BOOL eq(double d1, double d2)
{
    if (abs(d1 - d2) < 0.000001)
        return YES;
    return NO;
}

@end
