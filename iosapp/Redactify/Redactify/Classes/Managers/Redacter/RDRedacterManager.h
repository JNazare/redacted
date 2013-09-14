//
//  RDRedacterManager.h
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDRedacterManager : NSObject

+(id)initializeRedacterManager;

#pragma mark -
#pragma mark Redacter Methods

-(NSArray*)redactedWordsAndTextForString:(NSString*)string;

@end
