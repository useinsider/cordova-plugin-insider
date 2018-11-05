/********* insider.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "Insider.h"

@interface insider : CDVPlugin {

}

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)tagEvent:(CDVInvokedUrlCommand*)command;
- (void)setUserAttributes:(CDVInvokedUrlCommand*)command;
- (void)tagProduct:(CDVInvokedUrlCommand*)command;
- (void)trackPurchasedItems:(CDVInvokedUrlCommand*)command;
- (void)itemAddedToCart:(CDVInvokedUrlCommand*)command;
- (void)itemRemovedFromCart:(CDVInvokedUrlCommand*)command;
- (void)cartCleared:(CDVInvokedUrlCommand*)command;
- (void)getDeepLinkData:(CDVInvokedUrlCommand*)command;
@end

@implementation insider

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

- (void)getDeepLinkData:(CDVInvokedUrlCommand*)command{
    NSDictionary *deepLinks = [self getPushInfo];
    if (deepLinks){
        NSString *deepLink = [deepLinks objectForKey: [[command arguments] objectAtIndex:0]];
        if (deepLink){
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:deepLink];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }
}

- (void)init:(CDVInvokedUrlCommand*)command{
    NSString* partnerName = [[command arguments] objectAtIndex:0];
    [Insider startAutoIntegration:true];
    [Insider initSDK:partnerName launchOptions:nil];
    [Insider resumeSession];
    [Insider registerPush];
}

- (void)tagEvent:(CDVInvokedUrlCommand*)command{
    NSString* eventName = [[command arguments] objectAtIndex:0];
    [Insider tagEvent:eventName];
}

- (void)setUserAttributes:(CDVInvokedUrlCommand*)command{
    NSDictionary *properties = [[command arguments] objectAtIndex:0];
    [Insider setUserAttributes:properties];
}

- (void)tagProduct:(CDVInvokedUrlCommand*)command{
    NSString* productID = [[command arguments] objectAtIndex:0];
    [Insider tagProduct:productID];   
}

- (void)trackPurchasedItems:(CDVInvokedUrlCommand*)command{
    NSString* uniqueSaleID = [[command arguments] objectAtIndex:0];
    NSString* productID = [[command arguments] objectAtIndex:1];
    NSString* name = [[command arguments] objectAtIndex:2];
    NSString* category = [[command arguments] objectAtIndex:3];
    NSString* subCategory = [[command arguments] objectAtIndex:4];
    NSString* price = [[command arguments] objectAtIndex:5];
    NSString* currency = [[command arguments] objectAtIndex:6];
    [Insider trackPurchasedItems:uniqueSaleID name:name category:category subCategory:subCategory price:[price doubleValue] currency:currency productID:productID];
}

- (void)itemAddedToCart:(CDVInvokedUrlCommand*)command{
    NSString* productName = [[command arguments] objectAtIndex:0];
    NSString* productPrice = [[command arguments] objectAtIndex:1];
    NSString* productCurrency = [[command arguments] objectAtIndex:2];
    NSString* productImageURL = [[command arguments] objectAtIndex:3];
    [Insider itemAddedToCart:productName productPrice:[productPrice doubleValue] productCurrency:productCurrency productImageURL:productImageURL];
}

- (void)itemRemovedFromCart:(CDVInvokedUrlCommand*)command{
    NSString* productName = [[command arguments] objectAtIndex:0];
    [Insider itemRemovedFromCart:productName];
}

- (void)cartCleared:(CDVInvokedUrlCommand*)command{
    [Insider cartCleared];
}

@end
