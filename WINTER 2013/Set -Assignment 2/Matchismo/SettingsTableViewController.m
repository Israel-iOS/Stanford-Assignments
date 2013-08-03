//
//  SettingsTableViewController.m
//  Matchismo
//
//  Created by Apple on 05/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "PlayingCardDesk.h"
#import "GameResult.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void) showClearAlertMessage
{
    NSString *message = [NSString stringWithFormat:@"Are you sure want to clear all scores?"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear scores"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Cancel", nil];
    alert.tag = 0;
    
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

            if ([title isEqualToString:@"OK"])
            {
                [GameResult clearAllGameScores];
            }
}

- (void) showEditAlert
{
    NSString *message = [NSString stringWithFormat:@"Please, enter new amount playing cards"];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Number of playing cards"
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"Confirm"
                                           otherButtonTitles:@"Cancel", nil];
    alert.tag = 1;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"Cards amount";
    
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showClearAlertMessage];
    }
    else if (indexPath.row == 1) {
        [self showEditAlert];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)synchronize
{
     [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
