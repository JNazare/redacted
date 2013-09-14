//
//  RDHomeViewController.h
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "RDAbstractViewController.h"

@class RDRedactedTweetView;
@interface RDHomeViewController : RDAbstractViewController {
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet RDRedactedTweetView *redactedTweet;
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)gradePushed:(id)sender;
-(IBAction)nextPushed:(id)sender;

@end
