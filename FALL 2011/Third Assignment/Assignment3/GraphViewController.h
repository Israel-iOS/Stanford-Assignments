//
//  GraphViewController.h
//  Assignment3
//
//  Created by Apple on 15/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "CalculatorViewController.h"

 @interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>
 //conforms to protocol because GraphViewController will be the one to show split button
 
 @property (nonatomic,strong) UIBarButtonItem *splitViewBarButtonItem;
 
 @property (nonatomic,strong) id program; //model of this mvc, a stack,its value will be sagued from CalculatorViewController
 
 @property (weak, nonatomic) IBOutlet UILabel *displayOfExpression;//the one to display

 @property (strong,nonatomic) UILabel *displaySagued;// the one to receive sague data

 @property (weak, nonatomic) IBOutlet UILabel *result;

 @end
