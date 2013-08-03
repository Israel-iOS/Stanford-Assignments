//
//  CalculatorViewController.m
//  Assignment3
//
//  Created by Apple on 15/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL goingtopressbutton;
@property (nonatomic,strong) CalculatorBrain *brain;
@property (nonatomic,strong) NSDictionary *testVariableValues;


@end

@implementation CalculatorViewController


@synthesize goingtopressbutton = _goingtopressbutton;
@synthesize brain = _brain;
@synthesize display = _display;
@synthesize descriptionOfProgram = _descriptionOfProgram;
@synthesize testVariableValues = _testVariableValues;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate=self;
    //everytime awake from nip myself will control the split button
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
//ask the result must conform to the protocol, then it has the splitViewBarButtonItem to use in the next three methods
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)])
    {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
    //only hide the detail VC when it's iPad and on portrait orientation
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //put the button up
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //take the button away
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

- (CalculatorBrain *)brain
{
    if (_brain == nil)
        _brain = [[CalculatorBrain alloc]init];
    return _brain;
}

- (NSDictionary *)testVariableValues
{
    if(!_testVariableValues)
        _testVariableValues = [[NSDictionary alloc]init];
    return _testVariableValues;
}

- (IBAction)undo
{
    // Clearing the last object in the display
    if (self.goingtopressbutton && self.display.text.length>1)
    {
        //remove the last digit from number
        self.display.text=[self.display.text substringToIndex:self.display.text.length-1];
    }
    else
    {
        //clear top of stack and update display
        [self.brain clearTopOfOperandStack];
        self.display.text = @"0";
        self.descriptionOfProgram.text = [[CalculatorBrain class] descriptionOfProgram:self.brain.program];
    }
    // Clearing the last or top object of memory (Stack)
    [self.brain clearTopOfOperandStack];
}

- (IBAction)variablesPressed:(UIButton *)sender
{
    if (self.goingtopressbutton)
    {
        [self enterPressed];
    }
    [self.brain pushVariable:sender.currentTitle];
    self.display.text = sender.currentTitle;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    
    if (self.goingtopressbutton == YES)
    {
        self.display.text = [self.display.text stringByAppendingFormat:@"%@",digit];
    }
    else
    {
        self.display.text = digit;
        self.goingtopressbutton = YES;
    }
}

- (IBAction)pointPressed
{
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    self.goingtopressbutton = YES;
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.goingtopressbutton = NO;
    self.descriptionOfProgram.text = [[CalculatorBrain class] descriptionOfProgram:self.brain.program];
}

- (IBAction)operations:(UIButton *)sender
{
    if (self.goingtopressbutton)
    {
        [self enterPressed];
    }
    if ([self.brain.program count]>0)   //ignore user's pressing operation at the beginning
    {
        double result = [self.brain performOperation:sender.currentTitle];
        self.display.text = [NSString stringWithFormat:@"%g",result];
        self.descriptionOfProgram.text = [[CalculatorBrain class] descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)clear
{
    self.display.text = @"0";
    self.goingtopressbutton = NO;
    [self.brain emptyStack];
    self.descriptionOfProgram.text = nil;
}

- (GraphViewController *)graphViewController
{
    return [self.splitViewController.viewControllers lastObject];
}

-(GraphViewController *)splitViewGraphViewController
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphViewController class]]) gvc = nil;
    return gvc;
}// to get the gvc, because this method clearly define the result as a GraphViewController to be used in next method.

- (IBAction)graphButtonPressed
{
    if ([self splitViewGraphViewController])
    {//ipad
        [self splitViewGraphViewController].program = self.brain.program;
        [self splitViewGraphViewController].displaySagued = self.descriptionOfProgram;
    }
     
   if ([self graphViewController])
   {
        [[self graphViewController] setProgram:self.brain.program];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setProgram:self.brain.program];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //ipad support autoroation, iphone only support portrait (though its graph does support)
    return [self splitViewBarButtonItemPresenter] ? YES : toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    self.title = @"Calculator";
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setDisplay:nil];
    [self setDescriptionOfProgram:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
