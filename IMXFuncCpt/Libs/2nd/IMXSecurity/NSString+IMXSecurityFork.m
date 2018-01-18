//
//  NSString+IMXSecurityFork.m
//  IMXSecurityCpt
//
//  Created by zhoupanpan on 2017/8/10.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "NSString+IMXSecurityFork.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
@implementation NSString (IMXSecurityFork)

#pragma mark ======  md5 encode  ======
- (NSString *)imxMd5Encode
{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return hash;
}
#pragma mark ======  DES encode/decode  ======
+ (NSString *)imx_DESEncrypt:(NSString *)original key:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [original dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    Byte *iv = (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv, [textData bytes], dataLength,
                                          buffer, 1024, &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        ciphertext = [NSString imx_parseByte2HexString:buffer length:(NSUInteger)numBytesEncrypted];
    }
    return ciphertext;
}
+ (NSString *)imx_DESDecrypt:(NSString *)original key:(NSString *)key {
    NSString *plaintext = nil;
    //    NSData *cipherdata = [GTMBase64 decodeString:cipherText];
    NSData *cipherdata = [NSString imx_hexStringToData:original];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte *iv = (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv, [cipherdata bytes], [cipherdata length],
                                          buffer, 1024, &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc] initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}
#pragma mark ======  hash  ======
- (NSString *)imxHAMCSHA1:(NSString *)key {
    
    const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
}
#pragma mark ======  URL encode/decode  ======
- (NSString *)imxStringByUrlEncoding
{
    return [self imxStringByUrlEncoding:kCFStringEncodingUTF8];
}
- (NSString *)imxStringByUrlEncoding:(CFStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", encoding));
}
- (NSString *)imxStringByUrlDecode
{
    return [self imxStringByUrlDecode:NSUTF8StringEncoding];
}
- (NSString *)imxStringByUrlDecode:(NSStringEncoding)encoding
{
    return [self stringByReplacingPercentEscapesUsingEncoding:encoding];
}
#pragma mark ======  private  ======
+ (NSString *)imx_parseByte2HexString:(unsigned char[])bytes length:(NSUInteger)len
{
    
    NSMutableString *hexStr = [[NSMutableString alloc] init];
    int i = 0;
    
    if(bytes) {
        
        while (i < len) {
            
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];
            if([hexByte length]==1) {
                [hexStr appendFormat:@"0%@", hexByte];
            } else {
                [hexStr appendFormat:@"%@", hexByte];
            }
            i++;
        }
    }
    return [hexStr uppercaseString];
}
+ (NSData *)imx_hexStringToData:(NSString *)hexString
{
    int len = (int)[hexString length] / 2;
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [hexString length] / 2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i*2];
        byte_chars[1] = [hexString characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}
@end
