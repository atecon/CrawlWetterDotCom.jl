include("run_module.jl")

df = CrawlWetterDotCom("./data/city_url.json")
describe(df)