module GeoCubesPlots
using GLMakie, GeometryBasics, YAXArrays

include("vizCubes.jl")
include("vizLonLat.jl")
include("getSlides.jl")


export cube!, plotmap, plotcube, getTimeSlides, getCubeFaces, plotSlides, recordSlides

end # module
