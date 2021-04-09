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

    bsurf = heatmap!(ax, y .+ cxyz[2], z .+ cxyz[3], backF, transformation=(:yz, -a2 + cxyz[1]),
    colormap = cmap, transparency = transparent, limits = limits, colorrange = (lowLimit, highLimit)) # back, limits = FRect((-1,-1,-1), (2,2,2))
    heatmap!(ax, x .+ cxyz[1], z .+ cxyz[3], leftF, transformation=(:xz, -a2 + cxyz[2]),
        colormap = cmap, transparency = transparent, colorrange = (lowLimit, highLimit)) # left
    heatmap!(ax, x .+ cxyz[1], y .+ cxyz[2], bottomF, transformation=(:xy, -a2 + cxyz[3]),
        colormap = cmap, transparency = transparent, colorrange = (lowLimit, highLimit)) # bottom
    heatmap!(ax, y .+ cxyz[2], z .+ cxyz[3], frontF, transformation=(:yz,  a2 + cxyz[1]),
        colormap = cmap, transparency = transparent, colorrange = (lowLimit, highLimit)) # front
    heatmap!(ax, x .+ cxyz[1], z .+ cxyz[3], rightF, transformation=(:xz,  a2 + cxyz[2]),
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
        cmap = :Spectral_11, transparent = false, limits = Rect(Vec3f0(-1), Vec3f0(2)),
        topF    = randn(timeLonLat[1], timeLonLat[2]),
        bottomF = randn(timeLonLat[1], timeLonLat[2]),
        frontF  = randn(timeLonLat[2], timeLonLat[3]),
        backF   = randn(timeLonLat[2], timeLonLat[3]),
        leftF   = randn(timeLonLat[1], timeLonLat[3]),
        rightF  =  randn(timeLonLat[1], timeLonLat[3]),
        lonrange= (-20,10), latrange = (-25,15),
        timeStamps = ["Jan", "Feb", "Mar", "Apr", "May"], label = "label")

    fig = Figure(resolution = (650, 500))

    ax = LScene(fig, scenekw = (camera = cam3d!, show_axis = true))

    cbox = cube!(ax; a1 = a1, a2 = a2, timeLonLat = timeLonLat, cxyz = cxyz,
        limits = limits, cmap = cmap, transparent = transparent,
        topF = topF, bottomF=bottomF, frontF=frontF, backF =backF,
        leftF= leftF, rightF=rightF )

    cbar  = Colorbar(fig, cbox,  label = label,
        width = 11, height = Relative(2/4), tickalign = 1, ticklabelsize = 12, labelsize = 12,)

    dlon = (lonrange[2] - lonrange[1])
    dlat = (latrange[2] - latrange[1])
    δdlon = round(dlon/4, digits = 2)
    δdlat = round(dlat/4, digits = 2)

    yticks!(ax.scene; ytickrange = -1:0.5:1,
            yticklabels=["$(lonrange[1] + 0.0)", "$(lonrange[1] + δdlon)",
                "$(lonrange[1] + 2*δdlon) ", "$(lonrange[1] + 3*δdlon)", "$(lonrange[2] + 0.0)"])
    zticks!(ax.scene; ztickrange = -1:0.5:1,
            zticklabels=["$(latrange[1] + 0.0)", "$(latrange[1] + δdlat)",
                "$(latrange[1] + 2*δdlat) ", "$(latrange[1] + 3*δdlat)", "$(latrange[2] + 0.0)"])

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

