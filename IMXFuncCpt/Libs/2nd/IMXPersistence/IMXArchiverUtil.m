//
//  IMXArchiverUtil.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/8.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXArchiverUtil.h"

@implementation IMXArchiverUtil
#pragma mark ---  archiver  ---
//归档obj数据
+ (NSData *)imx_archiverDataFromObject:(id<NSCoding>)obj
{
    return [NSKeyedArchiver archivedDataWithRootObject:obj];
}
//解档data数据
+ (id)imx_objectFromArchiverData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
