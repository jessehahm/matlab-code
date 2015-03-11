#Author: Jesse Hahm, with intellectual contributions from Cliff Riebe

clear all;
close all;

%Script to explore relations between alpha, beta, n, nu, s.e.m., 
%in order to determine minimum detectable difference between null
%hypothesis slope and true slope for given significance, power, slope error, and
%number of samples. Slope for CDF vs. D,  one-tailed test due to physical considerations

%H0: slope is 0
%H1: slope is less than 0

%Type 1 error: alpha: significance level: reject true null hypothesis
%(false positive): say a site is kinetic-limited when it is actually
%supply-limited: 5% chance

%Type 2 error: beta: fail to reject the null hypothesis when it is false
%(false negative): say a site is supply-limited when it is actually
%kinetic-limited

%Power of test: 1 - beta: probability of rejecting a false null hypothesis

nullSlope=0; %Null Hypothesis Slope
sem = .25; %Standard Error of the Slope (s)
n = 12; %Number of samples
V = n-2; %Degrees of freedom
alpha = 0.05; %Significance level, P(reject H0|H0true)
beta = 0.8; %P(fail to reject H0|H0 true)
power = 1-beta; %P(reject H0|H0 false)

tCritAlpha=tinv(alpha,V);
tCritBeta=tinv(beta,V);
scaledCritAlpha = tCritAlpha*sem;
scaledCritBeta = tCritBeta*sem;

tX= -5:.01:5; %populate plotting array
tY1= tpdf(tX,V); %Generate pdf of t-distribution for given degrees of freedom
tY2= tcdf(tX,V); %Generate cdf of t-distribution for given degrees of freedom
scaledX = tX*sem;

%Minimum detectable difference / least significant difference:
%by how much must the true slope differ from null hypothesis slope so that
%the chance is 1-beta or better that the xbar measured will let us reject
%H0, at given significance alpha? 
tLSD = tCritAlpha-(tCritBeta)
scaledLSD = tLSD*sem

%Plot the t-distribution PDFs and CDFs with critical values
figure ('Name',['Power and significance analysis with t-distributions']);

subplot(2,1,1);
plot(tX+nullSlope,tY1); %plot pdf of t-distribution for given degrees of freedom centered at null hypothesis slope
hold on;
plot(tX+nullSlope,tY2); %plot cdf of t-distribution for given degrees of freedom centered at null hypothesis slope
hold on;
plot (tX+nullSlope+tLSD,tY1, 'k'); %plot pdf of t-distribution of true slope at minimum detectable difference away from null hypothesis slope
hold on;
plot (tX+nullSlope+tLSD,tY2, 'k'); %plot cdf of t-distribution of true slope at minimum detectable difference away from null hypothesis slope

%draw line for critical value (left tail of H0 dist. (.05), right tail of H1 (.90))
line([tCritAlpha tCritAlpha], [0 1],'Color', 'g')

%draw line between distribution peaks (i.e. least signifcant difference)
line([nullSlope+tLSD nullSlope], [tpdf(nullSlope,V) tpdf(nullSlope,V)],'Color', 'r')

xlabel('t = s.e.m. = standard deviations of sampling distribution of sample mean')
ylabel('P(t) or cumulative P(t)')
ylim([0 1])

titleText=['null hypothesis = ' num2str(nullSlope) '; s.e.m. = ' num2str(sem) '; n = ' num2str(n) '; alpha = ' num2str(alpha) '; beta = ' num2str(beta) '; t LSD = ' num2str(tLSD) '; scaled LSD = ' num2str(scaledLSD)];
title(titleText);

%Now plot the t-distributions and critical values scaled by the standard
%error (sem)
subplot(2,1,2);

plot(scaledX+nullSlope,tY1/sem); %plot pdf of scaled t-distribution for given degrees of freedom centered at null hypothesis slope
hold on;
plot(scaledX+nullSlope,tY2); %plot cdf of scaled t-distribution for given degrees of freedom centered at null hypothesis slope
hold on;
plot (scaledX+nullSlope+scaledLSD,tY1/sem, 'k'); %plot pdf of scaled t-distribution of true slope at minimum detectable difference away from null hypothesis slope
hold on;
plot (scaledX+nullSlope+scaledLSD,tY2, 'k'); %plot cdf of scaled t-distribution of true slope at minimum detectable difference away from null hypothesis slope

%draw line for critical value (left tail of H0 dist. (.05), right tail of H1 (.90))
line([scaledCritAlpha scaledCritAlpha], [0 5],'Color', 'g')

%draw line between distribution peaks (i.e. least signifcant difference)
line([nullSlope+scaledLSD nullSlope], [tpdf(nullSlope,V)/sem tpdf(nullSlope,V)/sem],'Color', 'r')

xlabel('slope (scaled by s.e.m.)')
ylabel('P(slope) or cumulative P(slope)')
ylim([0 2])


