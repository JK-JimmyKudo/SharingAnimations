//
//  WTWBShareManger.m
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#define kSinaAppKey         @"1282955290"
#define kSinaRedirectURI    @"http://www.3dov.cn"
#define kSinaAppSecret @"e74d1f146a7fa5b9c076f3c6d95e5821"

#import "WTWBShareManger.h"

static WTWBShareManger * _instance;


@implementation WTWBShareManger

+ (void)initialize
{
    
    [WTWBShareManger WeiBoShareManger];
    
}

+ (instancetype)WeiBoShareManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
        [_instance setRegisterApps];
    });
    return _instance;
}

- (void)setRegisterApps
{
    // 注册Sina微博
    [WeiboSDK registerApp:kSinaAppKey];
    
}

+ (void)WT_LoginUserInfoWithWTQQType:(WTWBType)type result:(WTWBResultBlock)result{
    
    _instance.resultBlock = result;
    _instance.wtLoginType = type;
    
    if (type == WTWBLoginType) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kSinaRedirectURI;
        request.scope = @"follow_app_official_microblog";
        [WeiboSDK sendRequest:request];
    }
}

+ (void)WT_shareWithContent:(WTShareContentItem *)contentObj shareType:(WTWBType)shareType shareResult:(WTWBResultBlock)shareResult{
    [WTWBShareManger WeiBoShareManger];
    _instance.resultBlock = shareResult;
    _instance.wtLoginType = shareType;
    
    
    NSData* imageData = nil;
    NSString *imageStr  = [NSString stringWithFormat:@"http://alycdntest.app.img.3dov.cn/0B7B3C833E645062B9DCB2D47786A02F.jpg"];
    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]];
    UIImage *oldImage  = [UIImage imageWithData:imageData];
    if (oldImage == nil) {
        oldImage = [UIImage imageNamed:@"placeholder-H"];
    }
    UIImage *newImage = [[WTWBShareManger WeiBoShareManger] thumbImageWithImage:oldImage limitSize:CGSizeMake(200, 200)];
    NSString *descri = @"哈哈哈哈哈哈哈哈哈哈哈哈哈";
    NSString * linkUrl = @"http://www.163.com";
    
    
    switch (shareType) {
        case WTShareWBType:
        {
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = kSinaRedirectURI;
            authRequest.scope = @"all";
            WBMessageObject *message = [WBMessageObject message];
            WBImageObject *webpage = [WBImageObject object];
            webpage.imageData =  UIImageJPEGRepresentation(oldImage, 0.5);
            message.imageObject = webpage;
            message.text = [NSString stringWithFormat:@"%@ - %@", @"标题",linkUrl];
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            [WeiboSDK sendRequest:request];
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        /**
         WeiboSDKResponseStatusCodeSuccess               = 0,//成功
         WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
         WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
         WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
         WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
         WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
         WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
         WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
         WeiboSDKResponseStatusCodeUnknown               = -100,
         */
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            //NSLog(@"微博----分享成功!!!");
            
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
            [alertView show];
            
            self.resultBlock(nil,@"0");
//            [MBProgressHUD showAutoMessage:@"分享成功"];
            
        }else if(response.statusCode == WeiboSDKResponseStatusCodeUserCancel)
        {
            //        NSLog(@"微博----用户取消发送");
//            [MBProgressHUD showAutoMessage:@"取消分享"];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"取消分享" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
            [alertView show];
            
            self.resultBlock(nil,@"-1");
            
            
            
        }else if (response.statusCode == WeiboSDKResponseStatusCodeSentFail){
            //        NSLog(@"微博----发送失败!");
//            [MBProgressHUD showAutoMessage:@"发送失败"];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
            [alertView show];
            
            self.resultBlock(nil, @"-2");
//            self.successBlock(@"-2");
        }
        
    }else if ([response isKindOfClass:WBAuthorizeResponse.class]){
        NSLog(@"token %@", [(WBAuthorizeResponse *) response accessToken]);
        NSLog(@"uid %@", [(WBAuthorizeResponse *) response userID]);
        if ([(WBAuthorizeResponse *) response accessToken] ==nil ||[(WBAuthorizeResponse *) response userID]==nil ) {
            return;
            
        }else{
            [self getWeiBoUserInfo:[(WBAuthorizeResponse *) response userID] token:[(WBAuthorizeResponse *) response accessToken]];
        }
    }
}

- (void)getWeiBoUserInfo:(NSString *)uid token:(NSString *)token
{
    NSString *url =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@&source=%@",uid,token,kSinaAppKey];
    NSURL *zoneUrl = [NSURL URLWithString:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    // 创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:zoneUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", [NSThread currentThread]);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"dic === %@",dic);
        
        NSDictionary *paramter = @{@"third_id" : [dic valueForKeyPath:@"idstr"],
                                   @"third_name" : [dic valueForKeyPath:@"screen_name"],
                                   @"third_image":[dic valueForKeyPath:@"avatar_hd"],
                                   @"access_token":token};
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.resultBlock)
            {
                _resultBlock(paramter, nil);
            }
        }];
        
    }];
    
    // 启动任务
    [task resume];
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
