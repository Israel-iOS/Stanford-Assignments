//
//  FlipResultView.h
//  GraphicalSet
//
//  Created by Apple on 08/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipResultView : UIView

@property (nonatomic) CGFloat cardSubviewDisplayRatio;

- (void)displayResultString:(NSString *)result;

- (void)displayResultString:(NSString *)result
           withCardSubviews:(NSArray *)cardSubviews
               displayRatio:(CGFloat)displayRatio;

@end
