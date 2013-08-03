//
//  CalculatorViewController.m
//  Assignment2
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfTyping;
@property (nonatomic,strong) NSDictionary *testVariableValues;
@property (nonatomic,strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

- (CalculatorBrain *)brain
{
    if (_brain == nil)
        _brain = [[CalculatorBrain alloc]init];
    return _brain;
}

- (NSDictionary *)testVariableValues{
    if(!_testVariableValues)
        _testVariableValues=[[NSDictionary alloc]init];
    return _testVariableValues;
}

- (IBAction)undo
{
    // Clearing the last object in the display
    if (self.userIsInTheMiddleOfTyping && self.display.text.length>1)
    {
        self.display.text=[self.display.text substringToIndex:self.display.text.length-1];
    }
    else
    {
        [self.brain clearTopOfOperandstack];
        self.display.text=@"0";
        self.descriptionOfProgram.text = [[CalculatorBrain class] descriptionOfProgram:self.brain.program];
    }
    [self.brain clearTopOfOperandstack];
}

- (IBAction)variablesPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfTyping)
    {
        [self enterPressed];
    }
    [self.brain pushVariable:sender.currentTitle];
    self.display.text = sender.currentTitle;
}



- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfTyping == YES)
    {
        self.display.text = [self.display.text stringByAppendingFormat:@"%@",digit];
    }
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfTyping = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfTyping = NO;
    self.descriptionOfProgram.text=[[CalculatorBrain class] descriptionOfProgram:self.brain.program];
}

- (IBAction)operations:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfTyping)
    {
        [self enterPressed];
    }
    //ignore user's pressing operation at the beginning
    if ([self.brain.program count]>0)
    {        double result = [self.brain performOperation:sender.currentTitle];
        self.display.text = [NSString stringWithFormat:@"%g",result];
        self.descriptionOfProgram.text=[[CalculatorBrain class] descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)clear
{
    self.display.text = @"0";
    self.userIsInTheMiddleOfTyping= NO;
    [self.brain emptyStack];
    self.descriptionOfProgram.text=nil;
}

- (IBAction)testPressed:(UIButton *)sender
{
    //set testVariableValues to some preset testing values
    if ([sender.currentTitle isEqualToString:@"Test 1"])
    {
        self.testVariableValues = @{ @"x": @5, @"y": @10, @"foo": @1 };
    }
    if ([sender.currentTitle isEqualToString:@"Test 2"])
    {
        self.testVariableValues = @{ @"x": @-5, @"y": @-10, @"foo": @-3 };
    }
    if ([sender.currentTitle isEqualToString:@"Test 3"])
    {
        self.testVariableValues=nil;
    }
    self.descriptionOfProgram.text=[[CalculatorBrain class] descriptionOfProgram:self.brain.program];
    self.variablesDisplay.text=nil;
    
    NSMutableSet *variablesUsedSet = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    NSArray *variablesUsedArray = [variablesUsedSet allObjects];
    
    if ([self.testVariableValues count]>0)
    {
        for (int i=0; i<[variablesUsedArray count]; i++)
        {
            if (!self.variablesDisplay.text)
            {
                self.variablesDisplay.text = [NSString stringWithFormat:@"%@ = %@ ", [variablesUsedArray objectAtIndex:i], [self.testVariableValues valueForKey:[variablesUsedArray objectAtIndex:i]]];
            }
            else
            {
                self.variablesDisplay.text = [NSString stringWithFormat:@"%@ = %@ ", [variablesUsedArray objectAtIndex:i], [self.testVariableValues valueForKey:[variablesUsedArray objectAtIndex:i]]];
            }
        }
    }
    else
    {
        self.variablesDisplay.text=nil;
    }
    //run program
    double result=[[self.brain class] runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g",result];
}

- (IBAction)pointPressed
{
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    self.userIsInTheMiddleOfTyping = YES;
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setVariablesDisplay:nil];
    [self setVariablesDisplay:nil];
    [self setDescriptionOfProgram:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
