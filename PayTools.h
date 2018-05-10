//
//  PayTools.h
//  payTest
//
//  Created by Dafiger on 2018/5/9.
//  Copyright © 2018年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayTools : NSObject

#pragma mark - Json与Object互转
+ (NSString *)objectToJsonStr:(id)object;
+ (id)jsonStrToObject:(NSString *)jsonStr;

#pragma mark - 持续写入日志
+ (void)writeLogWithStr:(NSString *)string;
#pragma mark - 选择文件主路径
+ (NSString *)selectFileBasePathNum:(int)num;
#pragma mark - 创建文件路径
+ (NSString *)createFileBasePathNum:(int)num
                           foldName:(NSString *)foldName
                           fileName:(NSString *)fileName;
#pragma mark - 检查文件路径是否存在
+ (BOOL)checkFileWithPath:(NSString *)filePath;
#pragma mark - 写入文件流
+ (BOOL)writeFileToPath:(NSString *)filePath
                   data:(NSData *)tmpData;
#pragma mark - 读取文件流
+ (NSData *)readFileDataFromPath:(NSString *)filePath;

@end
