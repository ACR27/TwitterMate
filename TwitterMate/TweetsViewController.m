//
//  TweetsViewController.m
//  TwitterMate
//
//  Created by Rao, Amar on 2/3/14.
//  Copyright (c) 2014 Rao, Amar. All rights reserved.
//

#import "TweetsViewController.h"
#import "UNIRest.h"
#import "Tweet.h"
#import "TouchDownGestureRecognizer.h"
#import "TouchUpGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>
#import "constants.h"

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define IMAGE_CENTER_X 160
#define IMAGE_CENTER_Y 226
#define BOUNDS 50

@interface TweetsViewController ()

@property (nonatomic, readwrite) NSMutableArray* tweets;
@property (nonatomic, readwrite) NSMutableArray* tweets_seen;
@property (nonatomic, readwrite) CGPoint priorPoint;
@property (nonatomic, readwrite) float currentLat;
@property (nonatomic, readwrite) float currentLng;
@property (nonatomic, readwrite) Tweet* defaultTweet;
@property (nonatomic, readwrite) Tweet* blankTweet;
@property (nonatomic, readwrite) Tweet* loadingTweet;
@property (nonatomic, readwrite) Tweet* currentTweet;

@end

@implementation TweetsViewController

@synthesize text,name,time;
@synthesize backText,backName,backTime;
@synthesize swapText,swapName,swapTime;
@synthesize firstView, secondImage, swapImage;
@synthesize locationManager;
@synthesize userId, twitter_handle, user_name;
@synthesize currentLat,currentLng;
@synthesize usernameLabel;
@synthesize defaultTweet, blankTweet, loadingTweet;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [locationManager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _tweets = [[NSMutableArray alloc] init];
    _tweets_seen = [[NSMutableArray alloc] init];
    
    usernameLabel.text = user_name;
    
    
    //Set up location Manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [firstView setUserInteractionEnabled:NO];
    
    defaultTweet.name = @"";
    defaultTweet.text = @"No More Tweets!";
    defaultTweet.time = @"";
    
    blankTweet.name = @"";
    blankTweet.text = @"";
    blankTweet.time = @"";
    
    loadingTweet.name = @"";
    loadingTweet.text = @"Loading...";
    loadingTweet.time = @"";
    
    [self setTopTweet:loadingTweet];
    [self setBottomTweet:blankTweet];
    
    
}


-(void) getMoreTweets {
    
    NSString* url = [NSString stringWithFormat:@"%@/api/getLocalTweets", BASE_URL];
    NSDictionary* headers = @{@"accept": @"application/json"};
    NSDictionary* parameters = @{
                                 @"lat": [NSString stringWithFormat:@"%f", currentLat],
                                 @"lng": [NSString stringWithFormat:@"%f", currentLng],
                                 @"user_id": userId};
    [[UNIRest get:^(UNISimpleRequest* request) {
        [request setUrl:url];
        [request setParameters:parameters];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        [response.body.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Tweet * tweet = [[Tweet alloc] init];
            tweet.tweet_id = [NSString stringWithFormat:@"%@", [((NSDictionary*) obj) objectForKey:(@"twitter_id")]];
            tweet.text = [((NSDictionary*) obj) objectForKey:(@"text")];
            tweet.name = [((NSDictionary*) obj) objectForKey:(@"name")];
            tweet.time = [((NSDictionary*) obj) objectForKey:(@"time")];
            [_tweets addObject:tweet];
        }];
        NSLog(@"GOT %d TWEETS!!!", [_tweets count]);
        if([_tweets count] > 0) {
            [self displayNextTweet];
        }
        [firstView setUserInteractionEnabled:YES];
    }];
}


-(void)likeTweet:(Tweet*)tweet {
    if(tweet != nil) {
        NSDictionary* parameters = @{@"twitter_id": tweet.tweet_id, @"text": tweet.text, @"user_id": userId};

        [[UNIRest post:^(UNISimpleRequest* request) {
            [request setUrl:[NSString stringWithFormat:@"%@/api/likeTweet", BASE_URL]];
            [request setParameters:parameters];
        }] asJson];
    }
}

-(void)dislikeTweet:(Tweet*)tweet {
    if(tweet != nil) {
        NSDictionary* parameters = @{@"twitter_id": tweet.tweet_id, @"text": tweet.text, @"user_id": userId};
        
        [[UNIRest post:^(UNISimpleRequest* request) {
            [request setUrl:[NSString stringWithFormat:@"%@/api/dislikeTweet", BASE_URL]];
            [request setParameters:parameters];
        }] asJson];
    }
}
#pragma mark Location Manager Delegates
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *lo = [locations objectAtIndex:0];
    currentLat = lo.coordinate.latitude;
    currentLng = lo.coordinate.longitude;
    NSLog(@"latitude = %f, longitude = %f", lo.coordinate.latitude, lo.coordinate.longitude);
    [self getMoreTweets];
    
    [manager stopUpdatingHeading];
    [manager stopUpdatingLocation];
}

