var exec = require('cordova/exec');

var insider = {}

insider.init = function (partnerName) {
    exec(function(){}, function(){}, 'insider', 'init', [partnerName]);
};

insider.initWithAppGroup = function (partnerName, appGroup) {
    exec(function(){}, function(){}, 'insider', 'initWithAppGroup', [partnerName, appGroup]);
};

insider.registerPushWithQuietPermission = function (isEnabled) {
    exec(function(){}, function(){}, 'insider', 'registerPushWithQuietPermission', [isEnabled]);
}

insider.startTrackingGeofence = function () {
    exec(function(){}, function(){}, 'insider', 'startTrackingGeofence', []);
};

insider.setCustomAttributeWithString = function (key, value) {
    exec(function(){}, function(){}, 'insider', 'setCustomAttributeWithString', [key, value]);
};

insider.setCustomAttributeWithDouble = function (key, value) {
    exec(function(){}, function(){}, 'insider', 'setCustomAttributeWithDouble', [key, value]);
};

insider.setCustomAttributeWithBoolean = function (key, value) {
    exec(function(){}, function(){}, 'insider', 'setCustomAttributeWithBoolean', [key, value]);
};

insider.setCustomAttributeWithDate = function (key, value) {
    exec(function(){}, function(){}, 'insider', 'setCustomAttributeWithDate', [key, value]);
};

insider.setCustomAttributeWithArray = function (key, value) {
    exec(function(){}, function(){}, 'insider', 'setCustomAttributeWithArray', [key, value]);
};

insider.setCustomAttributes = function (attributes) {
    exec(function(){}, function(){}, 'insider', 'setCustomAttributes', [attributes]);
};

insider.unsetCustomAttribute = function (key) {
    exec(function(){}, function(){}, 'insider', 'unsetCustomAttribute', [key]);
};

insider.setUserIdentifier = function (identifier) {
    exec(function(){}, function(){}, 'insider', 'setUserIdentifier', [identifier]);
};

insider.unsetUserIdentifier = function () {
    exec(function(){}, function(){}, 'insider', 'unsetUserIdentifier', []);
};

insider.refreshDeviceToken = function (token) {
    exec(function(){}, function(){}, 'insider', 'refreshDeviceToken', [token]);
};

insider.setPushEnabled = function (value) {
    exec(function(){}, function(){}, 'insider', 'setPushEnabled', [value]);
};

insider.setLocationEnabled = function (value) {
    exec(function(){}, function(){}, 'insider', 'setLocationEnabled', [value]);
};

insider.tagEvent = function (event) {
    exec(function(){}, function(){}, 'insider', 'tagEvent', [event]);
};

insider.tagEventWithParameters = function (event, parameters) {
    exec(function(){}, function(){}, 'insider', 'tagEventWithParameters', [event, parameters]);
};

insider.tagProduct = function (productID) {
    exec(function(){}, function(){}, 'insider', 'tagProduct', [productID]);
};

insider.trackPurchasedItems = function (uniqueSaleID, productID, productName, productCategory, productSubCategory, price, currency) {
    exec(function(){}, function(){}, 'insider', 'trackPurchasedItems', [uniqueSaleID, productID, productName, productCategory, productSubCategory, price, currency]);
};

insider.itemAddedToCart = function (productID, productName, productPrice, productCurrency, productImageURL) {
    exec(function(){}, function(){}, 'insider', 'itemAddedToCart', [productID, productName, productPrice, productCurrency, productImageURL]);
};

insider.itemRemovedFromCart = function (productID) {
    exec(function(){}, function(){}, 'insider', 'itemRemovedFromCart', [productID]);
};

insider.cartCleared = function () {
    exec(function(){}, function(){}, 'insider', 'cartCleared', []);
};

insider.getDeepLinkData = function (key, deepLinkCallback) {
    exec(deepLinkCallback, function(){}, 'insider', 'getDeepLinkData', [key]);
};

insider.getStringWithName = function (variableName, defaultValue, dataType, getStringWithNameCallback) {
    exec(getStringWithNameCallback, function(){}, 'insider', 'getStringWithName', [variableName, defaultValue, dataType]);
};

insider.getIntWithName = function (variableName, defaultValue, dataType, getIntWithNameCallback) {
    exec(getIntWithNameCallback, function(){}, 'insider', 'getIntWithName', [variableName, defaultValue, dataType]);
};

insider.getBoolWithName = function (variableName, defaultValue, dataType, getBoolWithNameCallback) {
    exec(getBoolWithNameCallback, function(){}, 'insider', 'getBoolWithName', [variableName, defaultValue, dataType]);
};

insider.cleanView = function () {
    exec(function(){}, function(){}, 'insider', 'cleanView', []);
};

module.exports = insider
window.Insider = insider
