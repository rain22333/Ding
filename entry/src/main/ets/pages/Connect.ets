import { DefaultUserList, UserInfo } from '../models/users'
import { router } from '@kit.ArkUI'
import { it } from '@ohos/hypium'

@Entry
@Component
struct Connect {


  @Watch("filterName")
  @State
  searchName: string = ''
  filterName(){
    this.filterList = DefaultUserList.filter((user:UserInfo)=>{
      return user.username.includes(this.searchName)
    })
  }


  @State
  filterList: UserInfo[] = []
  aboutToAppear(): void {
    // 一进页面要展示默认列表进入后
    this.filterList = DefaultUserList
  }

  build() {
    Column() {

      // 没有搜索词的情况
      if(this.searchName === ''){
        Header()

        Row() {
          Search({ placeholder: '搜索', value: $$this.searchName })
            .height(40)
            .backgroundColor($r('app.color.text_gray'))
            .borderRadius(4)
        }.width('95%')
        .padding({
          left: 10,
          right: 10
        })

        Row({space:15}){
          Image($r('app.media.add_friend1')).width(35).borderRadius(3)
          Text("新的好友")
        }.width("95%")
        .padding(10)
        Divider().width("90%")

        Row({space:15}){
          Image($r('app.media.my_group')).width(35).borderRadius(3)
          Text("我的群组")
        }.width("95%")
        .padding(10)


        List () {
          ForEach(this.filterList, (item: UserInfo) => {
            ListItem() {
              Row({ space: 10 }) {
                Image(item.avatar)
                  .width(35)
                  .height(35)
                  .borderRadius(4)
                Column({space:5}) {
                  Text(item.username)
                    .fontColor($r('app.color.text_primary'))
                    .fontSize(14)
                  Row({space:3}){
                    Text(item.firm).fontSize(13).fontColor("#ccc")
                    Image($r('app.media.true')).width(12)
                  }
                  Divider()
                }.layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .height(60)
              .padding({ left: 10, right: 10 })

            }
            .onClick(()=>{
              router.pushUrl({
                url:'component/ChatDetail/ChatDetail',
                params:item
              })
            })
          })
        }.width("95%")
      }else {      // 有搜索词的情况
        Row({space:10}){
          Image($r('app.media.back_left')).width(25)
          Search({ placeholder: '搜索', value: $$this.searchName })
            .backgroundColor($r('app.color.text_gray'))
            .borderRadius(4)
            .height(40)
            .width("90%")
        }.width("100%")
        .padding({left:20,right:20})

        Row(){
          Text("联系人")
            .fontSize(12)
            .fontColor('#ccc')
          Row({space:3}){
            Image($r('app.media.add')).width(15)
            Text("展开部门").fontSize(12).fontColor('#ccc')
          }.layoutWeight(1)
          .justifyContent(FlexAlign.End)
        }.width("100%")
        .padding({left:20,right:20})

        Divider().margin({top:10}).width("95%")


        List () {
          ForEach(this.filterList, (item: UserInfo) => {
            ListItem() {
              Row({ space: 15 }) {
                Image(item.avatar)
                  .width(55)
                  .height(55)
                  .borderRadius(4)
                Column({space:5}) {
                  Text(item.username)
                    .fontColor($r('app.color.text_primary'))
                    .fontSize(14)

                  Text(item.firm).fontSize(13).fontColor("#ccc")

                  Text("钉钉好友")
                    .fontSize(12)
                    .padding(2)
                    .fontColor($r('app.color.primary'))
                    .backgroundColor($r('app.color.second_primary'))
                    .borderRadius(3)

                }.layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Image($r('app.media.tel')).width(20)
                Image($r('app.media.pCard')).width(20)
              }.alignItems(VerticalAlign.Top)
              .width('100%')
              .height(60)
              .padding({ left: 10, right: 10 })
              .margin({top:20})
            }
            .onClick(()=>{
              router.pushUrl({
                url:'component/ChatDetail/ChatDetail',
                params:item
              })
            })
          })
        }.width("100%")
        .padding(10)

      }



    }
  }
}


@Component
struct Header{
  build() {
    Row(){
      Image($r('app.media.back_left')).width(20)
        .onClick(()=>{
          router.back()
        })
      Text("我的好友")
      Image($r('app.media.add_friends')).width(20)
    }.width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({left:10,right:10})
  }
}


export default  Connect