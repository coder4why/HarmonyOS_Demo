import { KgHotModel } from '../models/KgModel'

@Extend(Text) function  textStyle(){
  .fontSize(15)
  .fontColor('#36D')
}

@Extend(Row) function rowStyle(){
  // .width('100%')
  .height(100)
  .justifyContent(FlexAlign.Start)
  .backgroundColor('#F5F5F5')
  .borderRadius(10)
}

@Builder function rightColumn(kgModel){
  Column({ space: 8 }) {
    Text(kgModel.songname)
      .textStyle()
    Text(kgModel.filename)
      .textStyle()
    Text(kgModel.remark)
      .fontSize(13)
      .fontColor(Color.Grey)
  }
  .alignItems(HorizontalAlign.Start)
  .justifyContent(FlexAlign.Start)
}

@Builder function leftColumn(kgModel){
  Image(kgModel.album_sizable_cover)
    // .width(80)
    // .height(80)
    .borderRadius(10)
  // .onClick(() => {
  //   console.log('组件点击事件：', this.kgModel.album_id)
  //   this.onClickItem && this.onClickItem(this.kgModel);
  // })
}

@Component
export struct KgItem {
  private kgModel: KgHotModel
  // private onClickItem?:(model:KgHotModel)=>void
  build() {
    Row({ space: 10 }) {
      leftColumn(this.kgModel)
      // rightColumn(this.kgModel)
    }.rowStyle()
  }
}