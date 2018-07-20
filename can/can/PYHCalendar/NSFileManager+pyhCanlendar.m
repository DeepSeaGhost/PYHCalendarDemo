//
//  NSFileManager+pyhCanlendar.m
// Created by reset on 2018/7/13.

#import "NSFileManager+pyhCanlendar.h"
#define kPATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject
#define kMAINPATH [kPATH stringByAppendingPathComponent:[self base64String:@"pyhCalendar"]]
#define kSUBPATH(name) [kMAINPATH stringByAppendingPathComponent:[self base64String:name]]

@implementation NSFileManager (pyhCanlendar)

#pragma mark - 配置文件目录(文件夹) 区分不同账户(用户)
+ (BOOL)configFileDirectory:(NSString *)fdName {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:kMAINPATH]) {
        return [self creatDirectoryAtPath:kSUBPATH(fdName)];
    }else {
        BOOL isFinish = [manager createDirectoryAtPath:kMAINPATH withIntermediateDirectories:YES attributes:nil error:nil];
        if (isFinish) {
           return [self creatDirectoryAtPath:kSUBPATH(fdName)];
        }
    }
    return NO;
}
+ (BOOL)creatDirectoryAtPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        return [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;//已经存在了
}


#pragma mark - 写入数据 
+ (BOOL)writeDataToFileDirectory:(NSString *)fdName key:(NSString *)key data:(NSArray *)obj {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [kSUBPATH(fdName) stringByAppendingPathComponent:key];
    if ([manager fileExistsAtPath:kSUBPATH(fdName)]) {
        BOOL isWrite = [obj writeToFile:path atomically:YES];
        NSLog(@"%@",isWrite ? @"数据写入成功" : @"数据写入失败");
        return isWrite;
    }else {
        if ([self configFileDirectory:fdName]) {
            [self writeDataToFileDirectory:fdName key:key data:obj];
        }
    }
    return NO;
}

#pragma mark - 读取数据
+ (NSArray *)readDataWithFileDirectory:(NSString *)fdName withKey:(NSString *)key {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [kSUBPATH(fdName) stringByAppendingPathComponent:key];
    if ([manager fileExistsAtPath:kSUBPATH(fdName)]) {
        NSArray *obj = [NSArray arrayWithContentsOfFile:path];
        NSLog(@"%@",obj ? @"数据读取成功" : @"数据读取失败");
        return obj;
    }
    return nil;
}

#pragma mark - 清空数据
+ (BOOL)removeDataWithFileDirectory:(NSString *)fdName {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isRemove = [manager removeItemAtPath:kSUBPATH(fdName) error:nil];
    NSLog(@"%@",isRemove ? @"移除成功" : @"移除失败");
    return isRemove;
}

+ (NSString *)base64String:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}
@end
