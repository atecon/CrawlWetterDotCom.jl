# module wetter_dot_com_crawler
using Pkg;
Pkg.status()
# Pkg.add(["JSON", "DataFrames", "Dates", "CSV", "HTTP", "JSON"], preserve=PRESERVE_DIRECT)
using HTTP;
using CSV;
using DelimitedFiles;
using Dates;
using Printf;
using DataFrames;
using JSON;


URL = "https://www.wetter.com/wetter_aktuell/wettervorhersage/16_tagesvorhersage/deutschland/hamburg/DE0004130.html"
CITY_NAME = "Hamburg"


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
    return String(res.body)
end

function create_regex_pattern()::String
    """ Create regex pattern for parsing. """
    date_today = Dates.today()
    # pattern = @sprintf("r\"({\"date\":\"%s\",\"precipitation\":)(.\\*])\"", date_today)
    return "({\"date\":\"2020-11-26\",\"precipitation\":)(.*])"
end

function parse_json_string(body::String) # ::String
    # pattern = create_regex_pattern()
    # matched = match(pattern, body)
    """ Currently using 'pattern' does not work due to escape '\'. """

    matched = match(r"({\"date\":\"2020-11-26\",\"precipitation\":)(.*])", body)

    json = String(matched.match)
    json = remove_whitespaces(json)
    json = add_list_opener(json)
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


"""
body = fetch_html_body(URL);
outfile(body, "./data/html_hh.html");
"""
body = readfile("./data/html_hh.html");

json_string = parse_json_string(body);
json = JSON.parse(json_string);     # parse json_string to array type
df = reduce(vcat, DataFrame.(json))
df.date = Date.(df.date, "yyyy-mm-dd");

df.city = repeat_string(CITY_NAME, nrow(df))  # add city name column
select(df, ["date", "city"], :)               # reorder columns


ncol(df)
nrow(df)
names(df)
describe(df)


# TODO:
1) add a column "date_of_information"
2) Configure a json with key=city, value=url
3) Loop over all key-value pairs and concatenate resulting data frames to get a single one

# end # module

