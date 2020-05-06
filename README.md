
 
 <p align="center">
  <img width="250" height="250" src="https://github.com/Onaeem26/GoodNews/blob/master/GNLogoSmall.png">
</p>
<h1 align="center">GoodNews</h1>
<h4 align="center">v1.2</h4>

![iOS Build](https://camo.githubusercontent.com/c86345972e600bcb5df94a29e717be86260736d7/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f694f532d31332e302b2d626c75652e737667) ![Swift Version](https://camo.githubusercontent.com/667f6dfa9824258f1bea9b0cefb960b3f983092f/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f53776966742d352e312d627269676874677265656e2e737667) 
 <p align="center">
  <img width="1200" height="600" src="https://github.com/Onaeem26/GoodNews/blob/master/gnpromobanner.jpg">
</p>

<h2> GoodNews V1.2 Update: </h2>
I am excited to announce the release of GoodNews Version 1.2. V1.2 brings some neat new features, along with refining some of the existing ones. 

GoodNews V1.2 brings following new features / changes: 

1. Now you can fetch news from specific websites / domains that aren't available in the sources list. Just tap the `+` button on the top right and choose `Add Domain`. Write the domain name, <b>without</b> `http://`. For example, `9to5mac.com`. (The name of the site with `.com`).

2. The `For You` collection view layout is changed. Instead of showing the topical articles, you now get to see all the latest news from the specific websites/domains that you have added. I have also changed the layout of this section, and created a 2x2 grid that scrolls horizontally. 

3. If you go to `Sources` tab and tap any of the added domains, it will show you all the latest articles from that website. With v1.2, I have implemented infinite scrolling / pagination. As you keep scrolling, you keep on getting more and more articles.  

4. Tapping on any article, takes you to the respective website. The browser gets more features with website loading progress indicator, reload button. 



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
Please note: You need to have atleast one news source selected for the topical articles to show up. 

Selected sources (news sites and topics) are persisted on device. (```UserDefaults```). There is also an onboarding flow where if the user has no news sources selected, the app takes you through how to add a news source and get started. 



