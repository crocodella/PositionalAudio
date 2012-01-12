//
//  HelloWorldLayer.m
//  PositionalAudio
//
//  Created by Fabio Rodella on 5/20/11.
//  Copyright 2011 Crocodella Software. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "CDXAudioNode.h"
#import "SimpleAudioEngine.h"

#define USE_SIMPLE_AUDIO_ENGINE YES

@implementation HelloWorldLayer

+(CCScene *) scene {
    
	CCScene *scene = [CCScene node];

	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	[scene addChild: layer];
    
	return scene;
}

-(id) init {
    
	if( (self=[super init])) {

        srand((unsigned) time(NULL));
        
        self.isTouchEnabled = YES;
        
        // Creates the sprites
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *earSprite = [CCSprite spriteWithFile:@"user_green.png"];
        earSprite.position = ccp(size.width / 2, size.height / 2);
        
		soundSprite1 = [CCSprite spriteWithFile:@"sound.png"];
        soundSprite1.position = ccp(50, 50);
        soundSprite1.tag = 1;
        
        soundSprite2 = [CCSprite spriteWithFile:@"sound.png"];
        soundSprite2.position = ccp(size.width - 50, size.height - 50);
        soundSprite2.tag = 2;
        
        soundSprite3 = [CCSprite spriteWithFile:@"sound.png"];
        soundSprite3.position = ccp(50, size.height - 50);
        soundSprite3.tag = 3;
        
        [self addChild:earSprite];
        [self addChild:soundSprite1];
        [self addChild:soundSprite2];
        [self addChild:soundSprite3];
        
        // Sound initialization
        
        if (USE_SIMPLE_AUDIO_ENGINE) {
            
            [SimpleAudioEngine sharedEngine]; // Forces initialization
            
            // Machinegun sound configured for single play (tap the sprite to play again). Attached
            // to soundSprite1, using earSprite as the listener location;
            
            CDXAudioNode *audioNode = [CDXAudioNode audioNodeWithFile:@"machinegun.caf"];
            audioNode.earNode = earSprite;
            [soundSprite1 addChild:audioNode];
            [audioNode play];
            
            // Music configured for continuous looping. Attached to soundSprite2, using earSprite 
            // as the listener location;
            
            audioNode = [CDXAudioNode audioNodeWithFile:@"808_120bpm.caf"];
            audioNode.earNode = earSprite;
            audioNode.playMode = kAudioNodeLoop;
            [soundSprite2 addChild:audioNode];
            [audioNode play];
            
            // Voice configured for intermitent looping. Attached to soundSprite3, using earSprite 
            // as the listener location;
            
            audioNode = [CDXAudioNode audioNodeWithFile:@"dp2.caf"];
            audioNode.earNode = earSprite;
            audioNode.minLoopFrequency = 2.0f;
            audioNode.maxLoopFrequency = 4.0f;
            audioNode.playMode = kAudioNodePeriodicLoop;
            [soundSprite3 addChild:audioNode];
            [audioNode play];
            
        } else {
            
            [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
            [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
            
            // Waits for initialization (BAD way to do it, used here for simplicity's sake!)
            
            while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {}
            
            am = [CDAudioManager sharedManager];
            soundEngine = [CDAudioManager sharedManager].soundEngine;
            
            NSArray *defs = [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:3], nil];
            [soundEngine defineSourceGroups:defs];
            
            // Machinegun sound configured for single play (tap the sprite to play again). Attached
            // to soundSprite1, using earSprite as the listener location;
            
            CDXAudioNode *audioNode = [CDXAudioNode audioNodeWithFile:@"machinegun.caf" soundEngine:soundEngine sourceId:0];
            audioNode.earNode = earSprite;
            [soundSprite1 addChild:audioNode];
            [audioNode play];
            
            // Music configured for continuous looping. Attached to soundSprite2, using earSprite 
            // as the listener location;
            
            audioNode = [CDXAudioNode audioNodeWithFile:@"808_120bpm.caf" soundEngine:soundEngine sourceId:1];
            audioNode.earNode = earSprite;
            audioNode.playMode = kAudioNodeLoop;
            [soundSprite2 addChild:audioNode];
            [audioNode play];
            
            // Voice configured for intermitent looping. Attached to soundSprite3, using earSprite 
            // as the listener location;
            
            audioNode = [CDXAudioNode audioNodeWithFile:@"dp2.caf" soundEngine:soundEngine sourceId:2];
            audioNode.earNode = earSprite;
            audioNode.minLoopFrequency = 2.0f;
            audioNode.maxLoopFrequency = 4.0f;
            audioNode.playMode = kAudioNodePeriodicLoop;
            [soundSprite3 addChild:audioNode];
            [audioNode play];
        }
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    
    for (CCNode *c in self.children) {
        
        if ([c class] == [CCSprite class]) {
            
            CGSize s = c.contentSize;
            CGRect rect = CGRectMake(c.position.x - (s.width / 2), c.position.y - (s.height / 2), s.width, s.height);
            
            if (CGRectContainsPoint(rect, touchPoint)) {
                draggingNode = c;
                
                if (c.tag == 1) {
                    CDXAudioNode *audioNode = [[c children] objectAtIndex:0];
                    [audioNode play];
                }
            }
        }
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    
    draggingNode.position = touchPoint;
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    draggingNode = nil;
}

@end
