//
//  ViewController.m
//  can
//
//  Created by reset on 2018/6/21.
//  Copyright © 2018年 HangzhouVongi. All rights reserved.
//

#import "ViewController.h"
#import "PYHCalendarViewController.h"
#import "NSFileManager+pyhCanlendar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    for (int i = 0; i < 7; i ++) {
        NSString *str = [@"2018-06-" stringByAppendingFormat:@"%d",17+i];
        NSDate *date = [formatter dateFromString:str];
        NSDateComponents *com = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:date];
        NSLog(@"%zd",com.weekday);
        
        NSDateFormatter *formatterr = [[NSDateFormatter alloc]init];
        formatterr.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSLog(@"%@",[formatterr stringFromDate:date]);
    }
    
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSDateComponents *compt = [[NSDateComponents alloc] init];
//
//    [compt setYear:2012];
//    [compt setMonth:5];
//    [compt setDay:11];
//
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *date = [calendar dateFromComponents:compt];
//    //得到本地时间，避免时区问题
//    NSTimeZone *zone = [NSTimeZone localTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
//
//    NSLog(@"%@",localeDate);
    
    [self presentViewController:[PYHCalendarViewController new] animated:YES completion:nil];
//    NSArray *arr = @[@1,@2];
//    BOOL is = [arr containsObject:@1];
//    if (is) {
//        NSLog(@"yes");
//    }else {
//        NSLog(@"no");
//    }
    
//    [NSFileManager writeDataToFileDirectory:@"2018" key:@"key" data:@{@"name":@"name",@"age":@18,@"sex":@1,@"address":@"address"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
