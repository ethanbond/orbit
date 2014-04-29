//
//  CelestialBody.h
//  orbit
//
//  Created by Ethan Bond on 4/24/14.
//  Copyright (c) 2014 Ethan Bond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Body : SKShapeNode
@property (getter=isTarget) BOOL target;
@property (getter=isSatellite) BOOL satellite;
@property CGFloat radius;
@property CGFloat mass;



-(id)init;
-(id)initWithSize:(CGFloat)size position:(CGPoint)position color:(UIColor*)color;

-(void)remove;

@end
