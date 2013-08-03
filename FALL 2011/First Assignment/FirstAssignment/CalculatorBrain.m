//
//  CalculatorBrain.m
//  FirstAssignment
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic,strong) NSMutableArray *operandStack;

- (double)popOperand;

@end

@implementation CalculatorBrain

- (NSMutableArray *)operandStack        // initializing stack
{
    if (_operandStack == nil)
    {
        _operandStack = [[NSMutableArray alloc]init];
    }
    return _operandStack;
}

- (void)pushOperand:(double)operand     // pushing the variables in stack
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double)popOperand        
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject)
    {
        [self.operandStack removeLastObject];
    }
return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation        // performing necessary operations
{
    double result = 0;
    if ([operation isEqualToString:@"+"])
    {
    result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"*"])
    {
    result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"-"])
    {
    double subtract = [self popOperand];
    result = [self popOperand] - subtract;
    }
    else if ([operation isEqualToString:@"/"])
    {
    double divisor = [self popOperand];
    result = [self popOperand] / divisor;
    }
    else if ([operation isEqualToString:@"sin"])
    {
    double sine = [self popOperand];
    if (sine) result = sin(sine);
    }
    else if ([operation isEqualToString:@"cos"])
    {
    double cose = [self popOperand];
    if (cose)  result = cos(cose);
    }
    else if ([operation isEqualToString:@"sqrt"])
    {
    double squareRoot = [self popOperand];
    if (squareRoot) result = sqrt(squareRoot);
    }
    else if ([operation isEqualToString:@"π"])
    {
    result = M_PI;
    }
    
    [self pushOperand:result];    
    return result;
}

- (void)emptyStack      // clearing the stack
{
    [self.operandStack removeAllObjects];
}

@end
