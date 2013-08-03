//
//  CalculatorBrain.m
//  Assignment2
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

@property (nonatomic,strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

- (NSMutableArray *)operandStack
{
    if (_operandStack == nil)
    {
        _operandStack = [[NSMutableArray alloc]init];
    }
    return _operandStack;
}

- (void)clearTopOfOperandstack
{
    [self.operandStack removeLastObject];
}

- (id)program
{
    return [self.operandStack copy];
}

//check if an nsstring is an operation
+ (BOOL)isOperation:(NSString *)operation
{
    BOOL result=0;
    // Create a set of known operations
    NSMutableSet *operationSet=[NSMutableSet setWithObjects:@"+",@"-",@"*",@"/",@"sin",@"cos",@"sqrt", nil];
    if ([operationSet containsObject:operation] ) result= 1;
    return result;
}

// method to display about the description of the program
+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack];
}

//compare two operations' priority
+ (BOOL)compareOperationPriority:(NSString *)firstOperation vs:(NSString *)secondOperation
{
    BOOL result=0;
    NSDictionary *operationPriority= [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"+",@"1",@"-",@"2",@"*",@"2",@"/",@"3",@"sin",@"3",@"cos",@"3",@"sqrt", nil];
    int firstOperationLevel=[[operationPriority objectForKey:firstOperation] intValue];
    int secondOperationLevel;
    if (secondOperation)
    {
        secondOperationLevel=[[operationPriority objectForKey:secondOperation] intValue];
        if (firstOperationLevel>secondOperationLevel)  result=1;
    }
    return result;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *description;
    
    id topOfStack=[stack lastObject];
    [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) description=[topOfStack stringValue];
    
    else if([topOfStack isKindOfClass:[NSString class]])
    {
        
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"twoOperandOperation"])
        {
            NSString *second=[CalculatorBrain descriptionOfTopOfStack:stack];
            NSString *first=[CalculatorBrain descriptionOfTopOfStack:stack];
            description=[NSString stringWithFormat:@"(%@%@%@)",first,topOfStack,second];
            description=[CalculatorBrain surpressParienthese: description];
            //only two operand operation needs to surpress
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"singleOperandOperation"]) {
            description=[NSString stringWithFormat:@"%@ ( %@ )",topOfStack,[CalculatorBrain descriptionOfTopOfStack:stack]];
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"noOperandOperation"]) {
            description=[NSString stringWithFormat:@"%@",topOfStack];
        }
        if ([[CalculatorBrain typeOfString:topOfStack] isEqualToString:@"variable"]) {
            description=topOfStack;
        }
    }
    //check if description has "null" in the case of user pressed operation withoud operand before
    NSRange nsrange=[description rangeOfString:@"null"];
    if (nsrange.location!=NSNotFound) {
        description=@"operand not entered";
    }
    return description;
}

//get rid of unnecessary parienthese by comparing the last and the secondlast operation
+ (NSString *)surpressParienthese:(NSString *)description
{
    NSMutableArray *descriptionArray=[[description componentsSeparatedByString:@" "] mutableCopy];
    
    NSString *lastOperation,*secondLastOperation;
    for (int i=[descriptionArray count]-1; i>0 && !lastOperation; i--) {
        if([CalculatorBrain isOperation:[descriptionArray objectAtIndex:i]]){
            lastOperation=[descriptionArray objectAtIndex:i];//last operation found
            
            for (int j=i-1; j>0 && !secondLastOperation; j--) {
                if ([CalculatorBrain isOperation:[descriptionArray objectAtIndex:j]]) {
                    secondLastOperation=[descriptionArray objectAtIndex:j];
                    
                }
            }
            if (![CalculatorBrain compareOperationPriority:lastOperation vs:secondLastOperation]) {
                [descriptionArray removeObjectAtIndex:i-1];
                [descriptionArray removeObjectAtIndex:0];
            }
            
        }
    }
    
    description=[[descriptionArray valueForKey:@"description"] componentsJoinedByString:@" "];
    return description;
}

