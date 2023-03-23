//
//  AppDelegate.m
//  Colornimals
//
//  Created by Jörg Burbach on 10.12.14.
//  Copyright (c) 2014 quadWorks. All rights reserved.
//

#import "AppDelegate.h"
#import <GameKit/GameKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize score;
@synthesize hiscore;
@synthesize localPlayer;
@synthesize isGameCenter;
@synthesize myscores;

// Sounds
@synthesize wrong;
@synthesize sound1;
@synthesize sound2;
@synthesize sound3;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    score   = 0;
    hiscore = [[NSUserDefaults standardUserDefaults] integerForKey:@"hiscore"];
    
    // Authenticate Player with Game Center
    localPlayer = [GKLocalPlayer localPlayer];
    
    // Handle the call back from Game Center Authentication
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        isGameCenter = [[GKLocalPlayer localPlayer] isAuthenticated];
        
        // check Achievements
        if (!myscores) {
            [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                if(error != NULL) { NSLog(@"fehler: %@",error); }
                myscores = scores;
                NSLog(@"h%@",scores);
            }];
        }
     };
    
    // Sounds
    wrong  = [self initWithCafFile:@"00wrong"];
    sound1 = [self initWithCafFile:@"01"];
    sound2 = [self initWithCafFile:@"02"];
    sound3 = [self initWithCafFile:@"03"];

    return YES;
}

-(void) playid:(int) num {
    switch (num) {
        default: AudioServicesPlaySystemSound(wrong); break;
        case 1: AudioServicesPlaySystemSound(sound1); break;
        case 2: AudioServicesPlaySystemSound(sound2); break;
        case 3: AudioServicesPlaySystemSound(sound3); break;
    }
}

- (SystemSoundID) initWithCafFile: (NSString *)fileName {
    SystemSoundID mySound;
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *sURL = [NSURL fileURLWithPath:[mainBundle pathForResource:fileName ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sURL, &mySound);
    return mySound;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
