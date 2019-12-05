package insider.cordova.insider;

import com.useinsider.insider.Insider;
import com.useinsider.insider.RequestUtils;
import com.useinsider.insider.config.ContentOptimizerVariableType;
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
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import android.util.Log;

import android.app.Activity;

import org.apache.cordova.CordovaPreferences;

import android.os.Handler;
import android.util.Log;

public class InsiderPlugin extends CordovaPlugin {
    private Activity activity;
    //insider171682431132
    private int GOOGLE_API_KEY_OFFSET = 7; 

    @Override
    protected void pluginInitialize() {
        activity = this.cordova.getActivity();
        String s = this.preferences.getString("insider.android_google_app_id", "");
        Insider.Instance.init(activity.getApplication(),
                this.preferences.getString("insider.android_partner_name", ""),
                s.substring(GOOGLE_API_KEY_OFFSET),
                activity.getClass(),
                Boolean.valueOf(this.preferences.getString("insider.android_push_will_collapse", "false")),
                Integer.parseInt(this.preferences.getString("insider.android_geofence", "60")));
        Insider.Instance.resumeSession(activity);
        Insider.Instance.refreshDeviceToken();
        Insider.Instance.handleHybridIntent();
    }

    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) {
        if (args == null || args.length() == 0) {
            return false;
        }
        try {
            if (action.equals("initWithAppGroup") || action.equals("init")) {
                return true;
            } else if (action.equals("setCustomAttributeWithString")) {
                Insider.Instance.setCustomAttributeWithString(args.getString(0), args.getString(1));
                return true;
            } else if (action.equals("setCustomAttributeWithDouble")) {
                Insider.Instance.setCustomAttributeWithDouble(args.getString(0), args.getDouble(1));
                return true;
            } else if (action.equals("setCustomAttributeWithBoolean")) {
                Insider.Instance.setCustomAttributeWithBoolean(args.getString(0), args.getBoolean(1));
                return true;
            } else if (action.equals("setCustomAttributeWithDate")) {
                DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
                Insider.Instance.setCustomAttributeWithDate(args.getString(0), dateFormatter.parse(args.getString(1)));
                return true;
            } else if (action.equals("setCustomAttributeWithArray")) {
                JSONArray attributeJSONArray = args.getJSONArray(1);
                String[] attributes = new String[attributeJSONArray.length()];
                for (int i = 0; i < attributeJSONArray.length(); i++) {
                    attributes[i] = attributeJSONArray.getString(i);
                }
                Insider.Instance.setCustomAttributeWithArray(args.getString(0), attributes);
                return true;
            } else if (action.equals("setCustomAttributes")) {
                JSONObject attrJson = new JSONObject(args.getString(0));
                HashMap<String, Object> attrMap = new HashMap<String,Object>();
                Iterator<?> keys = attrJson.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next();
                    attrMap.put(key, attrJson.get(key));
                }
                Insider.Instance.setCustomAttributes(attrMap);
                return true;
            } else if (action.equals("unsetCustomAttribute")) {
                Insider.Instance.unsetCustomAttribute(args.getString(0));
                return true;
            } else if (action.equals("setUserIdentifier")) {
                Insider.Instance.setUserIdentifier(args.getString(0));
                return true;
            } else if (action.equals("unsetUserIdentifier")) {
                Insider.Instance.unsetUserIdentifier();
                return true;
            } else if (action.equals("setPushEnabled")) {
                Insider.Instance.setPushEnabled(args.getBoolean(0));
                return true;
            } else if (action.equals("setLocationEnabled")) {
                Insider.Instance.setLocationEnabled(args.getBoolean(0));
                return true;
            } else if (action.equals("tagEvent")) {
                Insider.Instance.tagEvent(args.getString(0));
                return true;
            } else if (action.equals("tagEventWithParameters")) {
                JSONObject paramJson = new JSONObject(args.getString(1));
                HashMap<String, Object> paramMap = new HashMap<String,Object>();
                Iterator<?> paramsKeys = paramJson.keys();
                while (paramsKeys.hasNext()) {
                    String key = (String) paramsKeys.next();
                    paramMap.put(key, paramJson.get(key));
                }
                Insider.Instance.tagEventWithParameters(args.getString(0), paramMap);
                return true;
            } else if (action.equals("getStringWithName")) {
                ContentOptimizerVariableType stringVariableDataType = getDataType(args.getString(2));
                String optimizedString = Insider.Instance.getStringWithName(args.getString(0), args.getString(1), stringVariableDataType);
                if (optimizedString != null && optimizedString.length() > 0) {
                    callbackSuccess(callbackContext, optimizedString);
                }
                return true;
            } else if (action.equals("getIntWithName")) {
                ContentOptimizerVariableType intVariableDataType = getDataType(args.getString(2));
                int optimizedInteger = Insider.Instance.getIntWithName(args.getString(0), args.getInt(1), intVariableDataType);
                callbackSuccess(callbackContext, optimizedInteger);
                return true;
            } else if (action.equals("getBoolWithName")) {
                ContentOptimizerVariableType boolVariableDataType = getDataType(args.getString(2));
                boolean optimizedBoolean = Insider.Instance.getBoolWithName(args.getString(0), args.getBoolean(1), boolVariableDataType);
                callbackSuccess(callbackContext, optimizedBoolean);
                return true;
            } else if (action.equals("refreshDeviceToken")) {
                Insider.Instance.refreshDeviceToken();
                return true;
            } else if (action.equals("tagProduct")) {
                Insider.Instance.tagProduct(args.getString(0));
                return true;
            } else if (action.equals("trackPurchasedItems")) {
                Insider.Instance.trackPurchasedItems(
                    args.getString(0),
                    args.getString(1),
                    args.getString(2),
                    args.getString(3),
                    args.getString(4),
                    args.getDouble(5),
                    args.getString(6)
                );
                return true;
            } else if (action.equals("itemAddedToCart")) {
                Insider.Instance.itemAddedToCart(
                    args.getString(0),
                    args.getString(1),
                    args.getDouble(2),
                    args.getString(3),
                    args.getString(4)
                );
                return true;
            } else if (action.equals("itemRemovedFromCart")) {
                Insider.Instance.itemRemovedFromCart(
                    args.getString(0)
                );
                return true;
            } else if (action.equals("cartCleared")) {
                Insider.Instance.cartCleared();
                return true;
            } else if (action.equals("getDeepLinkData")) {
                Object deepLinkData = Insider.Instance.getDeepLinkData(args.getString(0));
                if (deepLinkData != null && deepLinkData.toString().length() > 0) {
                    callbackSuccess(callbackContext, deepLinkData.toString());
                }
                return true;
            } else if (action.equals("cleanView")) {
                Insider.Instance.cleanView(activity);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            Insider.Instance.putException(e);
        }
        return false;  
    }
             
    private static ContentOptimizerVariableType getDataType(String dataType){
        if (dataType.equals("Content")) {
            return ContentOptimizerVariableType.InsiderVariableTypeContent;
        } else {
            return ContentOptimizerVariableType.InsiderVariableTypeElement;
        }
    }

    private static void callbackSuccess(CallbackContext callbackContext, String callbackValue) {
        try {
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, callbackValue);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        } catch (Exception e) {
            Insider.Instance.putException(e);
        }
    }

    private static void callbackSuccess(CallbackContext callbackContext, int callbackValue) {
        try {
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, callbackValue);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        } catch (Exception e) {
            Insider.Instance.putException(e);
        }
    }

    private static void callbackSuccess(CallbackContext callbackContext, boolean callbackValue) {
        try {
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, callbackValue);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        } catch (Exception e) {
            Insider.Instance.putException(e);
        }
    }
}