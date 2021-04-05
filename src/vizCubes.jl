"""
cube!(; args...)

add cubes faces to plot.

a1       :: size of each side
a2       :: position of each side
cxyz     :: cube position center
cmap     :: colormap
topF     :: top side of cube
bottomF  :: bottom side of cube
frontF   :: front side of cube
backF    :: back side of cube
leftF    :: left side of cube
rightF   :: right side of cube

"""
function cube!(ax; a1 = 1, a2 = 1, timeLonLat = (40,50,20), cxyz = (0,0,0),
        cmap = :plasma, transparent = false, limits = limits,
        topF    = randn(timeLonLat[1], timeLonLat[2]),
        bottomF = randn(timeLonLat[1], timeLonLat[2]),
        frontF  = randn(timeLonLat[2], timeLonLat[3]),
        backF   = randn(timeLonLat[2], timeLonLat[3]),
        leftF   = randn(timeLonLat[1], timeLonLat[3]),
        rightF  =  randn(timeLonLat[1], timeLonLat[3])) # highLimit=0, lowLimit=1

    highLimit = maximum(maximum.(x->isnan(x) ? -Inf : x, (topF, bottomF, frontF, backF, leftF, rightF)))
    lowLimit =  minimum(minimum.(x->isnan(x) ?  Inf : x, (topF, bottomF, frontF, backF, leftF, rightF)))

    x = LinRange(-a1, a1, size(topF)[1])
    y = LinRange(-a1, a1, size(topF)[2])
    z = LinRange(-a1, a1, size(leftF)[2])

    bsurf = heatmap!(ax, y .+ cxyz[2], z .+ cxyz[3], backF, transformation=(:yz, -a2 + .+ cxyz[1]),
    colormap = cmap, transparency = transparent, limits = limits, colorrange = (lowLimit, highLimit)) # back, limits = FRect((-1,-1,-1), (2,2,2))
    heatmap!(ax, x .+ cxyz[1], z .+ cxyz[3], leftF, transformation=(:xz, -a2 + .+ cxyz[2]),
        colormap = cmap, transparency = transparent, colorrange = (lowLimit, highLimit)) # left
    heatmap!(ax, x .+ cxyz[1], y .+ cxyz[2], bottomF, transformation=(:xy, -a2 + cxyz[3]),
        colormap = cmap, transparency = transparent, colorrange = (lowLimit, highLimit)) # bottom
    heatmap!(ax, y .+ cxyz[2], z .+ cxyz[3], frontF, transformation=(:yz,  a2 + cxyz[1]),
        colormap = cmap, transparency = transparent, colorrange = (lowLimit, highLimit)) # front
    heatmap!(ax, x .+ cxyz[1], z .+ cxyz[3], rightF, transformation=(:xz,  a2 + .+ cxyz[2]),
        colormap = cmap, transparency = transparent, colorrange = (lowLimit, highLimit)) # right
    heatmap!(ax, x .+ cxyz[1], y .+ cxyz[2], topF, transformation = (:xy,  a2 + cxyz[3]),
        colormap = cmap, transparency = transparent, colorrange = (lowLimit, highLimit)) # top
    bsurf
end

"""
plotcube(; args...)
______
a1       ::  size of each side
a2       :: position of each side
cxyz     :: cube position center
cmap     :: colormap
topF     :: top side of cube
bottomF  :: bottom side of cube
frontF   :: front side of cube
backF    :: back side of cube
leftF    :: left side of cube
rightF   :: right side of cube
lonrange :: longitude range for ticks
latrange :: longitude range for ticks
timeStamps :: time ticks to be considered

"""
function plotcube(;a1 = 1, a2 = 1, timeLonLat = (40,50,20), cxyz = (0,0,0),
        cmap = :Spectral_11, transparent = false, limits = limits,
        topF    = randn(timeLonLat[1], timeLonLat[2]),
        bottomF = randn(timeLonLat[1], timeLonLat[2]),
        frontF  = randn(timeLonLat[2], timeLonLat[3]),
        backF   = randn(timeLonLat[2], timeLonLat[3]),
        leftF   = randn(timeLonLat[1], timeLonLat[3]),
        rightF  =  randn(timeLonLat[1], timeLonLat[3]),
        lonrange= (-20,10), latrange = (-25,15),
        timeStamps = ["Jan", "Feb", "Mar", "Apr", "May"])

    limits = Rect(Vec3f0(-1), Vec3f0(2))
    fig = Figure(resolution = (650, 500))

    ax = LScene(fig, scenekw = (camera = cam3d!, show_axis = true))

    cbox = cube!(ax; a1 = a1, a2 = a2, timeLonLat = timeLonLat, cxyz = cxyz,
        limits = limits, cmap = cmap, transparent = transparent,
        topF = topF, bottomF=bottomF, frontF=frontF, backF =backF,
        leftF= leftF, rightF=rightF )

    cbar  = Colorbar(fig, cbox,  label = "Label",
        width = 11, height = Relative(2/4), tickalign = 1, ticklabelsize = 12, labelsize = 12,)

    yticks!(ax.scene; ytickrange = -1:0.5:1,
        yticklabels=[" ", "$(lonrange[1])", "$((lonrange[1] + lonrange[2])/2)", "$(lonrange[2])", " "])
    zticks!(ax.scene; ztickrange = -1:0.5:1,
        zticklabels=[" ", "$(latrange[1])", "$((latrange[1] + latrange[2])/2)", "$(latrange[2])", " "])
    xticks!(ax.scene; xtickrange = -1:0.5:1, xticklabels= timeStamps)


    axis = ax.scene[OldAxis]
    axis[:names, :axisnames] = ("time", "lon", "lat")
    axis[:ticks][:textcolor] = :black
    axis[:names][:textcolor] = (:black, :black, :black)
    #limits[] = Rect(Vec3f0(-2,-2,-2), Vec3f0(4.5))
    fig[1, 1] = ax
    fig[1, 2] = cbar
    fig
end
