//
//  FlipResultView.m
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "FlipResultView.h"

@interface FlipResultView ()

@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSArray *cardSubviews;

@end

@implementation FlipResultView

- (CGFloat) cardSubviewDisplayRatio
{
    if (_cardSubviewDisplayRatio <= 0)
    {
        _cardSubviewDisplayRatio = 1;
    }
    
    return _cardSubviewDisplayRatio;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)displayResultString:(NSString *)result
{
    [self displayResultString:result
             withCardSubviews:nil
                 displayRatio:0
                     animated:YES];
}

- (void)displayResultString:(NSString *)result
           withCardSubviews:(NSArray *)cardSubviews
               displayRatio:(CGFloat)displayRatio
{
    [self displayResultString:result
             withCardSubviews:cardSubviews
                 displayRatio:displayRatio
                     animated:YES];
}

- (void)displayResultString:(NSString *)result
           withCardSubviews:(NSArray *)cardSubviews
               displayRatio:(CGFloat)displayRatio
                   animated:(BOOL)animated
{
    self.result = result;
    self.cardSubviews = cardSubviews;
    self.cardSubviewDisplayRatio = displayRatio;
    self.alpha = 1;
    
    if (animated)
    {
        [UIView animateWithDuration:3
                              delay:1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{ self.alpha = 0; }
                         completion:NULL];
    }
    
    [self setNeedsDisplay];
}


#define FONT_SCALE_FACTOR 0.55

- (void)drawRect:(CGRect)rect
{
    // Clear out subviews from old results
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    // The result string font is scaled by the size of the view
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.height * FONT_SCALE_FACTOR];
    
    // Tokenize the result string...
    NSArray *resultStringArray = [FlipResultView parseResultString:self.result];
    
    // but before we can render the tokens as card views and attributed strings, we calculate the total
    // required width so that we can center the results within the view
    CGFloat widthNeeded = 0;
    
    for (id object in resultStringArray)
    {
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *)object;
            NSAttributedString *resultText = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : font }];
            widthNeeded += [resultText size].width;
        }
        else if ([object isMemberOfClass:[NSNull class]])
        {
            widthNeeded += self.bounds.size.height*self.cardSubviewDisplayRatio;
        }
    }
    
    // Then we render the results
    int xCoordinate = (self.bounds.size.width - widthNeeded) / 2;
    int subviewIndex = 0;
    
    for (id object in resultStringArray)
    {
        if ([object isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *)object;
            
            NSAttributedString *resultText = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : font }];
            
            CGRect textBounds;
            
            textBounds.origin = CGPointMake(xCoordinate, (self.bounds.size.height - [resultText size].height)/2);
            
            textBounds.size = [resultText size];
            
            [resultText drawInRect:textBounds];
            
            xCoordinate += textBounds.size.width;
            
        }
        else if ([object isMemberOfClass:[NSNull class]])
        {
            if (subviewIndex < [self.cardSubviews count])
            {
                UIView *subview = (UIView *)self.cardSubviews[subviewIndex];
                
                CGRect viewBounds;
                
                viewBounds.origin = CGPointMake(xCoordinate, 0);
                
                viewBounds.size = CGSizeMake(self.bounds.size.height*self.cardSubviewDisplayRatio, self.bounds.size.height);
                
                subview.frame = viewBounds;
                
                subview.backgroundColor = [UIColor clearColor];
                
                [self addSubview:subview];
                
                xCoordinate += viewBounds.size.width;
                
                subviewIndex++;
            }
        }
    }
}

// Takes the result string and turns it into an array of tokens. NSNull items are placeholders for the cards
+ (NSArray *)parseResultString:(NSString *)string
{
    if (!string) return nil;
    
    NSMutableArray *resultStringArray = [[NSMutableArray alloc] init];
    
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[.*?]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *textCheckingResults = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if ([textCheckingResults count])
    {
        int trailingIndex = 0;
        
        for (NSTextCheckingResult *textCheckingResult in textCheckingResults)
        {
            NSRange cardRange = [textCheckingResult range];
            [resultStringArray addObject:[string substringWithRange:NSMakeRange(trailingIndex, cardRange.location-trailingIndex)]];
            [resultStringArray addObject:[NSNull null]];
            trailingIndex = cardRange.location + cardRange.length;
        }
        
        if (trailingIndex != string.length)
        {
            [resultStringArray addObject:[string substringWithRange:NSMakeRange(trailingIndex, string.length-trailingIndex)]];
        }
    }
    else
    {
        [resultStringArray addObject:string];
    }
    
    return [resultStringArray copy];
}

@end
