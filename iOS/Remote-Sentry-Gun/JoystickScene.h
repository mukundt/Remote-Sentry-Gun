//
//  JoystickScene.h
//  Remote Sentry Gun
//
//  Created by Mukund Tibrewala on 7/7/14.
//  Copyright (c) 2014 Project Sentry Gun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Joystick.h"
#import "MotionJpegImageView.h"

@interface JoystickScene : SKScene {

@private
MotionJpegImageView *_imageView;
}

@end

Joystick *joystick;
CADisplayLink *velocityTick;