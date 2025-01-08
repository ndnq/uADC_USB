function phase_diff = compute_phase_delay(ffts, ref_index)
    % COMPUTE_PHASE_DELAY Computes the phase delay of each FFT relative to a specific FFT
    %
    % phase_delays = COMPUTE_PHASE_DELAY(ffts, ref_index)
    %
    % Inputs:
    %   ffts       - Array of FFTs (each row is an FFT)
    %   ref_index  - Index of the reference FFT (1-based index)
    %
    % Outputs:
    %   phase_delays - Array of phase delays (each row is the phase delay for corresponding FFT)
    
    % Get the reference FFT
    ffts(abs(ffts) < 1e-14) = 0;
    
    % Number of FFTs
    num_ffts = size(ffts, 1);
    len_ffts = size(ffts, 2);
    phase_diff = angle(ffts) - angle(ffts(ref_index, :));
    phase_diff = phase_diff(:,1:len_ffts/2-1);
    [somthing indices]= max(abs(phase_diff'));
    outdices=(1:1:num_ffts);
    phase_diff = phase_diff(sub2ind(size(phase_diff), outdices,indices ))%KYS
    
    
end