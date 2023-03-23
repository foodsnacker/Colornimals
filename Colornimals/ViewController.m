//
//  ViewController.m
//  Colornimals
//
//  Created by Jörg Burbach on 10.12.14.
//  Copyright (c) 2014 quadWorks. All rights reserved.
//

//Todo:
//- höhere Punktzahlen
//- combos mit Multiplikatoren
//- höhere Geschwindigkeit ab bestimmen Punktzahlen, etwa ab 10, 20, 50, etc.
//- aufs Display anpassen
//- mehr Effekte beim entfernen
//- punktzahl kurz springen lassen
//- sound für jedes Tier

#import "ViewController.h"
#import "TierObject.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <GameKit/GameKit.h>

@interface ViewController ()

@end

@implementation ViewController

// Achievements

#define kLeaderboardID @"Hiscores";
#define k10points      @"10points";
#define k20points      @"20points";
#define k50points      @"50points";
#define k100points     @"100points";
#define kdouble        @"double";
#define ktriple        @"triple";

// more
AppDelegate *appdelegate;

#define maxchars 10
#define animaltime 4.0f
#define maxnewanimal 3
#define maxcolors 10

@synthesize titleimg;
@synthesize hiscoreimage;

UIFont  * MyFont;
UIFont  * MyBigFont;

// 4 parts -> in Objekt
NSString * Chars[4];
UIColor  * Cols[4];
int        cnts[4];

NSArray  * colors;
NSString * mychars;

UILabel  * tierLabel[4];
@synthesize animal1;
@synthesize animal2;
@synthesize animal3;
@synthesize animal4;

// iAd
@synthesize bannerIsVisible;
@synthesize iAdBanner;

// Score & Timer
@synthesize punkte;
@synthesize timerlabel;
int timer;
NSTimer * mytimer;

// Share
@synthesize fbbutton;
@synthesize twbutton;

// Neue Objekte
NSTimer * myTierTimer;
@synthesize playfield; // Playfield for Animals

// Results
@synthesize scoreframe;
@synthesize result_score;
@synthesize hiscore;

