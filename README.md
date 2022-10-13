# BlackMap
## An app to display the current outages on a map with some functionality to see loadshedding when setting the time.


### Setup

- Clone the repo
- Run `pod install`

The APIClient needs an API key. The key should be provided in the AccessTokenProviderImplementation class. There is a function `provideAccessToken` that retuns an empty string. Place your API key here.

```
import Foundation
import shared

class AccessTokenProviderImplementation: AccessTokenProvider {
    func provideAccessToken() async throws -> String {
        return "" // place API key here
    }
}
```
