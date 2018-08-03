//
//  NSObject+LFJModel.m
//  StevenModel
//
//  Created by 李方建 on 2018/8/1.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import "NSObject+LFJModel.h"
#import <objc/runtime.h>

#define k_LFJ_IsEmptyStr(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )


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
        NSString *key = ivarKey;
        if ([self respondsToSelector:@selector(exchangekeyMap)]) {
            id idSelf = self;
            if (!k_LFJ_IsEmptyStr([idSelf exchangekeyMap][ivarKey])) {
                key = [idSelf exchangekeyMap][ivarKey];
            }
        }
        id value = dict[key];
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
                Class classModel = (Class)type;
                if ( [type respondsToSelector:@selector(length)]) {
                    classModel = NSClassFromString(type);
                }
                
                NSMutableArray *arrM = [NSMutableArray array];
                // 遍历字典数组，生成模型数组
                for (NSDictionary *dict in value) {
                    // 字典转模型
                    id model =  [classModel LFJModelWithDict:dict];
                    [arrM addObject:model];
                }
                // 把模型数组赋值给value
                value = arrM;
            }else{
                NSString *claType = [ivarType stringByReplacingOccurrencesOfString:@"NSArray" withString:@""];
                claType = [claType stringByReplacingOccurrencesOfString:@"<" withString:@""];
                claType = [claType stringByReplacingOccurrencesOfString:@">" withString:@""];
                claType = [claType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                claType = [claType stringByReplacingOccurrencesOfString:@"@" withString:@""];
                if (!k_LFJ_IsEmptyStr(claType)) {
                   Class classModel = NSClassFromString(claType);
                    if (classModel) {
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

            }
        }
        
        if ([ivarType containsString:@"NSString"]&&k_LFJ_IsEmptyStr(value)) {
            if ([self respondsToSelector:@selector(strEmptyDefaultValue)]) {
                id idSelf = self;
                value = [idSelf strEmptyDefaultValue];
            }
        }
        if (value) {
            [model setValue:value forKey:ivarKey];
        }
        
    }
    
    return model;
    
}

//将可能存在model数组转化为普通数组
- (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[object LFJModelToDic]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[object LFJModelToDic] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}
- (NSDictionary *)LFJModelToDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int outCount;
    Ivar *ivarList = class_copyIvarList(self.class, &outCount);
    for (int i = 0; i<outCount; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *ivarKey = [ivarName substringFromIndex:1];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        if ([ivarType containsString:@"^v"]||[ivarType isEqualToString:@":"]) {
            //@property (nonatomic, assign)void  *lfj13;
            //@property (nonatomic, assign)SEL lfj16;
            continue;
        }
        

        id value = [self valueForKey:ivarKey];
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger,dic
            [dic setObject:value forKey:ivarKey];
            
        } else if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:ivarKey];
            
        }else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
        } else {
            //model
            [dic setObject:[value LFJModelToDic] forKey:ivarKey];
        }

    }
    
    return [dic copy];
    
    
}
- (NSString *)LFJModelToJsonStr{
    NSDictionary *dic =  [self LFJModelToDic];
    return [self convertToJsonData:dic];
}

/// 字典转json字符串方法
- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
        
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
@end
