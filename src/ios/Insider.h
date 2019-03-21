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
+(void)handlePushLog:(NSDictionary *)launchOptions;

+(void)setHybridSDKVersion:(NSString *)sdkVersion;

+(void)setCustomAttributes:(NSDictionary*)customAttributes;
+(void)setCustomAttributeWithString:(NSString *)key value:(NSString *)value;
+(void)setCustomAttributeWithBOOL:(NSString *)key value:(BOOL)value;
+(void)setCustomAttributeWithDouble:(NSString *)key value:(double)value;
+(void)setCustomAttributeWithDate:(NSString *)key value:(NSDate *)value;
+(void)setCustomAttributeWithArray:(NSString *)key value:(NSArray *)value;
+(void)unsetCustomAttribute:(NSString *)key;

+(void)setUserIdentifier:(NSString *)identifier;
+(void)unsetUserIdentifier;

+(void)tagEvent:(NSString *)event;
+(void)tagEventWithParameters:(NSString *)event parameters:(NSDictionary *)parameters;

+(void)setPushEnabled:(BOOL)pushEnabled;
+(void)setLocationEnabled:(BOOL)locationEnabled;


+(void)tagProduct:(NSString *)productID;
+(void)trackPurchasedItems:(NSString *)uniqueSaleID name:(NSString *)name category:(NSString *)category subCategory:(NSString *)subCategory price:(double)price currency:(NSString *)currency productID:(NSString *)productID;


+(void)itemAddedToCart:(NSString *)productID productName:(NSString *)productName productPrice:(double)productPrice productCurrency:(NSString *)productCurrency productImageURL:(NSString *)productImageURL;
+(void)itemRemovedFromCart:(NSString *)productID;
+(void)cartCleared;

+(void)registerWithQuietPermission:(BOOL)enabled;
+(void)startTrackingUserLocation;
+(void)startTrackingGeofence;
-(void)addTestDevice:(NSString *)apiToken;
-(void)startCountly:(BOOL)isEnabled;
+(void)removeInapp;
+(void)handleUrl:(NSURL *)openUrl;
+(void)registerPushNotification:(UIApplication*)app deviceToken:(NSData*)inDeviceToken;
+(void)trackInteractiveLog:(NSString *)appGroup userInfo:(NSDictionary *)userInfo;
+(NSDictionary *)getAdvancedPushDeepLink:(NSDictionary *)launchOptions;

// Recommendaiton
+(void)getRecommendationAsMostViewed:(NSString*)language params:(NSDictionary*)params success:(void (^)(NSDictionary *recommendation))completionBlock;
+(void)getRecommendationAsMostPurchased:(NSString*)language params:(NSDictionary*)params success:(void (^)(NSDictionary *recommendation))completionBlock;
+(void)getRecommendationAsViewToView:(NSString*)language productID:(NSString*)productID params:(NSDictionary*)params success:(void (^)(NSDictionary *recommendation))completionBlock;
+(void)getRecommendationAsBuyToBuy:(NSString*)language productID:(NSString*)productID params:(NSDictionary*)params success:(void (^)(NSDictionary *recommendation))completionBlock;

+(void)getMessageCenterData:(NSDate *)startDate endDate:(NSDate *)endDate limit:(int)limit success:(void (^)(NSArray *messageCenterData))completionBlock;

+(void)setGDPRConsent:(BOOL)gdprConsent;
//On Premise functions
+(void)initSDK:(NSString*)partnerName launchOptions:(NSDictionary*)launchOptions customEndpoint:(NSString *)link;
+(void)initSDK:(NSString*)partnerName launchOptions:(NSDictionary*)launchOptions withAppGroup:(NSString *)appGroup customEndpoint:(NSString *)link;

typedef NS_ENUM(NSInteger, InsiderVariableDataType) {
    InsiderVariableDataTypeContent = 0,
    InsiderVariableDataTypeElement,
};

+(NSString *)getStringWithName:(NSString *)name defaultString:(NSString *)defaultString dataType:(InsiderVariableDataType)dataType;
+(BOOL)getBoolWithName:(NSString *)name defaultBool:(BOOL)defaultBool dataType:(InsiderVariableDataType)dataType;
+(int)getIntWithName:(NSString *)name defaultInt:(int)defaultInt dataType:(InsiderVariableDataType)dataType;
+(void)sendError:(NSException *)crashError desc:(NSString *)desc;
@end
