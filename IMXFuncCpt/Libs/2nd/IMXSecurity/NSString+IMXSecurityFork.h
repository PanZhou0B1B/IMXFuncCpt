//
//  NSString+IMXSecurityFork.h
//  IMXSecurityCpt
//
//  Created by zhoupanpan on 2017/8/10.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IMXSecurityFork)
#pragma mark ======  md5 encode  ======
- (NSString *)imxMd5Encode;
#pragma mark ======  DES encode/decode  ======
+ (NSString *)imx_DESEncrypt:(NSString *)original key:(NSString *)key;
+ (NSString *)imx_DESDecrypt:(NSString *)original key:(NSString *)key;
#pragma mark ======  hash  ======
- (NSString *)imxHAMCSHA1:(NSString *)key;
#pragma mark ======  URL encode/decode  ======
- (NSString *)imxStringByUrlEncoding;
- (NSString *)imxStringByUrlEncoding:(CFStringEncoding)encoding;
- (NSString *)imxStringByUrlDecode;
- (NSString *)imxStringByUrlDecode:(NSStringEncoding)encoding;
@end
