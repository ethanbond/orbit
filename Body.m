//
//  CelestialBody.m
//  orbit
//
//  Created by Ethan Bond on 4/24/14.
//  Copyright (c) 2014 Ethan Bond. All rights reserved.
//

#import "Body.h"


@implementation Body : SKShapeNode {
    
}
@synthesize target;
@synthesize satellite;
@synthesize radius;
@synthesize mass;


-(id)init {
    return [self initWithSize:10.f position:CGPointMake(10.f, 10.f) color:[UIColor colorWithRed:50.f green:50.f blue:200.f alpha:100.f]];
}
            
-(id)initWithSize:(CGFloat)size position:(CGPoint)position color:(UIColor*)color {
    self = [super init];
    if(self){
        radius = (size*size)/100;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, NULL, 0, 0, size, -M_PI_2, M_PI_2*3, NO);
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathCloseSubpath(path);
        self.path = path;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:size];
        self.physicsBody.mass = (size*size)/100;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = NO;
        self.physicsBody.linearDamping = 0.f;
        self.position = position;
        mass = self.physicsBody.mass;
        CGPathRelease(path);
        satellite = NO;
        target = NO;
        self.fillColor = color;
        self.lineWidth = 1;
        self.strokeColor = [SKColor colorWithRed:0.11 green:0.145 blue:0.173 alpha:1];

    }
    return self;
}

-(void)remove {
    SKAction* fade = [SKAction fadeAlphaTo:0 duration:0.2];
    SKAction* shrink = [SKAction scaleTo:0.0 duration:0.01*radius];
    SKAction* fadeAndShrink = [SKAction group:@[fade, shrink]];
    SKAction* delete = [SKAction removeFromParent];
    SKAction* sequence = [SKAction sequence:@[fadeAndShrink, delete]];
    [self runAction:sequence];
}



@end
