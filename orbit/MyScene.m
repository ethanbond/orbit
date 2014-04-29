//
//  MyScene.m
//  orbit
//
//  Created by Ethan Bond on 4/22/14.
//  Copyright (c) 2014 Ethan Bond. All rights reserved.
//

#import "MyScene.h"
#import "Body.h"

@implementation MyScene
CGFloat G = -0.067;


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.11 green:0.145 blue:0.173 alpha:1];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        [myLabel setName:@"Label"];
        
        myLabel.text = @"O R B I T";
        myLabel.fontSize = 10;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMaxY(self.frame)-50);
        
        [self addChild:myLabel];
        
        
        
    }
    return self;
}

-(CGVector)calculateForceFromA:(Body*)a toB:(Body*)b {
    if(a == b){return CGVectorMake(0.f, 0.f);}
    CGPoint aPos = [a position];
    CGPoint bPos = [b position];
    
    CGFloat aMass = a.mass;
    CGFloat dx, dy;
    dx = aPos.x - bPos.x;
    dy = aPos.y - bPos.y;

    CGVector force = CGVectorMake(dx*aMass/10.f, dy*aMass/10.f);
    
    return force;
}


-(Body*) newEntityAtLocation:(CGPoint)_location
                radius:(double)_radius
                color:(UIColor*)_color{
    Body* entity = [[Body alloc] initWithSize:_radius position:_location color:_color];
    [entity setName:@"Body"];
    return entity;
}

-(void)spawnTest {
    Body* s = [self newEntityAtLocation:CGPointMake(
                                                        CGRectGetMidX(self.frame),
                                                        CGRectGetMaxY(self.frame)-100
                                                                   ) radius:5 color:[UIColor colorWithRed:0.756 green:0.798 blue:0.754 alpha:1.000]];
    

    s.satellite = YES;
    s.name = @"Satellite";
    s.physicsBody.dynamic = YES;
    s.physicsBody.restitution = 0.001;
    s.physicsBody.friction = 0.9;
    
    self.satellite = s;
    
//    
//    NSString *trailPath = [[NSBundle mainBundle] pathForResource:@"trail" ofType:@"sks"];
//    SKEmitterNode* emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:trailPath];
//    emitter.targetNode = self;
//    [emitter setName:@"Emitter"];
//    [satellite addChild:emitter];
    
    [self addChild:s];
//    [satellite.physicsBody applyForce:CGVectorMake(0, -100) ];
}


-(double)calcR:(NSTimeInterval)duration {
    duration = duration*100;
    return duration+1;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        double stamp = [touch timestamp];
        self.timer = stamp;
        SKNode* target = [self nodeAtPoint:[touch locationInNode:self]];
        if(target != self){
            if([target name] == @"Label"){
                [self spawnTest];
            } else {
                [[target childNodeWithName:@"Emitter"] removeFromParent];
                Body* t = target;
                [t remove];
                self.timer = 0;
            }
        }
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.timer == 0){return;} // If an object was just deleted, don't continue
    NSTimeInterval ended;
    for (UITouch *touch in touches) {
        double stamp = [touch timestamp];
        ended = [touch timestamp];
        CGPoint location = [touch locationInNode:self];
        
        double duration = stamp - self.timer;
        if (duration > 0.1){
            Body* earth = [self newEntityAtLocation:location radius:[self calcR:(stamp-self.timer)] color:[UIColor colorWithRed:20.f green:20.f blue:20.f alpha:100.f]];
            [self addChild:earth];
        }
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
//
//    Body* satellite = [self childNodeWithName:@"Satellite"];
////    [self enumerateChildNodesWithName:@"Satellite" usingBlock:^(SKNode *satellite, BOOL *stop) {
//        __block CGVector finalForce = CGVectorMake(0, 0);
//        [self enumerateChildNodesWithName:@"Planet" usingBlock:^(SKNode *planet, BOOL *stop) {
//            CGVector T = [self calculateForceFromA:planet toB:satellite];
//            finalForce.dx += T.dx;
//            finalForce.dy += T.dy;
//        }];
//        [satellite.physicsBody applyForce:finalForce];
//        
//        if(!(satellite.position.x > -100) || satellite.position.x > CGRectGetWidth(self.view.bounds) + 100 || !(satellite.position.y > -100) || satellite.position.y > CGRectGetHeight(self.view.bounds) + 100 ){
//            [[satellite childNodeWithName:@"Emitter"] removeFromParent];
//            [satellite removeFromParent];
//            [self spawnTest];
//            
//        }
////    }];
//
    
    __block CGVector force = CGVectorMake(0.0, 0.0);
    [self enumerateChildNodesWithName:@"Body" usingBlock:^(SKNode *body, BOOL *stop) {
        force.dx += [self calculateForceFromA:body toB:self.satellite].dx;
        force.dy += [self calculateForceFromA:body toB:self.satellite].dy;
    }];
    [self.satellite.physicsBody applyForce:force];
    
    


    
}

@end
