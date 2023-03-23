//
//  ViewController.h
//  Colornimals
//
//  Created by Jörg Burbach on 10.12.14.
//  Copyright (c) 2014 quadWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController <ADBannerViewDelegate>

// Titleimage
@property (weak, nonatomic) IBOutlet UIImageView * titleimg;

// Score
@property (weak, nonatomic) IBOutlet UILabel *punkte;
@property (weak, nonatomic) IBOutlet UILabel *timerlabel;
@property (weak, nonatomic) IBOutlet UIImageView *hiscoreimage;

// Animals
@property (weak, nonatomic) IBOutlet UILabel *animal1;
@property (weak, nonatomic) IBOutlet UILabel *animal2;
@property (weak, nonatomic) IBOutlet UILabel *animal3;
@property (weak, nonatomic) IBOutlet UILabel *animal4;

// Animalwalking
@property (weak, nonatomic) IBOutlet UIScrollView *playfield;

// iAd
@property (weak, nonatomic) IBOutlet ADBannerView *iAdBanner;
@property (nonatomic, assign) BOOL bannerIsVisible;

// Result
@property (weak, nonatomic) IBOutlet UIScrollView *scoreframe;
@property (weak, nonatomic) IBOutlet UILabel *result_score;
@property (weak, nonatomic) IBOutlet UILabel *hiscore;

- (IBAction)sharetwitter:(id)sender;
- (IBAction)sharescore:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fbbutton;
@property (weak, nonatomic) IBOutlet UIButton *twbutton;

// Game-Functions
- (IBAction) startgame:(id)sender;

@end

