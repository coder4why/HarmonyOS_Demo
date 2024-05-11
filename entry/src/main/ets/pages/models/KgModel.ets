

export class KgModel{
  singerid: number
  songcount:number
  singername:string
  albumname:string
  albumid:string
  intro:string
  imgurl:string
  constructor(kgObject?: any) {
    if (kgObject) {
      // this.singerid = kgObject.singerid || '';
      // this.songcount = kgObject.songcount || '';
      // this.singername = kgObject.singername || '';
      // this.albumname = kgObject.albumname || '';
      // this.albumid = kgObject.albumid || '';
      // this.intro = (kgObject.intro || '').slice(0, (kgObject.intro || "").length > 20 ? 20 :(kgObject.intro || "").length );
      // this.imgurl = (kgObject.imgurl || '').replace('{size}','150');
    }
  }
}

//华语新歌model：
export class KgHotModel {
  songname:string
  sqhash:string
  album_id:string
  filename:string
  hash:string
  duration:string
  album_sizable_cover:string
  album_cover:string
  cover:string
  remark:string
  mvhash:string
  album_audio_id:string
  audio_id:string

  constructor(item:any) {
    this.songname = item.songname || '';
    this.sqhash = item.sqhash || '';
    this.album_id = item.album_id || '';
    this.filename = item.filename || '';
    this.hash = item.hash ||  '';
    this.duration = item.duration || '';
    this.remark = item.remark || '';
    this.mvhash = item.mvhash || '';
    this.album_audio_id = item.album_audio || '';
    this.audio_id = item.audio_id || '';
    this.album_sizable_cover = (item.album_sizable_cover || '').replace(/{size}/,'150');
    this.album_cover = (item.album_cover || '').replace(/{size}/,'150');
    this.cover = (item.cover || '').replace(/{size}/,'150');
  }
}

export class KgSongModel {
  imgUrl:string;
  author_name:string;
  hash:string;
  fileName:string;
  songName:string;
  album_img:string;
  url:string;
  singerName:string;
  duration:string;

  constructor(item:any) {
    console.log('序列化数据：',item,JSON.stringify(item))
    this.imgUrl = (item.imgUrl || '').replace(/{size}/g,'150');;
    this.author_name = item.author_name;
    this.hash = item.hash;
    this.fileName = item.fileName;
    this.songName = item.songName;
    this.album_img = (item.album_img || '').replace(/{size}/g,'150');
    this.url = item.url;
    this.singerName = item.singerName;
    this.duration = item.duration || item.timeLength;
  }
}