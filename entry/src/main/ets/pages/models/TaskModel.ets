export class TaskModel {
  name: string;
  isCompleted: boolean;
  index:number;
  constructor(isCompleted: boolean,name: string,index: number) {
    this.isCompleted = isCompleted;
    this.name = name ;
    this.index = index;
  }
}