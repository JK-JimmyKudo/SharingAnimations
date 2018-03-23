//
//  WTWXShareManger.m
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#define kWeixinAppId    @"wx5dd367c7eca31118"
#define kWeixinAppSecret @"17fd64dfed3e996fa26b9c50332ec178"


#import "WTWXShareManger.h"


static WTWXShareManger * _instance;


@interface WTWXShareManger ()

@property (nonatomic, strong)NSString * access_token;

@end


@implementation WTWXShareManger


+ (void)initialize
{
    
    [WTWXShareManger WXShareManger];
    
}

+(instancetype) WXShareManger{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
        [_instance setRegisterApps];
    });
    return _instance;
}




// 注册app
// 注册appid
- (void)setRegisterApps
{
   [WXApi registerApp:kWeixinAppId];
}

+(void) WT_LoginUserInfoWithWTQQType:(WTWXType)type result:(WTQQResultBlock)result{
    _instance.resultBlock = result;
    _instance.wtLoginType = type;
     if (type == WTLoginTypeWeiXin){
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.openID = kWeixinAppSecret;
        req.state = @"App";
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }
}


+(void) WT_shareWithContent:(WTShareContentItem *)contentObj shareType:(WTWXType)shareType shareResult:(WTQQResultBlock)shareResult{
    [WTWXShareManger WXShareManger];
    _instance.resultBlock = shareResult;
    _instance.wtLoginType = shareType;
    /**
     *  授权微信链接分享
     *
     *  @param linkTitle    链接标题
     *  @param description  链接描述
     *  @param thumbImage   链接缩略图
     *  @param linkUrl      链接地址
     *  @param scene        分享类型(会话、朋友圈、收藏)
     *  @param success      成功回调
     *  @param failure      失败回调
     */
    
    NSData* imageData = nil;
    NSString *imageStr  = [NSString stringWithFormat:@"http://alycdntest.app.img.3dov.cn/0B7B3C833E645062B9DCB2D47786A02F.jpg"];
    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    UIImage *oldImage  = [UIImage imageWithData:imageData];
    if (oldImage == nil) {
        oldImage = [UIImage imageNamed:@"placeholder-H"];
    }
    UIImage *newImage = [[ WTWXShareManger WXShareManger] thumbImageWithImage:oldImage limitSize:CGSizeMake(200, 200)];
    NSString *descri = @"哈哈哈哈哈哈哈哈哈哈哈哈哈";
    NSString * linkUrl = @"http://www.163.com";
    
    
    switch (shareType) {
        case WTShareTypeWeiXinSession:
        {
            WXMediaMessage * message = [WXMediaMessage message];
            message.title = @"标题";
            [message setThumbImage:newImage];
            //描述
            message.description = descri;
            WXWebpageObject * ext = [WXWebpageObject object];
            ext.webpageUrl = linkUrl;
            message.mediaObject = ext;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            [WXApi sendReq:req];
            break;
        }
        case WTShareTypeWeiXinTimeline: // 微信朋友圈
        {
            WXMediaMessage * message = [WXMediaMessage message];
            //标题
            message.title = descri;
            //照片
            [message setThumbImage:newImage];
            //描述
            message.description = descri;
            WXWebpageObject * ext = [WXWebpageObject object];
            ext.webpageUrl = linkUrl;
            message.mediaObject = ext;
            SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            [WXApi sendReq:req];
            break;
        }
        default:
            break;
    }
}


#pragma mark - WXApiDelegate
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (resp.errCode == WTShareWeiXinErrCodeSuccess) {
            NSString *code = aresp.code;
            
            NSLog(@"🐶🐶🐶🐶🐶🐶🐶🐶 code == %@ ",code);
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示==code" message:code delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
            [alertView show];
            
//            [kMyDefaults setObject:code forKey:@"code"];
//            [kMyDefaults synchronize];
            
            [[WTWXShareManger WXShareManger] getWeiXinUserInfoWithCode:code];
            
        }else{
            if (self.resultBlock)
            {
                self.resultBlock(nil, @"授权失败");
            }
        }
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        if (resp.errCode == WTShareWeiXinErrCodeSuccess) {
//            [MBProgressHUD showAutoMessage:@"分享成功"];
//            self.successBlock(@"0");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
            [alertView show];
            
            self.resultBlock(@{@"CodeSuccess":@"分享成功"}, @"0");
        
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"取消分享" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
            [alertView show];
//            [MBProgressHUD showAutoMessage:@"取消分享"];
//            self.successBlock(@"-1");
            self.resultBlock(@{@"CodeSuccess":@"取消分享"}, @"-1");
        }
    }else if([resp isKindOfClass:[PayResp class]]){
//        //支付回调
//        WTLoginWeiXinErrCode errorCode = XLsn0wPayResultSuccess;
//        NSString *errStr = resp.errStr;
//        switch (resp.errCode) {
//            case 0:
//                errorCode = XLsn0wPayResultSuccess;
//                errStr = @"订单支付成功";
//                //                [MBProgressHUD showAutoMessage:@"订单支付成功"];
//                NSLog(@"errStr %@ ",errStr);
//
//                break;
//            case -1:
//                errorCode = XLsn0wPayResultFailure;
//                errStr = resp.errStr;
//                NSLog(@"errStr %@ ",errStr);
//
//                break;
//            case -2:
//                errorCode = XLsn0wPayResultCancel;
//                errStr = @"用户中途取消";
//
//                //                [MBProgressHUD showAutoMessage:@"用户取消支付"];
//
//                NSLog(@"errStr %@ ",errStr);
//
//                break;
//            default:
//                errorCode = XLsn0wPayResultFailure;
//                errStr = resp.errStr;
//                NSLog(@"errStr %@ ",errStr);
//
//                break;
//        }
//        if (self.callBack) {
//            self.callBack(errorCode,errStr);
//        }
    }
}

- (void)getWeiXinUserInfoWithCode:(NSString *)code
{
    NSString * urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeixinAppId,kWeixinAppSecret,code];
    
    NSURL *url = [NSURL URLWithString:urlStr];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户取消授权" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
                    [alertView show];
                    
                }else{
                    self.access_token = [dict objectForKey:@"access_token"];
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
            }
        });
    });
}

/**
 *  获取用户信息
 *
 *  @param accessToken access_token
 *  @param openId      openId description
 */
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                //                NSLog(@"dict = %@",dict);
                if ([dict objectForKey:@"errcode"])
                {
                    //                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:self.access_token]];
                    
                }else{
                    
                    NSDictionary *paramter = [NSDictionary dictionaryWithObjectsAndKeys:dict[@"openid"],@"third_id",
                                              dict[@"nickname"],@"third_name",
                                              dict[@"headimgurl"],@"third_image",
                                              self.access_token,@"access_token", nil];
                    self.resultBlock(paramter, nil);
                    //                    if ([_delegate respondsToSelector:@selector(WXLoginShareLoginSuccess:)]) {
                    //                        [_delegate WXLoginShareLoginSuccess:dict];
                    //                    }
                }
            }
        });
    });
}
/**
 *  刷新access_token
 *
 *  @param refreshToken refreshToken description
 */
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWeixinAppId,refreshToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else{
                    //重新使用AccessToken获取信息
                }
            }
        });
    });
}

//这种方法对图片既进行压缩，又进行裁剪
- (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if (scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height) {
        return scImg;
    }
    CGSize thumbSize;
    if (scImg.size.width / scImg.size.height > limitSize.width / limitSize.height) {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / scImg.size.width * scImg.size.height;
    }else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}

@end
