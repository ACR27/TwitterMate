//
//  ViewController.m
//  TwitterMate
//
//  Created by Rao, Amar on 2/3/14.
//  Copyright (c) 2014 Rao, Amar. All rights reserved.
//

#import "ViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "STTwitterAPI.h"
#import "UNIRest.h"
#import "constants.h"
#import "UserInfoViewController.h"
#import "TweetsViewController.h"

@interface ViewController ()
@property (nonatomic) ACAccountStore *accountStore;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _accountStore = [[ACAccountStore alloc] init];
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil
                                                              consumerKey:@"AZvCPDEH6dntHVuVhZZYGg"
                                                           consumerSecret:@"OsVTBIG1KhRPRomGYYPWrfiNjrUM2kgWhVXtV7Dh4"];
    
    [twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        
        STTwitterAPI *twitterAPIOS = [STTwitterAPI twitterAPIOSWithFirstAccount];
        
        [twitterAPIOS verifyCredentialsWithSuccessBlock:^(NSString *username) {
            
            [twitterAPIOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                                successBlock:^(NSString *oAuthToken,
                                                                               NSString *oAuthTokenSecret,
                                                                               NSString *userID,
                                                                               NSString *screenName)
            {
                
                NSDictionary* headers = @{@"accept": @"application/json"};
                NSDictionary* parameters = @{@"twitter_id": userID};
                
                UNIHTTPJsonResponse* response = [[UNIRest get:^(UNISimpleRequest* request) {
                    [request setUrl:[NSString stringWithFormat:@"%@/api/tryLogin", BASE_URL]];
                    [request setHeaders:headers];
                    [request setParameters:parameters];
                }] asJson];
                if(response.body.object == nil) {
                    [self goToUserInfoPage:userID andName:screenName];
                } else {
                    NSString* name = [((NSDictionary*) response.body.object) objectForKey:@"name"];
                    [self goToTweetsPage:userID andName:name andHandle:screenName];
                }                                                   
                
            } errorBlock:^(NSError *error) {
                // ...
            }];
            
        } errorBlock:^(NSError *error) {
            // ...
        }];
        
    } errorBlock:^(NSError *error) {
        // ...
    }];
}


-(void) goToTweetsPage:(NSString*)userId andName:(NSString*) name andHandle:(NSString*)handle{
    
    TweetsViewController* tweetView = [self.storyboard instantiateViewControllerWithIdentifier:@"tweets"];
    tweetView.userId = userId;
    tweetView.user_name = name;
    tweetView.twitter_handle = handle;
    [self.navigationController presentViewController:tweetView animated:NO completion:^{
        
    }];
    
}

-(void)goToUserInfoPage:(NSString*)userId andName:(NSString*) name {
    UserInfoViewController* infoView = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfo"];
    infoView.userId = userId;
    infoView.twitter_handle = name;
    [self.navigationController presentViewController:infoView animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}

@end
