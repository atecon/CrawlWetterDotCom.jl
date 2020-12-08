# module wetter_dot_com_crawler
using Pkg;
Pkg.status()
# Pkg.add(["JuliaFormatter", "DataFrames", "Dates", "CSV", "HTTP", "JSON"], preserve=PRESERVE_DIRECT)
using HTTP;
using CSV;
using DelimitedFiles;
using Dates;
using Printf;
using DataFrames;
using JSON;
using Logging;

USE_JSON = true

if USE_JSON
    PATH_JSON = "./data/city_url.json"
else
    URL = "https://www.wetter.com/wetter_aktuell/wettervorhersage/16_tagesvorhersage/deutschland/hamburg/DE0004130.html"
    CITY_NAME = "Hamburg"
end


function read_json(filename::String)
    return JSON.parsefile(filename)
end

function readfile(filename::String)::String
    return read(filename, String)
end

function outfile(content::String, filename::String)
    """ Write content to asciss file. """
    open(filename, "w") do f
        write(f, content)
    end
end

function fetch_html_body(url::String)::String
    res = HTTP.request("GET", url, verbose=0)
    # println(res.status)
    # TODO: Add check
    return String(res.body)
end

function create_regex_pattern()::String
    """ Create regex pattern for parsing. """
    date_today = Dates.today()
    # pattern = @sprintf("r\"({\"date\":\"%s\",\"precipitation\":)(.\\*])\"", date_today)
    return "({\"date\":\"2020-11-08\",\"precipitation\":)(.*])"
end

function parse_json_string(body::String) # ::String
    # pattern = create_regex_pattern()
    # matched = match(pattern, body)
    """ Currently using 'pattern' does not work due to escape '\'. """

    json = ""
    err = false

    matched = match(r"({\"date\":\"2020-12-08\",\"precipitation\":)(.*])", body)
    try
        json = String(matched.match)
        json = remove_whitespaces(json)
        json = add_list_opener(json)
    catch
        @warn "No match for pattern found. Ignore."
        err = true
    end

    return json, err
end

function add_list_opener(content::String)
    content = "[" * content
end

function remove_whitespaces(content::String)::String
    replace(content, " " => "")
end

function repeat_string(s::String, times::Int64)::Array
    """Repeat a specific string and append each time to an array. """
    arr = Array{Union{Nothing,String}}(nothing, times)
    for i = 1:times
        arr[i] = s
    end
    return arr
end

function append_to_df(target::DataFrame, source::DataFrame)::DataFrame
    if names(target) == names(source)
        append!(target, source)
    else
        @error "Cannot append data frame as columns do not match."
    end
    return target
end


if USE_JSON
    cities = read_json(PATH_JSON)
else
    body = readfile("./data/html_hh.html");
end

@info @sprintf("Start crawling data for %d cities.", length(keys(cities)))

df_final = DataFrame(doi=Date[],
                    date=Date[],
                    city=String[],
                    precipitation=Float64[],
                    sunhours=Int64[],
                    temperatureMax=Int64[],
                    temperatureMin=Int64[])


for (city, url) in cities
    @info @sprintf("Start fetching data for '%s'.\n", city)
    body = fetch_html_body(url)

    json_string, err = parse_json_string(body);
    if err
        @warn @sprintf("Ignore '%s' as not recent data could be found.\n", city)
        continue
    end

    json = JSON.parse(json_string);                 # parse json_string to array type
    df = reduce(vcat, DataFrame.(json))
    df.date = Date.(df.date, "yyyy-mm-dd");
    df.city = repeat_string(city, nrow(df));  # this is faster than <df[!,:city2] .= CITY_NAME;>
    df[:,:doi] .= Dates.today()                    # date_of_information
    select!(df, ["doi", "date", "city"], :);       # reorder columns

    df_final = append_to_df(df_final, df)
    print(df_final)

    @info @sprintf("Succesfully finished parsing and storing data for '%s'.\n", city)
end

ncol(df_final)
nrow(df_final)
names(df_final)
describe(df_final)



# end # module

