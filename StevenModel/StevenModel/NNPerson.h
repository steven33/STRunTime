//
//  NNPerson.h
//  NNRuntimeTest
//
//  Created by 李方建 on 2018/8/1.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NNPerson <NSObject>
@end
@interface NNPerson : NSObject

/** 姓名 **/
@property (nonatomic, copy) NSString *name;
/** 性别 **/
@property (nonatomic, copy) NSString *sex;

- (NSString *)coding;
- (NSString *)eating;
- (NSString *)changeMethod;
@end
