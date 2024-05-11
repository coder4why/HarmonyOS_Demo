// xxx.ets
import web_webview from '@ohos.web.webview'

@Component
export struct WebComponent {
  @State progress: number = 0
  @State hideProgress: boolean = true
  controller: web_webview.WebviewController = new web_webview.WebviewController();

  build() {
    Column() {
      Progress({ total: 100, value: this.progress })
        .color('#ff5cea20')
        .visibility(this.hideProgress ? Visibility.None : Visibility.Visible)
      Web({ src: 'https://www.douban.com/', controller: this.controller })
        .height('100%')
          // 添加onProgressChange事件
        .onProgressChange(e => {
          this.progress = e.newProgress
          // 当进度100%时，进度条消失
          if (this.progress == 100) {
            this.hideProgress = true
          } else {
            this.hideProgress = false
          }
        })
    }.backgroundColor('0xFFFFFF')
    .width('100%')
    .height('100%')
  }
}
