package co.hypescout.graph_login;

import android.content.Intent;

import com.facebook.CallbackManager;

import io.flutter.plugin.common.PluginRegistry;

public class ActivityListener implements PluginRegistry.ActivityResultListener {
    private final CallbackManager _callbackManager;

    public ActivityListener(CallbackManager callbackManager) {
        _callbackManager = callbackManager;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return _callbackManager.onActivityResult(requestCode, resultCode, data);
    }
}
