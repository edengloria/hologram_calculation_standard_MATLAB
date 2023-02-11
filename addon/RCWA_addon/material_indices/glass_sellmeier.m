function result = glass_sellmeier(lambda)

lambda_um = lambda * 1e6;

n2 = 1 + ...
             0.6962 * lambda_um.^2 ./ (lambda_um.^2  - (0.06840)^2) + ...
             0.4079 * lambda_um.^2 ./ (lambda_um.^2  - (0.1162 )^2) + ...
             0.8975 * lambda_um.^2 ./ (lambda_um.^2  - (9.8962 )^2);

result = sqrt(n2);
