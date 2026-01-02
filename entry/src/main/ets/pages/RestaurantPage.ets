import { calcDistance } from '../utils/LocationUtils'
import { geoLocationManager } from '@kit.LocationKit'
import { loadFavorites, saveFavorites } from '../utils/FavoritesStore'
import { ArcList, ArcListItem, LengthMetrics, ArcListAttribute } from '@kit.ArkUI'


interface Restaurant {
  id: string
  name: string
  category: string
  rating: number
  description: string
  isOpen: boolean
  latitude: number
  longitude: number

  cuisines: string[]
  priceLevel: number
  openingHours: string
  isFavorite: boolean
}

@Builder
export function RestaurantPageBuilder() {
  RestaurantPage()
}

@Component
export struct RestaurantPage {
  pathStack: NavPathStack = new NavPathStack()
  categoryTitle: string = ''
  private context: Context = AppStorage.get('context') as Context
  @State favoriteMap: Map<string, boolean> = new Map()

  @State userLat: number = 0
  @State userLon: number = 0

  @State restaurants: Restaurant[] = [
    {
      id: '1',
      name: 'Amber Cup',
      category: 'Cafe',
      rating: 4.6,
      description: 'Artisan coffee and cozy atmosphere',
      isOpen: true,
      latitude: 41.0121,
      longitude: 28.9765,
      cuisines: ['Coffee', 'Sandwich', 'Dessert'],
      priceLevel: 2,
      openingHours: '08:00 - 22:00',
      isFavorite: false
    },
    {
      id: '2',
      name: 'Brew Corner',
      category: 'Cafe',
      rating: 4.3,
      description: 'Fresh brews and light snacks',
      isOpen: true,
      latitude: 41.0168,
      longitude: 28.9912,
      cuisines: ['Coffee', 'Toast'],
      priceLevel: 2,
      openingHours: '09:00 - 21:00',
      isFavorite: false
    },
    {
      id: '3',
      name: 'Roast & Bean',
      category: 'Cafe',
      rating: 4.1,
      description: 'Slow roasted specialty beans',
      isOpen: false,
      latitude: 41.0154,
      longitude: 28.9728,
      cuisines: ['Coffee', 'Bakery'],
      priceLevel: 3,
      openingHours: '10:00 - 20:00',
      isFavorite: false
    },
    {
      id: '4',
      name: 'Fire Grill',
      category: 'Fast Food',
      rating: 4.2,
      description: 'Grilled burgers and crispy fries',
      isOpen: true,
      latitude: 41.0186,
      longitude: 28.9793,
      cuisines: ['Burger', 'Fries'],
      priceLevel: 2,
      openingHours: '11:00 - 23:00',
      isFavorite: false
    },
    {
      id: '5',
      name: 'Quick Bite',
      category: 'Fast Food',
      rating: 3.9,
      description: 'Fast meals on the go',
      isOpen: true,
      latitude: 41.0112,
      longitude: 28.9841,
      cuisines: ['Wrap', 'Snack'],
      priceLevel: 1,
      openingHours: '10:00 - 00:00',
      isFavorite: false
    },
    {
      id: '6',
      name: 'Urban Stack',
      category: 'Fast Food',
      rating: 4.4,
      description: 'Layered burgers with bold flavors',
      isOpen: false,
      latitude: 41.0065,
      longitude: 28.9709,
      cuisines: ['Burger', 'Chicken'],
      priceLevel: 3,
      openingHours: '12:00 - 22:00',
      isFavorite: false
    },
    {
      id: '7',
      name: 'Sugar Cloud',
      category: 'Dessert',
      rating: 4.7,
      description: 'Handmade cakes and pastries',
      isOpen: true,
      latitude: 41.0133,
      longitude: 28.9771,
      cuisines: ['Cake', 'Pastry', 'Ice Cream'],
      priceLevel: 2,
      openingHours: '10:00 - 22:00',
      isFavorite: false
    },
    {
      id: '8',
      name: 'Golden Crumb',
      category: 'Dessert',
      rating: 4.5,
      description: 'Warm baked desserts daily',
      isOpen: true,
      latitude: 41.0079,
      longitude: 28.9224,
      cuisines: ['Baklava', 'Cookie'],
      priceLevel: 2,
      openingHours: '09:00 - 21:00',
      isFavorite: false
    },
    {
      id: '9',
      name: 'Sweet Loop',
      category: 'Dessert',
      rating: 4.0,
      description: 'Classic desserts with a modern touch',
      isOpen: false,
      latitude: 41.0304,
      longitude: 28.9498,
      cuisines: ['Waffle', 'Pancake'],
      priceLevel: 3,
      openingHours: '11:00 - 20:00',
      isFavorite: false
    },

    {
      id: '10',
      name: 'Corner Wrap',
      category: 'Street Food',
      rating: 4.3,
      description: 'Fresh wraps from the street',
      isOpen: true,
      latitude: 41.0395,
      longitude: 28.9056,
      cuisines: ['Wrap', 'Kebab'],
      priceLevel: 1,
      openingHours: '12:00 - 02:00',
      isFavorite: false
    },
    {
      id: '11',
      name: 'Midnight Skillet',
      category: 'Street Food',
      rating: 4.6,
      description: 'Late night street flavors',
      isOpen: true,
      latitude: 41.0447,
      longitude: 28.9239,
      cuisines: ['Grill', 'Sandwich'],
      priceLevel: 2,
      openingHours: '18:00 - 04:00',
      isFavorite: false
    },
    {
      id: '12',
      name: 'Rolling Pan',
      category: 'Street Food',
      rating: 4.1,
      description: 'Hot meals served fresh',
      isOpen: false,
      latitude: 41.0789,
      longitude: 28.8814,
      cuisines: ['Fried Food', 'Snack'],
      priceLevel: 1,
      openingHours: '16:00 - 23:00',
      isFavorite: false
    }
  ]
  async toggleFavorite(id: string) {
    const current = this.favoriteMap.get(id) === true
    this.favoriteMap.set(id, !current)

    this.favoriteMap = new Map(this.favoriteMap)

    const favorites: Restaurant[] = this.restaurants.filter(r =>
    this.favoriteMap.get(r.id) === true
    )

    await saveFavorites(this.context, favorites)
  }

