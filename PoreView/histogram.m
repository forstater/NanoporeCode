function [xconductance,hconductance,xcurrent,hcurrent] = histogram(sigdata,trange,filter,channels)
%HISTOGRAM loops through data and returns vectors to plot a histogram
%   [x,y] = histogram(cf.data,trange)
    
    % Signals
    fcurrentSig = channels(1);
    fcondSig = channels(2);
    
    % Create bins
    del = 0.030517578125; % constant for digidata with alpha=10
    V = mean(sigdata.get(trange(1)/sigdata.si:trange(1)/sigdata.si+1000,3));
    raw = sigdata.getViewData(trange);
    lowCurrent = min(raw(:,2)*1000);
    highCurrent = max(raw(:,2)*1000);
    xcurrent = lowCurrent-5:del:highCurrent+5;
    xconductance = xcurrent/abs(V);
    hconductance = zeros(1,numel(xconductance));
    hcurrent = zeros(1,numel(xcurrent));
    
    % Start figure
    h = figure(5);
    clf(5)
    
    % Loop through data and create histogram
    for i=trange(1):1:trange(2)
        data = sigdata.getByTime(i:min(i+1,trange(2)));
        current = data(:,fcurrentSig); % in pA
        conductance = data(:,fcondSig)*sign(V); % in nS
        hcurrent = hcurrent + hist(current,xcurrent);
        hconductance = hconductance + hist(conductance,xconductance);
        subplot(1,2,1)
        bar(xconductance,hconductance)
        subplot(1,2,2)
        bar(xcurrent,hcurrent)
        drawnow
    end
    
    %% Plot it on a log scale
    subplot(1,2,1)
    bar(xconductance,log(hconductance+1))
    xlabel('Conductance (nS)','FontSize',20)
    ylabel('Log (# data points +1)','FontSize',20)
    title([num2str(filter) 'Hz Filtered Conductance: ' num2str(V,3) 'mV'],'FontSize',18)
    ylim([0 max(log(hconductance+1))+1])
    xlim([min(0,xconductance(1)) max(0,xconductance(end))])
    set(gca,'FontSize',20)
    set(gca,'LooseInset',[0 0 0 0]) % the all-important elimination of whitespace!
    set(gca,'OuterPosition',[0.01 0 0.47 0.99]) % fit everything in there
    subplot(1,2,2)
    bar(xcurrent,log(hcurrent+1))
    xlabel('Current (pA)','FontSize',20)
    ylabel('Log (# data points +1)','FontSize',20)
    title([num2str(filter) 'Hz Filtered Current: ' num2str(V,3) 'mV'],'FontSize',18)
    ylim([0 max(log(hcurrent+1))+1])
    xlim([min(0,xcurrent(1)) max(0,xcurrent(end))])
    set(gca,'FontSize',20)
    set(gca,'LooseInset',[0 0 0 0]) % the all-important elimination of whitespace!
    set(gca,'OuterPosition',[0.52 0 0.47 0.99]) % fit everything in there
    set(h,'Position',[100 500 1200 300]) % size the figure
    
    %% separate conductance alone
    g = figure(6);
    clf(6)
    bar(xconductance,log(hconductance+1))
    xlabel('Conductance (nS)','FontSize',20)
    ylabel('Log (# points +1)','FontSize',20)
    title([num2str(filter) 'Hz Filtered Conductance: ' num2str(V,3) 'mV'],'FontSize',18)
    ylim([0 max(log(hconductance+1))+1])
    %xlim([min(0,xconductance(1)) max(0,xconductance(end))])
    xlim([-0.1 1.4])
    set(gca,'FontSize',20)
    set(gca,'LooseInset',[0 0 0 0]) % the all-important elimination of whitespace!
    set(gca,'OuterPosition',[0.01 0.01 0.97 0.99]) % fit everything in there
    set(g,'Position',[100 500 700 200]) % size the figure
    
end
