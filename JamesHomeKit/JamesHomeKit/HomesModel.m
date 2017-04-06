//
//  HomesModel.m
//  JamesHomeKit
//
//  Created by LDY on 17/4/6.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "HomesModel.h"

@implementation HomesModel
-(instancetype)init{
    if (self=[super init]) {
        _homes = [NSMutableArray array];
    }
    return self;
}
@end
