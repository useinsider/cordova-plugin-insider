//
//  ;
//  SDK
//
//  Created by Insider on 20.06.2016.
//  Copyright © 2016 Insider. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Insider : NSObject
+(void)initSDK:(NSString*)partnerName launchOptions:(NSDictionary*)launchOptions;
+(void)initSDK:(NSString*)partnerName launchOptions:(NSDictionary*)launchOptions withAppGroup:(NSString *)appGroup;
+(void)startAutoIntegration:(BOOL)shouldStart;
+(void)resumeSession;
+(void)setUserAttributes:(NSDictionary*)attr;
+(void)tagEvent:(NSString *)eventName;

+(void)tagProduct:(NSString *)productID;

+(void)trackSales:(NSString *) saleUniqueCode saleAmount:(NSInteger) saleAmount saleCurrency:(NSString *)currency ;
+(void)trackPurchasedItems:(NSString *)uniqueSaleID name:(NSString *)name category:(NSString *)category subCategory:(NSString *)subCategory price:(double)price currency:(NSString *)currency productID:(NSString *)productID;


+(void)itemAddedToCart:(NSString *)productName productPrice:(double)productPrice productCurrency:(NSString *)productCurrency productImageURL:(NSString *)productImageURL;
+(void)itemRemovedFromCart:(NSString *)productName;
+(void)cartCleared;

+(void)registerPush;
+(void)startTrackingUserLocation;
+(void)startTrackingGeofence;
-(void)addTestDevice:(NSString *)apiToken;
-(void)startCountly:(BOOL)isEnabled;
+(void)removeInapp;
+(void)handleUrl:(NSURL *)openUrl;
+(void)registerPushNotification:(UIApplication*)app deviceToken:(NSData*)inDeviceToken;
+(void)trackInteractiveLog:(NSString *)appGroup userInfo:(NSDictionary *)userInfo;
+(void)handlePushLog:(NSDictionary *)launchOptions;
+(NSDictionary *)getAdvancedPushDeepLink:(NSDictionary *)launchOptions appGroup:(NSString *)appGroup;

+(void)getRecommendedData:(NSString *)productID success:(void (^)(NSDictionary *jsonObject))completionBlock;

//On Premise functions
+(void)initSDK:(NSString*)partnerName launchOptions:(NSDictionary*)launchOptions customEndpoint:(NSString *)link;
+(void)initSDK:(NSString*)partnerName launchOptions:(NSDictionary*)launchOptions withAppGroup:(NSString *)appGroup customEndpoint:(NSString *)link;

@end
