import { TabBarComponent } from './components/TabBarComponent'
@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        TabBarComponent()
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#36D')
  }
}