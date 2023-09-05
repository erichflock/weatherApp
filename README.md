# WeatherApp
Weather app that allows users to access real-time or forecasted weather data for their location or any other location of their choice

Important: 
To test the app, please add an API key from OpenWeatherMap (https://openweathermap.org/appid) to the following path: https://github.com/erichflock/weatherApp/blob/main/WeatherApp/Network/NetworkConfig.swift

Additional Features:
* Multiple temperature units (Celsius and Fahrenheit).
* Light and dark mode support.
* Location permission requested when app starts. If user denies it, it will be requested again when he or she taps on location button.
* App handles different states: No location permission provided, no weather data found, no search results and loading while location and weather data are being fetched.
* Main tasks covered with unit tests.

Design decisions:
* Model-View architecture was chosen in combination with managers and network services. This allows each view to have its business logic separated in a file (view model) which improves the testability. Also, it makes it easier for other developers to understand the relationship of files in the application.
* Files organized by type and features. E.g.: Network files are grouped in the network directory and then divided by their function (API-related, general configuration, etc.). 
* Models received from API responses were separated from the ones used in the views. Then a map function was added inside each local model to facilitate the data transformation. This was done to reduce changes in the code when the API model changes and therefore reduce dependencies.
* To allow tests in the network layer, the technique of protocols was used. This was also done to avoid network communication during unit tests since the object responsible for making the API calls can be easily replaced by one that conforms to the API protocol.
* External communication is done using the new swift async calls to avoid using closures and use the new state of the art for this matter.

Demo dark mode:
https://github.com/erichflock/weatherApp/assets/10236662/0079eeb8-dfbd-4f83-8245-f1aa0c7c1e4e

Demo light mode:
https://github.com/erichflock/weatherApp/assets/10236662/eda26763-d07e-43e5-896c-9d016365f8b0

Screenshots:

![Weather_Celsius](https://github.com/erichflock/weatherApp/assets/10236662/3e8f2166-dd7e-4915-af37-a02099318616)
![Weather_Fahrenheit](https://github.com/erichflock/weatherApp/assets/10236662/c1eea57e-c74a-4d7e-8d4e-c32cf74ab57f)
![Search_Empty](https://github.com/erichflock/weatherApp/assets/10236662/c71cd363-d88f-4854-96a2-2a56852953e3)
![Search_Results](https://github.com/erichflock/weatherApp/assets/10236662/082652e8-0daa-484d-8cc5-f4c771c2cf4e)



