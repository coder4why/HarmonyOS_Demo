import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import bundleManager from '@ohos.bundle.bundleManager';
import PreferenceTool from '../pages/utils/PreferenceTool';

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {}
  onDestroy() {}
  onWindowStageCreate(windowStage: window.WindowStage) {
    getBundleId(appId=>{
      // Initializer.getInstance().initialize("Your API_KEY");
    });
    //data_preferences获取
    PreferenceTool.getPreferencesObj(this.context);
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        return;
      }
    });
  }
  onWindowStageDestroy() {}
  onForeground() {}
  onBackground() {}
}

/**
 * 获取appIdentifier
 */
function getBundleId(callback) {
  // 根据给定的bundle名称获取BundleInfo。
  // 使用此方法需要申请 ohos.permission.GET_BUNDLE_INFO权限。
  let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO;
  try {
     bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
      //获取appIdentifier
      let appIdentifier = data.signatureInfo.appId;
      callback(appIdentifier);
      console.info('getBundleAppIdentifier successfully. Data: ' + appIdentifier );
    }).catch(error => {
      console.error('getBundleAppIdentifier failed. Cause: ' + error.message);
    });
  } catch (error) {
    console.error('getBundleAppIdentifier failed:' + error.message);
  }
}
