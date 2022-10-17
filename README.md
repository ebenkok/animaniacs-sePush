# BlackMap

 An app to map the wards in the country to an EskomSePushID. BlackMap loads wards in the country from an included geoJSON file. Zones are overlayed onto the map and are interactive. Tapping on a zone highlights the zone, retrieves the EskomSePushID for the GPS Coordinates and retrievs the closest EskomSePushID via the API.

Each Ward or polygon has a unique ID in the geoJson dataset. Once the EskomSePushID has been retrieved a mapping is created between the EskomSePushID and the Polygon ID. This will allow for users to obtain the schedule for a Ward.

The geoJSON dataset is retrieved from https://gadm.org.



### Setup

- Ensure that JAVA 11 is installed
- Clone the repo
- Run git submodule update --init
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
