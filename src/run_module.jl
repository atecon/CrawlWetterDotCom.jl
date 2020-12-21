# module wetter_dot_com_crawler
using Pkg;
Pkg.status()
#Pkg.add(["JuliaFormatter", "DataFrames", "Dates", "CSV", "HTTP", "JSON"], preserve=PRESERVE_DIRECT)
using HTTP;
using CSV;
using DelimitedFiles;
using Dates;
using Printf;
using DataFrames;
using JSON;
using Logging;

function read_json(filename::String)
    return JSON.parsefile(filename)
end

function readfile(filename::String)::String
    return read(filename, String)
end

function outfile(content::String, filename::String)
    """ Write content to ascii file. """
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
    return "({\"date\":\"$date_today\",\"precipitation\":)(.*])"
end


function parse_json_string(body::String) # ::String
    json = ""
    err = false

    pattern = create_regex_pattern()
    matched = match(Regex(pattern), body)
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

function initialize_dataframe()::DataFrame
    return DataFrame(doi=Date[],
                    date=Date[],
                    city=String[],
                    precipitation=Float16[],
                    sunhours=Int8[],
                    temperatureMax=Int8[],
                    temperatureMin=Int8[])
end

function CrawlWetterDotCom(JSON_FILE::JSON)::DataFrame
    """ Main function """

    cities = read_json(JSON_FILE)
    @info @sprintf("Start crawling data for %d cities.", length(keys(cities)))

    df_final = initialize_dataframe()

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
        df.city = repeat_string(city, nrow(df));        # this is faster than <df[!,:city2] .= CITY_NAME;>
        df[:,:doi] .= Dates.today()
        select!(df, ["doi", "date", "city"], :);       # reorder columns

        df_final = append_to_df(df_final, df)

        @info @sprintf("Succesfully finished parsing and storing data for '%s'.\n", city)
    end

    @info @sprintf("Column labels of final data frame are: %s", names(df_final))
    @info @sprintf("Final data frame is of dimension: nrows=%d by ncols=%s", nrow(df_final), ncol(df_final))
    # describe(df_final)
end

# end # module
