//
//  IMXArchiverUtil.h
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/8.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMXArchiverUtil : NSObject

+ (NSData *)imx_archiverDataFromObject:(id<NSCoding>)obj;
+ (id)imx_objectFromArchiverData:(NSData *)data;

@end