//private method to determine a string's type
+ (NSString *)typeOfString:(NSString *)string
{
    NSMutableSet *twoOperandOperation=[NSMutableSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    NSMutableSet *singleOperandOperation=[NSMutableSet setWithObjects:@"sqrt",@"sin",@"cos", nil];
    NSMutableSet *noOperandOperation=[NSMutableSet setWithObjects:@"π", nil];
    NSMutableSet *variable=[NSMutableSet setWithObjects:@"x",@"y",@"foo", nil];
    if ([twoOperandOperation containsObject:string])return @"twoOperandOperation";
    else if ([singleOperandOperation containsObject:string])return @"singleOperandOperation";
    else if ([noOperandOperation containsObject:string])return @"noOperandOperation";
    else if ([variable containsObject:string]) return @"variable";
    else return nil;
}

- (void)pushVariable:(NSString *)variable
{
    [self.operandStack addObject:variable];
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.operandStack addObject:operation];
    if (![self.operandStack containsObject:@"x"])
    {
        return [[self class] runProgram:self.program];
    }
    else return 0;
}

+ (double)popOperandOffOperandstack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffOperandstack:stack] + [self popOperandOffOperandstack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffOperandstack:stack] * [self popOperandOffOperandstack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffOperandstack:stack];
            result = [self popOperandOffOperandstack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"])
        {
            double divisor = [self popOperandOffOperandstack:stack];
            if (divisor) result = [self popOperandOffOperandstack:stack] / divisor;
        }
        else if ([operation isEqualToString:@"π"])
        {
            result = M_PI;
        }
        else if ([operation isEqualToString:@"sqrt"])
        {
            double operd = [self popOperandOffOperandstack:stack];
            if (operd)
                result = sqrt(operd);
        }
        else if ([operation isEqualToString:@"cos"])
        {
            double operd = [self popOperandOffOperandstack:stack];
            if (operd) result = cos(operd);
        }
        else if([operation isEqualToString:@"sin"])
        {
            double operd = [self popOperandOffOperandstack:stack];
            if (operd) result = sin(operd);
        }
    }
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self popOperandOffOperandstack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    // Ensure program is an NSArray
    if ([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    
    //loop to replace variables with corresponding values in dictionary
    for (int i=0; i<[stack count]; i++)
    {
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"x"])
        {
            //convert NSString object to NSNumber object
            NSString *myString = [variableValues valueForKey:@"x"];
            NSNumber *myNumber = [NSNumber numberWithDouble:[myString doubleValue]];
            //replace "x" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"y"])
        {
            //convert NSString object to NSNumber object
            NSString *myString = [variableValues valueForKey:@"y"];
            NSNumber *myNumber = [NSNumber numberWithDouble:[myString doubleValue]];
            //replace "y" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]]&&[[stack objectAtIndex:i] isEqualToString:@"foo"])
        {
            //convert NSString object to NSNumber object
            NSString *myString = [variableValues valueForKey:@"foo"];
            NSNumber *myNumber = [NSNumber numberWithDouble:[myString doubleValue]];
            //replace "foo" with some value
            [stack replaceObjectAtIndex:i withObject:myNumber];
        }
    }
    return [self popOperandOffOperandstack:stack];
}

+ (NSMutableSet *)variablesUsedInProgram:(id)program
{
    //check if program contains variables
     NSMutableSet *variablesSetUsedInProgram;
   
    
    if (!variablesSetUsedInProgram) variablesSetUsedInProgram = [[NSMutableSet alloc] init];

    
    if ([program containsObject:@"x"])
    {
      [variablesSetUsedInProgram addObject:@"x"];  
    }
    if ([program containsObject:@"y"])
    {   [variablesSetUsedInProgram addObject:@"y"];
    }
    if ([program containsObject:@"foo"])
    {   [variablesSetUsedInProgram addObject:@"foo"];
    }
    
    if ([variablesSetUsedInProgram count] ==0)
    {   variablesSetUsedInProgram =nil;
    }
    return variablesSetUsedInProgram;
}

-(void) emptyStack
{
    [self.operandStack removeAllObjects];
}

@end
