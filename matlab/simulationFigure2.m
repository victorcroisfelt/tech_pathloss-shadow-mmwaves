% Matlab script used to generate Figure 2a and 2b of the technical report:
%
% "A Study of Pathloss and Shadow Fading Models for mmWaves"
%
% @author Victor Croisfelt Rodrigues
% @author Taufik Abrao
%


%Initialization
close all;
clearvars;

%% Simulation results

%Define the Tx-Rx distance range
d = logspace(0,3,100);

%Define the number of points
nbrOfPoints = 2;

%Prepare to store te simulation results
PL_LoS = zeros(length(d),nbrOfPoints);
PL_NLoS = zeros(length(d),nbrOfPoints);
std_LoS = zeros(length(d),nbrOfPoints);
std_NLoS = zeros(length(d),nbrOfPoints);

%% Simulation
for m = 1:nbrOfPoints
    
    %Extract simulation values
    if m == 1
        
        %LoS PL parameters
        alpha_LoS = 64.88;
        beta_LoS = 16.7;
        
        %LoS SF parameters
        a_LoS = -1.20;
        b_LoS = 1.54;
        
        %NLoS PL parameters
        dbreak_NLoS = 148.2;
        
        alpha_NLoS = 83.8;
        beta1_NLoS = 17.5;
        beta2_NLoS = 119;
        
        %NLoS SF parameters
        a_NLoS = -0.002;
        b1_NLoS = 7.3;
        b2_NLoS = 27.2;
        
    elseif m == 2
        
        %LoS PL parameters
        alpha_LoS = 67.48;
        beta_LoS = 15.5;
        
        %LoS SF parameters
        a_LoS = 2.36;
        
        %NLoS PL parameters
        alpha_NLoS = -70.5;
        beta_NLoS = 90.17;
        
        %NLoS SF parameters
        a_NLoS = 22.69;
        
    end
    
    %Compute the PL LoS
    PL_LoS(:,m) = alpha_LoS + beta_LoS*log10(d);
    
    %Compute the PL NLoS
    if m == 1
        
        for dd = 1:length(d)
            
            if (d(dd) <= dbreak_NLoS)
                
                PL_NLoS(dd,m) = alpha_NLoS+beta1_NLoS*log10(d(dd));
                
            else
                
                PL_NLoS(dd,m) = alpha_NLoS+beta1_NLoS*log10(dbreak_NLoS)+beta2_NLoS*log10(d(dd)/dbreak_NLoS);
                
            end
            
        end
        
    else
        
        PL_NLoS(:,m) = alpha_NLoS + beta_NLoS*log10(d);
        
    end
    
    %Compute the standard deviation for LoS
    if m == 1
        
        std_LoS(:,m) = a_LoS+b_LoS*log10(d);
        
    elseif m == 2
        
        std_LoS(:,m) = a_LoS;
        
    end
    
    %Compute the standard deviation for NLoS
    if m == 1
        
        
        for dd = 1:length(d)
            
            if (d(dd) <= dbreak_NLoS)
                
                std_NLoS(dd,m) = a_NLoS+b1_NLoS*log10(d(dd));
                
            else
                
                std_NLoS(dd,m) = a_NLoS+b1_NLoS*log10(dbreak_NLoS)+b2_NLoS*log10(d(dd)/dbreak_NLoS);
                
            end
            
        end
        
    elseif m == 2
        
        std_NLoS(:,m) = a_NLoS;
        
    end
    
end

%% Plot simulations

%Pathloss models
figure;
box on; hold on;

plot(d(1),PL_LoS(1,1),'o--');
plot(d(1),PL_NLoS(1,1),'o-.');
plot(d(1),PL_LoS(1,2),'^--');
plot(d(1),PL_NLoS(1,2),'^-.');

ax = gca;
ax.ColorOrderIndex = 1;

plot(d,PL_LoS(:,1),'--');
plot(d,PL_NLoS(:,1),'-.');
plot(d,PL_LoS(:,2),'--');
plot(d,PL_NLoS(:,2),'-.');

ax = gca;
ax.ColorOrderIndex = 1;

plot(d(10:10:end),PL_LoS((10:10:end),1),'o');
plot(d(10:10:end),PL_NLoS((10:10:end),1),'o');
plot(d(10:10:end),PL_LoS((10:10:end),2),'^');
plot(d(10:10:end),PL_NLoS((10:10:end),2),'^');

legend('OM: $\mathrm{PL}_{\mathrm{LoS}}$','OM: $\mathrm{PL}_{\mathrm{NLoS}}$','SoM: $\mathrm{PL}_{\mathrm{LoS}}$','SoM: $\mathrm{PL}_{\mathrm{NLoS}}$','Location','NorthWest');

set(gca,'XScale','log');

xlabel('Distance [m]');
ylabel('Pathloss [dB]');

%Shadowing models
figure;
box on; hold on;

plot(d(1),std_LoS(1,1),'o--');
plot(d(1),std_NLoS(1,1),'o-.');
plot(d(1),std_LoS(1,2),'^--');
plot(d(1),std_NLoS(1,2),'^-.');

ax = gca;
ax.ColorOrderIndex = 1;

plot(d,std_LoS(:,1),'--');
plot(d,std_NLoS(:,1),'-.');
plot(d,std_LoS(:,2),'--');
plot(d,std_NLoS(:,2),'-.');

ax = gca;
ax.ColorOrderIndex = 1;

plot(d(10:10:end),std_LoS((10:10:end),1),'o');
plot(d(10:10:end),std_NLoS((10:10:end),1),'o');
plot(d(10:10:end),std_LoS((10:10:end),2),'^');
plot(d(10:10:end),std_NLoS((10:10:end),2),'^');

legend('OM: $\sigma_{\mathrm{LoS}}$','OM: $\sigma_{\mathrm{NLoS}}$','SoM: $\sigma_{\mathrm{LoS}}$','SoM: $\sigma_{\mathrm{NLoS}}$','Location','NorthWest');

set(gca,'XScale','log');

xlabel('Distance [m]');
ylabel('$\sigma$ [dB]');