# get weather info from openweater.org
#

const INI_WEATHER_SERVICE = "weather_service"
const INI_WEATHER_API = "api_key"
const INI_WEATHER_ID = "city_id"
const INI_WEATHER_LOCATION = "location"
const OPEN_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
const WEATHER_API_URL = "http://api.weatherapi.com/v1/current.json"
const WEATHER_AST_URL = "http://api.weatherapi.com/v1/astronomy.json"

"""
    getWeather()

Return a Dict with weather information from openweather.org
or weatherapi.com.
The `config.ini`
of the framework must include the lines to define which
service to be used and api key and location for the service used.

```
# weather_service=openweather
weather_service=weatherapi
openweather:api_key=insert_valid_API-key_here
openweather:city_id=6350865

weatherapi:api_key=insert_valid_API-key_here
weatherapi:location=52.52,13.40

weatherapi:api_key=12345abcdef
weatherapi:location=48.8567,2.3508 # lon,lat is needed
```

with a valid app-key (available from openweather.org or weatherapi.com)
and the id or coordinates of a city.

## Value:
The return value has the elements:
- `:service`: name of the weather service or "no_service"
- `:pressure`: pressure in hPa
- `:temperature`: temperature in degrees Celsius
- `:windspeed`: wind speed in meter/sec
- `:winddir`: wind direction in degrees
- `:clouds`: cloudiness in percent
- `:rain`: rain forecast for today
- `:rain1h`
- `:rain3h`: rain in mm in the last 1 or 3 hours
- `:sunrise`
- `:sunset`: local time of sunrise/sunset as DateTime object
"""
function getWeather()

    weatherService = getConfig(INI_WEATHER_SERVICE)
    if weatherService == "openweather"
        return getOpenWeather()

    elseif weatherservice == "weatherapi"
        return getWeatherApi()

    else
        printLog("Try to get wetaher information form invalid service $weatherService")
        return Dict(:service => "no_service")
    end
end


"""
    getOpenWeather()

Return a Dict with weather information from openweather.org.
"""
function getOpenWeather()

    api = getConfig(INI_WEATHER_API, prefix="openweather")
    printDebug("api = $api")
    city = getConfig(INI_WEATHER_ID, prefix="openweather")
    printDebug("city = $city")

    url = "http://$WEATHER_URL?id=$city&APPID=$api"
    printDebug("url = $url")

    response = read(`curl $url`, String)

    Snips.printLog("Weather from OpenWeatherMap: $response")
    openWeather = tryParseJSON(response)

    if !(openWeather isa Dict)
        return nothing
    end

    weather = Dict()
    weather[:service] = "OpenWeatherMap"
    weather[:temperature] = getFromKeys(openWeather, :main, :temp)
    weather[:windspeed] = getFromKeys( openWeather, :wind, :speed)
    weather[:winddir] = getFromKeys( openWeather, :wind, :deg)
    weather[:clouds] = getFromKeys( openWeather, :clouds, :all)
    weather[:rain1h] = getFromKeys( openWeather, :rain, Symbol("1h"))
    if weather[:rain1h] == nothing
        weather[:rain1h] = 0.0
    end
    weather[:rain3h] = getFromKeys( openWeather, :rain, Symbol("3h"))
    if weather[:rain3h] == nothing
        weather[:rain3h] = 0.0
    end
    weather[:rain] = 0.0

    timestr = getFromKeys(openWeather, :sys, :sunrise)
    if timestr != nothing
        weather[:sunrise] = unix2datetime(timestr)

        if (sunrise isa DateTime) && haskey(openWeather, :timezone)
            weather[:sunrise] += Dates.Second(openWeather[:timezone])
        end
    end

    timestr = getFromKeys(openWeather, :sys, :sunset)
    if timestr != nothing
        weather[:sunset] = unix2datetime(timestr)

        if (sunset isa DateTime) && haskey(openWeather, :timezone)
            weather[:sunset] += Dates.Second(openWeather[:timezone])
        end
    end

    return weather
end


"""
    getWeatherApi()

Return a Dict with weather information from weatherapi.com.
"""
function getWeatherApi()

    api = getConfig(INI_WEATHER_API, prefix="weatherapi")
    printDebug("api = $api")
    location = getConfig(INI_WEATHER_LOCATION, multiple=true, prefix="weatherapi")
    if length(location) != 2
        printLog("Wrong location in config.ini for weatherAPI: lon,lat expected!")
        return Dict(:service => "no_service")
    end
    lon = location[1]
    lat = location[2]
    printDebug("location = $lon, $lat")

    url = "$WEATHER_API_URL?key=$api&q=$lat,$lon"
    printDebug("url = $url")

    response = read(`curl $url`, String)
    Snips.printLog("Weather from WeatherApi: $response")
    weatherApi = tryParseJSON(response)

    if !(weatherApi isa Dict)
        return nothing
    end

    weather = Dict()
    weather[:service] = "WeatherApi"
    weather[:temperature] = getFromKeys(weatherApi, :current, :temp_c)
    weather[:windspeed] = getFromKeys( weatherApi, :current, :wind_kph)
    weather[:winddir] = getFromKeys( weatherApi, :current, :wind_degree)
    weather[:clouds] = getFromKeys( weatherApi, :current, :cloud)
    weather[:rain] = getFromKeys( weatherApi, :current, :precip_mm)
    weather[:rain1h] = 0.0
    weather[:rain3h] = 0.0

    url = "$WEATHER_AST_URL?key=$api&q=$lat,$lon"
    printDebug("url = $url")

    response = read(`curl $url`, String)
    Snips.printLog("Astronomy from WeatherApi: $response")
    weatherApi = tryParseJSON(response)

    if !(weatherApi isa Dict)
        return nothing
    end

    timestr = getFromKeys(weatherApi, :astronomy, :astro, :sunrise)
    try
        weather[:sunrise] = Time(timestr, "HH:MM pp")
    catch
        weather[:sunrise] = nothing
    end

    timestr = getFromKeys(weatherApi, :astronomy, :astro, :sunset)
    try
        weather[:sunset] = Time(timestr, "HH:MM pp")
    catch
        weather[:sunset] = nothing
    end
    return weather
end


function getFromKeys(hierDict, key1, key2)

    if haskey(hierDict, key1) && haskey(hierDict[key1], key2)
        val = hierDict[key1][key2]
        return val
    else
        return nothing
    end
end
function getFromKeys(hierDict, key1, key2, key3)

    if haskey(hierDict, key1) && haskey(hierDict[key1], key2) &&
       haskey(hierDict[key1][key2], key3)
        val = hierDict[key1][key2][key3]
        return val
    else
        return nothing
    end
end
