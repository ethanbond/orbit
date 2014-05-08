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
@synthesize scale;
@synthesize player;
CGFloat G = 1000;
NSString* goalName = @"Goal";
NSString* playerName = @"Player";
NSString* obstacleName = @"Obstacle";
NSString* bodyName = @"Body";


static const uint32_t goalCategory = 0x1 << 0;
static const uint32_t playerCategory = 0x1 << 1;
static const uint32_t obstacleCategory = 0x1 << 2;
static const uint32_t bodyCategory = 0x1 << 3;



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.11 green:0.145 blue:0.173 alpha:1];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        self.scale = 1;
        self.name = @"OrbitScene";
        
        [self spawnPlayer];
        
        
        // All of these work!
        [self spawnGoal];
        [self spawnGoal];
        [self spawnGoal];
        
        
    }
    return self;
}


-(Body*)spawnGoal {
    NSLog(@"New Goal created.");

    int x = arc4random() % (int)(CGRectGetWidth(self.frame));
    int y = arc4random() % (int)(CGRectGetHeight(self.frame));
    int r = (arc4random() % (1*10))+10;
    
    Body* g = [self newBodyWithRadius:r position:CGPointMake(x, y) color:[UIColor colorWithRed:0.4 green:0.1 blue:0.05 alpha:1.0] type:goalName];
    
    return g;
    
}
-(void)didBeginContact:(SKPhysicsContact *)contact{
    Body *goalNode, *playerNode;

    if(contact.bodyA.categoryBitMask == playerCategory
        && contact.bodyB.categoryBitMask == goalCategory){
            playerNode = (Body *) contact.bodyA.node;
            goalNode = (Body *) contact.bodyB.node;

    } else if (contact.bodyA.categoryBitMask == goalCategory
               && contact.bodyB.categoryBitMask == playerCategory){
            goalNode = (Body *) contact.bodyA.node;
            playerNode = (Body *) contact.bodyB.node;

    }
    
    if(goalNode != nil && playerNode != nil){
        NSLog(@"Scene: Collision between player and goal.");
        
        // THIS PUTS EVERYTHING AT (0, 0)!
        [self spawnGoal];

//        self.player = nil;
//        [playerNode explodeInScene:self];
        
//        [goalNode makePlayerInScene:self];
//        [goalNode setName:playerName];
//        [self setPlayer:goalNode];
        
    }
    
}


-(void)printChildren {
    for(SKNode* child in [self children]){
        NSLog(@"%@", child);
        NSLog(@"-----------------------------------");
    }
    NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
}

-(CGVector)calculateForceFromA:(Body*)a toB:(Body*)b {
    if(a == b){return CGVectorMake(0.f, 0.f);}
    CGPoint aPos = [a position];
    CGPoint bPos = [b position];
    
    CGFloat aMass = a.mass;
    CGFloat dx, dy, distance;
    dx = (aPos.x/CGRectGetHeight(self.frame) - bPos.x/CGRectGetHeight(self.frame));
    dy = aPos.y/CGRectGetHeight(self.frame) - bPos.y/CGRectGetHeight(self.frame);
    
    distance = sqrt((abs(aPos.x-bPos.x) + abs(aPos.y-bPos.y))*100);
    
    CGVector force = CGVectorMake((dx*aMass*G)/(distance), (dy*aMass*G)/(distance));
    
    return force;
}


-(Body*) newBodyWithRadius:(CGFloat)Radius
                  position:(CGPoint)Position
                     color:(UIColor*)Color
                      type:(NSString*)Type {
    
    Body* entity = [[Body alloc] initBodyWithRadius:Radius position:Position color:Color type:Type inScene:self];
    
    if(Type == bodyName){
        entity.physicsBody.categoryBitMask = bodyCategory;
        entity.physicsBody.collisionBitMask = playerCategory | goalCategory | obstacleCategory | bodyCategory;

    }
    else if (Type == goalName){
        entity.physicsBody.categoryBitMask = goalCategory;
        entity.physicsBody.collisionBitMask = playerCategory | goalCategory | obstacleCategory | bodyCategory;
    }
    else if (Type == obstacleName){
        entity.physicsBody.categoryBitMask = obstacleCategory;
        entity.physicsBody.collisionBitMask = playerCategory | goalCategory | obstacleCategory | bodyCategory;

    }
    else if (Type == playerName){
        entity.physicsBody.categoryBitMask = playerCategory;
        entity.physicsBody.collisionBitMask = playerCategory | goalCategory | obstacleCategory | bodyCategory;
        entity.physicsBody.contactTestBitMask = playerCategory | goalCategory | obstacleCategory | bodyCategory;
    }
    
    [self addChild:entity];

    return entity;
}

-(Body*)spawnPlayer {
    if(self.player != nil){[self.player removeFromParent];}
    Body* s = [self newBodyWithRadius:10.0 position:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)) color:[UIColor colorWithRed:0.756 green:0.798 blue:0.754 alpha:1.0] type:playerName];
    
    [s makePlayerInScene:self];
    self.player = s;
    return s;
}


-(double)calcR:(NSTimeInterval)duration {
    duration = duration*100;
    return duration+1;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        double stamp = [touch timestamp];
        self.timer = stamp;
        NSArray* targets = [self nodesAtPoint:[touch locationInNode:self]];
        if([[[targets firstObject] name] isEqualToString:@"Body"]){
            Body* target = [targets firstObject];
            [target remove];
            self.timer = 0;
            
            // This works too!
            [self spawnGoal];
            
        }
    }

}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.timer == 0){return;} // If an object was just deleted, don't continue
    NSTimeInterval ended;
    for (UITouch *touch in touches) {
        double stamp = [touch timestamp];
        ended = [touch timestamp];
        CGPoint position = [touch locationInNode:self];
        
        double duration = stamp - self.timer;
        if (duration > 0.1){
            [self newBodyWithRadius:[self calcR:duration] position:position color:[UIColor colorWithRed:20.f green:20.f blue:20.f alpha:100.f] type:bodyName];
        }
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

//    if(![self.player isWithinBounds:self.view.bounds]){
//        NSLog(@"Scene: Player out of bounds.");
//        NSLog(@"%@", self.player);
//        [self.player remove];
//        [self.player removeFromParent];
//        [self spawnPlayer];
//        [self.player setPosition:CGPointMake(200.0, 200.0)];
//    }

    __block CGVector force = CGVectorMake(0.0, 0.0);
    [self enumerateChildNodesWithName:@"Body" usingBlock:^(SKNode *body, BOOL *stop) {
        force.dx += [self calculateForceFromA:body toB:self.player].dx;
        force.dy += [self calculateForceFromA:body toB:self.player].dy;
    }];
    [self.player.physicsBody applyForce:force];
    
    


    
}

@end
