import { KgMusic,KgHotSongs } from '../api/Apis';
import {KgItem} from './KgItem'
import { KgModel ,KgHotModel} from '../models/KgModel';
import { ReqMethod, request } from '../request/request';
import router from '@ohos.router'

//样式拓展
@Extend(Text) function textStyle(){
  .textAlign(TextAlign.Start)
    .lineHeight(30)
    .fontColor('#36D')
    .fontWeight(FontWeight.Bolder)
}

@Extend(Row) function rowStyle(){
  .height(30)
  .width('100%')
  .justifyContent(FlexAlign.Start)
}

@Extend(Column) function columnStyle(){
  .width('100%')
  .justifyContent(FlexAlign.Start)
  .padding(10)
}

// @Entry // Entry:表示这是一个页面文件的入口，没有这个装饰器，表示为一个自定义组件，不是页面
@Component // Component:标记自定义组件，被@Entry标记的页面组件调用才能加载显示
export struct KgMusicComponent { // struct 自定义组件，可复用的UI单元
  @State bgColor: Color = Color.White;
  @State musics: KgHotModel[] = [];
  scroller: Scroller = new Scroller()
  aboutToAppear(){
    // 请求页面数据：
    request(KgHotSongs,ReqMethod.GET,{},(response)=>{
      response.data.info.map(item=>{
        let model = new KgHotModel(item);
        this.musics.push(model);
      })
    })
  }

  //跳转到详情
  jumpDetail(model: KgHotModel){
    router.pushUrl({
      url: 'pages/KgDetail',
      params: {
        model
      }
    },router.RouterMode.Single);
  }

  build() {  // build:UI描述，内部以声明式方式描述UI结构
    // Row() {   // Row、Column、Text等都是ArkUI的内置UI组件，Row、Column为容器组件，用于布局；其他为基础组件；
      Column() {
        Row(){
          Text('HELLO，酷狗'+this.musics.length)
            .textStyle()
        }
        .rowStyle()
        Grid(this.scroller) {
          ForEach(this.musics,(item:KgHotModel)=>{
            GridItem(){
                KgItem({kgModel:item}) //自定义组件；
            }
            .onClick(()=>{
              this.jumpDetail(item);
            })
          })
        }
        .columnsTemplate('3')
        .rowsTemplate(this.musics.length/3 + '')
        .columnsGap(10)
        .rowsGap(10)
        // .scrollBar(BarState.Off)
        .layoutWeight(1) //设置组件布局的权重，不设置权重默认为0，设置为1，表示整个页面的剩余空间由当前组件全部占满
        .onScrollIndex(index=>{
          console.log('滚动序号：',index);
        })
      }.columnStyle()
  }
}