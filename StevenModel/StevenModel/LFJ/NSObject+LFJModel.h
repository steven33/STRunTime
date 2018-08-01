//
//  NSObject+LFJModel.h
//  StevenModel
//
//  Created by 李方建 on 2018/8/1.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ModelDelegate <NSObject>
@optional
// 用在三级数组转换
+ (NSDictionary *)arrayContainModelClass;

@end
@interface NSObject (LFJModel)

+ (instancetype)LFJModelWithDict:(NSDictionary *)dict;

@end
