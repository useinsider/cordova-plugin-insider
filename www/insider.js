var exec = require('cordova/exec');

var insider = {}

insider.init = function (partnerName) {
    exec(function(){}, function(){}, 'insider', 'init', [partnerName]);
};

insider.tagEvent = function (event) {
    exec(function(){}, function(){}, 'insider', 'tagEvent', [event]);
};

insider.setUserAttributes = function (attributes) {
    exec(function(){}, function(){}, 'insider', 'setUserAttributes', [attributes]);
};

insider.tagProduct = function (productId) {
    exec(function(){}, function(){}, 'insider', 'tagProduct', [productId]);
};

insider.trackSales = function (uniqueSaleId, saleAmount) {
    exec(function(){}, function(){}, 'insider', 'trackSales', [uniqueSaleId, saleAmount]);
};

insider.trackSalesCurrency = function (uniqueSaleId, saleAmount, currency) {
    exec(function(){}, function(){}, 'insider', 'trackSalesCurrency', [uniqueSaleId, saleAmount, currency]);
};

insider.trackPurchasedItems = function (uniqueSaleId, productId, productName, productCategory, productSubCategory, price, currency) {
    exec(function(){}, function(){}, 'insider', 'trackPurchasedItems', [uniqueSaleId, productId, productName, productCategory, productSubCategory, price, currency]);
};

insider.itemAddedToCart = function (productName, productPrice, productCurrency, productImageURL) {
    exec(function(){}, function(){}, 'insider', 'itemAddedToCart', [productName, productPrice, productCurrency, productImageURL]);
};

insider.itemRemovedFromCart = function (productName) {
    exec(function(){}, function(){}, '  insider', 'itemRemovedFromCart', [productName]);
};

insider.cartCleared = function () {
    exec(function(){}, function(){}, 'insider', 'cartCleared', []);
};

insider.getRecommendationData = function (productId, dataListener) {
    exec(dataListener, function(){}, 'insider', 'getRecommendationData', [productId]);
};

insider.getDeepLinkData = function (key, deepLinkResult) {
    exec(deepLinkResult, function(){}, 'insider', 'getDeepLinkData', [key]);
};

insider.setCustomEndpoint = function () {
    exec(function(){}, function(){}, 'insider', 'setCustomEndpoint', []);
};

module.exports = insider
