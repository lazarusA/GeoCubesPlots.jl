"""
plot(dataset; args...)

dataset is a Cube from YAXArrays

variable :: the variable to plot

x        :: horizontal axis values, i.e. longitude

y        :: vertical axis values, i.e. latitude

reversey  :: if the data is reverse in the y direction

cmap     :: colormap

rmvalue  :: remove an specific value
utime    :: your time selection, format: Date("xxxx-xx-xx")

Returns :

fig, ax, pltobj = plot(...)

"""
function plot(dataset::YAXArray; x = :lon, y = :lat, variable = nothing, legcbar=" ",
    cmap = :plasma, figsize = (1240,650), utime = nothing, rmvalue =nothing, reversey = true)

    #steplonticks = nothing, steplatticks = nothing

    lon = collect(getAxis(string(x), dataset).values)
    lat = collect(getAxis(string(y), dataset).values)

    timestamp = getAxis("time", dataset)
    # drop menu with all variable symbols and timestamps if available. [Use Nodes and Menu functions]
    if timestamp == nothing
        data = variable == nothing ? dataset.data[:,:] : dataset[var = string(variable)].data[:,:]
        label = variable == nothing ? legcbar : string(variable)
    else
        timerange = getAxis("time", dataset).values
        if variable != nothing
            if utime != nothing
                data = dataset[var = string(variable), time = utime].data[:,:]
                label = string(variable) * "  $(utime)"
            else
                data = dataset[var = string(variable), time = Date(timerange[1])].data[:,:] # add keyword for user selection of time
                label = string(variable) * "  $(Date(timerange[1]))"
            end
        else
            if utime != nothing
                data = dataset[time = utime].data[:,:]
                label = legcbar * "  $(utime)"
            else
                data = dataset[time = Date(timerange[1])].data[:,:] # add keyword for user selection of time
                label = legcbar * "  $(Date(timerange[1]))"
            end
        end
    end

    minlon  = round(minimum(lon), RoundDown)
    maxlon  = round(maximum(lon), RoundDown)
    #steplon = (maxlon - minlon)/6
    #steplon = steplonticks == nothing ? steplon : steplonticks

    minlat  = round(minimum(lat), RoundDown)
    maxlat  = round(maximum(lat), RoundDown)
    #steplat = (maxlat - minlat)/6
    #steplat = steplatticks == nothing ? steplat : steplatticks

    data =  replace(data, missing=>NaN)
    if rmvalue != nothing
        data = rmvalue in data ? replace(data, rmvalue=>NaN) : data
    end
    data = reversey == true ? data[:,end:-1:1] : data

    fig = Figure(resolution = figsize, fontsize = 20)
    ax = Axis(fig, xlabel = string(x), ylabel = string(y),
        xtickalign = 1, ytickalign = 1, spinewidth = 0.75)

    pltobj = heatmap!(ax, lon, lat, data, colormap = cmap)
    cbar = Colorbar(fig, pltobj, label = label, width = 11, ticklabelsize =20,
        tickalign = 1, spinewidth =0.5)
    limits!(ax, minlon, maxlon, minlat, maxlat)
    hidespines!(ax, :t, :r)
    #ax.xticks = minlon:steplon:maxlon
    #ax.yticks = minlat:steplat:maxlat
    ax.xtickformat = "{:d}ᵒ"
    ax.ytickformat = "{:d}ᵒ"
    fig[1,1] = ax
    fig[1,2] = cbar
    fig, ax, pltobj #, cbar
end
