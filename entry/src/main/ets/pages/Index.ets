import { TabBarClass } from '../models/Tab'
import Connect from './Connect'
import My from './My'
import Phonebook from './Phonebook'

@Entry
@Component
struct Index {
  @State
  tabList: TabBarClass[] = [{
    icon: $r('app.media.ic_public_message'),
    name: 'Ding',
    title: '消息',
    selectIcon: $r('app.media.ic_public_message_filled')
  }, {
    icon: $r('app.media.ic_gallery_discover'),
    name: 'cooperation',
    title: '协作',
    selectIcon: $r('app.media.ic_gallery_discover_filled')
  }, {
    icon: $r('app.media.application'),
    name: 'firm',
    title: '博为峰',
    selectIcon: $r('app.media.logo')
  }, {
    icon: $r('app.media.ic_public_contacts_group'),
    name: 'connect',
    title: '通讯录',
    selectIcon: $r('app.media.ic_public_contacts_group_filled')
  }, {
    icon: $r('app.media.ic_public_contacts'),
    name: 'my',
    title: '我的',
    selectIcon: $r('app.media.ic_public_contacts_filled')
  }]
  @State
  currentIndex: number = 0
  @Builder
  CommonTabBar (item: TabBarClass) {
    Column () {
      Image(this.tabList[this.currentIndex].name === item.name ? item.selectIcon : item.icon )
        .width(20)
        .height(20)
      Text(item.title)
        .fontSize(12)
        .fontColor(item.name === this.tabList[this.currentIndex].name ? $r('app.color.primary') : $r('app.color.text_primary'))
        .margin({
          top: 5
        })
    }
  }
  build() {
    Tabs({ index: $$this.currentIndex }) {
      ForEach(this.tabList, (item: TabBarClass) => {
        TabContent() {
          if(item.name === "connect") {
            Phonebook()
          }else if(item.name === 'my'){
            My()
          }
        }.tabBar(this.CommonTabBar(item))

      }, (item: TabBarClass) => item.name.toString())
    }.barPosition(BarPosition.End)
    .animationDuration(300)
  }
}