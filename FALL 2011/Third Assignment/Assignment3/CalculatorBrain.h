//
//  ClacBrain.h
//  Assignment2
//
//  Created by Apple on 09/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)pushVariable:(NSString *)variable;
- (void)clearTopOfOperandStack;
- (void)emptyStack;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSMutableSet *)variablesUsedInProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@property (nonatomic, readonly) id program;

 @end
