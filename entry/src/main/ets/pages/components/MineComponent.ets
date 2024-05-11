
import thermal from '@ohos.thermal';
import { TaskModel } from '../models/TaskModel';
import PreferenceTool from '../utils/PreferenceTool';
@Component
export struct MineComponent {
  @State finishedTasks:number = 0; // 已完成任务数
  @State allTasks:TaskModel[] = []; //总任务数
  @State startIndex:number = 1;
  aboutToAppear(){
    this.queryAll();
  }
  aboutToDisappear(){
    console.log('查询allTasks:',JSON.stringify(this.allTasks))
    PreferenceTool.clearAll();
    this.allTasks.forEach(item=>{
      PreferenceTool.putModel(item,()=>{});
    });
  }
  queryAll(){
    PreferenceTool.queryModels((models:object)=>{
      console.log('写入成功查询2：',JSON.stringify(models))
      let tasks:TaskModel[] = [];
      Object.values(models).forEach(item=>{
        let itemObject = JSON.parse(item);
        let mod = new TaskModel(itemObject.isCompleted, itemObject.name,parseInt(itemObject.index));
        if (mod.index > this.startIndex) {
          this.startIndex = mod.index;
        }
        tasks.push(mod);
      });
      this.allTasks = tasks;
      this.finishedTasks = this.allTasks.filter(item=>item.isCompleted == true).length;
    });
  }
  build() {
    Row(){
      Column({space:15}){
        MineTopComponent({finishedTasks:$finishedTasks,allTasks:$allTasks})
        Button('新增任务',{type:ButtonType.Capsule,stateEffect:false})
          .width(150)
          .height(50)
          .borderRadius(25)
          .onClick(()=>{
            let model = new TaskModel(false,`任务${this.startIndex++}`,this.startIndex);
            PreferenceTool.putModel(model,()=>{
              this.allTasks.push(model);
              this.finishedTasks = this.allTasks.filter(item=>item.isCompleted == true).length;
            });
          });
        MineListComponent({finishedTasks:$finishedTasks, allTasks:$allTasks})
      }.height('100%')
    }
    .width('100%')
    .height('100%')
    .padding({top:15})
    .backgroundColor('#e7e9ec')
  }
}

@Component
struct MineTopComponent {
  @Link finishedTasks:number; //
  @Link allTasks:TaskModel[]; //
  build() {
    Row(){
      Text('任务进度：')
        .fontSize(32)
      Stack(){
        Progress({value:this.finishedTasks,total:this.allTasks.length,type:ProgressType.Ring})
          .color('#36D')
          .width(100)
          .backgroundColor('#F5F5F5')
          .style({
            strokeWidth:4,
          })
       Row(){
         Text(`${this.finishedTasks}`)
           .fontColor('#36D')
           .fontSize(22)
         Text(` /  ${this.allTasks.length}`)
           .fontColor('#000000')
           .fontSize(25)
       }
      }
    }
    .width('94%')
    .height(120)
    .borderRadius(10)
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.SpaceEvenly)
    .alignItems(VerticalAlign.Center)
  }
}

@Component
struct MineListComponent {
  @Link finishedTasks:number; //
  @Link allTasks:TaskModel[]

  @Builder deleteTask(item:TaskModel,index:number){
      Button(){
        Image($r('app.media.delete'))
          .interpolation(ImageInterpolation.High)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Fill)
      }
      .backgroundColor(Color.White)
      .borderRadius(30)
      .width(60)
      .height(60)
      .margin({left:10,right:10})
      .onClick(()=>{
        PreferenceTool.deleteModel(item,()=>{
          this.allTasks.splice(index,1)
          this.finishedTasks = this.allTasks.filter(item=>item.isCompleted == true).length;
        });
      })
  }
  build() {
    Row(){
      List({space:10}){
        ForEach(this.allTasks,(item:TaskModel,index:number)=>{
          ListItem(){
            Row(){
              Text(item.name)
                .fontSize(20)
              Blank()
              Checkbox()
                .select(item.isCompleted)
                .onChange(val=>{
                  let newModel = {
                    ...item,
                    isCompleted:val
                  };
                  PreferenceTool.putModel(newModel,()=>{
                    item.isCompleted = val;
                    this.finishedTasks = this.allTasks.filter(item=>item.isCompleted == true).length;
                  });
                })
            }
            .backgroundColor(Color.White)
            .borderRadius(10)
            .height(80)
            .width('94%')
            .margin({left:10,right:10})
            .padding({left:10,right:10})
            .justifyContent(FlexAlign.SpaceAround)
            .alignItems(VerticalAlign.Center)
          }
          .swipeAction({
            end:()=>{
              console.log('滑动操作')
              this.deleteTask(item,index);
            }
          })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding({bottom:15})
    .alignItems(VerticalAlign.Top)
    .layoutWeight(1)
  }
}