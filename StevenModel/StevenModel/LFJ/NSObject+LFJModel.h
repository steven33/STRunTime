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
/*
 **用在数组内部dic转换成model映射
 *eg1: return @{@"list":@"NNPerson"};表示list字段的数组内部的dic转成NNPerson model对象
 *eg2: return @{@"list":[NNPerson class]}; 表示list字段的数组内部的dic转成NNPerson model对象(建议使用这种方式)
*/
+ (NSDictionary *)arrayContainModelClass;
+ (NSString *)strEmptyDefaultValue;

@end
@interface NSObject (LFJModel)

+ (instancetype)LFJModelWithDict:(NSDictionary *)dict;
- (NSDictionary *)LFJModelToDic;
- (NSString *)LFJModelToJsonStr;
@end
