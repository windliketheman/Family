//
//  RequestCore.m
//  Family
//
//  Created by jia on 15/8/27.
//  Copyright (c) 2015年 jia. All rights reserved.
//

#import "RequestCore.h"
#import "AFNetworking.h"
#import "JSONModel.h"

@implementation RequestCore

#pragma mark - Get
+ (void)GET:(NSString *)urlstring params:(NSDictionary *)params success:(Success)successBlock failure:(Failure)failureBlock
{
    [self GET:urlstring params:params returnModel:nil success:successBlock failure:failureBlock];
}

+ (void)GET:(NSString *)urlstring params:(NSDictionary *)params returnModel:(Class)JSONModelClass success:(Success)successBlock failure:(Failure)failureBlock
{
    if (!urlstring)
    {
        NSLog(@"Error, requestWithCmd cmd is nil");
        return;
    }
    
    if (params)
    {
        // [params setObject:[NSString stringWithFormat:@"%lu", ++sidNum] forKey:@"sid"];
    }
    
    // 创建管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 利用方法请求数据
    NSLog(@"Request URL:\n%@\ndata\n%@", urlstring, [params description]);
    [manager GET:urlstring parameters:params success:^(AFHTTPRequestOperation *operation, id result) {
        
        if (successBlock)
        {
            if (result)
            {
                [self request:operation complectionData:result callback:successBlock dataModal:JSONModelClass];
            }
            else
            {
                successBlock(nil);
                return;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error && failureBlock)
        {
            failureBlock(error);
            return;
        }
    }];
}

+ (void)POST:(NSString *)urlstring params:(NSDictionary *)params success:(Success)successBlock failure:(Failure)failureBlock
{
    [self POST:urlstring params:params returnModel:nil success:successBlock failure:failureBlock];
}

+ (void)POST:(NSString *)urlstring params:(NSDictionary *)params returnModel:(Class)JSONModelClass success:(Success)successBlock failure:(Failure)failureBlock
{
    if (!urlstring)
    {
        NSLog(@"Error, requestWithCmd cmd is nil");
        return;
    }
    
    if (params)
    {
        // [params setObject:[NSString stringWithFormat:@"%lu", ++sidNum] forKey:@"sid"];
    }
    
    // 创建管理类
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置二进制数据，数据格式默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 利用方法请求数据
    NSLog(@"Request URL:\n%@\ndata\n%@", urlstring, [params description]);
    [manager POST:urlstring parameters:params success:^(AFHTTPRequestOperation *operation, id result) {
        
        if (successBlock)
        {
            if (result)
            {
                [self request:operation complectionData:result callback:successBlock dataModal:JSONModelClass];
            }
            else
            {
                successBlock(nil);
                return;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error && failureBlock)
        {
            NSDictionary *headerFields = [operation.request allHTTPHeaderFields];
            NSLog(@"HTTPHeaderFields: %@", [headerFields description]);
            
            failureBlock(error);
            return;
        }
    }];
}

+ (void)request:(AFHTTPRequestOperation *)operation complectionData:(id)result callback:(Success)successBlock dataModal:(Class)JSONModelClass
{
    // successBlock([[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
    id jsonData = [self unpackResponseData:(NSData *)result];
    
    // 未传入数据实体，不解析
    if (!JSONModelClass ||
        ![JSONModelClass isSubclassOfClass:[JSONModel class]])
    {
        successBlock(jsonData);
        return;
    }
    else
    {
        if ([jsonData isKindOfClass:[NSArray class]])
        {
            NSMutableArray *outputArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in jsonData)
            {
                JSONModel *itemData = [[JSONModelClass alloc] initWithDictionary:dic error:nil];
                
#if 0
                if (JSONModelClass == NSClassFromString(@"FamilyMembersModel"))
                {
                    if (dic[@"nickName"])
                    {
                        [itemData setValue:dic[@"nickName"] forKeyPath:@"nickName"];
                    }
                    
                    if (dic[@"userID"])
                    {
                        [itemData setValue:dic[@"userID"] forKeyPath:@"userID"];
                    }
                }
#endif
                
                [outputArray addObject:itemData];
            }
            
            successBlock(outputArray);
            return;
        }
        else if ([jsonData isKindOfClass:[NSDictionary class]])
        {
            JSONModel *dataModal = [[JSONModelClass alloc] initWithDictionary:jsonData error:nil];
            
            successBlock(dataModal);
            return;
        }
        else
        {
            successBlock(jsonData);
            return;
        }
    }
}

// 解析服务端返回的数据返回基本类型
+  (id)unpackResponseData:(NSData *)responseData
{
    /*    //异或解密
     NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSISOLatin1StringEncoding];
     NSString *decryptText = [XOREncryptAndDecrypt decryptForEncryption:responseStr];
     
     //解压缩
     #ifdef NeedCompress
     NSData *decomData = [[[decryptText copy] dataUsingEncoding:NSISOLatin1StringEncoding] gzipInflate];
     #else
     NSData *decomData = [[decryptText copy] dataUsingEncoding:NSISOLatin1StringEncoding];
     #endif
     */
    //进行json解析
    id jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    //NSLog(@"unpackResponseData jsonData is %@",jsonData);
    
    return jsonData;
}

@end
