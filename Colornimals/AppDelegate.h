//
//  AppDelegate.h
//  Colornimals
//
//  Created by Jörg Burbach on 10.12.14.
//  Copyright (c) 2014 quadWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) int       score;
@property (nonatomic) int       hiscore;

@property (nonatomic) int       targettag1;
@property (nonatomic) int       targettag2;
@property (nonatomic) int       targettag3;
@property (nonatomic) int       targettag4;

@property (nonatomic) bool      isGameCenter;
@property (nonatomic) GKLocalPlayer * localPlayer;
@property (strong,nonatomic) NSArray * myscores;

// Sounds
@property (nonatomic) SystemSoundID wrong;
@property (nonatomic) SystemSoundID sound1;
@property (nonatomic) SystemSoundID sound2;
@property (nonatomic) SystemSoundID sound3;

-(void) playid:(int) num;

@end

