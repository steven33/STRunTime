//
//  TestModel.h
//  StevenModel
//
//  Created by 李方建 on 2018/8/1.
//  Copyright © 2018年 李方建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+LFJModel.h"
#import "NNPerson.h"

@interface TestModel : NSObject

@property (nonatomic, strong) NNPerson *person;

@property (nonatomic, copy) NSString *coderID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSArray <NNPerson*>*list;

@property (nonatomic, assign) BOOL bo;;
@property (nonatomic, assign) float f;
@property (nonatomic, assign) double d;
@property (nonatomic, assign) int i;
@end
