//
//  JoystickScene.m
//  Remote Sentry Gun
//
//  Created by Mukund Tibrewala on 7/7/14.
//  Copyright (c) 2014 Project Sentry Gun. All rights reserved.
//

#import "JoystickScene.h"

@implementation JoystickScene

- (void)didMoveToView: (SKView *) view
{
    /*//NSURL *url = [NSURL URLWithString:@"http://admin:password@192.168.1.5/video/mjpg.cgi"];
    NSURL *url = [NSURL URLWithString:@"http://shibuya.ipcam.jp:60001/nphMotionJpeg?Resolution=320x240&Quality=Standard"];
    
    _imageView = [[MotionJpegImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x,
                                                                       [[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width)];
    _imageView.url = url;
    [self.view addSubview:_imageView];
    
    [self.view sendSubviewToBack:_imageView];
    [_imageView play];*/
    
    SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick.png"];
    SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad.png"];
    joystick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
    joystick.position = CGPointMake(jsBackdrop.size.width, jsBackdrop.size.height);
    velocityTick = [CADisplayLink displayLinkWithTarget:self selector:@selector(joystickMovement)];
    [velocityTick addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    joystick.zPosition = 1;
    [self addChild:joystick];
    
}

- (void)joystickMovement
{
   
}


@end
