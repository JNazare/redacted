//
//  RDAbstractRequest.h
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDAbstractRequest : NSObject <NSURLConnectionDelegate>

-(void)getUrlStr:(NSString*)urlStr withMethod:(NSString*)method withEdit:(void(^) (NSMutableURLRequest* request))edit andResponse:(void(^) (NSData *data, NSError *error))response;

@end
