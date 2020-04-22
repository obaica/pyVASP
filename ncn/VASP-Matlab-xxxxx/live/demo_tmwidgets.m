function demo_tmwidgets
%% DEMO_TMWIDGETS   Demonstration of the TM Widgets with Analog Input

% Copyright 2004 The MathWorks, Inc

%% Initialize scopes
% Initialize the scopes by creating an axes for each scope and calling the
% initialization routines to configure the scopes.
Fs = 44100;                     % Sample rate       
Nfft = 1024;                    % FFT Length
ax1 = subplot(411);             % Strip chart
ax2 = subplot(4,2,[3 5 7]);     % Spectrumscope
ax3 = subplot(4,2,[4 6 8]);     % Specgramscope
stripchart(ax1,Fs,1);ylim(ax1,[-.01 .01])
spectrumscope(ax2,Fs,Nfft);
specgramscope(ax3,Fs,Nfft);

%% Initialize Hardware
% Initialize the sound card for a single channel of continuous acquisition.
% Use a very fast timer to have the display run as fast as possible.
% Program TimerFcn to send current data to scopes.  Program the figure's
% CloseRequestFcn to stop and destroy the analoginput object.  These two
% functions are included as nested functions inside the main function.
% This gives them visibility into all data from the main function,
% including axes handles.
ai = analoginput('winsound');
addchannel(ai,1);
set(ai,'SampleRate',Fs)
set(ai,'TimerPeriod',.01);
set(ai,'TriggerRepeat',inf)
set(ai,'TimerFcn',@aicallback);
set(gcf,'CloseRequestFcn',@figclosefcn);

%% Start Hardware
start(ai)

    % AICALLBACK (Nested Function)
    % Execute upon Timer event.  Update scopes with current data.
    function aicallback(ai,event)
        if get(ai,'SamplesAvailable') < get(ai,'SamplesPerTrigger'), return, end;
        d=peekdata(ai,ai.SamplesPerTrigger);
        stripchart(ax1,d);
        spectrumscope(ax2,d);
        specgramscope(ax3,d)
    end % END AICALLBACK

    % FIGCLOSEFCN (Nested Function)
    % Execute upon closing figure.  Stop and delete AI objects.
    function figclosefcn(obj,event)
        try
            stop(ai);
            delete(ai);
        end
        closereq
    end % END FIGCLOSEFCN

end % END DEMO_TMWIDGETS (Main function)