"""
plotSlides(dataSlides, lonrange, latrange; a1 = 1, a2 = 0, cxyz = (0,0,0), cmap = :Spectral_11,
        figsize = (840,800), transparency = true, rmvalue = -9999, iswater = (true, (:dodgerblue, 0.35), -1, 0),
        cbar = false, leg = "legend", inidate = " ", findate = " ")
"""
function plotSlides(dataSlides, lonrange, latrange; a1 = 1, a2 = 0, cxyz = (0,0,0), cmap = :Spectral_11,
        figsize = (840,800), transparency = true, rmvalue = -9999, iswater = (true, (:dodgerblue, 0.35), -1, 0),
        cbar = false, leg = "legend", inidate = " ", findate = " ")
    nxyz = size(dataSlides)
    allSlides = replace(dataSlides, rmvalue => NaN)
    highLimit = maximum(maximum.(x->isnan(x) ? -Inf : x, allSlides))
    lowLimit =  minimum(minimum.(x->isnan(x) ?  Inf : x, allSlides))
    clims = (lowLimit, highLimit)

    y = LinRange(-a1, a1, nxyz[1])
    z = LinRange(-a1, a1, nxyz[2])
    fig = Figure(resolution = figsize)
    #ax = Axis3(fig, aspect = :data, viewmode= viewmode,perspectiveness = 0.5, title = title)
    ax = LScene(fig, scenekw = (camera = cam3d!, show_axis = true))
    scatter!(ax, [Point3f0(0), Point3f0(1)], markersize = 0, limits =  Rect(Vec3f0(-1.1), Vec3f0(2))) # due to ticks issue !
    for (indx,i) in enumerate(LinRange(a1, -a1, nxyz[3]))
        pltobj = heatmap!(ax, y .+ cxyz[2], z .+ cxyz[3], allSlides[:,:,indx],
            #limits =  Rect(Vec3f0(-1), Vec3f0(2)), # put them in terms of a1 and  cxyz
            transformation=(:yz, -a2 - i + cxyz[1]), colormap = cmap, transparency = transparency,
            colorrange = clims)
        if iswater[1] == true
            heatmap!(ax, y .+ cxyz[2], z .+ cxyz[3], dataSlides[:,:,indx],
                transformation=(:yz, -a2 - i + cxyz[1]), colorrange = (iswater[3],iswater[4]),
                lowclip = iswater[2], highclip = :transparent, transparency = transparency,)
        end
    end
    axis = ax.scene[OldAxis]
    axis[:ticks][:textcolor] = (:transparent, :black, :black)
    axis[:names][:axisnames] = ("", "lon", "lat")
    axis[:names][:rotation] = (qrotation(Vec3(0,0,1), π),
                              qrotation(Vec3(0,0,1), π/2),
                              qrotation(Vec3(0,0,1), -π/2) * qrotation(Vec3(0,1,0), -π/2))
    axis[:names][:align] = ((:center, :right), (:center, :right), (:center, :left))

    dlon = (lonrange[2] - lonrange[1])
    dlat = (latrange[2] - latrange[1])
    δdlon = round(dlon/4, digits = 2)
    δdlat = round(dlat/4, digits = 2)

    yticks!(ax.scene; ytickrange = -1:0.5:1,
        yticklabels=["$(lonrange[1] + 0.0)", "$(lonrange[1] + δdlon)",
            "$(lonrange[1] + 2*δdlon) ", "$(lonrange[1] + 3*δdlon)", "$(lonrange[2] + 0.0)"])
    zticks!(ax.scene; ztickrange = -1:0.5:1,
        zticklabels=["$(latrange[1] + 0.0)", "$(latrange[1] + δdlat)",
            "$(latrange[1] + 2*δdlat) ", "$(latrange[1] + 3*δdlat)", "$(latrange[2] + 0.0)"])


    #ax.limits[] = Rect(Vec3f0(-1), Vec3f0(2))
    text!(inidate, position = Point3f0(-1, -1, 1.2),
    color = :black,
    #rotation = 2π +π/10,
    align = (:center, :center),
    textsize = 20,
    #space = :data
    )
    text!(findate, position = Point3f0(1, -1, 1.2),
    color = :red,
    #rotation = 2π +π/10,
    align = (:center, :center),
    textsize = 20,
    #space = :data
    )

    fig[1,1] = ax
    #fig[0,1] = Label(fig, title, textsize = 20, color = (:black, 0.85))
    if cbar == true
        cbar = Colorbar(fig, limits = clims, nsteps = 100, colormap = cmap,
        label = leg, width = 11, height = Relative(2/4), tickalign = 1)
        fig[1,2] = cbar
    end
    fig
end