- (void) counttimer {
    
    timer--;
    [timerlabel setText:[NSString stringWithFormat:@"%i",timer]];
    [punkte setText:[NSString stringWithFormat:@"%i",appdelegate.score]];
    
    // Check Achievements
    [self checkAchievement];
    
    if ( timer == 0 ) {
            
            // check, if hiscore
            if (appdelegate.hiscore < appdelegate.score) {
                appdelegate.hiscore = appdelegate.score;
                
                if ( hiscoreimage.alpha != 1.0f ) {
                    [UIView animateWithDuration:0.25
                                     animations:^(void) {
                                         hiscoreimage.alpha = 1.0f;
                                     }
                     ];
                }

                [hiscore setText:[NSString stringWithFormat:@"Hiscore: %i",appdelegate.hiscore]];
                [[NSUserDefaults standardUserDefaults] setInteger:appdelegate.hiscore forKey:@"hiscore"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }

            [self.view bringSubviewToFront:scoreframe];
            
            [result_score setText:[NSString stringWithFormat:@"%i",appdelegate.score]];
            [UIView animateWithDuration:0.5f animations:^(void) {
                scoreframe.alpha = 1.0f;
                punkte.alpha = 0.0f;
                timerlabel.alpha = 0.0f;
            } ];
            
            // Remove Animal-Labels
            for (int i=0;i<4;i++) { // tierLabel[i].alpha = 0.0f;
                [UIView animateWithDuration:0.25 + (i * 0.2) animations:^(void) { tierLabel[i].alpha = 0.0f; } ];
            }

            // Show FB-Button
            if ( fbbutton.alpha == 0 ) [UIView animateWithDuration:2.0f animations:^(void) { fbbutton.alpha = 1.0f; } ];
        
            // Show Twitter-Button
            if ( twbutton.alpha == 0 ) [UIView animateWithDuration:2.0f animations:^(void) { twbutton.alpha = 1.0f; } ];
            
            // Show Title
            [UIView animateWithDuration:1.0f animations:^(void) { titleimg.alpha = 1.0f; } ];
            [myTierTimer invalidate];
            myTierTimer = nil;
            [mytimer invalidate];
            mytimer = nil;
            
            // Send Scores to Game Center
            [self submitMyScore];
        }
}

- (void) startLetter {
    int yh;
    int yh2;
    int myCharTag;
    
    for (int i=0; i< maxnewanimal; i++) {
    // Random position
        yh  = arc4random() % ( (int)playfield.frame.size.height );
        yh2 = arc4random() % ( (int)playfield.frame.size.height );
        myCharTag = arc4random() % ( maxchars );
    
        // Make Frames
        CGRect startFrame = CGRectMake(-100,  yh, 100, 100);
        CGRect toFrame    = CGRectMake( 320, yh2, 100, 100);
    
        TierObject * newTier = [TierObject new];
        [newTier setLabel:startFrame
                 withtext:[NSString stringWithFormat:@"%c",[mychars characterAtIndex:myCharTag]]
                withcolor:colors[arc4random() % ( maxcolors )]
                 withfont:MyBigFont
                  withtag:myCharTag];
        
        [newTier animateFromTo:startFrame withToFrame:toFrame withSpeed:animaltime];

        [playfield addSubview:newTier];
    }
    
}

- (void) getrandomcolors:(int) num {
    int n = arc4random() % ( maxcolors );
    Cols[num] = [colors objectAtIndex:n];
}

- (void) getrandomchars:(int) num {
    int n = arc4random() % ( maxchars);
    
    switch (num) {
        default:
        case 0 :
            appdelegate.targettag1 = n;
            Chars[0] = [NSString stringWithFormat:@"%c",[mychars characterAtIndex:appdelegate.targettag1]];
            break;
        case 1 :
            while (n == appdelegate.targettag1) n = arc4random() % ( maxchars);
            appdelegate.targettag2 = n;
            Chars[1] = [NSString stringWithFormat:@"%c",[mychars characterAtIndex:appdelegate.targettag2]];
            break;
        case 2 :
            while ((n == appdelegate.targettag1) || (n == appdelegate.targettag2)) n = arc4random() % ( maxchars);
            appdelegate.targettag3 = n;
            Chars[2] = [NSString stringWithFormat:@"%c",[mychars characterAtIndex:appdelegate.targettag3]];
            break;
        case 3 :
            while ((n == appdelegate.targettag1) || (n == appdelegate.targettag2) || (n == appdelegate.targettag3)) n = arc4random() % ( maxchars);
            appdelegate.targettag4 = n;
            Chars[3] = [NSString stringWithFormat:@"%c",[mychars characterAtIndex:appdelegate.targettag4]];
            break;
    }

}

// Set the 4 Labels
- (void) setfour:(int) num {
    [tierLabel[num] setText:Chars[num]];
    [tierLabel[num] setTextColor:Cols[num]];
    [tierLabel[num] setTag:cnts[num]];
    [tierLabel[num] setFont:MyFont];
}

- (void) resetfour {
    for (int i=0; i<4;i++) {
        [self getrandomcolors:i];
        [self getrandomchars:i];
        [self setfour:i];
        [UIView animateWithDuration:0.25 + (i * 0.2) animations:^(void) { tierLabel[i].alpha = 1.0f; } ];
    }
}

- (IBAction) startgame:(id)sender {
    [self resetfour];
    
    // remove score
    if (scoreframe.alpha == 1)
        [UIView animateWithDuration:0.5f
                         animations:^(void) {
                             scoreframe.alpha = 0.0f;
                             punkte.alpha = 1.0f;
                             timerlabel.alpha = 1.0f;
                             if ( fbbutton.alpha == 1.0f) { fbbutton.alpha = 0; }
                             if ( twbutton.alpha == 1.0f) { twbutton.alpha = 0; }
                         }
                         completion:^(BOOL finished) {
                             mytimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(counttimer) userInfo:nil repeats:YES];
                             
                             // bring Animals
                             myTierTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startLetter) userInfo:nil repeats:YES];
                         } ];
    
    // Hide Titleimage
    if (titleimg.alpha > 0.3) [UIView animateWithDuration:2.0f animations:^(void) { titleimg.alpha = 0.3; } ];
    if (hiscoreimage.alpha != 0) [UIView animateWithDuration:2.0f animations:^(void) { hiscoreimage.alpha = 0.0; } ];
    
    // Timer vorbereiten
    timer = 60;
    appdelegate.score = 0;
    [punkte setText:@"0"];
    [timerlabel setText:@"60"];

}

- (void)viewDidLoad {
    appdelegate = [[UIApplication sharedApplication] delegate];

    // start iAD
    iAdBanner.delegate=self;
    bannerIsVisible=NO;

    
    mychars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    colors = [NSArray arrayWithObjects:
                        [UIColor redColor],      [UIColor blueColor],
                        [UIColor greenColor],    [UIColor yellowColor],
                        [UIColor brownColor],    [UIColor cyanColor],
                        [UIColor magentaColor],  [UIColor orangeColor],
                        [UIColor purpleColor],   [UIColor whiteColor], nil];
//                        [UIColor darkGrayColor], [UIColor lightGrayColor],
//                        [UIColor grayColor],     nil];
    
    MyFont    = [UIFont fontWithName:@"Animals" size:33.0f];
    MyBigFont = [UIFont fontWithName:@"Animals" size:60.0f];

    // Hide Animal-Labels
    animal1.alpha = 0.0f;
    animal2.alpha = 0.0f;
    animal3.alpha = 0.0f;
    animal4.alpha = 0.0f;

    tierLabel[0] = animal1;
    tierLabel[1] = animal2;
    tierLabel[2] = animal3;
    tierLabel[3] = animal4;
 
   // change score
    [result_score setText:@"0"];
    [hiscore setText:[NSString stringWithFormat:@"Hiscore: %i",appdelegate.hiscore]];
    
    [super viewDidLoad];

}

