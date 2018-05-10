//
//  PayTools.m
//  payTest
//
//  Created by Dafiger on 2018/5/9.
//  Copyright © 2018年 wpf. All rights reserved.
//

#import "PayTools.h"
#import "PayHeader.h"

@implementation PayTools

#pragma mark - Json与Object互转
+ (NSString *)objectToJsonStr:(id)object
{
    NSString *json_str = @"";
    @try {
        NSData *json_data = [NSJSONSerialization dataWithJSONObject:object
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:nil];
        json_str = [[NSString alloc] initWithData:json_data
                                         encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        PayLog(@"Pay:%s [Line %d] 对象转换成JSON字符串出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    @finally {
        
    }
    return json_str;
}

+ (id)jsonStrToObject:(NSString *)jsonStr
{
    // NSJSONReadingMutableContainers：返回可变容器
    // NSJSONReadingMutableLeaves：返回的JSON对象中字符串的值为NSMutableString
    // NSJSONReadingAllowFragments：允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment。
    id object = nil;
    @try {
        NSData *json_data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];;
        object = [NSJSONSerialization JSONObjectWithData:json_data
                                                 options:NSJSONReadingAllowFragments
                                                   error:nil];
    }
    @catch (NSException *exception) {
        PayLog(@"Pay:%s [Line %d] JSON字符串转换成对象出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    @finally {
        
    }
    return object;
}

#pragma mark - 持续写入日志
+ (void)writeLogWithStr:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *homePath = [paths objectAtIndex:0];
    NSString *filePath = [homePath stringByAppendingPathComponent:@"logfile.txt"];
    PayLog(@"日志路径>>>>>>>>%@",filePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath])//如果不存在
    {
        NSString *str = @"日志：";
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];//将节点跳到文件的末尾
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@">>>>>>>>yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *str = [NSString stringWithFormat:@"\n%@\n%@",datestr,string];
    NSData *stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    [fileHandle closeFile];
}

#pragma mark - 选择文件主路径
+ (NSString *)selectFileBasePathNum:(int)num
{
    if(num == 1){
        // 临时文件路径
        // NSString *tmp = NSTemporaryDirectory();
        NSString *tmp = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
        return tmp;
    }else if(num == 2){
        // 缓存路径
        // NSString *library = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
        // NSString *cache = [library stringByAppendingPathComponent:@"Caches"];
        NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        return cache;
    }else{
        // 目录路径
        // NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        return documents;
    }
}

#pragma mark - 创建文件路径
+ (NSString *)createFileBasePathNum:(int)num
                           foldName:(NSString *)foldName
                           fileName:(NSString *)fileName
{
    //    NSString *path = [self selectFileBasePathNum:num];
    NSString *path = [[self class] selectFileBasePathNum:num];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *foldPath = [path stringByAppendingPathComponent:foldName];
    if (![fileManager fileExistsAtPath:foldPath]){
        [fileManager createDirectoryAtPath:foldPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [foldPath stringByAppendingPathComponent:fileName];
    return filePath;
}

#pragma mark - 检查文件路径是否存在
+ (BOOL)checkFileWithPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

#pragma mark - 写入文件流
+ (BOOL)writeFileToPath:(NSString *)filePath
                   data:(NSData *)tmpData
{
    BOOL success = [tmpData writeToFile:filePath atomically:YES];
    if (success) {
#ifdef Debug_Log
        NSLog(@"文件保存成功");
#endif
        return YES;
    }else{
#ifdef Debug_Log
        NSLog(@"文件保存失败");
#endif
        return NO;
    }
}

#pragma mark - 读取文件流
+ (NSData *)readFileDataFromPath:(NSString *)filePath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:filePath]){
        NSData *data = [NSData dataWithContentsOfFile:filePath];
#ifdef Debug_Log
        NSLog(@"读取文件成功");
#endif
        return data;
    }else{
#ifdef Debug_Log
        NSLog(@"读取文件失败");
#endif
        return nil;
    }
}
@end
