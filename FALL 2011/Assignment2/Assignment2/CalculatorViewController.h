//
//  CalculatorViewController.h
//  Assignment2
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
  

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)variablesPressed:(UIButton *)sender;
- (IBAction)testPressed:(UIButton *)sender;
- (IBAction)operations:(UIButton *)sender;
- (IBAction)undo;
- (IBAction)clear;
- (IBAction)enterPressed;
- (IBAction)pointPressed;

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOfProgram;
@property (weak, nonatomic) IBOutlet UILabel *variablesDisplay;

@end
