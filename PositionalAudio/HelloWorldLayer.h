//
//  HelloWorldLayer.h
//  PositionalAudio
//
//  Created by Fabio Rodella on 5/20/11.
//  Copyright 2011 Crocodella Software. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CDAudioManager.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CDAudioManager *am;
	CDSoundEngine  *soundEngine;
    
    CCNode *draggingNode;
    
    CCSprite *soundSprite1;
    CCSprite *soundSprite2;
    CCSprite *soundSprite3;
}

+(CCScene *) scene;

@end
