//
//  WTQQShareManger.h
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WTLoginType) {
    WTLoginTypeWeiBo = 0,   // 新浪微博
    WTLoginTypeTencent,      // QQ
    WTLoginTypeWeiXin       // 微信
};

typedef NS_ENUM(NSInteger, WTLoginWeiXinErrCode) {
    WTErrCodeSuccess = 0,
    WTErrCodeCancel = -2,
};

@interface WTQQShareManger : NSObject

@end
