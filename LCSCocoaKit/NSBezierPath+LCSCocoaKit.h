
@interface NSBezierPath (LCSCocoaKit)

+ (NSBezierPath*)pathFromSVGElement:(NSXMLElement*)svgElement;
- (void)applyPropertiesFromSVGElement:(NSXMLElement*)svgElement;

+ (NSBezierPath*)pathWithPoints:(NSArray*)points closed:(BOOL)closed;

- (NSBezierPath*)pathWithStraightSegements;

- (void)controlPointsPathCp1:(NSBezierPath **)controlPoints1Path cp2:(NSBezierPath **)controlPoints2Path;

- (NSBezierPath*)approximatePathWithMaxLineLength:(CGFloat)maxLineLength;

@property (nonatomic,readonly) CGPathRef CGPath;
@property (nonatomic,readonly) NSArray *allPoints;

- (BOOL)isEqual:(id)anObject;

@end
