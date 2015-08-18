//
//  GameScene.m
//  BrickGame
//
//  Created by Alen Alexander on 31/07/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"

@interface GameScene()
@property (nonatomic) SKSpriteNode *paddlenode;
@property (nonatomic) SKSpriteNode *ballnode;
@property(nonatomic) NSInteger finish;
@end

static const uint32_t ballCtgry = 0x1;
static const uint32_t paddleCtgry = 0x1 << 1;
static const uint32_t brickCtgry = 0x1 << 2;
static const uint32_t bottomedgeCtgry = 0x1 << 3;

@implementation GameScene

- (void)addBall {
    //adding ball to the scene
    self.ballnode = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    self.ballnode.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.ballnode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:30];
    self.ballnode.physicsBody.categoryBitMask = ballCtgry;
    self.ballnode.physicsBody.contactTestBitMask = paddleCtgry | brickCtgry | bottomedgeCtgry;
    self.ballnode.physicsBody.restitution = 1.0f;
    self.ballnode.physicsBody.linearDamping = 0.0f;              // resistance to air movement is set to zero for smooth movement
    self.ballnode.physicsBody.friction = 0.0f;
    [self addChild:self.ballnode];    // added ball to the scene
    
    CGVector ballshootangle = CGVectorMake(50,50);
    [self.ballnode.physicsBody applyImpulse:ballshootangle];  // initial impulse applied to the ball at an angle(x=50˚ , y=50˚)
                      // resistance to edges is reduced to zero
    
}

- (void)addPaddle {
    self.paddlenode = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    self.paddlenode.position = CGPointMake(self.size.width/2,self.size.height/2 - self.size.height/4);
    self.paddlenode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddlenode.frame.size];
    self.paddlenode.physicsBody.categoryBitMask = paddleCtgry;
    self.paddlenode.physicsBody.dynamic = NO;
    [self addChild:self.paddlenode];
}



- (void)addBricks {
    for(int i=0;i<5;i++)
    {
        SKSpriteNode *bricknode = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        bricknode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bricknode.frame.size];
        bricknode.physicsBody.categoryBitMask = brickCtgry;
        bricknode.physicsBody.dynamic = NO;
        int xpos = self.size.width/6 *(i+1);
        int ypos = self.size.height - 50;
        bricknode.position = CGPointMake(xpos, ypos);
        bricknode.name = @"BRICK";
        [self addChild:bricknode];
    }
}

- (void)addBottomedge {
    SKNode *bottomedge = [SKNode node];
    bottomedge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 5) toPoint:CGPointMake(self.frame.size.width, 5)];
    bottomedge.physicsBody.categoryBitMask = bottomedgeCtgry;
    bottomedge.physicsBody.dynamic = NO;
    [self addChild:bottomedge];
}

-(id)initWithSize:(CGSize)size{
    /* Setup your scene here */
//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    myLabel.text = @"Hello, World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    [self addChild:myLabel];
    
    if(self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor whiteColor];
        self.physicsWorld.gravity = CGVectorMake(0,0);    // default gravity is 9.8m/sˆ2. With default gravity,the nodes would get affected by gravity. Gravity of physics world(all the nodes) are therefore set to 0.
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]; // screen edges are also made as physicsbody by making it as real edges.
        self.physicsWorld.contactDelegate = self;
        [self addBall];
        [self addPaddle];
        [self addBricks];
        [self addBottomedge];
        self.finish=0;
    }
    
    return self;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint renewpoint;
        renewpoint = CGPointMake(location.x, self.size.height/2 - self.size.height/4);
        if(location.x < self.paddlenode.size.width - 50)
        {
            renewpoint = CGPointMake(self.paddlenode.size.width - 50, self.size.height/2 - self.size.height/4);
        }
        else if (location.x > self.size.width - self.paddlenode.size.width + 50)
        {
            renewpoint = CGPointMake(self.size.width - self.paddlenode.size.width + 50, self.size.height/2 - self.size.height/4);
        }
        
        self.paddlenode.position = renewpoint;

    }
}


-(void)didBeginContact:(SKPhysicsContact *)contact
{
//    if(contact.bodyA.categoryBitMask == brickCtgry)
//    {
//        NSLog(@"Ball touched the brick");
//    }
    SKPhysicsBody *NotBall;
    if(contact.bodyA.contactTestBitMask < contact.bodyB.contactTestBitMask)
    {
    NotBall = contact.bodyA;
    }
    else
    {
    NotBall = contact.bodyB;
    }
    
    
    if(NotBall.categoryBitMask == brickCtgry)
    {
        [NotBall.node removeFromParent];
    }
    if(NotBall.categoryBitMask == bottomedgeCtgry)
    {
        GameOverScene *gameoverscene = [[GameOverScene alloc]initWithSize:self.frame.size];
        [self.view presentScene:gameoverscene transition:[SKTransition doorsCloseHorizontalWithDuration:1.5]];
    }
//    NSLog(@"%f  %f",self.ballnode.physicsBody.velocity.dx,self.ballnode.physicsBody.velocity.dy);
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(![self childNodeWithName:@"BRICK"] && (self.finish==0))
    {
        self.finish=1;
        [self.ballnode removeFromParent];
        SKLabelNode *WinStatusLbl = [[SKLabelNode alloc]initWithFontNamed:@"Futura"];
        WinStatusLbl.text = @"You WON";
        WinStatusLbl.fontSize = 30.0;
        WinStatusLbl.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        WinStatusLbl.fontColor = [SKColor blackColor];
        [self addChild:WinStatusLbl];
    }
}

@end
