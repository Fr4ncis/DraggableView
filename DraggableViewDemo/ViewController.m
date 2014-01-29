//
//  ViewController.m
//  DragChoose
//
//  Created by Francesco Mattia on 21/01/2014.
//  Copyright (c) 2014 Francesco Mattia. All rights reserved.
//

#import "ViewController.h"
#import "DraggableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DraggableView *view = [[DraggableView alloc] initWithFrame:CGRectMake(25, 142, 270, 270)];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
