//
//  CelestialBody.h
//  orbit
//
//  Created by Ethan Bond on 4/24/14.
//  Copyright (c) 2014 Ethan Bond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Body : SKNode

@property NSString * type;
@property CGFloat  mass;
@property CGFloat  radius;
@property UIColor  * color;





-(id)init;
-(id)initBodyWithRadius:(CGFloat)Radius position:(CGPoint)Position color:(UIColor*)Color type:(NSString*)Type inScene:(SKScene*)Scene;

-(void)remove;
-(void)makePlayerInScene:(SKScene*)view;
-(void)explodeInScene:(SKScene*)view;
-(BOOL)collidesWith:(Body*)otherBody;
-(BOOL)isWithinBounds:(CGRect)bounds;
-(void)makeDynamic;
-(void)makeStationary;

-(CGPoint)position;
-(CGFloat)radius;
-(UIColor*)color;

@end
