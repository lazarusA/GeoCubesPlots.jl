"""
getTimeSlides(datCubes::YAXArray, lon = lonRange, lat = latRange,
    time = timeRange; variable = nothing, reversey = true)

time :: (Date("xxxx-xx-xx"),) or (Date("xxxx-xx-xx"), Date("xxxx-xx-xx"))
"""
function getTimeSlides(datCubes::YAXArray, lon = lonRange, lat = latRange,
    time = timeRange; variable = nothing, reversey = true)
    if length(time) == 1
        time = (time[1], time[1])
    end
    if variable != nothing
        timeSlides = datCubes[var = variable, lon = lonRange, lat=latRange, time = time].data
    else
        timeSlides = datCubes[lon = lonRange, lat=latRange, time = time].data
    end
    if reversey == true
        return replace(timeSlides[:,end:-1:1,:], missing => NaN)
    else
        return replace(timeSlides[:,:,:], missing => NaN)
    end
end


"""
getCubeFaces(datCubes::YAXArray, timeRange, lonRange, latRange;
    variable = nothing, reversey = true)
variable :: string
"""
function getCubeFaces(datCubes::YAXArray, timeRange, lonRange, latRange;
    variable = nothing, reversey = true)
    if variable != nothing
        #front face
        cubef = datCubes[
            var  = variable,
            time = timeRange[1],
            lon  = lonRange,
            lat  = latRange].data[:,:]
        #back face
        cubeb = datCubes[
            var  = variable,
            time = timeRange[2],
            lon  = lonRange,
            lat  = latRange].data[:,:];
        #rigth face
        cuber = datCubes[
            var  = variable,
            time = timeRange,
            lon  = lonRange[2],
            lat  = latRange].data[:,:];
        #left face
        cubel = datCubes[
            var   = variable,
            time  = timeRange,
            lon   = lonRange[1],
            lat   = latRange].data[:,:];
        #top face
        cubet = datCubes[
            var  = variable,
            time = timeRange,
            lon  = lonRange,
            lat  = latRange[2]].data[:,:];
        #bottom face
        cubebt = datCubes[
            var  = variable,
            time = timeRange,
            lon  = lonRange,
            lat  = latRange[1]].data[:,:]
        else
            #front face
            cubef = datCubes[
                time = timeRange[1],
                lon  = lonRange,
                lat  = latRange].data[:,:]
            #back face
            cubeb = datCubes[
                time = timeRange[2],
                lon  = lonRange,
                lat  = latRange].data[:,:];
            #rigth face
            cuber = datCubes[
                time = timeRange,
                lon  = lonRange[2],
                lat  = latRange].data[:,:];
            #left face
            cubel = datCubes[
                time  = timeRange,
                lon   = lonRange[1],
                lat   = latRange].data[:,:];
            #top face
            cubet = datCubes[
                time = timeRange,
                lon  = lonRange,
                lat  = latRange[2]].data[:,:];
            #bottom face
            cubebt = datCubes[
                time = timeRange,
                lon  = lonRange,
                lat  = latRange[1]].data[:,:]
        end

        if reversey == true
            cubef  = replace(cubef[:,end:-1:1], missing => NaN)
            cubeb  = replace(cubeb[:,end:-1:1], missing => NaN)
            cubet  = replace(cubet', missing => NaN)
            cubebt = replace(cubebt', missing => NaN)
            cubel  = replace(cubel'[:,end:-1:1], missing => NaN)
            cuber = replace(cuber'[:,end:-1:1], missing => NaN) #
        else # still not sure about the generality for this one.
            cubef  = replace(cubef, missing => NaN)
            cubeb  = replace(cubeb, missing => NaN)
            cubet  = replace(cubet', missing => NaN)
            cubebt = replace(cubebt', missing => NaN)
            cubel  = replace(cubel', missing => NaN)
            cuber = replace(cuber', missing => NaN) #
        end

    return cubef, cubeb, cuber, cubel, cubet, cubebt
end
