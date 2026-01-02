interface Restaurant {
  id: string
  name: string
  category: string
  rating: number
  description: string
  isOpen: boolean
  cuisines: string[]
  priceLevel: number
  openingHours: string
}
@Builder
export function RestaurantDetailsPageBuilder() {
  RestaurantDetailsPage()
}

@Component
export struct RestaurantDetailsPage {
  restaurant!: Restaurant

  build() {
    NavDestination() {
      Column({ space: 6 }) {
        Text(this.restaurant.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        Text(this.restaurant.category)
          .fontSize(12)
          .fontColor('#aaa')
        Row({ space: 6 }) {
          Text(`⭐ ${this.restaurant.rating}`)
            .fontSize(12)
          Text(this.restaurant.isOpen ? 'OPEN' : 'CLOSED')
            .fontSize(10)
            .fontColor(this.restaurant.isOpen ? '#4CAF50' : '#F44336')
        }
        Column({ space: 3 }) {
          Text('What they serve')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
          Row({ space: 3 }) {
            ForEach(this.restaurant.cuisines, (item: string) => {
              Text(item)
                .fontSize(10)
                .backgroundColor('#2a2a2a')
                .borderRadius(8)
            },(item: string) => item)
          }
        }
        Row() {
          Text('Price level ')
            .fontSize(12)
          Text(this.getPriceText(this.restaurant.priceLevel))
            .fontSize(12)
        }
        Row() {
          Text('Opening hours ')
            .fontSize(12)
          Text(this.restaurant.openingHours)
            .fontSize(12)
            .fontColor('#aaa')
        }
        Text(this.restaurant.description)
          .fontSize(8)
          .fontColor('#ccc')
      }
      .padding(16)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
    .onReady((context: NavDestinationContext) => {
      this.restaurant = context.pathInfo?.param as Restaurant
    })
  }

  getPriceText(level: number): string {
    return '$'.repeat(level)
  }
}
