//
//  SetCardView.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView ()

@property (nonatomic) BOOL shouldBeMarked;

@end

@implementation SetCardView

- (void)setColor:(NSUInteger)color
{
    _color = color;
    
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    
    [self setNeedsDisplay];
}

- (void)setShade:(NSUInteger)shade
{
    _shade = shade;
    
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

// Highlight the set card view
- (void)mark
{
    self.shouldBeMarked = YES;
}

#define CORNER_RADIUS_SCALE .05
- (CGFloat)cornerRadius
{
    return self.bounds.size.width * CORNER_RADIUS_SCALE + self.bounds.size.height * CORNER_RADIUS_SCALE;
}

#define SELECTED_CHECKMARK_SCALE .3

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    
    UIRectFill(self.bounds);
    
    
    [[UIColor whiteColor] setFill];

    UIRectFill(self.bounds);
    
    if (self.shouldBeMarked)
    {
        [[UIColor blueColor] setStroke];
        
        UIBezierPath *borderBezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
        
        borderBezierPath.lineWidth = 3;
        
        [borderBezierPath stroke];
        
        // We want the marking to be removed on next redraw (i.e. on next player move)
        self.shouldBeMarked = NO;
    }
    
    UIColor *strokeColor = [self colorForCard];
    
    UIColor *fillColor = nil;
    
    // solid color fill
    if (self.shade == 1)
    {
        fillColor = strokeColor;
    }
    else if (self.shade == 2)
    {
        fillColor = [self stripedFillColorForCard];
    }
    
    for (NSValue *rectValue in [self rectsForSymbolsOnCardWithRect:rect])
    {
        CGRect symbolRect = [rectValue CGRectValue];
        
        UIBezierPath *bezierPath = [SetCardView bezierPathForSymbol:self.symbol inRect:symbolRect];
        bezierPath.lineWidth = 2;
        
        [fillColor setFill];
        [strokeColor setStroke];
        [bezierPath fill];
        [bezierPath stroke];
    }
    
    if (self.isFaceUp)
    {
        CGSize checkmarkSize = CGSizeMake(rect.size.width * SELECTED_CHECKMARK_SCALE, rect.size.width * SELECTED_CHECKMARK_SCALE);
        CGRect checkmarkRect = CGRectMake(rect.size.width + rect.origin.x - checkmarkSize.width, 0,
                                          checkmarkSize.width, checkmarkSize.height);
        NSAttributedString *checkmarkAttributedString = [[NSAttributedString alloc] initWithString:@"✓" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:checkmarkSize.width]}];
        [checkmarkAttributedString drawInRect:checkmarkRect];
    }
}

#define MARGIN_SCALE .1

// Returns NSArray of NSValue-wrapped CGRects where the symbols should be drawn
- (NSArray *)rectsForSymbolsOnCardWithRect:(CGRect)rect
{
    NSArray *rects = nil;
    
    // An inset rect with margins
    CGFloat marginWidth = rect.size.width * MARGIN_SCALE;
    CGFloat marginHeight = rect.size.height * MARGIN_SCALE;
    CGRect insetRect = CGRectInset(rect, marginWidth, marginHeight);
    
    CGSize symbolSize = CGSizeMake(insetRect.size.width, insetRect.size.height/3);
    
    if (self.number == 1)
    {
        rects = @[[NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height/3 + marginHeight, symbolSize.width, symbolSize.height)]];
    }
    else if (self.number == 2)
    {
        rects = @[[NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height/6 + marginHeight, symbolSize.width, symbolSize.height)],
                  [NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height/2 + marginHeight, symbolSize.width, symbolSize.height)]];
    }
    else if (self.number == 3)
    {
        rects = @[[NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.origin.y, symbolSize.width, symbolSize.height)],
                  [NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height/3 + marginHeight, symbolSize.width, symbolSize.height)],
                  [NSValue valueWithCGRect:CGRectMake(insetRect.origin.x, insetRect.size.height*2/3 + marginHeight, symbolSize.width, symbolSize.height)]];
    }
    
    return rects;
}

// Returns the UIColor for this card's symbols
- (UIColor *)colorForCard
{
    UIColor *color = nil;
    
    if (self.color == 1)
    {
        color = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1];
    }
    else if (self.color == 2)
    {
        color = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1];
    }
    else if (self.color == 3)
    {
        color = [[UIColor alloc] initWithRed:.5 green:0 blue:.5 alpha:1];
    }
    
    return color;
}

// Returns striped UIColor pattern for striped shading
- (UIColor *)stripedFillColorForCard
{
    UIColor *color = nil;
    
    if (self.color == 1)
    {
        color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"red_stripes.gif"]];
    }
    else if (self.color == 2)
    {
        color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green_stripes.gif"]];
    }
    else if (self.color == 3)
    {
        color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"purple_stripes.gif"]];
    }
    
    return color;
}

#define KERNING_SCALE .2
#define SQUIGGLE_CONTROL_POINT_PULL_SCALE .5
#define DIAMOND_SIDE_INSET_SCALE .2
#define OVAL_SIDE_INSET_SCALE .2

// Returns the symbol drawn as a UIBezierPath within the bounds of a CGRect
+ (UIBezierPath *)bezierPathForSymbol:(NSUInteger)symbol inRect:(CGRect)rect
{
    UIBezierPath *bezierPath = nil;
    
    CGFloat kerningHeight = KERNING_SCALE * rect.size.height;
    
    if (symbol == 1)
    {
        // Draw diamond
        bezierPath = [[UIBezierPath alloc] init];
        
        [bezierPath moveToPoint:CGPointMake(rect.origin.x + (rect.size.width*DIAMOND_SIDE_INSET_SCALE), rect.origin.y + rect.size.height/2)];
        
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + kerningHeight)];
        
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + (rect.size.width*(1-DIAMOND_SIDE_INSET_SCALE)) , rect.origin.y + rect.size.height/2)];
        
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height - kerningHeight)];
        
        [bezierPath closePath];
    }
    else if (symbol == 2)
    {
        // Draw squiggle
        CGFloat squigglePullStrength = rect.size.height * SQUIGGLE_CONTROL_POINT_PULL_SCALE;
        bezierPath = [[UIBezierPath alloc] init];
        
        CGPoint topLeft = CGPointMake(rect.origin.x, rect.origin.y+kerningHeight);
        
        CGPoint bottomRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height-kerningHeight);
        
        CGPoint controlPoint1 = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
        
        CGPoint controlPoint2 = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y-squigglePullStrength);
        
        CGPoint controlPoint3 = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
        
        CGPoint controlPoint4 = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height+squigglePullStrength);
        
        // Start at top left, add curve to bottom right (using control points)
        [bezierPath moveToPoint:topLeft];
        
        [bezierPath addCurveToPoint:bottomRight controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        
        [bezierPath addCurveToPoint:topLeft controlPoint1:controlPoint3 controlPoint2:controlPoint4];
    }
    else if (symbol == 3)
    {
        // Draw oval
        bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x + (rect.size.width*OVAL_SIDE_INSET_SCALE), rect.origin.y + kerningHeight, rect.size.width - (2*rect.size.width*OVAL_SIDE_INSET_SCALE), rect.size.height - (kerningHeight * 2))];
    }
    
    return bezierPath;
}

@end