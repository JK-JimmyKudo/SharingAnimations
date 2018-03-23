//
//  WTQQShareManger.h
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WTShareContentItem.h"
typedef NS_ENUM(NSInteger, WTQQType) {
    WTLoginTypeTencent,      // QQ
    WTShareTypeQQ,          // QQ好友
    WTShareTypeQQZone,      // QQ空间
};

typedef NS_ENUM(NSInteger, WTLoginWeiXinErrCode) {
    WTErrCodeSuccess = 0,
    WTErrCodeCancel = -2,
};


typedef void(^WTQQResultBlock)(NSDictionary * LoginResult, NSString * error);


@interface WTQQShareManger : NSObject<TencentSessionDelegate, TencentLoginDelegate,QQApiInterfaceDelegate>


@property (nonatomic, copy)WTQQResultBlock resultBlock;
@property (nonatomic, assign)WTQQType wtLoginType;



+ (instancetype)QQShareManger;

+ (void)WT_LoginUserInfoWithWTQQType:(WTQQType)type result:(WTQQResultBlock)result;

+ (void)WT_shareWithContent:(WTShareContentItem *)contentObj shareType:(WTQQType)shareType shareResult:(WTQQResultBlock)shareResult;

// 判断QQ分享是否成功
+ (void)didReceiveTencentUrl:(NSURL *)url;
@end
