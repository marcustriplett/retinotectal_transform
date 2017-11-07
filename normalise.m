function vec = normalise(vec)
mn = min(vec); mx = max(vec);
vec = (vec - mn)/(mx - mn);
end