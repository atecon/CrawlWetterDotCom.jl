# CrawlWetterDotCom
Crawl daily weather forecasts up to 16 days ahead from www.wetter.com. This package is my first Julia 'project' to get into this programming language.

## Module
There is a single module ```./src/CrawlWetterDotCom.jl``` which can be loaded via the command  ```using CrawlWetterDotCom```. This module exports a single function named ```Crawler```.

## ```Crawler()```
This main function has the following signature:

```Crawler(JSON_FILE::String)::DataFrame```

It consumes a json file and returns a data frame with the crawled data of weather forecasts.

## json-structure
The user must pass the path to a json-file which has the following structure (also see ```./data/city_url.json```):

```json
{
    "<CITY_NAME>": "<WETTER_DOT_COM_URL>",
    "<CITY_NAME>": "<WETTER_DOT_COM_URL>"
}
```

## Sample script
```./main.jl``` shows on how to load the module and call it:
```julia
using CrawlWetterDotCom

df = Crawler("./data/city_url.json")
df
```

The returned data frame looks as:
```
julia> df
32×7 DataFrame
 Row │ doi         date        city     precipitation  sunhours  temperatureMax  temperatureMin
     │ Date…       Date…       String   Float16        Int8      Int8            Int8
─────┼──────────────────────────────────────────────────────────────────────────────────────────
   1 │ 2021-01-03  2021-01-03  berlin             9.4         0               1               0
   2 │ 2021-01-03  2021-01-04  berlin             1.9         0               1               0
   3 │ 2021-01-03  2021-01-05  berlin             0.0         0               2               0
   4 │ 2021-01-03  2021-01-06  berlin             0.2         1               1               0
   5 │ 2021-01-03  2021-01-07  berlin             0.0         7               0              -3
   6 │ 2021-01-03  2021-01-08  berlin             0.0         2               0              -2
   7 │ 2021-01-03  2021-01-09  berlin             0.0         2               0              -2
   8 │ 2021-01-03  2021-01-10  berlin             0.1         1              -1              -2
   9 │ 2021-01-03  2021-01-11  berlin             0.0         1               0              -2
  ⋮  │     ⋮           ⋮          ⋮           ⋮           ⋮            ⋮               ⋮
  24 │ 2021-01-03  2021-01-10  hamburg            0.0         1               0              -2
  25 │ 2021-01-03  2021-01-11  hamburg            0.0         1               0              -2
  26 │ 2021-01-03  2021-01-12  hamburg            0.0         1               1              -2
  27 │ 2021-01-03  2021-01-13  hamburg            0.0         5               4               0
  28 │ 2021-01-03  2021-01-14  hamburg            0.0         1               2              -1
  29 │ 2021-01-03  2021-01-15  hamburg            0.2         0               1              -2
  30 │ 2021-01-03  2021-01-16  hamburg            0.1         1               0              -3
  31 │ 2021-01-03  2021-01-17  hamburg            0.3         0               1              -1
  32 │ 2021-01-03  2021-01-18  hamburg            0.9         0               5              -3
```

## Next steps
1) Add tests\
2) officially publish?
