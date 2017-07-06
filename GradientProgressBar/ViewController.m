//
//  ViewController.m
//  GradientProgressBar
//
//  Created by qq on 2017/7/3.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "ViewController.h"
#import "GradientProgressBar.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GradientProgressBar *gradientBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button:(id)sender {
    if(_gradientBar.isAnimating==NO){
        self.gradientBar.percent = 1;
        [_gradientBar beginAnimate];
        
        //    [_gradientBar setPercent:1 animated:YES];
    }
}

@end
