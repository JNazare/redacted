//
//  RDRedacterManager.m
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "RDRedacterManager.h"

@interface RDRedacterManager() {
    NSMutableArray *flaggedWords;
}

@end

static RDRedacterManager *sharedRedacter = nil;

@implementation RDRedacterManager

+(id)initializeRedacterManager {
    @synchronized(self) {
        if(sharedRedacter == nil)
            sharedRedacter = [[RDRedacterManager alloc] init];
    }
    return sharedRedacter;
}

-(id)init {
    if(self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:File_RedactedWords ofType:@".txt"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *words = [dataStr componentsSeparatedByString:@"\n"];
        
        flaggedWords = [[NSMutableArray alloc] init];
        for(NSString *word in words) {
            if(![word isEqualToString:@""]) [flaggedWords addObject:word];
        }
        
        NSArray *sortedFlaggedWords = [flaggedWords sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *word1 = (NSString*)obj1;
            NSString *word2 = (NSString*)obj2;
            if([word1 length] == [word2 length]) return NSOrderedSame;
            else if([word1 length] > [word2 length]) return NSOrderedAscending;
            else return NSOrderedDescending;
        }];
    
        flaggedWords = [NSMutableArray arrayWithArray:sortedFlaggedWords];
    }
    return self;
}

#pragma mark -
#pragma mark Redacter Methods

-(NSArray*)redactedWordsAndTextForString:(NSString*)string {
    NSString *lowercaseStr = [string lowercaseString];
    NSMutableArray *wordsAndIndexes = [NSMutableArray array];
    
    for(NSString *word in flaggedWords) {
        NSString *regexStr = [NSString stringWithFormat:@"\\b%@\\b",word];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:NULL];
        NSArray *matches = [regex matchesInString:lowercaseStr options:0 range:NSMakeRange(0, [lowercaseStr length])];

        int offset = 0;
        for(int i = 0; i < [matches count]; i++) {
            NSTextCheckingResult *match = matches[i];
            NSRange range = [match range];
            [wordsAndIndexes addObject:@[word,[NSNumber numberWithInt:range.location]]];
            
            range.location += offset;
            lowercaseStr = [lowercaseStr stringByReplacingCharactersInRange:range withString:String_Redacted];
            string = [string stringByReplacingCharactersInRange:range withString:String_Redacted];
            offset -= range.length - [String_Redacted length];
        }
    }
    
    NSArray *w = [wordsAndIndexes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray *arr1 = (NSArray*)obj1;
        NSArray *arr2 = (NSArray*)obj2;
        
        if([arr1[1] intValue] == [arr2[1] intValue]) return NSOrderedSame;
        else if([arr1[1] intValue] < [arr2[1] intValue]) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    return @[w,string];
}

@end
