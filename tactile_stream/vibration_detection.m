function [vibration_detection_value] = vibration_detection(x)

    % This function is a niave implementation of the flutter range
    % vibration detection function.
    
    % -------
    % Authors: Thwaites (2016)
    % Kymata Hypothisis group

    % Input stream: The momentary vertical displacement (mm) on a region of
    % the skin ('spot') ('x').

    % Note: this is a naive model. Future implementations may also add in 
    % potential desensitisation of the mechanoreceptors, hyperpolarisation
    % of the afferents and other known physiological characteristics of the
    % afferent pairs, as well as wieghting for non-gaborious skin (Mountcastle, 1967;
    % Kruger and Kenton, 1973).
    
    % -----
    % Main Parameters
    
    % Pacinian-corpuscles/rapidly-adapting-type-II afferents are the
    % mechanoreceptive afferent pairs that generate nerve signals on
    % application of skin displacement oscillations between 40 and 400 Hz,
    % with a best frequency of about 250 Hz (Iggo, 1985). 

    % Here, we set the cutt-off as 100 Hz.
    paciniancuttoff = 100;  % Hz, Passband (Cutoff) Frequency

    % Model only Pacinian information getting through.
        
    Fs  = 1000;                                     % Sampling Frequency (Hz)
    Fn  = Fs/2;                                     % Nyquist Frequency
    Fco = paciniancuttoff;                          % Passband (Cutoff) Frequency
    Fnorm = Fco/Fn;                                 % Normalized frequency
    df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);
   
    grpdelay(df,2048,Fs);   % plot group delay
    D = mean(grpdelay(df)); % filter delay in samples
    
    y = filter(df,[x; zeros(D,1)]); % Append D zeros to the input data
    y = y(D+1:end);                  % Shift data to compensate for delay
    
    % Run a fast fourier transform to work out if there is any high
    % oscillations left inside this window. Return out the maximum power
    % for any freqency.
    
    vibration_detection_value = max(fft(y));
      
end
