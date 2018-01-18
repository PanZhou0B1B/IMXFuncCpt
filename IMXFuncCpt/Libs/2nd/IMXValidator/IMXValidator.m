//
//  IMXValidator.m
//  IMXBaseModules
//
//  Created by guyouwen on 2017/9/16.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXValidator.h"

int getIndexNew (char ch);
BOOL isNumberNew (char ch);

int getIndexNew (char ch) {
    if ((ch >= '0'&& ch <= '9')||(ch >= 'a'&& ch <= 'z')||
        (ch >= 'A' && ch <= 'Z')|| ch == '_') {
        return 0;
    }
    if (ch == '@') {
        return 1;
    }
    if (ch == '.') {
        return 2;
    }
    return -1;
}

BOOL isNumberNew (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}
@implementation IMXValidator

+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    int len = (int)strlen(cvalue);
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}

+ (BOOL) validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) isValidEmail:(NSString*)value {
    static int state[5][3] = {
        {1, -1, -1},
        {1,  2, -1},
        {3, -1, -1},
        {3, -1, 4},
        {4, -1, -1}
    };
    BOOL valid = TRUE;
    const char *cvalue = [value UTF8String];
    int currentState = 0;
    int len = (int)strlen(cvalue);
    int index;
    for (int i = 0; i < len && valid; i++) {
        index = getIndexNew(cvalue[i]);
        if (index < 0) {
            valid = FALSE;
        }
        else {
            currentState = state[currentState][index];
            if (currentState < 0) {
                valid = FALSE;
            }
        }
    }
    //end state is invalid
    if (currentState != 4) {
        valid = FALSE;
    }
    return valid;
}

+ (BOOL) isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    int len = (int)strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumberNew(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}

