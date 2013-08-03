//
//  RNPCalculatorViewController.h
//  FirstAssignment
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNPCalculatorViewController : UIViewController

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operations:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)enterPressed;
- (IBAction)pointPressed;

@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *display;

@end
