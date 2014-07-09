//
//  ViewController.m
//  Remote-Sentry-Gun
//
//  Created by Mukund Tibrewala on 13/2/14.
//  www.mukundt.com
//  Copyright (c) 2014 Project Sentry Gun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <JoystickDelegate>

@end

@implementation ViewController

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSURL *url = [NSURL URLWithString:@"http://admin:password@192.168.1.5/video/mjpg.cgi"];
    NSURL *url = [NSURL URLWithString:@"http://shibuya.ipcam.jp:60001/nphMotionJpeg?Resolution=320x240&Quality=Standard"];

    _imageView = [[MotionJpegImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x,
[[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width)];
    _imageView.url = url;
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_imageView];
    [self.view sendSubviewToBack:_imageView];
    [_imageView play];
    
    MFLJoystick *joystick = [[MFLJoystick alloc] initWithFrame:CGRectMake(426, 165, 128, 128)];
    [joystick setThumbImage:[UIImage imageNamed:@"joystick.png"]
                 andBGImage:[UIImage imageNamed:@"dpad.png"]];
    [joystick setDelegate:self];
    // Minimum 200 ms interval between packets
    [joystick setMovementUpdateInterval:0.2];
    [self.view addSubview:joystick];
    
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BLEShieldScan:(id)sender
{
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
            return;
        }
    
    if (bleShield.peripherals)
        bleShield.peripherals = nil;
    
    [bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
}


// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
}

-(void) bleDidConnect
{
    UIImage *btnImage = [UIImage imageNamed:@"disconnect.png"];
    [self.buttonConnect setImage:btnImage forState:UIControlStateNormal];
}

- (void) bleDidDisconnect
{
    UIImage *btnImage = [UIImage imageNamed:@"connect.png"];
    [self.buttonConnect setImage:btnImage forState:UIControlStateNormal];
}

// Refer to communications protocol
- (void)joystick:(MFLJoystick *)aJoystick didUpdate:(CGPoint)dir
{
    double rad = atan2(30 * dir.y, 30 * dir.x);
    double deg = (rad > 0 ? rad : (2*M_PI + rad)) * 360 / (2*M_PI);

    unsigned char quad = 'q';
    
    if (45 <= deg) quad = 'w';
    
    if (90 <= deg) quad = 'e';
    
    if (135 <= deg) quad = 'r';
    
    if (180 <= deg) quad = 't';
    
    if (225 <= deg) quad = 'y';
    
    if (270 <= deg) quad = 'u';
    
    if (315 <= deg) quad = 'i';
    
    double dist = sqrt(dir.x * dir.x + dir.y*dir.y);
    
    unsigned char speed = '0';
    
    if (dist > 0) speed = '1';
    
    if (dist > 0.1) speed = '2';
    
    if (dist > 0.2) speed = '3';
    
    if (dist > 0.3) speed = '4';
    
    if (dist > 0.4) speed = '5';
    
    [self sendMovement:quad withArg2:speed];
}

- (void)sendMovement:(unsigned char)quad withArg2:(unsigned char)speed
{
    NSLog(@"%c", quad);
    NSLog(@"%c", speed);
    
    NSData *data = [NSData dataWithBytes: &quad length: sizeof(quad)];
    
    [bleShield write:data];
    
    data = [NSData dataWithBytes: &speed length: sizeof(speed)];
    
    [bleShield write:data];
}

- (IBAction)startFire:(id)sender
{
    unsigned char toSend = 'f';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
}

- (IBAction)endFire:(id)sender
{
    unsigned char toSend = 'n';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
}

-(IBAction)enableOrDisable:(id)sender
{
    if (isEnabled)
    {
        unsigned char toSend = 'l';
        //'l' for life
        
        NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
        
        [bleShield write:data];
        
        isEnabled = false;
        
        UIImage *btnImage = [UIImage imageNamed:@"enable.png"];
        [self.buttonEnable setImage:btnImage forState:UIControlStateNormal];
    }
    
    else
    {
        unsigned char toSend = 'k';
        //'k' for kill
        
        NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
        
        [bleShield write:data];
        
        isEnabled = true;
        
        UIImage *btnImage = [UIImage imageNamed:@"disable.png"];
        [self.buttonEnable setImage:btnImage forState:UIControlStateNormal];
        
    }
}

@end
