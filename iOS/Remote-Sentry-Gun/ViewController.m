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
    
   /* UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_temp.jpg"]];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView]; */
    
    //self.view.backgroundColor = [UIColor greenColor];
    
   /* _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0,0.0,640.0,480.0)];
    _webView.userInteractionEnabled = NO;
    CGFloat scaleRatio = self.view.bounds.size.width / _webView.bounds.size.width;
    CGAffineTransform scalingTransform =
    CGAffineTransformScale(CGAffineTransformIdentity, scaleRatio, scaleRatio);
    [_webView setTransform:scalingTransform];
    CGRect webFrame = _webView.frame;
    webFrame.origin.y = 0.0;
    webFrame.origin.x = 0.0;
    _webView.frame = webFrame;*/
    
    NSURL *url = [NSURL URLWithString:@"http://admin:rudolphlabs@192.168.1.5/video/mjpg.cgi"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    //  [self.window addSubview:_webView];
    
  //  webFrame.origin.y += webFrame.size.height;
    _imageView = [[MotionJpegImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.height, self.view.bounds.size.width)];
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
    
    [self.spinner startAnimating];
}


// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [self.spinner stopAnimating];
    }
}

-(void) bleDidConnect
{
    [self.spinner stopAnimating];
    [self.buttonConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
}

- (void) bleDidDisconnect
{
    [self.buttonConnect setTitle:@"Connect" forState:UIControlStateNormal];
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


@end
