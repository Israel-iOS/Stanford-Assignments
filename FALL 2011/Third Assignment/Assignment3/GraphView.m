//
//  GraphView.m
//  Assignment3
//
//  Created by Apple on 15/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView
@synthesize dataSource=_datasource;
@synthesize scale=_scale;
@synthesize axisOrigin=_axisOrigin;

#define DEFAULT_SCALE 100

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}

- (CGFloat)scale
{
    // Set the scale to the default scale if none already
    if (!_scale) _scale = DEFAULT_SCALE;
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    // Do nothing if the scale hasn't changed
    if (_scale == scale) return;
    _scale = scale;
    
    // Ask the delegate to store the scale
    [self.dataSource storeScale:_scale ForGraphView:self];
    
    // Redraw whenever the scale is changed
    [self setNeedsDisplay];
}

- (void)setAxisOrigin:(CGPoint)axisOrigin
{
    // Do nothing is the axis origin hasn't changed
    if (_axisOrigin.x == axisOrigin.x && _axisOrigin.y == axisOrigin.y) return;
    
    _axisOrigin = axisOrigin;
    
    // Ask the delegate to store the scale
    [self.dataSource storeAxisOriginX:_axisOrigin.x andAxisOriginY:_axisOrigin.y ForGraphView:self];
    
    // Redraw whenever the axis origin is changed
    [self setNeedsDisplay];
}

- (CGPoint)axisOrigin
{
    // Set it to the middle of the graphBounds, if if the current origin is (0,0)
    if (!_axisOrigin.x && !_axisOrigin.y)
    {
        _axisOrigin.x = (self.graphBounds.origin.x + self.graphBounds.size.width) / 2;
        _axisOrigin.y = (self.graphBounds.origin.y + self.graphBounds.size.height) / 2;
    }
    return _axisOrigin;
}

- (CGRect)graphBounds
{
    // Let's just make it the size of the view to keep things simple
    return self.bounds;
}

- (CGPoint)convertToGraphCoordinateFromViewCoordinate:(CGPoint)coordinate
{    
    CGPoint graphCoordinate;
    
    graphCoordinate.x = (coordinate.x - self.axisOrigin.x) / self.scale;
    graphCoordinate.y = (self.axisOrigin.y - coordinate.y) / self.scale;
    
    return graphCoordinate;
}

- (CGPoint)convertToViewCoordinateFromGraphCoordinate:(CGPoint)coordinate
{
    CGPoint viewCoordinate;
    
    viewCoordinate.x = (coordinate.x * self.scale) + self.axisOrigin.x;
    viewCoordinate.y = self.axisOrigin.y - (coordinate.y * self.scale);
    
    return viewCoordinate;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the line width and colour of the axis.
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor]CGColor]);
    
    // Draw the axes using the AxesDrawer helper class.
    [AxesDrawer drawAxesInRect:self.graphBounds originAtPoint:self.axisOrigin scale:self.scale];
    
    // Set the line width and colour of the graph lines
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor]CGColor]);
    
    CGContextBeginPath(context);
    
    CGFloat startingX = self.graphBounds.origin.x;
    CGFloat endingX = self.graphBounds.origin.x + self.graphBounds.size.width;
    CGFloat increment = 1/self.contentScaleFactor; // To enable iteration over pixels
    
    BOOL firstPoint = YES;
    
    // Iterate over the horizontal pixels, plotting the corresponding y values
    for (CGFloat x = startingX; x<= endingX; x+=increment) {
        // Identify the starting X point for the curve and convert to graph coordinates.
        // Then retrieve the corresponding Y value and convert it back to view coordindates
        CGPoint coordinate;
        coordinate.x = x;
        coordinate = [self convertToGraphCoordinateFromViewCoordinate:coordinate];
        coordinate.y = [self.dataSource YValueForXValue:coordinate.x inGraphView:self];
        coordinate = [self convertToViewCoordinateFromGraphCoordinate:coordinate];
        coordinate.x = x;
        
        // Handle the edge cases
        if (coordinate.y == NAN || coordinate.y == INFINITY || coordinate.y == -INFINITY)
            continue;
        
        if (firstPoint)
        {
            CGContextMoveToPoint(context, coordinate.x, coordinate.y);
            firstPoint = NO;
        }
        
        CGContextAddLineToPoint(context, coordinate.x, coordinate.y);
        
    }
    CGContextStrokePath(context);
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        // Adjust the scale and reset the gesture scale to 1
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        // Move the origin of the graph
        CGPoint translation = [gesture translationInView:self];
        
        CGPoint axisOrigin;
        axisOrigin.x = self.axisOrigin.x + translation.x;
        axisOrigin.y = self.axisOrigin.y + translation.y;
        
        self.axisOrigin = axisOrigin;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)tripleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        self.axisOrigin = [gesture locationOfTouch:0 inView:self];
    }
}


@end