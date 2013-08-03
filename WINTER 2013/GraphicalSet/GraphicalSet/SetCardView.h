//
//  SetCardView.h
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger shade;
@property (nonatomic) NSUInteger color;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;

// Marks the card
- (void)mark;

@end
