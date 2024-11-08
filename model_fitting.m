clear all ; 
close all ; 
clc ; 

disp('Lendo a Tabela... ');

df = readtable('T0000ALL.CSV' , 'HeaderLines', 15);

Tempo = df.TIME;
Vdegrau = df.CH1; 
Vsaida = df.CH4; 


figure (1)
subplot 211;
plot(Tempo , Vdegrau);
title('Unit Step Impulse');
ylabel('V')
xlabel('t [s]')
grid on ; 

subplot 212;
plot(Tempo , Vsaida);
title('System Response');
ylabel('V')
xlabel('t [s]')
grid on ; 


% Reajustando o vetor tempo
% Reamostrando o tempo para ter um ponto por amostra + reajustando o
% offset...
tempo0 = -1.80783 ; 
TempoAjustado = linspace(Tempo(1) , Tempo(end) , numel(Tempo)) - tempo0;

% Removendo offset da tensão quando t < 0 ; 
VdegrauAjustado = Vdegrau - mean(Vdegrau(TempoAjustado < 0 ));
VsaidaAjustada = Vsaida - mean(Vsaida(TempoAjustado < 0 ));

VdegrauAjustado = movmean(VdegrauAjustado , 100);
VsaidaAjustada = movmean(VsaidaAjustada , 100);

figure (2)

subplot 211;
plot(TempoAjustado , VdegrauAjustado , 'Color' , 'Red');
title('Unit Step Impulse');
ylabel('V')
xlabel('t [s]')
grid on ; 

subplot 212;
plot(TempoAjustado , VsaidaAjustada , 'Color' , 'Red');
title('System Response');
ylabel('V')
xlabel('t [s]')
grid on ; 

% Estimativa do modelo 
Ts = TempoAjustado(2) - TempoAjustado(1); 

DadosDegrau = iddata(VsaidaAjustada , VdegrauAjustado , Ts) ; 

% Estimativa p/ Primeira Ordem
modelo   = tfest(DadosDegrau , 1 , 0) ; 
Gest = tf(modelo) ; 

%%
VsaidaMODELO = lsim(Gest , VdegrauAjustado , TempoAjustado) ; 


figure(3) 
subplot 211 ; 

plot(TempoAjustado , VdegrauAjustado);
grid on ; 

subplot 212;
plot(TempoAjustado , VsaidaAjustada);
hold on ; 

plot(TempoAjustado , VsaidaMODELO);
grid on ; 


legend('Experimental' , 'Modelo')
















