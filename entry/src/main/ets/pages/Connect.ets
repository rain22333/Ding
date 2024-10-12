import { DefaultUserList, UserInfo } from '../models/users'

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
      Row() {
        Search({ placeholder: '搜索', value: $$this.searchName })
          .height(40)
          .backgroundColor($r('app.color.text_gray'))
          .borderRadius(4)
      }.width('100%')
      .padding({
        left: 10,
        right: 10
      })

      List () {
        ForEach(this.filterList, (item: UserInfo) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(item.avatar)
                .width(30)
                .height(30)
                .borderRadius(4)
              Column() {
                Text(item.username)
                  .fontColor($r('app.color.text_primary'))
                  .fontSize(14)
              }.layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
            }
            .width('100%')
            .height(60)
            .padding({ left: 10, right: 10 })
          }
        })
      }
    }
  }
}

export default  Connect