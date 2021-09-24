function charInput = extract_feature(B)
for i = 1:length(B.cycle)
   F1 = B.cycle(i).data.TimeSum;
   F2 = B.cycle(i).data.TimeRatio;
   F3 = B.cycle(i).data.ChargeTemp;
   F4 = B.cycle(i).data.DischargeTemp;
   charInput(i,:) = [F1,F2,F3,F4];
   %charInput(i,:) = [F2,F4];
end
charInput(~any(charInput, 2), :) = [];
