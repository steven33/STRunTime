//
//  NNPerson.m
//  NNRuntimeTest
//
//  Created by 李方建 on 2018/8/1.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import "NNPerson.h"

@implementation NNPerson
+ (NSString *)strEmptyDefaultValue{
    return @"wo shi empty";
}
- (NSString *)coding {
    return @"coding";
}

- (NSString *)eating {
    return @"eating";
}

- (NSString *)changeMethod {
    return @"方法已被拦截并替换";
}

@end
