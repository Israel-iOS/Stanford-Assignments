//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Apple on 05/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()

@property (nonatomic) SEL sortSelector;

@property (weak, nonatomic) IBOutlet UITextView *resultsTextView;

@end

@implementation GameResultViewController

- (void)updateUI
{
    NSString *resultString = @"";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    
    for (GameResult *result in [[GameResult allResults] sortedArrayUsingSelector:self.sortSelector])
    
        resultString = [resultString stringByAppendingFormat:@"%@ score : %d \n (%@, %gs)\n \n",
                        result.gameName, result.score, [dateFormat stringFromDate:result.end], round(result.duration)];
    
    
    self.resultsTextView.text = resultString;
}

@synthesize sortSelector = _sortSelector;

- (SEL)sortSelector
{
    if (!_sortSelector) _sortSelector = @selector(compareScoreToGameResult:);
    return _sortSelector;
}

- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
}

- (IBAction)sortByDate
{
   self.sortSelector = @selector(compareEndDateToGameResult:); 
}

- (IBAction)sortByScore
{
    self.sortSelector = @selector(compareScoreToGameResult:);
}

- (IBAction)sortByDuration
{
    self.sortSelector = @selector(compareDurationToGameResult:);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
 self.view.backgroundColor = [[UIColor scrollViewTexturedBackgroundColor] colorWithAlphaComponent:1.0];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
