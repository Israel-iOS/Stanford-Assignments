//
//  GraphViewController.m
//  Assignment3
//
//  Created by Apple on 15/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
// Israel

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "GraphView.h"
#import "CalculatorViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController () <GraphViewDataSource>

@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation GraphViewController

@synthesize program = _program;
@synthesize graphView = _graphView;
@synthesize displaySagued = _displaySagued;
@synthesize displayOfExpression = _displayOfExpression;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize result;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem!=_splitViewBarButtonItem)
    {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items=toolbarItems;
        _splitViewBarButtonItem=splitViewBarButtonItem;
    }
}

//I have to add this otherwise iPad's expression not shown, detail reason not found
- (void) setProgram:(id)program
{
    _program = program;
    [self.graphView setNeedsDisplay];//update graph when program updated
     
    // We want to set the title of the controller if the program changes
    
    self.title = [NSString stringWithFormat:@"y = %@",[CalculatorBrain descriptionOfProgram:self.program]];
    
    // We want to update the graphView to set the starting values for the program.
    //In iPhone mode this method is called as part of prepareSegue, at which point the graphView
    //is not available, and so the call shouldn't do anything.
    [self refreshGraphViewProperties];
}

- (void)setDisplaySagued:(UILabel *)displaySagued
{
    _displaySagued=displaySagued;
    self.displayOfExpression.text = displaySagued.text;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    // Synchronize the view with the model
    if (self) { }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
 //   self.splitViewController.delegate = self;
    self.splitViewController.presentsWithGesture = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    // Only show the master controller in landscape mode
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    // Show the bar button item on the toolbar
    barButtonItem.title = aViewController.title;
    
    // Add the button to the toolbar
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems insertObject:barButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;   
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Hide the bar button item on the detail controller
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems removeObject:barButtonItem];
    self.toolbar.items = toolbarItems;
}

- (void)refreshGraphViewProperties
{
    // Need a program to recall scale and axis origin
    if (! self.program) return;
    
    // Need a graph view to set initial scale and axis origin
    if (! self.graphView) return;
    
    NSString *program = [CalculatorBrain descriptionOfProgram:self.program];
    
    // Retrieve the scale from storage
    float scale = [[NSUserDefaults standardUserDefaults]
                   floatForKey:[@"scale." stringByAppendingString:program]];
    
    // Retrieve the x axis origin from storage
    float xAxisOrigin = [[NSUserDefaults standardUserDefaults]
                         floatForKey:[@"x." stringByAppendingString:program]];
    
    // Retrieve the y axis origin from storage
    float yAxisOrigin = [[NSUserDefaults standardUserDefaults]
                         floatForKey:[@"y." stringByAppendingString:program]];
    
    // If we have scale in storage, then set this as the scale for the graph view
    if (scale) self.graphView.scale = scale;
    
    // If we have a value for the xAxisOrigin and yAxisOrigin then set it in the graph view
    if (xAxisOrigin && yAxisOrigin)
    {
        
        CGPoint axisOrigin;
        
        axisOrigin.x = xAxisOrigin;
        axisOrigin.y = yAxisOrigin;
        
        self.graphView.axisOrigin = axisOrigin;
    }
    
    // Refresh the graph View
    [self.graphView setNeedsDisplay];
}

-(void)setGraphView:(GraphView *)graphView
{
    self.displayOfExpression.text = self.displaySagued.text;//force to update text
    _graphView=graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tripleTap=[[UITapGestureRecognizer alloc]initWithTarget:self.graphView action:@selector(tripleTap:)];
    tripleTap.numberOfTapsRequired=3;
    
    [self.graphView addGestureRecognizer:tripleTap];
    
    self.graphView.dataSource=self; //assign self as delegate to graphView
}

- (void)storeScale:(float)scale ForGraphView:(GraphView *)sender
{    
    // Store the scale in user defaults
    [[NSUserDefaults standardUserDefaults]
     setFloat:scale forKey:[@"scale." stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.program]]];
    
    // Save the scale
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeAxisOriginX:(float)x andAxisOriginY:(float)y ForGraphView:(GraphView *)sender
{
    NSString *program = [CalculatorBrain descriptionOfProgram:self.program];
    
    // Store the x axis origin in user defaults
    [[NSUserDefaults standardUserDefaults] setFloat:x forKey:[@"x." stringByAppendingString:program]];
    
    // Store the y axis origin in user defaults
    [[NSUserDefaults standardUserDefaults] setFloat:y forKey:[@"y." stringByAppendingString:program]];
    
    // Save the axis origin
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (float)YValueForXValue:(float)xValue inGraphView:(GraphView *)sender
{
    // Find the corresponding Y value by passing the x value to the calculator Brain
    double yValue = [CalculatorBrain runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:xValue] forKey:@"x"]];
    
    return yValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.result.text=[NSString stringWithFormat:@"%@",[CalculatorBrain descriptionOfProgram:self.program]];
}


- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setResult:nil];
    [super viewDidUnload];
}

@end