
function dab_mode(params, switch_events)
    dab = MetaDiGraph(cycle_digraph(8))

    set_props!(dab, Dict(
        :L => params.L, 
        :N => params.N, 
        :V₁ => params.V₁, 
        :V₂ => params.V₂, 
        :Tsw => params.Tsw))

    for e in edges(dab)
        set_prop!(dab,e,:sw_state,[Unknown{A}(),Unknown{B}(),Unknown{C}(),Unknown{D}()])
    end
    
    for (v,ev) in zip(vertices(dab),switch_events)
        set_prop!(dab, v, :sw_event, ev)
    end
    
    for (vₙ₋₁,vₙ,vₙ₊₁) in partition((non_backtracking_randomwalk(dab, 1, 2nv(dab))),3,1)
        prev_state = get_prop(dab, vₙ₋₁, vₙ, :sw_state)
        sw_event = get_prop(dab, vₙ, :sw_event)
        next_state = Vector{HBState}(map(s->switch(s,sw_event),prev_state))
        set_prop!(dab, vₙ, vₙ₊₁, :sw_state, next_state)
    end

    conA, conB, conC, conD = Int[], Int[], Int[], Int[]
    for e in edges(dab)
        SA, SB, SC, SD = get_prop(dab,e,:sw_state)
        1SA == 1 && push!(conA,src(e))
        1SB == 1 && push!(conB,src(e))
        1SC == 1 && push!(conC,src(e))
        1SD == 1 && push!(conD,src(e))
    end
    
    return dab, (A=conA, B=conB, C=conC, D=conD)
end

using Combinatorics

circular_permutations(a) = ((a[1],as...) for as in permutations(a[1+1:end]))

events = (
    SwitchHi{A}(), 
    SwitchHi{B}(), 
    SwitchHi{C}(), 
    SwitchHi{D}(), 
    SwitchLo{A}(), 
    SwitchLo{B}(),
    SwitchLo{C}(), 
    SwitchLo{D}(),
    )

modes = circular_permutations(events)

mode_A = (
    SwitchHi{A}(), 
    SwitchLo{D}(), 
    SwitchHi{C}(), 
    SwitchLo{A}(), 
    SwitchLo{C}(), 
    SwitchHi{B}(), 
    SwitchHi{D}(), 
    SwitchLo{B}()
    )