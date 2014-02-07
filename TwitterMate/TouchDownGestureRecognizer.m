//
//  TouchDownGestureRecognizer.m
//  AmazonSwag
//
//  Created by Rao, Amar on 7/11/13.
//  Copyright (c) 2013 Rao, Amar. All rights reserved.
//

#import "TouchDownGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TouchDownGestureRecognizer

    -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
        if (self.state == UIGestureRecognizerStatePossible) {
            self.state = UIGestureRecognizerStateRecognized;
        }
    }

@end
