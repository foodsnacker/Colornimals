//
//  TierObject.m
//  Colornimals
//
//  Created by Jörg Burbach on 14.12.14.
//  Copyright (c) 2014 quadWorks. All rights reserved.
//

#import "TierObject.h"
#import "AppDelegate.h"

@implementation TierObject {
    NSTimer * animTimer;
    float     animFrames;
    float     animIncX;
    float     animIncY;
    CGRect    animCurrentFrame;
    
    UIColor * targetcolor;
}

AppDelegate *appdelegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setLabel:(CGRect) myframe withtext:(NSString *) mytext withcolor:(UIColor *) mycolor withfont:(UIFont *) myfont withtag:(int) mytag {
    [self setFrame:myframe];
    [self setText:mytext];
    [self setFont:myfont];
    [self setTextColor:mycolor];
    [self setTag:mytag];
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setAdjustsFontSizeToFitWidth:YES];
    [self setUserInteractionEnabled:YES];
    targetcolor = mycolor;
}

- (TierObject *) init {
    appdelegate = [[UIApplication sharedApplication] delegate];

    TierObject * newTier = [[TierObject alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return newTier;
}

- (void) Remove {
    if (animTimer) {
        [animTimer invalidate];
        animTimer = nil;
    }
    [self removeFromSuperview];
}

- (void) moveme {
    // Position Object
    animCurrentFrame.origin.x += animIncX;
    animCurrentFrame.origin.y += animIncY;

    [self setFrame:animCurrentFrame];

    if ( animCurrentFrame.origin.x > 320 ) [self Remove];
}

- (void) animateFromTo:(CGRect) fromFrame withToFrame:(CGRect) toFrame withSpeed:(float) mySpeed {
    float myx = fromFrame.origin.x;
    if ( myx < 0 ) myx = - myx;
    
    animCurrentFrame = fromFrame;
    animFrames       = mySpeed * 33;
    animIncX         = (myx + toFrame.origin.x) / animFrames;
    animIncY         = (fromFrame.origin.y - toFrame.origin.y) / animFrames;

    animTimer = [NSTimer scheduledTimerWithTimeInterval:mySpeed / 100 target:self selector:@selector(moveme) userInfo:nil repeats:YES];
}

- (UILabel *)copyLabel:(UILabel *)label {
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject: label];
    UILabel* copy = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    return copy;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Check and remove?
    if (( appdelegate.targettag1 == self.tag ) ||
        ( appdelegate.targettag2 == self.tag ) ||
        ( appdelegate.targettag3 == self.tag ) ||
        ( appdelegate.targettag4 == self.tag )) {
        
        CATransform3D bigger  = CATransform3DMakeScale(1.25f, 1.25f, 1.25f);
        CATransform3D smaller = CATransform3DMakeScale( .25f,  .25f,  .25f);
        
        // Add Score
        appdelegate.score++;

        [appdelegate playid:1];
        
        // if color is correct, add another point
//        if ( self.textColor == targetcolor ) appdelegate.score ++;
        
        // make bigger, then smaller
        [UIView animateWithDuration:0.10
                         animations:^(void) {
                             [self.layer setTransform:bigger];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.25
                                              animations:^(void) {
                                                  [self.layer setTransform:smaller];
                                              }
                                              completion:^(BOOL finished) {
                                                [self Remove];
                                              } ];
                         } ];
    } else {
        // Bummer, did not fit. YOU LOSE ONE POINT!
        appdelegate.score--;
        [appdelegate playid:0];
    }
}

@end
