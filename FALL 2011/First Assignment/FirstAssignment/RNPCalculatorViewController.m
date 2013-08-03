//
//  RNPCalculatorViewController.m
//  FirstAssignment
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "RNPCalculatorViewController.h"
#import "CalculatorBrain.h"

@interface RNPCalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic,strong) CalculatorBrain *brain;

@end

@implementation RNPCalculatorViewController

- (CalculatorBrain *)brain      // initializing brain operation
{
    if (_brain == nil) 
        _brain = [[CalculatorBrain alloc]init];
        return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
    {
    NSString *digit = [sender currentTitle];    
    if (self.userIsInTheMiddleOfEnteringANumber == YES)
    {
        self.display.text = [self.display.text stringByAppendingFormat:@"%@",digit];
    }
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.history.text = [self.history.text stringByAppendingFormat:@" "];
    self.history.text = [self.history.text stringByAppendingString:self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operations:(id)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    // updating display label
    self.display.text = [NSString stringWithFormat:@"%g", result];
    // updating history label
    self.history.text = [self.history.text stringByAppendingFormat:@" "];
    self.history.text = [self.history.text stringByAppendingFormat:@"%@", operation];
    self.history.text = [self.history.text stringByAppendingFormat:@" = " ];
    self.history.text = [self.history.text stringByAppendingString:self.display.text];    
}

- (IBAction)clear:(id)sender
{
    [self.brain emptyStack];
    self.display.text = @"0";
    self.history.text = @" ";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)pointPressed
{
    //Check if there is a . already in the number inside display label
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) 
    {
        //user did not press . button
        self.display.text = [self.display.text stringByAppendingFormat:@"."];
    }
    self.userIsInTheMiddleOfEnteringANumber = YES;
}

@end
