//
//  NSFileManager+pyhCanlendar.h
// Created by reset on 2018/7/13.

#import <Foundation/Foundation.h>

@interface NSFileManager (pyhCanlendar)

///配置文件夹 fd:目录名 用于区分多用户的存储
+ (BOOL)configFileDirectory:(NSString *)fdName;

///写入数据 fd:目录名 用于区分多用户的存储  key:文件名 用于数据的区分
+ (BOOL)writeDataToFileDirectory:(NSString *)fdName key:(NSString *)key data:(NSArray *)obj;

///提取数据 fd:目录名 用于区分多用户的存储  key:文件名 用于数据的区分
+ (NSArray *)readDataWithFileDirectory:(NSString *)fdName withKey:(NSString *)key;

///清空数据 fd:目录名 用于区分多用户的存储
+ (BOOL)removeDataWithFileDirectory:(NSString *)fdName;
@end
