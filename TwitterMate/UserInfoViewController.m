//
//  UserInfoViewController.m
//  TwitterMate
//
//  Created by Rao, Amar on 2/5/14.
//  Copyright (c) 2014 Rao, Amar. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UNIRest.h"
#import "constants.h"
#import "TweetsViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

@synthesize userId, twitter_handle;
@synthesize name,male,female;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"GOT USER ID %@", userId);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void) finishLogin {
    int gender = [self getGender];
    if(name.text.length <= 0 || gender == 0) {
        // SEND UI ALERT MESSAGE
        
    } else {
        //    // Send in request to create user
        NSDictionary* headers = @{@"accept": @"application/json"};
        NSDictionary* parameters = @{@"twitter_id": userId, @"gender": [NSString stringWithFormat:@"%d",gender], @"name": name.text, @"twitter_handle": twitter_handle};
        
        UNIHTTPJsonResponse* response = [[UNIRest post:^(UNISimpleRequest* request) {
            [request setUrl:[NSString stringWithFormat:@"%@/api/createUser", BASE_URL]];
            [request setHeaders:headers];
            [request setParameters:parameters];
        }] asJson];
        NSDictionary* user = response.body.object;
        if (user != nil && [user objectForKey:@"exception"] == nil) {
            TweetsViewController* tweetView = [self.storyboard instantiateViewControllerWithIdentifier:@"tweets"];
            tweetView.userId = userId;
            tweetView.user_name = [user objectForKey:@"name"];
            tweetView.twitter_handle = twitter_handle;
            [self.navigationController presentViewController:tweetView animated:YES completion:^{
                
            }];
        } else {
            // Show warning message
        }
    }
}

- (int) getGender {
    if([male isSelected]) {
        return 1;
    } else if ([female isSelected]) {
        return 2;
    } else {
        return 0;
    }
}


- (IBAction)maleSelected {
    [male setSelected:YES];
    [female setSelected:NO];
}
- (IBAction)femaleSelected {
    [female setSelected:YES];
    [male setSelected:NO];
}


@end
