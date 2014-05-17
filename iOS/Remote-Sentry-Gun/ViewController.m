//
//  ViewController.m
//  Remote-Sentry-Gun
//
//  Created by Mukund Tibrewala on 13/2/14.
//  www.mukundt.com
//  Copyright (c) 2014 Project Sentry Gun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"http://admin:password@192.168.1.5/video/mjpg.cgi"];
    //NSURL *url = [NSURL URLWithString:@"http://shibuya.ipcam.jp:60001/nphMotionJpeg?Resolution=320x240&Quality=Standard"];
    
    _imageView = [[MotionJpegImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x,
[[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width)];
    _imageView.url = url;
    [self.view addSubview:_imageView];
    [self.view sendSubviewToBack:_imageView];
    [_imageView play];
    
    
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
    self.RSG.textColor = [UIColor greenColor];
}

- (void) bleDidDisconnect
{
    self.RSG.textColor = [UIColor redColor];
}

- (IBAction)startFire:(id)sender
{
    //self.view.backgroundColor = [UIColor redColor];
    
    unsigned char toSend = 'f';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
    
    //test this by printing rec'd char at Arduino's side
}

- (IBAction)endFire:(id)sender
{
    
    //self.view.backgroundColor = [UIColor greenColor];
    
    unsigned char toSend = 'n';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
}

- (IBAction)startLeft:(id)sender
{
    unsigned char toSend = 'a';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
    
    //test this by printing rec'd char at Arduino's side
}

- (IBAction)startRight:(id)sender
{
    unsigned char toSend = 'd';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
    
    //test this by printing rec'd char at Arduino's side
}

- (IBAction)endPan:(id)sender
{
    unsigned char toSend = 'p';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
}

- (IBAction)startUp:(id)sender
{
    unsigned char toSend = 'w';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
    
    //test this by printing rec'd char at Arduino's side
}

- (IBAction)startDown:(id)sender
{
    unsigned char toSend = 's';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
    
    //test this by printing rec'd char at Arduino's side
}

- (IBAction)endTilt:(id)sender
{
    unsigned char toSend = 't';
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
}

-(IBAction)arm:(id)sender
{
    if (self.arm.on)
    {
        unsigned char toSend = 'k';
        //'k' for kill
        
        NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
        
        [bleShield write:data];
    }
    
    else
    {
        unsigned char toSend = 'l';
        //'l' for life
        
        NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
        
        [bleShield write:data];
    }
}


@end
