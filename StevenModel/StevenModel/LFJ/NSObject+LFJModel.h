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
/*
 *当数据类型为NSString 的时候空数据的默认字符串
 */
+ (NSString *)strEmptyDefaultValue;
/*
 *把字段转其他字段eg:return @{@"coderID":@"id"}; coderID是model字段，id是实际dic字段
 */
+ (NSDictionary *)exchangekeyMap;

@end
@interface NSObject (LFJModel)
/*
 *字典转Model
 */
+ (instancetype)LFJModelWithDict:(NSDictionary *)dict;
/*
 *Model转字典
 */
- (NSDictionary *)LFJModelToDic;
/*
 *Model转json
 */
- (NSString *)LFJModelToJsonStr;
@end
