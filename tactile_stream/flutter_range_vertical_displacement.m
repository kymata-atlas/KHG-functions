function [flutter_range_vertical_displacement_value] = flutter_range_vertical_displacement(xhistory, x)

    % This function is a niave implementation of the flutter range vertical
    % displacement function.
    
    % -------
    % Authors: Thwaites (2016)
    % Kymata Hypothesis group

    % Input stream: The momentary vertical displacement (mm) on a region of
    % the skin ('x') and the previous n inputs in the array xhisory.

    % Note: this is a naive model. Future implementations may also add in 
    % potential desensitisation of the mechanoreceptors, hyperpolarisation
    % of the afferents and other known physiological characteristics of the
    % afferent pairs, as well as wieghting for non-gaborious skin (Mountcastle, 1967;
    % Kruger and Kenton, 1973).
    
    % -----
    % Main Parameters
    
    % Meissner’s corpuscles are most sensitive between 10 and 70 Hz, while
    % Merkel cells are most sensitive between 5 to 15 Hz, although the
    % frequency selectivity for all mechanoreceptors overlap (Iggo, 1985).
    % Here, we set the cutt-off as 70 Hz.
    
    merkelandMeissnercuttoff = 70; % Hz, Passband (Cutoff) Frequency
    

    % Model only merkel and Meissner information getting through.
    
    Fs  = 1000;                                    % Sampling Frequency (Hz)
    Fn  = Fs/2;                                    % Nyquist Frequency
    Fco = merkelandMeissnercuttoff;                % Passband (Cutoff) Frequency
    Fnorm = Fco/Fn;                                 % Normalized frequency
    df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);
    y = filter(df,concat(x, xhistory));
        
    flutter_range_vertical_displacement_value = y(end);
    
   
end



