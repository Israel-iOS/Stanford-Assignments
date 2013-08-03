//
//  ClacBrain.h
//  Assignment2
//
//  Created by Apple on 09/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClacBrain : NSObject



- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)emptyStack;
- (void)pushVariable:(NSString *) variable;
- (void)clearTopOfOperandstack;
+ (NSMutableSet *)variablesUsedInProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

@property (nonatomic, readonly) id program;

 @end
