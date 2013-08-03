//
//  CalculatorBrain.h
//  FirstAssignment
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)emptyStack;
- (void)pushVariable:(NSString *)variable;
- (void)clearTopOfOperandStack;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVaraibleValues:(NSDictionary *)variableValues;
+ (NSMutableArray *)variablesUsedInProgram:(id)program;

@property (nonatomic,readonly) id program;

@end
