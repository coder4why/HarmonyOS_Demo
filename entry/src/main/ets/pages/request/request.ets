import http from '@ohos.net.http';
import call from '@ohos.telephony.call';

//网络请求方式
export enum ReqMethod{
  POST = 'POST',
  GET = 'GET',
}

//发起请求：
export function request(url:string, method:ReqMethod,params:object,callback:Function) {
  console.log('请求URL：',url)
  console.log('请求入参：',JSON.stringify(params));
  let httpRequest = http.createHttp();
  httpRequest.request(
    // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
    url,
    {
      method: method == ReqMethod.POST ? http.RequestMethod.POST: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
      // 开发者根据自身业务需要添加header字段
      header: {
        'Content-Type': 'application/json'
      },
      // 当使用POST请求时此字段用于传递内容
      // extraData: {
      //   "data": "data to send",
      // },
      expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      usingCache: true, // 可选，默认为true
      priority: 1, // 可选，默认为1
      connectTimeout: 60000, // 可选，默认为60000ms
      readTimeout: 60000, // 可选，默认为60000ms
      usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定
    }, (err, data) => {
    if (!err) {
      if(typeof (data.result) == 'string' && data.result.indexOf('KG_TAG_RES_START') != -1){
        data.result = JSON.parse(data.result.replace('<!--KG_TAG_RES_START-->',"").replace('<!--KG_TAG_RES_END-->',''));
      }
      console.log('请求成功1',JSON.stringify(data.result));
      // data.result为HTTP响应内容，可根据业务需要进行解析
      console.log('Result:' + data.result);
      callback && callback(data.result);
      // console.info('code:' + JSON.stringify(data.responseCode));
      // // data.header为HTTP响应头，可根据业务需要进行解析
      // console.info('header:' + JSON.stringify(data.header));
      // console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
    } else {
      console.log('请求失败！')
      console.info('error:' + JSON.stringify(err));
      // 取消订阅HTTP响应头事件
      httpRequest.off('headersReceive');
      // 当该请求使用完毕时，调用destroy方法主动销毁。
      httpRequest.destroy();
    }
  }
  );
}