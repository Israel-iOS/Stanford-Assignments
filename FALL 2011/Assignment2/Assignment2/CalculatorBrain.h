//
//  CalculatorBrain.h
//  Assignment2
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)pushVariable:(NSString *) variable;
- (void)clearTopOfOperandstack;
- (void)emptyStack;

+ (NSMutableSet *)variablesUsedInProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

@property (nonatomic, readonly) id program;

@end

