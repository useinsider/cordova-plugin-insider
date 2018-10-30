package insider.cordova.insider;

import com.useinsider.insider.Insider;
import com.useinsider.insider.RequestUtils;
import com.google.firebase.iid.FirebaseInstanceId;

import android.content.Context;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import android.util.Log;

import android.app.Activity;
import org.apache.cordova.CordovaPreferences;
import android.os.Handler;
import android.util.Log;

public class InsiderPlugin extends CordovaPlugin {
    private Activity activity;

    @Override
    protected void pluginInitialize() {
        activity = this.cordova.getActivity();
        String s = this.preferences.getString("insider.android_google_app_id","");
        Insider.Instance.setSDKType("cordova");
        Insider.Instance.init(activity.getApplication(),
                    this.preferences.getString("insider.android_partner_name",""),
                    s.substring(7),
                    activity.getClass(),
                    Boolean.valueOf(this.preferences.getString("insider.android_push_will_collapse","false")),
                    Integer.parseInt(this.preferences.getString("insider.android_geofence","60")));
        Insider.Instance.refreshDeviceToken();
        Insider.Instance.setDeepLinks();
    }
    
    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) {
        try {
            if (args == null || args.length() == 0) {
                return false;
            }
            if(action.equals("init")){                
                return true;
            } 
            else if (action.equals("tagEvent")) {
                Insider.Instance.tagEvent(activity, args.getString(0));
                return true;
            } else if(action.equals("setUserAttributes")) {
                JSONObject attrJson = new JSONObject(args.getString(0));
                HashMap<String, Object> attrMap = new HashMap<String,Object>();
                Iterator<?> keys = attrJson.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next();
                    attrMap.put(key, attrJson.get(key));
                }
                Insider.Instance.setUserAttributes(attrMap);
                return true;
            } else if(action.equals("tagProduct")) {
                Insider.Instance.tagProduct(args.getString(0));
                return true;
            } else if(action.equals("trackSales")) {
                Insider.Instance.trackSales(
                        activity,
                        args.getString(0),
                        args.getInt(1)
                );
                return true;
            } else if(action.equals("trackSalesCurrency")) {
                Insider.Instance.trackSales(
                        activity,
                        args.getString(0),
                        args.getInt(1),
                        args.getString(2)
                );
                return true;
            } else if(action.equals("trackPurchasedItems")) {
                Insider.Instance.trackPurchasedItems(
                        activity,
                        args.getString(0),
                        args.getString(1),
                        args.getString(2),
                        args.getString(3),
                        args.getString(4),
                        args.getDouble(5),
                        args.getString(6)
                );
                return true;
            } else if(action.equals("itemAddedToCart")) {
                Insider.Instance.itemAddedToCart(
                        activity,
                        args.getString(0),
                        (float) args.getDouble(1),
                        args.getString(2),
                        args.getString(3)
                );
                return true;
            } else if(action.equals("itemRemovedFromCart")) {
                Insider.Instance.itemRemovedFromCart(
                        this.cordova.getActivity(),
                        args.getString(0)
                );
                return true;
            } else if(action.equals("cartCleared")) {
                Insider.Instance.cartCleared(activity);
                return true;
            } else if(action.equals("getRecommendationData")) {
                Insider.Instance.getRecommendationData(args.getString(0), new RequestUtils.Recommendation() {
                    @Override
                    public void loadRecommendationData(JSONArray jsonArray) {
                        callbackSuccess(callbackContext, jsonArray);
                    }
                });
                return true;
            } else if(action.equals("getDeepLinkData")) {
                Object deepLinkData = Insider.Instance.getDeepLinkData(args.getString(0));
                if (deepLinkData != null && deepLinkData.toString().length() > 0) {
                callbackSuccess(callbackContext, deepLinkData.toString());
                }
                return true;
            } else if(action.equals("cleanView")) {
                Insider.Instance.cleanView(activity);
                return true;
            } else if(action.equals("setCustomEndpoint")) {
                Insider.Instance.setCustomEndpoint(args.getString(0));
                return true;
            }
        } catch (Exception e) {
            Insider.Instance.putLog(e);
        }
        return false;
    }

    private static void callbackSuccess(CallbackContext callbackContext, JSONArray jsonArray) {
        if (jsonArray == null) jsonArray = new JSONArray();
        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonArray);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
    }

    private static void callbackSuccess(CallbackContext callbackContext, String deepLink) {
        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, deepLink);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
    }

    @Override
    public void onStart(){
        Insider.Instance.start(activity);
    }

    @Override
    public void onStop(){
        Insider.Instance.stop(activity);
    }

}