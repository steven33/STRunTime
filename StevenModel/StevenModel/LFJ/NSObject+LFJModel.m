//
//  NSObject+LFJModel.m
//  StevenModel
//
//  Created by 李方建 on 2018/8/1.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import "NSObject+LFJModel.h"
#import <objc/runtime.h>

@implementation NSObject (LFJModel)
+ (instancetype)LFJModelWithDict:(NSDictionary *)dict{
    id model = [[self alloc] init];
    unsigned int count = 0;
    //获取成员属性数组
    Ivar *ivarList = class_copyIvarList(self, &count);
    //遍历所有成员属性名
    for (int i = 0; i < count; i++) {
        //获取成员属性
        Ivar ivar = ivarList[i];
        //获取成员属性名
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        NSString *ivarKey = [ivarName substringFromIndex:1];
        id value = dict[ivarKey];
        //如果值是字典的话看能不能转model
        if ([value isKindOfClass:[NSDictionary class]]) {
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];

            Class modelClass = NSClassFromString(ivarType);
            if (modelClass) {
                value = [modelClass LFJModelWithDict:value];
            }
        }
        if ([value isKindOfClass:[NSArray class]]) {
            // 判断对应类有没有实现字典数组转模型数组的协议
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                // 转换成id类型，就能调用任何对象的方法
                id idSelf = self;
                // 获取数组中字典对应的模型
                NSString *type = [idSelf arrayContainModelClass][ivarKey];
                // 生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *arrM = [NSMutableArray array];
                // 遍历字典数组，生成模型数组
                for (NSDictionary *dict in value) {
                    // 字典转模型
                    id model =  [classModel LFJModelWithDict:dict];
                    [arrM addObject:model];
                }
                // 把模型数组赋值给value
                value = arrM;
            }
        }
        
        if (value) {
            [model setValue:value forKey:ivarKey];
        }
        
        
    }
    
    
    return model;
    
}

@end
