//
//  Tweet.h
//  TwitterMate
//
//  Created by Rao, Amar on 2/4/14.
//  Copyright (c) 2014 Rao, Amar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic,readwrite) NSString* tweet_id;
@property (nonatomic,readwrite) NSString* time;
@property (nonatomic,readwrite) NSString* text;
@property (nonatomic,readwrite) NSString* name;

@end
