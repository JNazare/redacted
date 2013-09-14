//
//  RDAbstractViewController.m
//  Redactify
//
//  Created by Zealous Amoeba on 9/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "RDAbstractViewController.h"

@interface RDAbstractViewController() {
    
}

@end

@implementation RDAbstractViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:Image_ViewBackground]];
    [self.view setBackgroundColor:color];
}

@end
