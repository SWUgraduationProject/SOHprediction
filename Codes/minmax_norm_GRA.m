function [Output] = minmax_norm_GRA (charInput)
ym = min(charInput);
yr = max(charInput) - min(charInput);
Output = (charInput - ym)/yr;