//
//  DTSMTPManager.h
//  DTEN
//
//  Created by 东途 on 16/7/6.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKPSMTPMessage;
@interface DTSMTPManager : NSObject

+ (instancetype)sharedManager;

- (void)sendWithSenderID:(NSString *)dtenID recive:(NSString *)toEmail path:(NSString *)path;

@property (copy, nonatomic) void(^sentSuccess)();
@property (copy, nonatomic) void(^sentFailure)(NSError *error);

@end
