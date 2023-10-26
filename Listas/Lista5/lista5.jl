using GLM, LinearAlgebra 
White = function (Y, X)
    X = Array(X)
    Y = Array(Y)
    modelo = lm(X,Y)
    u_hat_2 = (Y - predict(modelo)).^2
    u_omega = Diagonal(u_hat_2)
    xx_1 = inv(transpose(X)*X)
    white = transpose(X)*u_omega*X
    estimador = xx_1*white*xx_1
    return estimador
end


using WooldridgeDatasets, DataFrames
wage2 = DataFrame(wooldridge("wage2"))
X = DataFrame(ind = 1, IQ = wage2.IQ, hours = wage2.hours)
Y = wage2[:,"wage"]

White(Y, X)


HAC = function (Y, X, g)
    X = Array(X)
    Y = Array(Y)
   modelo = lm(X, Y)
   covs = vcov(modelo)
   u_hat = residuals(modelo)
   sigma = sqrt(sum(u_hat.^2)/(size(X,1)-size(X,2)))
   for i in 2:size(X,2)
    X_aux = X[:, 1:end .!= i]
    modelo_aux = lm(X_aux, X[:, i])
    r_hat = residuals(modelo_aux)
    a_hat = r_hat.*u_hat
    v_hat = sum(a_hat.^2)
    for h in 1:g
        coef = 1-h/(g+1)
        soma = 0
        for t in (h+1):size(X,1)
            soma = soma + a_hat[t]*a_hat[t-h]            
        end
        v_hat = v_hat + 2*coef*soma
    end
    covs[i,i] = covs[i,i]*sqrt(v_hat)/(sigma^2)
   end

   return covs
end

HAC(Y, X, 5)

scrr = function calc_hac_se(reg, g)
    n = nobs(reg)
    X = reg.mm.m
    n = size(X, 1)
    K = size(X, 2)
    u = residuals(reg)
    ser = sqrt(sum(u .^ 2) / (n - K))
    se_ols = coeftable(reg).cols[2]
    se_hac = zeros(K)
    for k in 1:K
    yk = X[:, k]
    Xk = X[:, (1:K).!=k]
    bk = inv(transpose(Xk) * Xk) * transpose(Xk) * yk
    rk = yk .- Xk * bk
    ak = rk .* u
    vk = sum(ak .^ 2)
    for h in 1:g
    sum_h = 2 * (1 - h / (g + 1)) * sum(ak[(h+1):n] .* ak[1:(n-h)])
    vk = vk + sum_h
    end
    se_hac[k] = (se_ols[k] / ser)^2 * sqrt(vk)
    end
    return se_hac
    end
    
scrr(lm(@formula(wage~IQ+hours), wage2), 5)
HAC(Y, X, 5)