import Notification from '@ohos.notificationManager';
import image from '@ohos.multimedia.image';
import { KgMusicComponent } from './KgMusic'
import { MineComponent } from './MineComponent'
import { WebComponent } from './WebComponent'
@Component
export struct TabBarComponent {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  private searchController: SearchController = new SearchController()

  private nf_index: number = 0;
  private tabImages = [
    $r('app.media.main'),
    $r('app.media.discover'),
    $r('app.media.global'),
    $r('app.media.mine'),
  ];

  private notifyTitles = [
    '基础通知',
    '长文本通知',
    '多行文本通知',
    '文本图片通知'
  ];

  private notify_image:PixelMap = null;

  @Builder TabBuilder(index: number, name: string) {
    Column() {
      Image(this.tabImages[index])
        .width(26)
        .height(26)
        .objectFit(ImageFit.Fill)
        .interpolation(ImageInterpolation.High)
        .margin({ top: 12, bottom:12 })
    }.width('100%')
    .backgroundColor('#F5F5F5')
  }

  async  aboutToAppear(){
    let manager = getContext(this).resourceManager;
    let file = await manager.getMediaContent($r('app.media.icon'));
    image.createImageSource(file.buffer).createPixelMap()
      .then(pixelMap =>this.notify_image = pixelMap);
  }

  //发生消息通知
  @Builder publicNotify(){
    List({space:10}){
      ForEach(this.notifyTitles,(title,index)=>{
        ListItem(){
          Button(title,{type:ButtonType.Capsule})
            .onClick(()=>this.sendNotification(index))
        }.width('100%')
      });
    }.margin({top:10})
    .width('100%')
  }

  getContent(index){
    console.log('图片PixelImage：',this.notify_image);
    let content = {};
    switch (index) {
      case 0:
        content ={
          contentType:Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal:{
            title:'索尔学HM - '+this.nf_index,
            text:'普京-乌拉乌拉哄',
            additionalText:'面向鸿蒙生态的声明式开发套件，包含了鸿蒙生态应用从设计、开发、测试、上架所需的关键技术和产品。（鸿蒙指华为终端鸿蒙智能设备操作系统软件）'
          },
        }
        break;
      case 1:
        content ={
          contentType:Notification.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
          longText:{
            title:'索尔学HM - '+this.nf_index,
            briefText:'乌军总司令：局势已经恶化',
            text:'普京-乌拉乌拉哄',
            longText:'俄罗斯图160战略轰战机已起航,俄罗斯图160战略轰战机已起航,俄罗斯图160战略轰战机已起航,俄罗斯图160战略轰战机已起航',
            expandedTitle:'俄罗斯总统普京宣布使用核武器抹平乌克兰,俄罗斯总统普京宣布使用核武器抹平乌克兰,俄罗斯总统普京宣布使用核武器抹平乌克兰！',
            additionalText:'面向鸿蒙生态的声明式开发套件，包含了鸿蒙生态应用从设计、开发、测试、上架所需的关键技术和产品。（鸿蒙指华为终端鸿蒙智能设备操作系统软件）'
          },
        }
        break;
      case 2:
        content ={
          contentType:Notification.ContentType.NOTIFICATION_CONTENT_MULTILINE,
          multiLine:{
            title:'索尔学HM - '+this.nf_index,
            briefText:'乌军总司令：局势已经恶化',
            text:'普京-乌拉乌拉哄',
            longTitle:'俄罗斯图160战略轰战机已起航',
            additionalText:'面向鸿蒙生态的声明式开发套件，包含了鸿蒙生态应用从设计、开发、测试、上架所需的关键技术和产品。（鸿蒙指华为终端鸿蒙智能设备操作系统软件）',
            lines:[
              '1.面向鸿蒙生态的声明式开发套件',
              '2.包含了鸿蒙生态应用从设计、开发、测试、上架所需的关键技术和产品',
              '3.（鸿蒙指华为终端鸿蒙智能设备操作系统软件）'
            ],
          },
        }
        break;
      case 3:
        content ={
          contentType:Notification.ContentType.NOTIFICATION_CONTENT_PICTURE,
          picture:{
            title:'索尔学HM - '+this.nf_index,
            briefText:'乌军总司令：局势已经恶化',
            text:'普京-乌拉乌拉哄',
            expandedTitle:'俄罗斯总统普京宣布使用核武器抹平乌克兰,俄罗斯总统普京宣布使用核武器抹平乌克兰,俄罗斯总统普京宣布使用核武器抹平乌克兰！',
            additionalText:'面向鸿蒙生态的声明式开发套件，包含了鸿蒙生态应用从设计、开发、测试、上架所需的关键技术和产品。（鸿蒙指华为终端鸿蒙智能设备操作系统软件）',
            picture:this.notify_image //image.PixelMap
          },
        }
        break;
      default:
        break;
    }
    return content;
  }

  //发送通知
  sendNotification(index:number){
    this.nf_index++;
    let typeObj = [
      Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
      Notification.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
      Notification.ContentType.NOTIFICATION_CONTENT_MULTILINE,
      Notification.ContentType.NOTIFICATION_CONTENT_PICTURE
    ];
    let request:Notification.NotificationRequest = {
      id:this.nf_index,
      content:{
        contentType:typeObj[index],
        ...(this.getContent(index)),
      },
      deliveryTime:new Date().getTime(),
      showDeliveryTime:true,
      slotType:Notification.SlotType.SOCIAL_COMMUNICATION
    }
    Notification.publish(request,(error)=>{
      console.log(error ? '消息发送失败':'消息发送成功')
    });
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          KgMusicComponent()
        }.tabBar(this.TabBuilder(0, '热门'))

        TabContent() {
          WebComponent()
        }.tabBar(this.TabBuilder(1, '歌手'))

        TabContent() {
          Column(){
            Text('Lottie Failed')
              .margin(15)
            Image($r("app.media.cat")) //加载一个svg图片
              .width('100%')
            this.publicNotify()
          }
          .height('100%')
          .margin(15)
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
        }.tabBar(this.TabBuilder(2, '视频'))

        TabContent() {
          MineComponent()
        }.tabBar(this.TabBuilder(3, '我的'))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .barHeight(56)
      .scrollable(false)
      .animationDuration(0)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width('100%')
      .height('100%')
      .margin({ bottom: 0 })
      .backgroundColor('#F1F3F5')
    }.width('100%')
    .height('100%')
  }
}