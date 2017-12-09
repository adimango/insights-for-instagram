# Insights for Instagram
A simple iOS Instagram's media insights App.

![iOS](https://img.shields.io/badge/iOS-10.0%2B-blue.svg)
![Swift](https://img.shields.io/badge/Swift-4-blue.svg)
[![Build Status](https://travis-ci.org/adimango/insights-for-instagram.svg?branch=master)](https://travis-ci.org/adimango/insights-for-instagram)

![](screenshots/app-github-header.png)

### Quick Start

Want to get the app running? Run this in your shell:

```sh
git clone https://github.com/adimango/insights-for-instagram.git
cd insights-for-instagram
pod install
open insights-for-instagram.xcworkspace
```

You will have a running version of the insights-for-instagram app by hitting `Build > Run`.

### Features

* Passwordless Reports, simply add your Instagram username, and start seeing reports right away
* Best Engagement, insights for Instagram gives you information about which posts resonate better than others
* Top Most Commented and Liked, the posts that generated the most comments or likes

### Planned features

* Best Day to Post, find out what your best time to post on Instagram is
* Hashtag Performance, discover which hashtags deliver the most engagement

### Questions

If you have questions about any aspect of this project, please feel free to
[open an issue](https://github.com/adimango/insights-for-instagram/issues/new).

### Credits

- [Moya][]: network abstraction layer written in Swift
- [Realm][]: data layer written in Swift
- [Quick][]: behavior-driven development framework for Swift

### License

MIT License. See [LICENSE](LICENSE).

[Moya]:https://github.com/Moya/Moya
[Realm]:https://realm.io/docs/swift/latest/
[Quick]:https://github.com/Quick/Quick

## Updates

### Dec 01, 2017: Breaking Changes

The Instragram API media endpoints now returns to 404-pages. After more of 20k downloads in just few month, Instagram removed the public API. However, the advanced queries are still available and a workaround will be push soon!

### Dec 09, 2017: Back on Track

The app is using a new Instragram API proxy, developed using `/graphql/query` and some web API params.

```
https://insights-for-instagram.herokuapp.com/api/users/:user_name/media

```

