clear
load('sa_prices.mat')
load('nsw_2010_prices.mat')

sa_half_hour_prices = zeros(48*366,1);
nsw_2010_half_hour_prices = zeros(48*366,1);

for i = 1:17567
    sa_half_hour_prices(i,:) = mean(sa_prices(6*(i-1)+1:6*i));
end

for i = 1:
    nsw_2010_half_hour_prices(i,:) = mean(nsw_2010_prices(6*(i-1)+1:6*i));
end

sa_half_hour_prices(17568,:) = mean(sa_prices(105403:105407));
nsw_2010_half_hour_prices(17568,:) = mean(nsw_2010_prices(105403:105407));

save("nsw_2010_half_hour_prices.mat","nsw_2010_half_hour_prices");
save("sa_half_hour_prices.mat","sa_half_hour_prices");