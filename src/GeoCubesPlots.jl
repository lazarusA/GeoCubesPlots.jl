module GeoCubesPlots
using GLMakie, GeometryBasics, YAXArrays

include("vizCubes.jl")
include("vizLonLat.jl")

export cube!, plot, plotcube

end # module