"""
recordSlides(dataSlides, tstamps, lonrange, latrange; filename = "temp.mp4", framerate = 24,
        a1 = 1, a2 = 0, cxyz = (0,0,0), cmap = :Spectral_11, figsize = (900,900), transparency = true,
        iswater = (true, (:dodgerblue, 0.35), -1, 0), cbar = false, leg = "legend")
"""
function recordSlides(dataSlides, tstamps, lonrange, latrange; filename = "temp.mp4", framerate = 24,
        a1 = 1, a2 = 0, cxyz = (0,0,0), cmap = :Spectral_11, figsize = (900,900), transparency = true,
        iswater = (true, (:dodgerblue, 0.35), -1, 0), cbar = false, leg = "legend")
    inidate = "$(Date(tstamps[1]))"
    #findate = Node(" ")
    nxyz = size(dataSlides)
    allSlides = replace(dataSlides, -9999 => NaN)
    highLimit = maximum(maximum.(x->isnan(x) ? -Inf : x, allSlides))
    lowLimit =  minimum(minimum.(x->isnan(x) ?  Inf : x, allSlides))
    clims = (lowLimit, highLimit)

    y = LinRange(-a1, a1, nxyz[1])
    z = LinRange(-a1, a1, nxyz[2])
    fig = Figure(resolution = figsize)
    #ax = Axis3(fig, aspect = :data, title = "hola")
    ax = LScene(fig, scenekw = (camera = cam3d!, show_axis = true))
    scatter!(ax, [Point3f0(0), Point3f0(1)], markersize = 0, limits =  Rect(Vec3f0(-1.1), Vec3f0(2))) # due to ticks issue !
    axis = ax.scene[OldAxis]
    axis[:ticks][:textcolor] = (:transparent, :black, :black)
    axis[:names][:axisnames] = ("", "lon", "lat")
    axis[:names][:rotation] = (qrotation(Vec3(0,0,1), π),
                              qrotation(Vec3(0,0,1), π/2),
                              qrotation(Vec3(0,0,1), -π/2) * qrotation(Vec3(0,1,0), -π/2))
    axis[:names][:align] = ((:center, :right), (:center, :right), (:center, :left))

    dlon = (lonrange[2] - lonrange[1])
    dlat = (latrange[2] - latrange[1])
    δdlon = round(dlon/4, digits = 2)
    δdlat = round(dlat/4, digits = 2)

    yticks!(ax.scene; ytickrange = -1:0.5:1,
        yticklabels=["$(lonrange[1] + 0.0)", "$(lonrange[1] + δdlon)",
            "$(lonrange[1] + 2*δdlon) ", "$(lonrange[1] + 3*δdlon)", "$(lonrange[2] + 0.0)"])
    zticks!(ax.scene; ztickrange = -1:0.5:1,
        zticklabels=["$(latrange[1] + 0.0)", "$(latrange[1] + δdlat)",
            "$(latrange[1] + 2*δdlat) ", "$(latrange[1] + 3*δdlat)", "$(latrange[2] + 0.0)"])


    if cbar == true
        cbar = Colorbar(fig, limits = clims, nsteps = 100, colormap = cmap,
        label = leg, width = 11, height = Relative(2/4), tickalign = 1)
        fig[1,2] = cbar
    end
    text!(inidate, position = Point3f0(-1, -1, 1.2),
    color = :black,
    #rotation = 2π +π/10,
    align = (:center, :center),
    textsize = 20,
    #space = :data
    )
    #Label(fig[1, 1, Bottom()], findate, color = :red, padding = (5, 0, 0, 0))
    #Label(fig[1, 1, Right()], inidate, rotation = pi/2, padding = (0, 0, 0, 0))
    record(fig, filename, framerate=framerate) do io
        for (indx,i) in enumerate(LinRange(a1, -a1, nxyz[3]))
            heatmap!(ax, y .+ cxyz[2], z .+ cxyz[3], allSlides[:,:,indx],
                #limits =  Rect(Vec3f0(-1), Vec3f0(2)), # put them in terms of a1 and  cxyz
                transformation=(:yz, -a2 - i + cxyz[1]), colormap = cmap, transparency = transparency,
                colorrange = clims)
            if iswater[1] == true
                heatmap!(ax, y .+ cxyz[2], z .+ cxyz[3], dataSlides[:,:,indx],
                    transformation=(:yz, -a2 - i + cxyz[1]), colorrange = (iswater[3],iswater[4]),
                    lowclip = iswater[2], highclip = :transparent, transparency = transparency,)
            end

            txtobj = text!("$(Date(tstamps[indx]))", position = Point3f0(1, -1, 1.2), # Point3f0(-a2 - i, -1, 1.2),
                color = :red,
                #rotation = 2π +π/10,
                align = (:center, :center),
                textsize = 20,
                #space = :data
                )
            fig[1,1] = ax
            #findate[] = "$(Date(tstamps[indx]))"
            #fig[0,1] = Label(fig, "$(Date(tstamps[indx]))", textsize = 20, color = (:white, 0.85))
            recordframe!(io)
            if indx < nxyz[3]
                delete!(ax, txtobj) # horrible hack !
            end
        end
        #ax.limits[] = Rect(Vec3f0(-1), Vec3f0(2))
    end
end
