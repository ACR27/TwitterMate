//
//  UserInfoViewController.h
//  TwitterMate
//
//  Created by Rao, Amar on 2/5/14.
//  Copyright (c) 2014 Rao, Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, readwrite) NSString* userId;
@property (nonatomic, readwrite) NSString* twitter_handle;

@property (nonatomic, readwrite) IBOutlet UITextField* name;
@property (nonatomic, readwrite) IBOutlet UIButton* male;
@property (nonatomic, readwrite) IBOutlet UIButton* female;


- (IBAction)finishLogin;
- (IBAction)maleSelected;
- (IBAction)femaleSelected;

@end
