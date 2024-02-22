function [value,stop,dir] = spike_event( t, y )


if( isnan(y(1)) || y(1) > -40) 
    value = 0;
else
    value = y(1)-2.5;
end
stop = 1;
dir = 0;
end

