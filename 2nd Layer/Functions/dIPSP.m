function DeltaWipsp = dIPSP(Iter,MvngWndwCa2pSpkFq,CntFq)
% Slope fn. for determinig the delta weight of IPSP, based on the frequency
% of calcium spiking
% Selecting the Slope fn. based on the BreakPoint Frequency

if Iter.Fq(CntFq) == 20
    if  MvngWndwCa2pSpkFq > 20
        DeltaWipsp = SlopeDeltaWipsp20p(MvngWndwCa2pSpkFq);
    end
    if  MvngWndwCa2pSpkFq <= 20
        DeltaWipsp = SlopeDeltaWipsp20n(MvngWndwCa2pSpkFq);
    end
end

if Iter.Fq(CntFq) == 40
    if  MvngWndwCa2pSpkFq > 40
        DeltaWipsp = SlopeDeltaWipsp40p(MvngWndwCa2pSpkFq);
    end
    if  MvngWndwCa2pSpkFq <= 40
        DeltaWipsp = SlopeDeltaWipsp40n(MvngWndwCa2pSpkFq);
    end
end

if Iter.Fq(CntFq) == 60
    if  MvngWndwCa2pSpkFq > 60
        DeltaWipsp = SlopeDeltaWipsp60p(MvngWndwCa2pSpkFq);
    end
    if  MvngWndwCa2pSpkFq <= 60
        DeltaWipsp = SlopeDeltaWipsp60n(MvngWndwCa2pSpkFq);
    end
end

if Iter.Fq(CntFq) == 80
    if  MvngWndwCa2pSpkFq > 80
        DeltaWipsp = SlopeDeltaWipsp80p(MvngWndwCa2pSpkFq);
    end
    if  MvngWndwCa2pSpkFq <= 80
        DeltaWipsp = SlopeDeltaWipsp80n(MvngWndwCa2pSpkFq);
    end
end

if Iter.Fq(CntFq) == 100
    DeltaWipsp = SlopeDeltaWipsp100(MvngWndwCa2pSpkFq);
end

end

%% Slope Fq. 20

function y = SlopeDeltaWipsp20p(x)

m = tan(3.179*pi/180);
y = (m*(x-20))/1000;

end

function y = SlopeDeltaWipsp20n(x)

m = tan(26.55*pi/180);
y = (m*(x-20))/1000;

end

%% Slope Fq. 40

function y = SlopeDeltaWipsp40p(x)

m = tan(3.57*pi/180);
y = (m*(x-40))/1000;

end

function y = SlopeDeltaWipsp40n(x)

m = tan(14.05*pi/180);
y = (m*(x-40))/1000;

end

%% Slope Fq. 60

function y = SlopeDeltaWipsp60n(x)

m = tan(9.45*pi/180);
y = (m*(x-60))/1000;

end

function y = SlopeDeltaWipsp60p(x)

m = tan(4.08*pi/180);
y = (m*(x-60))/1000;

end

%% Slope Fq. 80

function y = SlopeDeltaWipsp80n(x)

m = tan(7.13*pi/180);
y = (m*(x-80))/1000;

end

function y = SlopeDeltaWipsp80p(x)

m = tan(4.76*pi/180);
y = (m*(x-80))/1000;

end

%% Slope Fq. 100

function y = SlopeDeltaWipsp100(x)

m = tan(5.7*pi/180);
y = (m*(x-100))/1000;

end

