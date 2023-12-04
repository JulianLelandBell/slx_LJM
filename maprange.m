function [outVal] = maprange(inVal,in_Min,in_Max,out_Min,out_Max)
%MAPRANGE Matlab implementation of simple Arduino maprange function
%   Source: https://www.arduino.cc/reference/en/language/functions/math/map/
outVal = (inVal - in_Min) * (out_Max - out_Min)/(in_Max - in_Min) + out_Min;
end