//
//  RDRedactedTweetView.h
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDTweetModel;
@interface RDRedactedTweetView : UIView <UITextFieldDelegate> {
    IBOutlet UILabel *textLabel;
}

#pragma mark -
#pragma mark Display Methods

-(void)presentTweet:(RDTweetModel*)model;
-(NSArray*)grade;
-(void)dismiss;

@end
