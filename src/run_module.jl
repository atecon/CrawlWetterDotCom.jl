# module wetter_dot_com_crawler
using Pkg;
# Pkg.add(["HTTP", "JSON"], preserve=PRESERVE_DIRECT)
using HTTP;

URL = "https://www.wetter.com/wetter_aktuell/wettervorhersage/16_tagesvorhersage/deutschland/hamburg/DE0004130.html"

function fetch_html_body(url::String)::String
    res = HTTP.request("GET", url, verbose=0)
    # println(res.status)
    println(String(res.body))
end

function parse_json_string(body::String)::String
    
end

body = fetch_html_body(URL)




{"date":"2020-11-25","precipitation":0,"temperatureMax":7,"temperatureMin":2,"sunhours":4},{"date":"2020-11-26","precipitation":0.6,"temperatureMax":10,"temperatureMin":6,"sunhours":1},{"date":"2020-11-27","precipitation":0,"temperatureMax":6,"temperatureMin":2,"sunhours":0},{"date":"2020-11-28","precipitation":0,"temperatureMax":7,"temperatureMin":4,"sunhours":2},{"date":"2020-11-29","precipitation":0,"temperatureMax":3,"temperatureMin":0,"sunhours":4},{"date":"2020-11-30","precipitation":0,"temperatureMax":3,"temperatureMin":-1,"sunhours":2},{"date":"2020-12-01","precipitation":0,"temperatureMax":5,"temperatureMin":2,"sunhours":1},{"date":"2020-12-02","precipitation":0,"temperatureMax":6,"temperatureMin":4,"sunhours":1},{"date":"2020-12-03","precipitation":0,"temperatureMax":4,"temperatureMin":1,"sunhours":0},{"date":"2020-12-04","precipitation":0,"temperatureMax":3,"temperatureMin":0,"sunhours":2},{"date":"2020-12-05","precipitation":0,"temperatureMax":4,"temperatureMin":0,"sunhours":1},{"date":"2020-12-06","precipitation":0.9,"temperatureMax":3,"temperatureMin":1,"sunhours":2},{"date":"2020-12-07","precipitation":0.5,"temperatureMax":7,"temperatureMin":3,"sunhours":0},{"date":"2020-12-08","precipitation":0.4,"temperatureMax":9,"temperatureMin":7,"sunhours":1},{"date":"2020-12-09","precipitation":0.1,"temperatureMax":8,"temperatureMin":6,"sunhours":1},{"date":"2020-12-10","precipitation":0.5,"temperatureMax":9,"temperatureMin":8,"sunhours":0}            ]</script>


# dat = JSON.parse(join(readlines(IOBuffer(res.body)), " "))
# haskey(dat, "bpi") ? dat["bpi"] : Dict()


# end # module