// Achievements
-(void)checkAchievement {
    float percent = 100.0f;
    NSString * identifier;
    
    switch (appdelegate.score) {
        case  10: identifier = k10points; break;
        case  20: identifier = k20points; break;
        case  50: identifier = k50points; break;
        case 100: identifier = k100points; break;
        default: return; break;
    }
    
    // Achievement already checked.
    if ([appdelegate.myscores containsObject:identifier]) return;

    // Do Achievment
    GKAchievement* achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    achievement.percentComplete = percent;
    achievement.showsCompletionBanner = YES;
    [achievement reportAchievementWithCompletionHandler: ^(NSError *error) { } ];
}

// Score for Leaderboard
-(void)submitMyScore {
    //This is the same category id you set in your itunes connect GameCenter LeaderBoard
    GKScore *myScoreValue = [[GKScore alloc] initWithLeaderboardIdentifier:@"Hiscores"];
    myScoreValue.value = appdelegate.score;
    
    [myScoreValue reportScoreWithCompletionHandler:^(NSError *error){
        if(error != nil){
            NSLog(@"Score Submission Failed");
        } else {
            NSLog(@"Score Submitted");
        } 
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner { }

//when any problems occured
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error { }

bool FacebookResult;
bool TwitterResult;

- (void) PostTwitter:(NSString*)text withLink:(NSString*)link withImage:(UIImage*)bild {
    TwitterResult = NO;
    
    SLComposeViewController *twittersheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if (twittersheet) {
        twittersheet.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultCancelled) TwitterResult = NO;
            if (result == SLComposeViewControllerResultDone) TwitterResult = YES;
            
            //  Tweet Sheet ausblenden
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{ }];
            });
        };
        
        // Text, Bild und URL ergänzen
        [twittersheet setInitialText:text];                                                //Add here your text
        if (bild != Nil)  { [twittersheet addImage:bild]; }                                //Add here the name of your picture     oder: [UIImage imageNamed:@"socialThumb.png"]
        if (![link isEqual:@""]) { [twittersheet addURL:[NSURL URLWithString:link]]; }     //Add here your Link
        [self presentViewController:twittersheet animated:YES completion:^(void) {} ];
        
        //       [twittersheet.view removeFromSuperview];
        twittersheet = nil;
    }
}

- (void) PostFacebook:(NSString*)text withLink:(NSString*)link withImage:(UIImage*)bild {
    FacebookResult = NO;
    
    SLComposeViewController *facebooksheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    if (facebooksheet) {
        facebooksheet.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultCancelled) FacebookResult = NO;
            if (result == SLComposeViewControllerResultDone) FacebookResult = YES;
            
            //  Tweet Sheet ausblenden
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{ }];
            });
        };
        
        // Text, Bild und URL ergänzen
        [facebooksheet setInitialText:text];                                                //Add here your text
        if (bild != Nil)  { [facebooksheet addImage:bild]; }                                //Add here the name of your picture     oder: [UIImage imageNamed:@"socialThumb.png"]
        if (![link isEqual:@""]) { [facebooksheet addURL:[NSURL URLWithString:link]]; }     //Add here your Link
        [self presentViewController:facebooksheet animated:YES completion:^(void) {} ];
        
        //       [facebooksheet.view removeFromSuperview];
        facebooksheet = nil;
    }
}

#define storelink @"http://bit.ly/1uLZbaW" // was https://itunes.apple.com/en/app/id951493036?mt=8

- (IBAction)sharetwitter:(id)sender {
    [self PostFacebook:[NSString stringWithFormat:@"Got a new score in #Colornimals: %i. Beat me! #hiscore #beatmequick #nicetry",appdelegate.score] withLink:storelink withImage:[UIImage imageNamed:@"Colornimals.png"]];
}

- (IBAction)sharescore:(id)sender {
    [self PostFacebook:[NSString stringWithFormat:@"Got a new score in #Colornimals: %i. Come on, beat me! #hiscore #beatmequick #nicetry",appdelegate.score] withLink:storelink withImage:[UIImage imageNamed:@"Colornimals.png"]];
}

@end
