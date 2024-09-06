
function solve_mode(dab,Δts)
    L = get_prop(dab, :L)
    N = get_prop(dab, :N)
    V₁ = get_prop(dab, :V₁)
    V₂ = get_prop(dab, :V₂)
    Tsw = get_prop(dab, :Tsw)
    
    for (e,Δt) in zip(edges(dab),Δts)
        set_prop!(dab,e,:Δt,Δt)
    end
    
    for e in edges(dab)
        SA, SB, SC, SD = get_prop(dab, e, :sw_state)
        Δt = get_prop(dab, e, :Δt)
        VAB = SA*V₁ - SB*V₁
        VCD = N*SC*V₂ - N*SD*V₂
        VL = VAB - VCD
        Δi = VL/L*Δt*Tsw
        set_prop!(dab,e,:Δi,Δi)
    end
    
    iL′ = circshift(cumsum([get_prop(dab,e,:Δi) for e in edges(dab)]),1)
    
    for (v,iL) in zip(vertices(dab),iL′)
        set_prop!(dab, v, :iL, iL)
    end
    
    i_avg′ = 0
    for e in edges(dab)
        i₁ = get_prop(dab, src(e), :iL)
        i₂ = get_prop(dab, dst(e), :iL)
        Δt = get_prop(dab, e, :Δt)
        i_avg′ += (i₁ + i₂)/2*Δt
    end
    
    for v in vertices(dab)
        iL = get_prop(dab, v, :iL)
        set_prop!(dab, v, :iL, iL - i_avg′)
    end

    i_rms = 0
    for e in edges(dab)
        i₁ = get_prop(dab, src(e), :iL)
        i₂ = get_prop(dab, dst(e), :iL)
        Δt = get_prop(dab, e, :Δt)
        i_rms += (i₁^2 + i₁*i₂ + i₂^2)/3*Δt
    end
    #i_rms = √clamp(sum(i_rms), 0, Inf) # sqrt would sometimes report negative input
    
    P = 0
    for e in edges(dab)
        SA, SB, _, _ = get_prop(dab, e, :sw_state)
        i₁ = get_prop(dab, src(e), :iL)
        i₂ = get_prop(dab, dst(e), :iL)
        Δt = get_prop(dab, e, :Δt)
        VAB = SA*V₁ - SB*V₁
        P += VAB*(i₁ + i₂)/2*Δt
    end

    vtA, vtB, vtC, vtD = 0, 0, 0, 0
    for e in edges(dab)
        SA, SB, SC, SD = get_prop(dab,e,:sw_state)
        Δt = get_prop(dab, e, :Δt)
        vtA += 1SA * V₁ * Δt
        vtB += 1SB * V₁ * Δt
        vtC += 1SC * V₂ * Δt
        vtD += 1SD * V₂ * Δt
    end

    ts = [0;cumsum([get_prop(dab,e,:Δt) for e in edges(dab)])]
    ils = [get_prop(dab,v,:iL) for v in vertices(dab)]
    ils = [ils; ils[1]]

    return P, i_rms, (ts, ils), (vtA, vtB, vtC, vtD)
end
