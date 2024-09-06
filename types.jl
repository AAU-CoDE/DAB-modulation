
abstract type HalfBridge end
struct A <: HalfBridge end
struct B <: HalfBridge end
struct C <: HalfBridge end
struct D <: HalfBridge end

abstract type HBState{T<:HalfBridge} end
struct Hi{T} <: HBState{T} end
struct Lo{T} <: HBState{T} end
struct Unknown{T} <: HBState{T} end

abstract type SwitchingEvent{T<:HalfBridge} end
struct SwitchHi{T} <: SwitchingEvent{T} end
struct SwitchLo{T} <: SwitchingEvent{T} end

switch(::HBState{T},::SwitchHi{T}) where T <: HalfBridge = Hi{T}()
switch(::HBState{T},::SwitchLo{T}) where T <: HalfBridge = Lo{T}()
switch(s::HBState{T},x) where T <: HalfBridge = s

Base.convert(::Type{N}, ::Hi{T}) where {T <: HalfBridge, N <: Number} = one(N)
Base.convert(::Type{N}, ::Lo{T}) where {T <: HalfBridge, N <: Number} = zero(N)
Base.convert(::Type{N}, ::Unknown{T}) where {T <: HalfBridge, N <: Number} = missing
Base.promote_rule(::Type{N}, ::Type{T}) where {T <: HBState, N <: Number} = N
import Base.*
*(a::T, b::N) where {T <: HBState, N <: Number} = *(promote(a, b)...)
*(a::N, b::T) where {T <: HBState, N <: Number} = *(promote(b, a)...)
