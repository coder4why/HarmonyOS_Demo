

//酷狗音乐API：
export const KgMusic:string = "http://mobilecdnbj.kugou.com/api/v3/singer/album?version=9108&plat=0&pagesize=100&singerid=86747&category=1&area_code=1&page=1&show_album_tag=0"
//华语新歌
export const KgHotSongs:string = "http://mobilecdnbj.kugou.com/api/v3/rank/newsong?version=9108&plat=0&with_cover=1&pagesize=100&type=1&area_code=1&page=1&with_res_tag=1";
//根据hash查询歌曲链接等信息
export const KgSongDetail = (hash:string) => `http://m.kugou.com/app/i/getSongInfo.php?cmd=playInfo&hash=${hash}`