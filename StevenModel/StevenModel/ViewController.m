//
//  ViewController.m
//  StevenModel
//
//  Created by 李方建 on 2018/8/1.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"
#import "NSObject+LFJModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *test = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 50)];
    [test addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    test.backgroundColor = [UIColor redColor];
    [self.view addSubview:test];
}

- (void)tap{
    
    NSDictionary *person = @{@"name":@"你是谁",
                             @"sex": @""};
    NSDictionary *dict = @{@"id":@"100",
                           @"nickName": @"以梦为马",
                           @"phoneNumber": @"110",
                           @"person" : person,
                           @"list":@[person,person,person]
                           };
    NSArray *addarr = @[dict ,dict, dict];
//
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSDictionary *item in addarr) {
        TestModel *coding = [TestModel LFJModelWithDict:dict];
//        [arr addObject:coding];
//    }
//    NSLog(@"%@",arr);
    NSLog(@"%@",coding);
    
    NSDictionary *dic =  [coding LFJModelToDic];
    NSLog(@"%@",[coding LFJModelToJsonStr]);
}


@end
