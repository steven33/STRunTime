//
//  ViewController.m
//  SliderDome
//
//  Created by 李方建 on 2018/8/7.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import "ViewController.h"
#import "SliderView.h"

#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
{
    SliderView *slider;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    slider = [[SliderView alloc] initWithFrame:CGRectMake(10, 100, Kwidth-20, KdefaultHeight)];
    [self.view addSubview:slider];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)tap{
    slider.isShow = NO;
}


@end
