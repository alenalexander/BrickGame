//
//  GameOverScene.m
//  BrickGame
//
//  Created by Alen Alexander on 31/07/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"
@interface GameOverScene()
@property (nonatomic)SKLabelNode *gamerestartlbl;
@end

@implementation GameOverScene


-(id)initWithSize:(CGSize)size
{
    if(self= [super initWithSize:size])
    {
        SKLabelNode *gameoverlbl = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        gameoverlbl.text = @"GAME OVER";
        gameoverlbl.fontColor = [SKColor whiteColor];
        gameoverlbl.fontSize = 44.0;
        gameoverlbl.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:gameoverlbl];
        
        self.gamerestartlbl = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
        self.gamerestartlbl.text = @"Click to play again";
        self.gamerestartlbl.fontColor = [SKColor whiteColor];
        self.gamerestartlbl.fontSize = 24.0;
        self.gamerestartlbl.position = CGPointMake(self.frame.size.width/2, -35);
        SKAction *restartaction = [SKAction moveToY:self.frame.size.height/2 - 100 duration:2.0];
        [self.gamerestartlbl runAction:restartaction];
        [self addChild:self.gamerestartlbl];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//  UITouch *touch = [[event allTouches]anyObject];
//  CGPoint location = [touch locationInNode:self];
    [self.gamerestartlbl removeFromParent];
    GameScene *GameSceneObj = [[GameScene alloc]initWithSize:self.size];
    [self.view presentScene:GameSceneObj transition:[SKTransition doorsOpenHorizontalWithDuration:2]];
    
    
}

@end
