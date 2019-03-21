/********* insider.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "Insider.h"

@interface insider : CDVPlugin {

}

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)registerPushWithQuietPermission:(CDVInvokedUrlCommand*)command;
- (void)refreshDeviceToken:(CDVInvokedUrlCommand*)command;
- (void)tagEvent:(CDVInvokedUrlCommand*)command;
- (void)tagEventWithParameters:(CDVInvokedUrlCommand*)command;
- (void)setCustomAttributes:(CDVInvokedUrlCommand*)command;
- (void)setCustomAttributeWithString:(CDVInvokedUrlCommand*)command;
- (void)setCustomAttributeWithDouble:(CDVInvokedUrlCommand*)command;
- (void)setCustomAttributeWithBoolean:(CDVInvokedUrlCommand*)command;
- (void)setCustomAttributeWithDate:(CDVInvokedUrlCommand*)command;
- (void)setCustomAttributeWithArray:(CDVInvokedUrlCommand*)command;
- (void)setPushEnabled:(CDVInvokedUrlCommand*)command;
- (void)setLocationEnabled:(CDVInvokedUrlCommand*)command;
- (void)unsetCustomAttribute:(CDVInvokedUrlCommand*)command;
- (void)setUserIdentifier:(CDVInvokedUrlCommand*)command;
- (void)unsetUserIdentifier:(CDVInvokedUrlCommand*)command;
- (void)tagProduct:(CDVInvokedUrlCommand*)command;
- (void)trackPurchasedItems:(CDVInvokedUrlCommand*)command;
- (void)itemAddedToCart:(CDVInvokedUrlCommand*)command;
- (void)itemRemovedFromCart:(CDVInvokedUrlCommand*)command;
- (void)cartCleared:(CDVInvokedUrlCommand*)command;
- (void)getDeepLinkData:(CDVInvokedUrlCommand*)command;
- (void)startTrackingGeofence:(CDVInvokedUrlCommand*)command;
- (void)getStringWithName:(CDVInvokedUrlCommand*)command;
- (void)getIntWithName:(CDVInvokedUrlCommand*)command;
- (void)getBoolWithName:(CDVInvokedUrlCommand*)command;
@end

@implementation insider

int INVALID_DATA_TYPE = -1;

- (void)pluginInitialize {}

-(NSDictionary *)getPushInfo{
  NSUserDefaults *pref = [[NSUserDefaults alloc] init];
  NSDictionary *mainDict = [pref objectForKey:@"InsiderDeepLinks"];
  NSDictionary *deepLinks = [mainDict objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (deepLinks){
    return deepLinks;
  }

  return mainDict;
}

-(InsiderVariableDataType)getDataType:(NSString *)dataType{
    if ([dataType isEqualToString:@"Content"]){
        return InsiderVariableDataTypeContent;
    } else if ([dataType isEqualToString:@"Element"]){
        return InsiderVariableDataTypeElement;
    } else {
        return INVALID_DATA_TYPE;
    }
}

- (void)init:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* partnerName = [[command arguments] objectAtIndex:0];
        [Insider startAutoIntegration:true];
        [Insider initSDK:partnerName launchOptions:nil];
        [Insider resumeSession];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - init"];
    }
}

- (void)refreshDeviceToken:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* deviceToken = [[command arguments] objectAtIndex:0];
        NSData* data=[deviceToken dataUsingEncoding:NSUTF8StringEncoding];
        [Insider registerPushNotification:nil deviceToken:data];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - refreshDeviceToken"];
    }
}

- (void)registerPushWithQuietPermission:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* quietPermission = [[command arguments] objectAtIndex:0];
        [Insider registerWithQuietPermission:[quietPermission boolValue]];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - registerPushWithQuietPermission"];
    }
}

- (void)getStringWithName:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* variableName = [[command arguments] objectAtIndex:0];
        NSString* defaultString = [[command arguments] objectAtIndex:1];
        NSString* dataType = [[command arguments] objectAtIndex:2];
        InsiderVariableDataType insiderDataType = [self getDataType:dataType];
        if (insiderDataType == INVALID_DATA_TYPE) return;
        NSString* optimisedString = [Insider getStringWithName:variableName defaultString:defaultString dataType:insiderDataType];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:optimisedString];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - getStringWithName"];
    }
}

- (void)getIntWithName:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* variableName = [[command arguments] objectAtIndex:0];
        int defaultInt = [[[command arguments] objectAtIndex:1] intValue];
        NSString* dataType = [[command arguments] objectAtIndex:2];
        InsiderVariableDataType insiderDataType = [self getDataType:dataType];
        if (insiderDataType == INVALID_DATA_TYPE) return;
        int optimisedInt = [Insider getIntWithName:variableName defaultInt:defaultInt dataType:insiderDataType];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:optimisedInt];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - getIntWithName"];
    }
}

- (void)getBoolWithName:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* variableName = [[command arguments] objectAtIndex:0];
        BOOL defaultBool = [[[command arguments] objectAtIndex:1] boolValue];
        NSString* dataType = [[command arguments] objectAtIndex:2];
        InsiderVariableDataType insiderDataType = [self getDataType:dataType];
        if (insiderDataType == INVALID_DATA_TYPE) return;
        BOOL optimisedBool = [Insider getBoolWithName:variableName defaultBool:defaultBool dataType:insiderDataType];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:optimisedBool];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - getBoolWithName"];
    }
}

- (void)getDeepLinkData:(CDVInvokedUrlCommand*)command{
    @try {
        NSDictionary *deepLinks = [self getPushInfo];
        if (deepLinks){
            NSString *deepLink = [deepLinks objectForKey: [[command arguments] objectAtIndex:0]];
            if (deepLink){
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:deepLink];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - getDeepLinkData"];
    }
}

- (void)startTrackingGeofence:(CDVInvokedUrlCommand*)command{
    @try {
        [Insider startTrackingGeofence];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - startTrackingGeofence"];
    }
}

- (void)tagEvent:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* eventName = [[command arguments] objectAtIndex:0];
        [Insider tagEvent:eventName];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - tagEvent"];
    }
}

- (void)tagEventWithParameters:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* eventName = [[command arguments] objectAtIndex:0];
        NSDictionary* parameters = [[command arguments] objectAtIndex:1];
        [Insider tagEventWithParameters:eventName parameters:parameters];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - tagEventWithParameters"];
    }
}

- (void)setCustomAttributes:(CDVInvokedUrlCommand*)command{
    @try {
        NSDictionary *attributes = [[command arguments] objectAtIndex:0];
        [Insider setCustomAttributes:attributes];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setCustomAttributes"];
    }
}

- (void)setCustomAttributeWithString:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* key = [[command arguments] objectAtIndex:0];
        NSString* value = [[command arguments] objectAtIndex:1];
        [Insider setCustomAttributeWithString:key value:value];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setCustomAttributeWithString"];
    }
}

- (void)setCustomAttributeWithDouble:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* key = [[command arguments] objectAtIndex:0];
        double value = [[[command arguments] objectAtIndex:1] doubleValue];
        [Insider setCustomAttributeWithDouble:key value:value];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setCustomAttributeWithDouble"];
    }
}

- (void)setCustomAttributeWithBoolean:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* key = [[command arguments] objectAtIndex:0];
        BOOL value = [[[command arguments] objectAtIndex:1] boolValue];
        [Insider setCustomAttributeWithBOOL:key value:value];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setCustomAttributeWithBoolean"];
    }
}

- (void)setCustomAttributeWithDate:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* key = [[command arguments] objectAtIndex:0];
        NSString* value = [[command arguments] objectAtIndex:1];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSDate *date = [dateFormat dateFromString:value];
        [Insider setCustomAttributeWithDate:key value:date];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setCustomAttributeWithDate"];
    }
}

- (void)setCustomAttributeWithArray:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* key = [[command arguments] objectAtIndex:0];
        NSArray* value = [[command arguments] objectAtIndex:1];
        [Insider setCustomAttributeWithArray:key value:value];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setCustomAttributeWithArray"];
    }
}

- (void)setPushEnabled:(CDVInvokedUrlCommand*)command{
    @try {
        BOOL value = [[[command arguments] objectAtIndex:0] boolValue];
        [Insider setPushEnabled:value];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setPushEnabled"];
    }
}

- (void)setLocationEnabled:(CDVInvokedUrlCommand*)command{
    @try {
        BOOL value = [[[command arguments] objectAtIndex:0] boolValue];
        [Insider setLocationEnabled:value];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setLocationEnabled"];
    }
}

- (void)unsetCustomAttribute:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* key = [[command arguments] objectAtIndex:0];
        [Insider unsetCustomAttribute:key];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - unsetCustomAttribute"];
    }
}

- (void)setUserIdentifier:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* key = [[command arguments] objectAtIndex:0];
        [Insider setUserIdentifier:key];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - setUserIdentifier"];
    }
}

- (void)unsetUserIdentifier:(CDVInvokedUrlCommand*)command{
    @try {
     [Insider unsetUserIdentifier];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - unsetUserIdentifier"];
    }
}

- (void)tagProduct:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* productID = [[command arguments] objectAtIndex:0];
        [Insider tagProduct:productID];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - tagProduct"];
    }
}

- (void)trackPurchasedItems:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* uniqueSaleID = [[command arguments] objectAtIndex:0];
        NSString* productID = [[command arguments] objectAtIndex:1];
        NSString* name = [[command arguments] objectAtIndex:2];
        NSString* category = [[command arguments] objectAtIndex:3];
        NSString* subCategory = [[command arguments] objectAtIndex:4];
        NSString* price = [[command arguments] objectAtIndex:5];
        NSString* currency = [[command arguments] objectAtIndex:6];
        [Insider trackPurchasedItems:uniqueSaleID name:name category:category subCategory:subCategory price:[price doubleValue] currency:currency productID:productID];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - trackPurchasedItems"];
    }
}

- (void)itemAddedToCart:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* productID = [[command arguments] objectAtIndex:0];
        NSString* productName = [[command arguments] objectAtIndex:1];
        NSString* productPrice = [[command arguments] objectAtIndex:2];
        NSString* productCurrency = [[command arguments] objectAtIndex:3];
        NSString* productImageURL = [[command arguments] objectAtIndex:4];
        [Insider itemAddedToCart:productID productName:productName productPrice:[productPrice doubleValue] productCurrency:productCurrency productImageURL:productImageURL];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - itemAddedToCart"];
    }
}

- (void)itemRemovedFromCart:(CDVInvokedUrlCommand*)command{
    @try {
        NSString* productName = [[command arguments] objectAtIndex:0];
        [Insider itemRemovedFromCart:productName];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - itemRemovedFromCart"];
    }
}

- (void)cartCleared:(CDVInvokedUrlCommand*)command{
    @try {
        [Insider cartCleared];
    } @catch (NSException *exception) {
        [Insider sendError:exception desc:@"insider.m - cartCleared"];
    }
}

@end
