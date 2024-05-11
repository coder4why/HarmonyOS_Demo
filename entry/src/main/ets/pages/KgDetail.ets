import router from '@ohos.router';
import { KgSongDetail } from './api/Apis';
import { KgHotModel,KgSongModel } from './models/KgModel'
import { ReqMethod, request } from './request/request';
import display from '@ohos.display';
import thermal from '@ohos.thermal';
//局部样式
@Extend(Image) function imageStyle(screen){
  .width(360)
  .height(360)
  .margin({top:15})
  // .width(screen.width)
  // .height(screen.width)
}

//全局样式
@Styles function containerStyle(){
  .width('100%')
  .height('100%')
}

@Entry
@Component
struct KgDetail{
  @State model:KgHotModel = null;
  @State songModel:KgSongModel = null;
  @State isPlaying:boolean = false;
  @State displayObj:display.Display = null;
  @State leftTime:string = '00:00';
  @State rightTime:string = '';
  @State currentTime:number = 0;
  timer = null;

  getScreen(){
    this.displayObj = display.getDefaultDisplaySync();
    this.displayObj.width = this.displayObj.width/this.displayObj.scaledDensity
    this.displayObj.height = this.displayObj.height/this.displayObj.scaledDensity
  }
  durationToTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
  }
  onPageShow(){
    this.getScreen();
    this.model = (router.getParams()['model'] as KgHotModel);
    request(KgSongDetail(this.model.hash),ReqMethod.GET,{},(response)=>{
      this.songModel = new KgSongModel(response);
      this.rightTime = this.durationToTime(this.songModel.duration || 0);
      this.currentTime = 0;
      console.log('打印：',this.songModel.imgUrl.length,this.songModel.album_img.length)
      if (this.songModel.url.length > 0) {
        setTimeout(()=>{
          this.playMusic();
        },500)
      }
    })
  }
  onPageHide(){
    this.timer && clearInterval(this.timer);
  }

  goBack():void{
    router.back();
  }

  @Builder SliderItem(){
    Row(){
      Text(this.leftTime)
      Slider({value:this.currentTime, max:parseInt(this.songModel.duration),min:0,step:1,style:SliderStyle.InSet})
        .width('60%')
        .margin({left:5,right:5})
        .trackThickness(8)
        .onChange(value => {
          console.log('发生改变：',value)
          this.currentTime = parseInt(value.toFixed(0));
          this.leftTime = this.durationToTime(this.currentTime)
        })
      Text(this.rightTime)
    }
  }

  playMusic(){
    if(this.currentTime <= parseInt(this.songModel.duration)){
      console.log('播放1')
      if (!this.isPlaying){
        this.timer && clearInterval(this.timer);
      }else{
        this.timer = setInterval(()=>{
          this.currentTime++;
          this.leftTime = this.durationToTime(this.currentTime)
        },1000)
      }
    }else{
      console.log('播放2')
      this.currentTime = parseInt(this.songModel.duration);
      this.timer && clearInterval(this.timer);
    }
  }

  build(){
    Row(){
      Column(){
        Column(){
          Row(){
            Button()
            {
              Image($r('app.media.navBack'))
                .width(24)
                .height(24)
                .renderMode(ImageRenderMode.Original)
                .objectFit(ImageFit.Contain)
                .interpolation(ImageInterpolation.High) //渲染本地图片不带锯齿
            }
            .backgroundColor(Color.Transparent)
            .onClick(()=>this.goBack())
            if (this.model){ //条件渲染
              Text(this.model.songname)
                .fontColor('#323233')
                .textAlign(TextAlign.Center)
                .fontSize(18)
                .margin({left:-10})
                .layoutWeight(1)
                .onClick(()=>this.goBack())
            }
          }
          .width('100%')
          .height(46)
          .backgroundColor(Color.Transparent)
          Divider()
        }
        if (this.songModel && this.displayObj){
          Column({space:8}){
            Image(this.songModel.imgUrl)
              .imageStyle(this.displayObj)
            Text(`作词：${this.songModel.author_name}`)
            Text(this.songModel.songName)
            Text(this.songModel.singerName)
            this.SliderItem()
            Button(){
              Image(this.isPlaying ? $r('app.media.pause') : $r('app.media.play'))
                .width(50)
                .height(50)
                .interpolation(ImageInterpolation.High)
            }
              .backgroundColor(Color.Transparent)
              .onClick(()=>{
                console.log('Mp3链接：',this.songModel.url);
                this.isPlaying = !this.isPlaying;
                this.playMusic();
              })
          }
          .width('100%')
          .layoutWeight(1)
        }
      }
      .containerStyle()
      .justifyContent(FlexAlign.Start)
    }
    .containerStyle()
    .backgroundColor('#F5F5F5')
  }
}
