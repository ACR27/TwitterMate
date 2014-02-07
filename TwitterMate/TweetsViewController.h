//
//  TweetsViewController.h
//  TwitterMate
//
//  Created by Rao, Amar on 2/3/14.
//  Copyright (c) 2014 Rao, Amar. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface TweetsViewController : ViewController <UIGestureRecognizerDelegate, CLLocationManagerDelegate>

@property (nonatomic,readwrite) IBOutlet UILabel* usernameLabel;


// Tweet Images
@property (nonatomic,readwrite) IBOutlet UILabel* text;
@property (nonatomic,readwrite) IBOutlet UILabel* name;
@property (nonatomic,readwrite) IBOutlet UILabel* time;

@property (nonatomic,readwrite) IBOutlet UILabel* backText;
@property (nonatomic,readwrite) IBOutlet UILabel* backName;
@property (nonatomic,readwrite) IBOutlet UILabel* backTime;

@property (nonatomic,readwrite) IBOutlet UILabel* swapText;
@property (nonatomic,readwrite) IBOutlet UILabel* swapName;
@property (nonatomic,readwrite) IBOutlet UILabel* swapTime;

@property (nonatomic,readwrite) IBOutlet UIView* firstView;
@property (nonatomic,readwrite) IBOutlet UIView* secondImage;
@property (nonatomic,readwrite) IBOutlet UIView* swapImage;

//Controller variables
@property (nonatomic,readwrite) CLLocationManager* locationManager;

@property (nonatomic, readwrite) NSString* userId;
@property (nonatomic, readwrite) NSString* twitter_handle;
@property (nonatomic, readwrite) NSString* user_name;

- (IBAction)selectionDetected:(UILongPressGestureRecognizer*)longPress;

@end
