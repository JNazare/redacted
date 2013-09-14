//
//  RDRedactedTweetView.m
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "RDRedactedTweetView.h"

#import "RDTweetModel.h"

@interface RDRedactedTweetView() {
@private
    int lastTextFieldTag;
    RDTweetModel *tweet;
}

@end

@implementation RDRedactedTweetView

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark -
#pragma mark Display Methods

-(void)presentTweet:(RDTweetModel*)model {
    [textLabel setText:[model redacedText]];
    
    CGSize size = [self sizeForText:[model redacedText] withWidth:textLabel.frame.size.width];
    [textLabel setFrame:CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, size.height)];
    
    [self addTextFieldsForTweet:model];
    
    tweet = model;
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0f];
        NSLog(@"Animate");
    }];
}

-(void)grade {
    NSArray *words = [tweet redactedWords];

    int correctGuesses = 0;
    for(int i = 10; i < lastTextFieldTag+1; i++) {
        UITextField *field = (UITextField*)[self viewWithTag:i];
        if([[field.text lowercaseString] isEqualToString:[words[i-10][0] lowercaseString]]) correctGuesses++;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yay!" message:[NSString stringWithFormat:@"You got %i correct",correctGuesses] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)dismiss {
    [self dismissTextFields];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0.0f];
    }];
}

#pragma mark -
#pragma mark Text Field Methods

-(CGSize)sizeForText:(NSString*)text withWidth:(int)width {
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)addTextFieldsForTweet:(RDTweetModel*)model {
    NSString *regexStr = [NSString stringWithFormat:@"%@",String_Redacted_Regex];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:NULL];
    NSArray *matches = [regex matchesInString:[model redacedText] options:0 range:NSMakeRange(0, [[model redacedText] length])];
    
    for(int i = 0; i < [matches count]; i++) {
        NSTextCheckingResult *match = matches[i];
        NSRange range = [match range];
        int startIndex = range.location+[String_Redacted length];
        int endIndex = range.location;
        NSString *substring = [[model redacedText] substringToIndex:range.location];
        CGSize size = [self sizeForText:substring withWidth:textLabel.frame.size.width];
        
        NSMutableArray *words = [NSMutableArray arrayWithArray:[substring componentsSeparatedByString:@" "]];
        [words removeObject:@""];
        int count = [words count];
        NSLog(@"Substring: %@",substring);
        [words addObject:String_Redacted];
        for(int i = 0; i < count; i++) {
            if(2*i+1 < [words count]) [words insertObject:@" " atIndex:2*i+1];
            else [words addObject:@" "];
        }
        NSLog(@"Substring: -%@-",[substring substringWithRange:NSMakeRange([substring length]-1, 1)]);
        
        
        BOOL done = NO;
        words = [[words reverseObjectEnumerator] allObjects];
        
        NSLog(@"Words: %@",words);
        if([[substring substringWithRange:NSMakeRange([substring length]-1, 1)] isEqualToString:@" "])  {
            [words removeLastObject];
        }
        NSLog(@"Words: %@",words);
        
        for(NSString *word in words) {
            if(!done) {
                NSLog(@"Word: %@ (%i)",word,[word length]);
                startIndex -= [word length];
                NSString *sub = [[model redacedText] substringToIndex:startIndex];
                CGSize s = [self sizeForText:sub withWidth:textLabel.frame.size.width];
                if(s.height < size.height || [sub isEqualToString:@""]) {
                    done = YES;
                }
            }
        }
        
        NSLog(@"Start: %i and end: %i",startIndex,endIndex);
        
        substring = [[model redacedText] substringWithRange:NSMakeRange(startIndex, endIndex-startIndex)];
        CGSize newsize = [substring sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0] constrainedToSize:CGSizeMake(MAXFLOAT, 23.0) lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"Str: -%@- Width: %f and height: %f",substring,newsize.width,newsize.height);
        

        CGSize subsize = [self sizeForText:substring withWidth:textLabel.frame.size.width];
        CGSize checksize = [self sizeForText:[substring stringByAppendingString:String_Redacted] withWidth:textLabel.frame.size.width];
        
        if(checksize.height > subsize.height) {
            size.height += 22.0;
            newsize.width = 0;
        }
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(13+newsize.width, size.height-10, 75, 22)];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setDelegate:self];
        [textField setTag:10+i];
        if(i == [matches count]-1) [textField setReturnKeyType:UIReturnKeyDone];
        else [textField setReturnKeyType:UIReturnKeyNext];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, textField.frame.size.height)];
        [textField setLeftView:border];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setAlpha:1.0];
        
        [self addSubview:textField];
    }
    lastTextFieldTag = 10+[matches count]-1;
    NSLog(@"DONE!!!");
}

-(void)dismissTextFields {
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[UITextField class]]) [view removeFromSuperview];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.tag == lastTextFieldTag) [self endEditing:YES];
    else {
        [textField resignFirstResponder];
        UITextField *field = [self viewWithTag:textField.tag+1];
        [field becomeFirstResponder];
    }
    return YES;
}

@end
