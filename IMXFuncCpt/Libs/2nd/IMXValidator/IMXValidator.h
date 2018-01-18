//
//  IMXValidator.h
//  IMXBaseModules
//
//  Created by guyouwen on 2017/9/16.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    ValidatorTypeKnown = 0,
    ValidatorTypeZipCode,      //1
    ValidatorTypeEmail,        //2
    ValidatorTypePhone,        //3
    ValidatorTypeUnicomPhone,  //4
    ValidatorTypeQQ,           //5
    ValidatorTypeNumber,       //6
    ValidatorTypeString,       //7
    ValidatorTypeIdentifier,   //8
    ValidatorTypePassort,      //9
    ValidatorTypeCreditNumber, //10
    ValidatorTypeBirthday,     //11
}ValidatorType;

@interface IMXValidator : NSObject

+ (BOOL) isValid:(ValidatorType) type value:(NSString*) value;
/// 判断字符串是否为纯数字
+ (BOOL)isNumText:(NSString *)str;
/// 判断是否为汉字
+ (BOOL)isHanzText:(NSString *)str;
///判断字符串是以什么开头
+ (BOOL)checkString:(NSString*)string start:(NSString*)start;

@end
