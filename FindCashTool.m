//
//  FindCashTool.m
//  payTest
//
//  Created by Dafiger on 2018/5/10.
//  Copyright © 2018年 wpf. All rights reserved.
//

#import "FindCashTool.h"
#import "PayHeader.h"

@implementation FindCashTool

#pragma mark - 获取单例
+ (FindCashTool *)instance
{
    static FindCashTool *sharedManagerInstance = nil;
    static dispatch_once_t predicate = 0;
    dispatch_once( &predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

- (id)init
{
    self = [super init];
    if(self){
        [self initManager];
    }
    return self;
}

- (void)initManager
{
    // 设置捕捉异常的回调
    NSSetUncaughtExceptionHandler(handleException);
}

/**
 * 拦截异常
 */
void handleException(NSException *exception)
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"callStack"] = [exception callStackSymbols]; // 调用栈信息（错误来源于哪个方法）
    info[@"name"] = [exception name]; // 异常名字
    info[@"reason"] = [exception reason]; // 异常描述（报错理由）
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PayLogs" ofType:@"txt"];
    if (info.allKeys.count) {
        NSString *errorStr = [PayTools objectToJsonStr:info];
        [PayTools writeLogWithStr:errorStr];
    }
}

@end
