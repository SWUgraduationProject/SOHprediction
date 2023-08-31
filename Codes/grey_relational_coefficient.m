% Step 2 (Grey relational coefficient)
function [Output0, Output1, Output2, Output3, Output4] = grey_relational_coefficient (Input0, Input1, Input2, Input3, Input4, SOH)
coefficientValue = 0.5;

deltaF0 = abs(SOH - Input0);
deltaF1 = abs(SOH - Input1);
deltaF2 = abs(SOH - Input2);
deltaF3 = abs(SOH - Input3);
deltaF4 = abs(SOH - Input4);

devMin=[min(deltaF0),min(deltaF1),min(deltaF2),min(deltaF3),min(deltaF4)];
devMax=[max(deltaF0),max(deltaF1),max(deltaF2),max(deltaF3),max(deltaF4)];

deltaMin = min(devMin);
deltaMax = max(devMax);

ym = deltaMax * coefficientValue;
yr = deltaMin + ym;

Output0 = bsxfun(@rdivide,yr,bsxfun(@plus, deltaF0, ym));
Output1 = bsxfun(@rdivide,yr,bsxfun(@plus, deltaF1, ym));
Output2 = bsxfun(@rdivide,yr,bsxfun(@plus, deltaF2, ym));
Output3 = bsxfun(@rdivide,yr,bsxfun(@plus, deltaF3, ym));
Output4 = bsxfun(@rdivide,yr,bsxfun(@plus, deltaF4, ym));