- (void) animateView:(UIView*)view toPoint:(int)x withAngle:(int)angle {
//    swapImage = [[UIView alloc] initWithFrame:view.frame];
//    swapImage.transform = view.transform;
//    swapImage.bounds = view.bounds;
//    
//    
//    swapName.text = name.text;
//    swapText.text = text.text;
//    swapTime.text = time.text;
//    [swapImage setHidden:NO];
    [view setHidden:YES];
    
//    [UIView animateWithDuration:0.5f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^(void) {
//                        [swapImage setCenter:CGPointMake(x, IMAGE_CENTER_Y)];
//                         CGAffineTransform rotationTransform = CGAffineTransformIdentity;
//                         rotationTransform = CGAffineTransformRotate(rotationTransform, DEGREES_RADIANS(angle));
//                         swapImage.transform = rotationTransform;
//                     }
//                     completion:^(BOOL finished) {
//                        [swapImage setHidden:YES];
//                     }];
//    
    
    
    [self displayNextTweet];
    [view setBounds:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    [view setCenter:CGPointMake(IMAGE_CENTER_X, IMAGE_CENTER_Y)];
    [view setHidden:NO];
}

/**
 Displays the next tweet in the tweet array.
 */
-(void) displayNextTweet {
    if([_tweets count] == 0) {
        [self setTopTweet:defaultTweet];
        NSLog(@"no tweets");
        [firstView setUserInteractionEnabled:NO];
        return;
    } else {
        Tweet* first = [_tweets objectAtIndex:0];
        _currentTweet = first;
        NSLog(@"%@", first.name);
        [self setTopTweet:first];
        
        NSLog(@"setting top");
        [firstView setUserInteractionEnabled:YES];
    
        if([_tweets count] > 1) {
            [self setTopTweet:first];
            if([_tweets count] > 2) {
                Tweet* second = [_tweets objectAtIndex:1];
                [self setBottomTweet:second];
            } else {
                [self setBottomTweet:defaultTweet];
            }
        }
        
        if([_tweets count] < 5) {
            NSLog(@"Loading More Tweets");
            [self getMoreTweets];
        }
    }
    [_tweets removeObjectAtIndex:0];
}


-(void) setTopTweet:(Tweet*) tweet {
    name.text = tweet.name;
    text.text = tweet.text;
    time.text = tweet.time;
}

-(void) setBottomTweet:(Tweet*) tweet {
    backName.text = tweet.name;
    backText.text = tweet.text;
    backTime.text = tweet.time;
}

#pragma mark Gesture Recognizers
-(void)selectionDetected:(UILongPressGestureRecognizer*)sender
{
    if(sender.state==1)
    {
        // Have image hover add shadow
        sender.view.layer.shadowColor = [UIColor blackColor].CGColor;
        sender.view.layer.shadowOffset = CGSizeMake(0, 3);
        sender.view.layer.shadowOpacity = 0.5;
        sender.view.layer.shadowRadius = 10.0;
    }
    else if(sender.state==3)
    {
        Tweet* tweet = nil;
        if([_tweets count] > 0) {
            tweet = (Tweet*)[_tweets objectAtIndex:0];
        }
        // If the image was liked
        if(sender.view.center.x > self.view.bounds.size.width - BOUNDS) {
            [self performSelectorInBackground:@selector(likeTweet:) withObject:_currentTweet];
            
            // Make a copy of the view and have that animate off of the screen.
            [self animateView:sender.view toPoint:900 withAngle:80];
            
        }
        // If the image was disliked
        else if(sender.view.center.x < BOUNDS) {
            [self performSelectorInBackground:@selector(dislikeTweet:) withObject:_currentTweet];
            [self animateView:sender.view toPoint:-900 withAngle:-80];
        }
        // Image was released, go back to the center.
        else {
            

            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                             animations:^(void) {
                                 [sender.view setBounds:CGRectMake(0, 0, sender.view.bounds.size.width, sender.view.bounds.size.height)];
                                 [sender.view setCenter:CGPointMake(IMAGE_CENTER_X, IMAGE_CENTER_Y)];
                             }
                             completion:NULL];
        }
        sender.view.transform = CGAffineTransformIdentity;
        firstView.layer.shadowColor = [UIColor clearColor].CGColor;
    }
    
    UIView *view = sender.view;
    CGPoint point = [sender locationInView:view.superview];
    
    //Pan
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat xDist = point.x - _priorPoint.x;
        //CGFloat yDist = point.y - _priorPoint.y;
        
        CGPoint center = view.center;
        center.x += xDist;
        //center.y += yDist;
        
        // Swiping to the right (Rotate Image)
        if(xDist > 0) {
            if (sender.view.center.x > IMAGE_CENTER_X) {
                [self rotateView:sender.view degrees:10];
            }
        }
        
        // Swiping to the left (Rotate Image)
        else if(xDist < 0) {
            if(sender.view.center.x < IMAGE_CENTER_X) {
                [self rotateView:sender.view degrees:-10];
            }
        } 
        
        view.center = center;
    }
    _priorPoint = point;
}

-(void) rotateView:(UIView*) view degrees:(int)degrees {
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         CGAffineTransform rt = CGAffineTransformIdentity;
                         rt = CGAffineTransformRotate(rt, DEGREES_RADIANS(degrees));
                         view.transform = rt;
                     }
                     completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
