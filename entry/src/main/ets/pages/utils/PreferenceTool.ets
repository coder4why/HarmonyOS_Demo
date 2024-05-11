import preferences from '@ohos.data.preferences';
import data_preferences from '@ohos.data.preferences';
import call from '@ohos.telephony.call';
import hilog from '@ohos.hilog';
import { TaskModel } from '../models/TaskModel';
//preferences 名称：
const preferenceName = 'Fengniu403_preference';
//应用数据持久化：
export default class PreferenceTool {
  private static preferenceObj:data_preferences.Preferences = null;
  //获取Preferences对象:
  static getPreferencesObj(context) {
    try {
      data_preferences.getPreferences(context,preferenceName,(error,pref)=>{
        if (!error) {
          PreferenceTool.preferenceObj = pref;
        }
      })
    }catch (e) {
      console.log(e,'获取preference失败！')
    }
  }
  
  //移除preferences对象
  static deletePreferencesObj(context) {
    if (PreferenceTool.preferenceObj){
      data_preferences.deletePreferences(context,preferenceName,(error)=>{
        if (!error){
          console.log('删除preferences成功！');
        }
      })
    } 
  }

  //新增或者修改数据
  static putModel(model:TaskModel,callback:Function){
    if (PreferenceTool.preferenceObj){
      PreferenceTool.preferenceObj.put(`${model.name}`,JSON.stringify(model),(error)=>{
        if (!error){
          //刷盘
          PreferenceTool.preferenceObj.flush();
          console.log(model.name +'，写入成功！');
          callback && callback();
        }else{
          console.log('写入失败！')
        }
      });
    }
  }

  //删除数据
  static deleteModel(model:TaskModel,callback:Function){
    if (PreferenceTool.preferenceObj){
        PreferenceTool.preferenceObj.delete(`${model.name}}`,(error)=>{
          if (!error){
            console.log(model.name+',删除成功！')
            //刷盘
            PreferenceTool.preferenceObj.flush();
            callback && callback();
          }else {
            console.log('删除失败')
          }
        });
    }
  }

  static clearAll(){
    PreferenceTool.preferenceObj.clear();
  }

  //查询全部
  static queryModels(callback:Function){
    if (PreferenceTool.preferenceObj){
      PreferenceTool.preferenceObj.getAll((error,data)=>{
        if (!error){
          console.log(`111：${data}`);
          callback && callback(data);
        }else{
          console.log('查询异常！')
        }
      });
    }
  }
}

