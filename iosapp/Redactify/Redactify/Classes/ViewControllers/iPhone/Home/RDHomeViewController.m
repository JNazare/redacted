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
#import <QuartzCore/QuartzCore.h>

@interface RDHomeViewController() {
@private
    RDTweetModel *model;
    ACAccountStore *accountStore;
    
    int correct;
    int total;
}

@end

@implementation RDHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [redactedTweet setAlpha:0.0f];
    
    [nextButton setAlpha:0.0f];
    accountStore = [[ACAccountStore alloc] init];
    
    correct = 0;
    total = 0;
    
    [activityBackground.layer setCornerRadius:score.frame.size.width/2.0];
    [activityBackground setBackgroundColor:Color_Alizarin];
    
    [name.layer setCornerRadius:score.frame.size.width/2.0];
    [name setBackgroundColor:Color_Nephritis];
    
    [score setText:@"-%"];
    [score setBackgroundColor:Color_Alizarin];
    [score.layer setCornerRadius:score.frame.size.width/2.0];
    
    [navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navBar setBackgroundColor:Color_PeterRiver];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [activityIndicator stopAnimating];
    [activityBackground setAlpha:0.5f];
    
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
                                 
                                 NSMutableArray *tweets = [[NSMutableArray alloc] init];
                                 NSDictionary *tweet;
                                 RDTweetModel *aModel;
                                 int redactedWordCount = 0;
                                 RDTweetModel *modelWithMostRedactedWords;
                                 
                                 for (int i = 0; i < statuses.count; i++)
                                 {
                                     tweet = statuses[i];git 
                                     aModel = [[RDTweetModel alloc] initWithDictionary:@{ DC_Tweet_Text : tweet[@"text"] }];
                                     [tweets addObject:aModel];
                                     if ( aModel.redactedWords.count > redactedWordCount)
                                     {
                                         redactedWordCount = aModel.redactedWords.count;
                                         modelWithMostRedactedWords = aModel;
                                     }
                                 }
                                 
                                 model = modelWithMostRedactedWords;
                                 
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
    [gradeButton setAlpha:0.5f];
    [gradeButton setUserInteractionEnabled:NO];
    
    [activityIndicator startAnimating];
    [activityBackground setAlpha:1.0f];
    
    [self authAndGetTweets];
}

-(void)updateToTweet:(RDTweetModel*)tweet {
    [activityIndicator stopAnimating];
    [activityBackground setAlpha:0.5f];
    
    NSLog(@"Tweet: %@",[tweet tweetText]);
    [redactedTweet presentTweet:tweet];
    
    [gradeButton setAlpha:1.0f];
    [gradeButton setUserInteractionEnabled:YES];
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)gradePushed:(id)sender {
    NSArray *arr = [redactedTweet grade];
    correct += [arr[0] intValue];
    total += [arr[1] intValue];
    
    if(total == 0) [score setText:@"-"];
    else {
        int percent = (int)100.0*((float)correct / (float)total);
        [score setText:[NSString stringWithFormat:@"%i%%",percent]];
    }
    
    [gradeButton setAlpha:0.5f];
    [gradeButton setUserInteractionEnabled:NO];
    
    [nextButton setAlpha:1.0f];
}

-(IBAction)nextPushed:(id)sender {
    [redactedTweet dismiss];
    [self getNewTweet];
    [nextButton setAlpha:0.0f];
}

@end
