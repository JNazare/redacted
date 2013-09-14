//
//  RDTweetModel.h
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDTweetModel : NSObject
@property(nonatomic, strong, readonly) NSString *tweetText;
@property(nonatomic, strong, readonly) NSString *redacedText;
@property(nonatomic, strong, readonly) NSArray *redactedWords;

-(id)initWithDictionary:(NSDictionary*)dict;

@end
