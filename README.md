
 
 <p align="center">
  <img width="250" height="250" src="https://github.com/Onaeem26/GoodNews/blob/master/GNLogoSmall.png">
</p>
<h1 align="center">GoodNews</h1>

<p align="center">
    <img src="https://img.shields.io/badge/version-1.2-red.svg" />
    <img src="https://img.shields.io/badge/iOS-13.0%2B-blue.svg" />
    <img src="https://img.shields.io/badge/Swift-5.0-ff69b4.svg" />
    <a href="https://twitter.com/madebyon">
        <img src="https://img.shields.io/badge/contact-%40madebyon-lightgrey" alt="Twitter: @madebyon" />
    </a>
</p>

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

5. Fixed a bug that was present in v1.1 where images wouldn't load properly. With V1.2, I have re-written the image caching code from ground up and you will find images to load up quickly and smoothly. 

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



