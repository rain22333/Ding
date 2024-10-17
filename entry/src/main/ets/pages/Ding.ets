import { MessageInfoModel } from '../models/Message'
import { StoreClass } from '../utils/store'
import { router } from '@kit.ArkUI'
import { currentUser } from '../models/users'
import { emitter } from '@kit.BasicServicesKit'
import { FileOperate } from '../utils/FileOperate'


@Component
@Entry
struct Ding {

  @Styles DingTag(){
    .backgroundColor('#ccc').padding({ left:15,right:15,top:5,bottom:5 }).borderRadius(5)
  }

  @State
  searchMsg:string = '';


  @State
  list: MessageInfoModel[] = []

  aboutToAppear(): void {
    this.list = StoreClass.getAllChatLastMessage()
    emitter.on(StoreClass.ding_key,()=>{
      this.list = StoreClass.getAllChatLastMessage()
    })
  }





  @Builder
  getListEnd(userId:string) {
    Row() {
      Text("删除")
        .fontColor($r('app.color.white'))
        .width(100)
        .textAlign(TextAlign.Center)
    }.height(70)
    .padding({
      left: 20,
      right: 20
    })
    .backgroundColor($r('app.color.danger'))
    .onClick(()=>{
      FileOperate.delUserPath(userId)
      StoreClass.removeChatAllMessage(userId)
    })
  }



  build() {
    Column() {


      // 头部
      Row({space:10}){
        Image(currentUser.avatar).width(45).height(45).borderRadius(5)
        Text(currentUser.firm)
          .fontSize(20)
          .fontColor(Color.White)
          .width("35%")
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.None})
        Row({space:15}){
          Image($r('app.media.video_call_white')).width(25)
          Image($r('app.media.add_white')).width(20)
        }.layoutWeight(1)
        .justifyContent(FlexAlign.End)
      }.backgroundColor($r('app.color.backGroundColor_second'))
      .width("100%")
      .height(60)
      .padding({left:20,right:20})




      Row() {
        Search({ placeholder: '搜索', value: $$this.searchMsg })
          .height(40)
          .backgroundColor($r('app.color.text_gray'))
          .borderRadius(4)
      }.width('97%')
      .padding({
        left: 10,
        right: 10
      })

      Row(){
        Text("日历").fontSize(12).fontColor('#CCC')
        Text("待办").fontSize(12).fontColor('#CCC')
        Text("DING").fontSize(12).fontColor('#CCC')
        Text("打卡").fontSize(12).fontColor('#CCC')
        Text("更多").fontSize(12).fontColor('#CCC')
      }.width("97%")
      .justifyContent(FlexAlign.SpaceAround)
      .margin({top: 10})

      Divider().width("95%").margin({top:10,bottom:10})

      Row({space:10}){
        Text("全部").fontSize(12).fontColor('#999').DingTag()
        Text("未读").fontSize(12).fontColor('#999').DingTag()
        Text("@我").fontSize(12).fontColor('#999').DingTag()
        Text("单聊").fontSize(12).fontColor('#999').DingTag()
        Text("群聊").fontSize(12).fontColor('#999').DingTag()
      }.width("97%")
      .justifyContent(FlexAlign.SpaceAround)
      .margin({bottom:10})


      List() {
        ForEach(this.list, (item:MessageInfoModel) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(item.connectUser.avatar)
                .width(50)
                .height(50)
                .borderRadius(4)

              Column({ space: 10 }) {
                Row() {
                  Text(item.connectUser.username)
                    .fontColor($r('app.color.text_primary'))
                    .fontSize(16)
                  Text(this.transTime(item.sendTime))
                    .fontSize(12)
                    .fontColor($r('app.color.text_second'))
                    .margin({
                      top: 10
                    })
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')

                Text(item.messageContent)
                  .fontColor($r('app.color.text_second'))
                  .fontSize(14)
                  .maxLines(1)
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(HorizontalAlign.Start)
              .height(50)
              .layoutWeight(1)
              .padding({
                top: 3,
                bottom: 3
              })
            }
            .onClick(()=>{
              router.pushUrl({
                url:'component/ChatDetail/ChatDetail',
                params: item.connectUser
              })
            })
            .stateStyles({
              normal: {
                .backgroundColor($r('app.color.white'))
              },
              pressed: {
                .backgroundColor($r('app.color.back_color'))
              }
            })
          }
          .padding({
            top: 10,
            bottom: 10
          })
          .swipeAction({
            end: ()=>{
              this.getListEnd(item.connectUser.user_id)
            }
          })
        })
      }
      .divider({
        strokeWidth: 1,
        color: $r('app.color.border_color')
      })
      .padding({
        left: 10,
        right: 20
      })
      .width("97%")
    }
    .height('100%')


  }























  transTime(time:number){
    const dateObj = new Date(time)
    const year = dateObj.getFullYear()
    const month = dateObj.getMonth()
    const date = dateObj.getDate()
    const hours = dateObj.getHours();
    const minutes = dateObj.getMinutes();
    if (year === new Date().getFullYear()){
      if (month === new Date().getMonth()){
        if (date === new Date().getDate()) {
          // 当天的消息
          return `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}`
        }else{
          return `${new Date().getDate()-date}天前`
        }
      }else{
        return `${(month + 1).toString()}月${date}日`
      }
    } else {
      return `${year}年${(month + 1).toString()}月${date}日`
    }
  }

}

export default Ding