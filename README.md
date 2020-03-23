
 
 <p align="center">
  <img width="250" height="250" src="https://github.com/Onaeem26/GoodNews/blob/master/GNLogoSmall.png">
</p>
<h1 align="center">GoodNews</h1>

![iOS Build](https://camo.githubusercontent.com/c86345972e600bcb5df94a29e717be86260736d7/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f694f532d31332e302b2d626c75652e737667) ![Swift Version](https://camo.githubusercontent.com/667f6dfa9824258f1bea9b0cefb960b3f983092f/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f53776966742d352e312d627269676874677265656e2e737667) 
 <p align="center">
  <img width="1200" height="600" src="https://github.com/Onaeem26/GoodNews/blob/master/gnpromobanner.jpg">
</p>


<h3>GoodNews is a simple and minimal news app for iPhone. The app uses <a href="https://newsapi.org">NewsAPI</a> to fetch latest news.</h3>

 GoodNews let's you make your own news feed by selecting news sources and topics. You can select from 130 news sources from all around the globe. If you want to get articles on a speicific topic, just type it in and the app will find the latest articles related to the topic.

GoodNews app uses a framework that I created late last year called <a href="https://newsapi.org">GlideUI</a>. This framework provides the Card UI that you will see quite a lot in this app. The card UI provides easy and one handed access. The card UI handles keyboard as well as any scrollViews that may be embedded inside the card view controller. 

<h3> Backend Architecture </h3>
GoodNews uses a very simple and robust architecture to connect the front end to the back end. The app is decoupled from the backend and the app can be hooked up to any backend service as you please. There is a generic protocol that contains all the methods which needs to be conformed to when connecting your own backend service. 

```swift
protocol NewsNetworkManagerProtocol {
    func fetchNewsSources(completion: @escaping ([NewsSource]) -> ())
    func fetchArticles(sources: [NewsSource: Bool], completion: @escaping ([ForYouSection]) -> ())
    func fetchTopicalArticles(topics: [String], completion: @escaping (ForYouSection) -> ())
    func fetchForYouArticles(sources: [NewsSource: Bool], topic: [String]?, completion: @escaping ([ForYouSection]) -> ())
}
```


The app uses ```DiffableDataSource``` and ```UICollectionViewCompositionalLayout``` to design the For You screen. 
```ForYouSection``` is a struct that contains the section enum and the articles for that certain section. 
```Section``` enum consists of: 
```swift
enum Section {
    case featured
    case topical
    case misc
}
```
Please note: You need to have one news source selected for the topical articles to show up. 

Selected sources (news sites and topics) are persisted on device. (```UserDefaults```). There is also an onboarding flow where if the user has no news sources selected, the app takes you through how to add a news source and get started. 


