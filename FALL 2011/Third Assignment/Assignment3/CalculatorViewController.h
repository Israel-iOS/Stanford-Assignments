//
//  CalculatorViewController.h
//  Assignment3
//
//  Created by Apple on 15/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate>


- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operations:(UIButton *)sender;
- (IBAction)variablesPressed:(UIButton *)sender;
- (IBAction)graphButtonPressed;
- (IBAction)pointPressed;
- (IBAction)enterPressed;
- (IBAction)clear;
- (IBAction)undo;

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOfProgram;

@end
