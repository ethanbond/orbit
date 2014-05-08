//
//  CelestialBody.m
//  orbit
//
//  Created by Ethan Bond on 4/24/14.
//  Copyright (c) 2014 Ethan Bond. All rights reserved.
//

#import "Body.h"


@implementation Body : SKNode {
}

@synthesize type;
@synthesize mass;
@synthesize radius;
@synthesize color;

-(id)initBodyWithRadius:(CGFloat)Radius position:(CGPoint)Position color:(UIColor*)Color type:(NSString*)Type inScene:(SKScene*)Scene {
    
    NSLog(@"Body initializer called.");
    self = [super init];
    NSLog(@"Body: self initialized.");
    
    if(self){
        NSLog(@"Body: self retained.");
        // Initialize SKSpriteNode with radius, image, color
        
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Planet.png"];

        [sprite setSize:CGSizeMake(Radius*2, Radius*2)];
        [sprite setColor:Color];
        [sprite setColorBlendFactor:0.5f];
        NSLog(@"Body: Sprite created.");
        
        // Initialize SKPhysicsBody
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:Radius];
        self.physicsBody.mass = (Radius*Radius)/100;
        self.physicsBody.dynamic = NO;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.linearDamping = 0.0f;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        NSLog(@"Body: PhysicsBody created.");
        
        // Add SKSpriteNode to Body self
        [self addChild:sprite];
        [sprite setZPosition:1.0];
        NSLog(@"Body: sprite added to self.");
        
        // Populate properties
        self.type = Type;
        self.name = Type;
        self.position = Position;
        self.mass = (Radius*Radius)/100;
        self.radius = Radius;
        self.color = Color;

        NSLog(@"Body: Properties updated.");
        NSLog(@"Body: \n Type: %@ \n Position: <%f, %f> \n Mass: %f \n Radius: %f \n Color: %@", self.type, self.position.x, self.position.y, self.mass, self.radius, self.color);
        

        
    }
    
    return self;
}

-(void)makeDynamic{
    self.physicsBody.dynamic = YES;
}

-(void)makeStationary {
    self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
}

-(void)makePlayerInScene:(SKScene*)scene {
    self.physicsBody.dynamic = YES;

    NSString *trailPath = [[NSBundle mainBundle] pathForResource:@"trail" ofType:@"sks"];
    SKEmitterNode* emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:trailPath];
    emitter.targetNode = scene;
    [emitter setName:@"Emitter"];
    [self addChild:emitter];
    [emitter setZPosition:-1.0];
    emitter.particleScale = self.radius/100;

}


-(void)explodeInScene:(SKScene*)view{
    [[self childNodeWithName:@"Emitter"] removeFromParent];
    NSString *trailPath = [[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"sks"];
    SKEmitterNode* emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:trailPath];
    emitter.targetNode = view;
    emitter.position = self.position;
    [emitter setName:@"Explosion"];
    [view addChild:emitter];
    
    SKAction* wait = [SKAction waitForDuration:10.0];
    SKAction* delete = [SKAction removeFromParent];
    SKAction* waitThenDestroy = [SKAction sequence:@[wait, delete]];
    
//    [self removeFromParent];
    [emitter runAction:waitThenDestroy];
}

-(void)remove {
    SKAction* fade = [SKAction fadeAlphaTo:0 duration:0.2];
    SKAction* shrink = [SKAction scaleTo:0.0 duration:0.01*radius];
    SKAction* fadeAndShrink = [SKAction group:@[fade, shrink]];
    SKAction* delete = [SKAction removeFromParent];
    SKAction* sequence = [SKAction sequence:@[fadeAndShrink, delete]];
    [[self childNodeWithName:@"Emitter"] removeFromParent];
    [self runAction:sequence];
}


-(BOOL)isWithinBounds:(CGRect)bounds{
    if(!(self.position.x > -100) || self.position.x > CGRectGetWidth(bounds) + 100 || !(self.position.y > -100) || self.position.y > CGRectGetHeight(bounds) + 100){
        return NO;
    }
    return YES;
}



@end
