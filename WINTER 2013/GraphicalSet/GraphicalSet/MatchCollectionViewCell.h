//
//  MatchCollectionViewCell.h
//  GraphicalSet
//
//  Created by Apple on 10/07/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSNumber *score;

- (void)setCardView:(UIView *)cardView atPosition:(NSUInteger)position;

@end
