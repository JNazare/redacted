//
//  RDTweetModel.m
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "RDTweetModel.h"
#import "RDRedacterManager.h"

@implementation RDTweetModel

-(id)initWithDictionary:(NSDictionary*)dict {
    if(self = [super init]) {
        NSString *text = dict[DC_Tweet_Text];
        text = [text stringByReplacingOccurrencesOfString:@"'" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"~" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"`" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        _tweetText = text;

        RDRedacterManager *manager = [RDRedacterManager initializeRedacterManager];
        NSArray *wordsAndText = [manager redactedWordsAndTextForString:text];
        _redactedWords = wordsAndText[0];
        _redacedText = wordsAndText[1];
    }
    return self;
}

@end
