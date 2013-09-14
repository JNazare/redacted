//
//  RDMenuButton.m
//  Redactify
//
//  Created by Zealous Amoeba on 9/14/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "RDMenuButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation RDMenuButton

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self.layer setCornerRadius:3.0f];
        [self setBackgroundColor:Color_PeterRiver];
        
        [[self titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
        [self setTitleColor:Color_Clouds forState:UIControlStateNormal];
    }
    return self;
}

@end
