module GeoCubesPlots
using GLMakie, GeometryBasics, YAXArrays

include("vizCubes.jl")
include("vizLonLat.jl")
include("getSlides.jl")
include("vizSpheres.jl")


export cube!, plotmap, plotcube, getTimeSlides, getCubeFaces, plotSlides, recordSlides
export toCartesian, lonlat3D, SphereBall
end # module
