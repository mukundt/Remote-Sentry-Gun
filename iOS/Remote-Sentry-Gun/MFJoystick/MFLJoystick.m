//
//  MFJoystick.m
//  
//
//  Created by teejay on 5/14/13.
//  Copyright (c) 2013 teejay. All rights reserved.
//

#import "MFLJoystick.h"

@interface MFLJoystick ()

@property BOOL isTouching;

@property CGFloat moveViscosity;
@property CGFloat smallestPossible;
@property CGPoint defaultPoint;

@property UIImageView *bgImageView;
@property UIImageView *thumbImageView;
@property UIView *handle;

@end

@implementation MFLJoystick

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setDefaultValues];
        [self roundView:self toDiameter:self.bounds.size.width];
        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                                                                     self.bounds.size.height)];
        [self roundView:_bgImageView toDiameter:_bgImageView.bounds.size.width];
        [self addSubview:_bgImageView];
        
        [self makeHandle];
        [self animate];
        [self notifyDelegate];
    }
    
    return self;
}

- (void)setDefaultValues
{
    _moveViscosity = 14;
    _smallestPossible = 0.09;
    _updateInterval = 1.0/45;
}

- (void)makeHandle
{
    self.handle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
    [self.handle setCenter:CGPointMake(self.bounds.size.width/2,
                                       self.bounds.size.height/2)];
    self.defaultPoint = self.handle.center;
    [self roundView:self.handle toDiameter:self.handle.bounds.size.width];
    [self addSubview:self.handle];
    
    self.thumbImageView = [[UIImageView alloc] initWithFrame:self.handle.frame];
    [self addSubview:self.thumbImageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:.2 animations:^{
        
    }];
    
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[touches allObjects] objectAtIndex:0];
    CGPoint currentPos = [myTouch locationInView: self];
    
    //else
    CGPoint selfCenter = CGPointMake(self.bounds.origin.x+self.bounds.size.width/2,
                                     self.bounds.origin.y+self.bounds.size.height/2);
    CGFloat selfRadius = self.bounds.size.width/2 - 34;
    
    if (DistanceBetweenTwoPoints(currentPos, selfCenter) > selfRadius) {
        double vX = currentPos.x - selfCenter.x;
        double vY = currentPos.y - selfCenter.y;
        double magV = sqrt(vX*vX + vY*vY);
        currentPos.x = selfCenter.x + vX / magV * selfRadius;
        currentPos.y = selfCenter.y + vY / magV * selfRadius;
    }
    
    [UIView animateWithDuration:.1 animations:^{
        self.thumbImageView.center = currentPos;
    }];
    
    self.handle.center = currentPos;
    self.isTouching = TRUE;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:.4 animations:^{
        
    }];
    [self.delegate joystick:self didUpdate:CGPointZero];
    self.isTouching = FALSE;
}

- (BOOL)checkPoint:(CGPoint)point isInCircle:(CGPoint)center withRadius:(CGFloat)radius
{
    return (powf(point.x-center.x, 2) + powf(point.y-center.y, 2) < powf(radius, 2));
}

- (void)animate
{
    if (!self.isTouching)
    {
        //move the handle back to the default position
        CGFloat newX = self.handle.center.x;
        CGFloat newY = self.handle.center.y;
        CGFloat dx = fabsf(newX - self.defaultPoint.x);
        CGFloat dy = fabsf(newY - self.defaultPoint.y);
        
        if (self.handle.center.x > self.defaultPoint.x)
        {
            newX = self.handle.center.x - dx/self.moveViscosity;
        } else if (self.handle.center.x < self.defaultPoint.x) {
            newX = self.handle.center.x + dx/self.moveViscosity;
        }
        
        if (self.handle.center.y > self.defaultPoint.y) {
            newY = self.handle.center.y - dy/self.moveViscosity;
        } else if (self.handle.center.y < self.defaultPoint.y) {
            newY = self.handle.center.y + dy/self.moveViscosity;
        }

        if (fabsf(dx/self.moveViscosity) < self.smallestPossible &&
            fabsf(dy/self.moveViscosity) < self.smallestPossible)
        {
            newX = self.defaultPoint.x;
            newY = self.defaultPoint.y;
        }
        
        self.handle.center = CGPointMake(newX, newY);
        self.thumbImageView.center = self.handle.center;
    }
    [self performSelector:@selector(animate) withObject:nil afterDelay:1/45];
}

- (void)notifyDelegate
{
    if (self.isTouching)
    {
        CGPoint degreeOfPosition = CGPointMake((self.handle.frame.origin.x/self.handle.frame.size.width)*2,
                                               (self.handle.frame.origin.y/self.handle.frame.size.height)*-2);
        [self.delegate joystick:self didUpdate:degreeOfPosition];
    }
    
    [self performSelector:@selector(notifyDelegate) withObject:nil afterDelay:self.updateInterval];

}

- (void)setMovementUpdateInterval:(CGFloat)interval
{
    if (interval <= 0) {
        self.updateInterval = 1.0;
    } else {
        self.updateInterval = interval;
    }
}
- (void)setMoveViscosity:(CGFloat)mv andSmallestValue:(CGFloat)sv
{
    self.moveViscosity = mv;
    self.smallestPossible = sv;
}

- (void)setThumbImage:(UIImage *)thumbImage andBGImage:(UIImage *)bgImage
{
    self.thumbImageView.image = thumbImage;
    self.bgImageView.image = bgImage;
}

- (void)roundView:(UIView *)roundedView toDiameter:(float)newSize
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

#pragma mark Geometry Methods

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

@end
