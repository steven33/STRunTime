//
//  TestModel.m
//  StevenModel
//
//  Created by 李方建 on 2018/8/1.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel
+ (NSDictionary *)arrayContainModelClass{
    return @{@"list":@"NNPerson"};
//    return @{@"list":[NNPerson class]};
}
+ (NSString *)strEmptyDefaultValue{
    return @"wo shi empty";
}
+ (NSDictionary *)keyMap{
    return @{@"coderID":@"id"};
}


@end
