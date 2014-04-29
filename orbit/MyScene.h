//
//  MyScene.h
//  orbit
//

//  Copyright (c) 2014 Ethan Bond. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene
@property NSTimeInterval timer;
@property const float G;
@property (nonatomic, strong) SKNode* satellite;


@end
