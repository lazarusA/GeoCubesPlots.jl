function toCartesian(lon, lat; r = 1, cxyz = (0,0,0) )
    lat, lon = lat*π/180, lon*π/180
    cxyz[1] + r * cos(lat) * cos(lon), cxyz[2] + r * cos(lat) * sin(lon), cxyz[3] + r *sin(lat)
end
function lonlat3D(lon, lat, data; cxyz = (0,0,0))
    xyzw = zeros(size(data)..., 3)
    for (i,lon) in enumerate(lon), (j,lat) in enumerate(lat)
        x, y, z = toCartesian(lon, lat; cxyz = cxyz)
        xyzw[i,j,1] = x
        xyzw[i,j,2] = y
        xyzw[i,j,3] = z
    end
    xyzw[:,:,1], xyzw[:,:,2], xyzw[:,:,3]
end

function SphereBall(; r = 0.995, cxyz = (0,0,0))
    Θ = LinRange(0, 2π, 500) # 50
    Φ = LinRange(0, π, 500)
    x0 = [cxyz[1] + r * cos(θ) * sin(ϕ)      for θ in Θ, ϕ in Φ]
    y0 = [cxyz[2] + r * sin(θ) * sin(ϕ)      for θ in Θ, ϕ in Φ]
    z0 = [cxyz[3] + r * cos(ϕ) for θ in Θ, ϕ in Φ]
    x0, y0, z0
end
