//
//  RDHomeViewController.m
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "RDHomeViewController.h"

#import "RDRedactedTweetView.h"
#import "RDTweetModel.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface RDHomeViewController() {
@private
    RDTweetModel *model;
    ACAccountStore *accountStore;
}

@end

@implementation RDHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [redactedTweet setAlpha:0.0f];
    
    accountStore = [[ACAccountStore alloc] init];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [activityIndicator stopAnimating];
    [self getNewTweet];

}

-(void)authAndGetTweets {
    //  Step 0: Check that the user has local Twitter accounts
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                 NSDictionary *params = @{@"q" : @"nsa"};
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                 
                 [request setAccount:[twitterAccounts lastObject]];
                 [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (timelineData) {
                                 NSLog(@"Timeline Response: %@\n", timelineData);
                                 NSArray *statuses = timelineData[@"statuses"];
                                 NSDictionary *tweet = statuses[0];
                                 model = [[RDTweetModel alloc] initWithDictionary:@{ DC_Tweet_Text :tweet[@"text"] }];
                                 
                                 [self updateToTweet:model];
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
}

#pragma mark -
#pragma mark Tweet Methods

-(void)getNewTweet {
    [activityIndicator startAnimating];
    [self authAndGetTweets];
}

-(void)updateToTweet:(RDTweetModel*)tweet {
    [activityIndicator stopAnimating];
    NSLog(@"Tweet: %@",[tweet tweetText]);
    [redactedTweet presentTweet:tweet];
    
    
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)gradePushed:(id)sender {
    [redactedTweet grade];
}

-(IBAction)nextPushed:(id)sender {
    [redactedTweet dismiss];
    [self getNewTweet];
}

@end
