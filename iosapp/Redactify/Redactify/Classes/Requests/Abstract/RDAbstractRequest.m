//
//  RDAbstractRequest.m
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "RDAbstractRequest.h"

typedef void (^ResponseCallback)(NSData *data, NSError *error);

@interface RDAbstractRequest() {
    NSMutableData *requestData;
    ResponseCallback callback;
    
    NSMutableURLRequest *request;
    NSURLConnection *connection;
}
@end

@implementation RDAbstractRequest

-(void)getUrlStr:(NSString*)urlStr withMethod:(NSString*)method withEdit:(void(^) (NSMutableURLRequest* request))edit andResponse:(void(^) (NSData *data, NSError *error))response {
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:method];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:60];
    
    edit(request);
    NSLog(@"Request headers: %@",[request allHTTPHeaderFields]);
    
    callback = response;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

#pragma mark -
#pragma mark NSURL Connection Methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"Response: %i",[httpResponse statusCode]);
    
    requestData = [NSMutableData data];
    [requestData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [requestData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    callback(requestData,error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    callback(requestData,NULL);
}



@end
