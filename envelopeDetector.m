function [envelope] = envelopeDetector(modulatedSignal)
%envelopeDetector Summary of this function goes here
%   This function detects the envelope of a signal
envelope = abs(hilbert(modulatedSignal));
end

