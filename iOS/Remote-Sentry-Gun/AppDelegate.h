//
//  AppDelegate.h
//  Remote-Sentry-Gun
//
//  Created by Mukund Tibrewala on 13/2/14.
//  www.mukundt.com
//  Copyright (c) 2014 Project Sentry Gun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionJpegImageView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    @private
        MotionJpegImageView *_imageView;
}

@property (strong, nonatomic) UIWindow *window;

@end