  getDistanceToRestaurant(r: Restaurant): string {
    const distance = calcDistance(
      this.userLat,
      this.userLon,
      r.latitude,
      r.longitude
    )
    return distance < 1000
      ? `${Math.round(distance)} m`
      : `${(distance / 1000).toFixed(1)} km`
  }


  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Text(this.categoryTitle)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        ArcList() {
        ForEach(
          this.restaurants.filter(r => r.category === this.categoryTitle),
          (item: Restaurant) => {

            ArcListItem() {
              this.RestaurantCard(item)
            }

          },
          (item: Restaurant) => item.id
        )
      } .scrollBar(BarState.Off)
        .space(LengthMetrics.px(50))
        .height(150)
      }
      .padding(16)
    }
    .hideBackButton(true)
    .onReady(async (context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      this.categoryTitle = context.pathInfo?.param as string
      const saved: Restaurant[] = await loadFavorites(this.context)

      const map = new Map<string, boolean>()
      saved.forEach(r => {
        map.set(r.id, true)
      })

      this.favoriteMap = map


      this.restaurants = this.restaurants.slice()
      let request: geoLocationManager.ContinuousLocationRequest =
        { 'interval': 1, 'locationScenario': geoLocationManager.UserActivityScenario.NAVIGATION };
      let locationCallback = (location: geoLocationManager.Location): void => {
          this.userLat = location.latitude
        this.userLon = location.longitude
          }
      try {
        geoLocationManager.on('locationChange', request, locationCallback);
      } catch (err) {
        console.error(err.code);
      }
    })
  }

  @Builder
  RestaurantCard(item: Restaurant) {
        Column({ space: 6 }) {
          Row() {
            Text(item.name)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
            Text(this.favoriteMap.get(item.id) ? ' ❤️' : ' 🤍')
              .fontSize(14)
              .onClick(() => this.toggleFavorite(item.id))
          }

          Row() {
            Text(item.isOpen ? 'OPEN' : 'CLOSED')
              .fontSize(10)
              .fontColor(item.isOpen ? '#4CAF50' : '#F44336')
            Text(` 📍${this.getDistanceToRestaurant(item)}`)
              .fontSize(10)
              .fontColor('#ccc')
          }

          Text(item.description)
            .fontSize(10)
            .fontColor('#aaa')
            .maxLines(1)
          Text(`⭐ ${item.rating}`)
            .fontSize(10)
        }
        .padding(12)
        .width('90%')
        .backgroundColor('#2a2a2a')
        .borderRadius(16)
        .onClick(() => {
          this.pathStack.pushPathByName(
            'restaurantDetailsPage',
            item
          )
        })
  }
}
