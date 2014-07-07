//
//  ViewController.h
//  Remote-Sentry-Gun
//
//  Created by Mukund Tibrewala on 13/2/14.
//  www.mukundt.com
//  Copyright (c) 2014 Project Sentry Gun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"
#import "MotionJpegImageView.h"

@interface ViewController : UIViewController <BLEDelegate> {
    BLE *bleShield;
@private
    MotionJpegImageView *_imageView;
    BOOL isEnabled;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;
@property (weak, nonatomic) IBOutlet UIButton *buttonFire;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
@property (weak, nonatomic) IBOutlet UIButton *buttonUp;
@property (weak, nonatomic) IBOutlet UIButton *buttonDown;
@property (weak, nonatomic) IBOutlet UIButton *buttonEnable;

@end
