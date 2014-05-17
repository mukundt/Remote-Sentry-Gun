//
//  ViewController.h
//  Sentry Remote
//
//  Created by Mukund Tibrewala on 16/5/14.
//  Copyright (c) 2014 Project Sentry Gun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ViewController : UIViewController <BLEDelegate> {
    BLE *bleShield;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonConnect;
@property (weak, nonatomic) IBOutlet UIImageView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *buttonEnable;
@property (weak, nonatomic) IBOutlet UIButton *buttonDisable;


@end
