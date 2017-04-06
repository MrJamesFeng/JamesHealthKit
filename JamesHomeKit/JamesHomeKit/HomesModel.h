//
//  HomesModel.h
//  JamesHomeKit
//
//  Created by LDY on 17/4/6.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMHome;
@interface HomesModel : NSObject
@property(nonatomic,strong)NSMutableArray<HMHome*> *homes;
@end
