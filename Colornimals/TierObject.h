//
//  TierObject.h
//  Colornimals
//
//  Created by Jörg Burbach on 14.12.14.
//  Copyright (c) 2014 quadWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TierObject : UILabel

- (TierObject *) init;
- (void) Remove;

- (void) setLabel:(CGRect) myframe withtext:(NSString *) mytext withcolor:(UIColor *) mycolor withfont:(UIFont *) myfont withtag:(int) mytag;

- (void) animateFromTo:(CGRect) fromFrame withToFrame:(CGRect) toFrame withSpeed:(float) mySpeed;

@end