/// 判断是否为纯数字
+ (BOOL)isNumText:(NSString *)str{
    NSString *regex= @"^[0-9]*$";
    NSPredicate *pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch= [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}
/// 判断是否为汉字
+ (BOOL)isHanzText:(NSString *)str{
    NSString *regex= @".*[\\u4e00-\\u9faf].*";
    NSPredicate *pred= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch= [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL) isValidPhone:(NSString*)value {
    const char *cvalue = [value UTF8String];
    int len = (int)strlen(cvalue);
    if (len != 11) {
        return FALSE;
    }
    if (![IMXValidator isValidNumber:value])
    {
        return FALSE;
    }
    NSString *preString = [[NSString stringWithFormat:@"%@",value] substringToIndex:2];
    if ([preString isEqualToString:@"13"] ||
        [preString isEqualToString: @"15"] ||
        [preString isEqualToString: @"18"])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    return TRUE;
}
+ (BOOL) isValidString:(NSString*)value
{
    return value && [value length];
}
const int factorNew[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
const int checktableNew[] = { 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 };//校验值对应表
+ (BOOL) isValidIdentifier:(NSString*)value
{
    const int LENGTH = 18;
    const char *str = [[value lowercaseString] UTF8String];
    NSInteger i;
    NSInteger length = strlen(str);
    BOOL result = TRUE;
    /*
     * identifier length is invalid
     */
    if (15 != length && LENGTH != length)
    {
        result = FALSE;
    }
    else
    {
        for (i = 1; i < length - 1; i++)
        {
            if(!(str[i] >= '0' && str[i] <= '9'))
            {
                result = FALSE;
                break;
            }
        }
        if (result)
        {
            if(LENGTH == length)
            {
                if (!((str[i] >= '0' && str[i] <= '9')||str[i] == 'X'||str[i] == 'x'))
                {
                    result = FALSE;
                }
            }
        }
        /*
         * check sum for second generation identifier
         */
        if (result && length == LENGTH)
        {
            int i;
            int *ids = malloc(sizeof(int)*LENGTH);
            for (i = 0; i < LENGTH; i++)
            {
                ids[i] = str[i] - 48;
            }
            int checksum = 0;
            for (i = 0; i < LENGTH - 1; i ++ )
            {
                checksum += ids[i] * factorNew[i];
            }
            if (ids[17] == checktableNew[checksum%11]||
                (str[17] == 'x' && checktableNew[checksum % 11] == 10))
            {
                result  = TRUE;
            }
            else
            {
                result  = FALSE;
            }
            free(ids);
            ids = NULL;
        }
    }
    return result;
}
+ (BOOL) isValidPassport:(NSString*)value
{
    const char *str = [value UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G'))
    {
        return FALSE;
    }
    if (first == 'P')
    {
        if (length != 8)
        {
            return FALSE;
        }
    }
    if (first == 'G')
    {
        if (length != 9)
        {
            return FALSE;
        }
    }
    BOOL result = TRUE;
    for (NSInteger i = 1; i < length; i++)
    {
        if (!(str[i] >= '0' && str[i] <= '9'))
        {
            result = FALSE;
            break;
        }
    }
    return result;
}

+ (BOOL) isValidCreditNumber:(NSString*)value
{
    BOOL result = TRUE;
    NSInteger length = [value length];
    if (length >= 13)
    {
        result = [IMXValidator isValidNumber:value];
        if (result)
        {
            NSInteger twoDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 2)] integerValue];
            NSInteger threeDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 3)] integerValue];
            NSInteger fourDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 4)] integerValue];
            //Diner's Club
            if (((threeDigitBeginValue >= 300 && threeDigitBeginValue <= 305)||
                 fourDigitBeginValue == 3095||twoDigitBeginValue==36||twoDigitBeginValue==38) && (14 != length))
            {
                result = FALSE;
            }
            //VISA
            else if([IMXValidator checkString:value start:@"5"] && !(13 == length|| 16 == length))
            {
                result = FALSE;
            }
            //MasterCard
            else if((twoDigitBeginValue >= 51 && twoDigitBeginValue <= 55) && (16 != length))
            {
                result = FALSE;
            }
            //American Express
            else if(([IMXValidator checkString:value start:@"34"]||[IMXValidator checkString:value start:@"37"]) && (15 != length))
            {
                result = FALSE;
            }
            //Discover
            else if([IMXValidator checkString:value start:@"6011"] && (16 != length))
            {
                result = FALSE;
            }
            else
            {
                NSInteger begin = [[value substringWithRange:NSMakeRange(0, 6)] integerValue];
                //CUP
                if ((begin >= 622126 && begin <= 622925) && (16 != length))
                {
                    result = FALSE;
                }
                //other
                else
                {
                    result = TRUE;
                }
            }
        }
        if (result)
        {
            NSInteger digitValue = 0;
            NSInteger checkSum = 0;
            NSInteger index = 0;
            NSInteger leftIndex;
            //even length, odd index
            if (0 == length%2)
            {
                index = 0;
                leftIndex = 1;
            }
            //odd length, even index
            else
            {
                index = 1;
                leftIndex = 0;
            }
            while (index <= length)
            {
                if (index < length) {
                    digitValue = [[value substringWithRange:NSMakeRange(index, 1)] integerValue];
                } else {
                    digitValue = 0;
                }
                digitValue = digitValue*2;
                if (digitValue >= 10)
                {
                    checkSum += digitValue/10 + digitValue%10;
                }
                else
                {
                    checkSum += digitValue;
                }
                if (leftIndex < length) {
                    digitValue = [[value substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
                } else {
                    digitValue = 0;
                }
                
                checkSum += digitValue;
                index += 2;
                leftIndex += 2;
            }
            result = (0 == checkSum%10) ? TRUE:FALSE;
        }
    }
    else
    {
        result = FALSE;
    }
    return result;
}
+ (BOOL) isValidBirthday:(NSString*)birthday
{
    BOOL result = FALSE;
    if (birthday && 8 == [birthday length])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:birthday];
        if (date)
        {
            result = TRUE;
        }
    }
    return result;
}
+ (BOOL) isChinaUnicomPhoneNumber:(NSString*) mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILENUM = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILENUM];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//+ (BOOL) isChinaUnicomPhoneNumber:(NSString*) phoneNumber
//{
//    BOOL unicom = TRUE;
//    NSString *mobileNumFormat13 = @"[1]{1}[3]{1}[4-9]{1}[0-9]{8}";
//    NSString *mobileNumFormat14 = @"[1]{1}[4]{1}[7]{1}[0-9]{8}";
//    NSString *mobileNumFormat15 = @"[1]{1}[5]{1}[012789]{1}[0-9]{8}";
//    NSString *mobileNumFormat18 = @"[1]{1}[8]{1}[2378]{1}[0-9]{8}";
//    NSPredicate *predicate13 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileNumFormat13];
//    NSPredicate *predicate14 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileNumFormat14];
//    NSPredicate *predicate15 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileNumFormat15];
//    NSPredicate *predicate18 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileNumFormat18];
//    if ([predicate13 evaluateWithObject:phoneNumber] ||
//        [predicate14 evaluateWithObject:phoneNumber] ||
//        [predicate15 evaluateWithObject:phoneNumber] ||
//        [predicate18 evaluateWithObject:phoneNumber])
//    {
//        unicom = FALSE;
//    }
//    return unicom;
//}
+ (BOOL) isValid:(ValidatorType) type value:(NSString*) value
{
    if (!value ||[[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        return FALSE;
    }
    BOOL result = TRUE;
    switch (type)
    {
        case ValidatorTypeZipCode:
            result = [IMXValidator isValidZipcode:value];
            break;
        case ValidatorTypeEmail:
            //            result = [IdentifierValidator isValidEmail:value];
            result = [IMXValidator validateEmail:value];
            break;
        case ValidatorTypePhone:
            result = [IMXValidator isValidPhone:value];
            break;
        case ValidatorTypeUnicomPhone:
            result = [IMXValidator isChinaUnicomPhoneNumber:value];
            break;
        case ValidatorTypeQQ:
            result = [IMXValidator isValidNumber:value];
            break;
        case ValidatorTypeNumber:
            result = [IMXValidator isValidNumber:value];
            break;
        case ValidatorTypeString:
            result = [IMXValidator isValidString:value];
            break;
        case ValidatorTypeIdentifier:
            result = [IMXValidator isValidIdentifier:value];
            break;
        case ValidatorTypePassort:
            result = [IMXValidator isValidPassport:value];
            break;
        case ValidatorTypeCreditNumber:
            result = [IMXValidator isValidCreditNumber:value];
            break;
        case ValidatorTypeBirthday:
            result = [IMXValidator isValidBirthday:value];
            break;
        default:
            break;
    }
    return result;
}
+ (BOOL)checkString:(NSString*)string start:(NSString*)start
{
    BOOL result = FALSE;
    NSRange found = [string rangeOfString:start options:NSCaseInsensitiveSearch];
    if (found.location == 0)
    {
        result = TRUE;
    }
    return result;
}
@end
