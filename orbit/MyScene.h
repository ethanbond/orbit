//
//  MyScene.h
//  orbit
//

//  Copyright (c) 2014 Ethan Bond. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Body.h"

@interface MyScene : SKScene
<SKPhysicsContactDelegate>

-(Body*) newBodyWithRadius:(CGFloat)Radius
                  position:(CGPoint)Position
                     color:(UIColor*)Color
                      type:(NSString*)Type;

@property NSTimeInterval timer;
@property const float G;
@property Body* player;
@property int scale;


@end
