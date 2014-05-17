//
//  ViewController.m
//  Sentry Remote
//
//  Created by Mukund Tibrewala on 16/5/14.
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
    UIImage *btnImage = [UIImage imageNamed:@"Button_Bluetooth_Disconnect.png"];
    [self.buttonConnect setImage:btnImage forState:UIControlStateNormal];
}

- (void) bleDidDisconnect
{
    UIImage *btnImage = [UIImage imageNamed:@"Button_Bluetooth_Connect.png"];
    [self.buttonConnect setImage:btnImage forState:UIControlStateNormal];
}

-(IBAction)arm:(id)sender
{
    unsigned char toSend = 'k';
    //'k' for kill
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
    
    self.indicator.image = [UIImage imageNamed:@"Indicator_Enabled.png"];
}

-(IBAction)disarm:(id)sender
{
    unsigned char toSend = 'l';
    //'l' for life
    
    NSData *data = [NSData dataWithBytes: &toSend length: sizeof(toSend)];
    
    [bleShield write:data];
    
    self.indicator.image = [UIImage imageNamed:@"Indicator_Disabled.png"];
}

@end
