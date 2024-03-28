library(DEGraph)
library(fdANOVA)
library(multtest)
library(future.apply)

###############################################functions###############################################

###########################################################################
#Max-T

maxt <- function(x,y,m){
  statistic <- c()
  for (i in 1:m) {
    statistic[i] <- t.test(x[, i], y[, i])$statistic
  }
  return(max(statistic))
}


###########################################################################
#Adaptive Neyman

AN <- function(x,y,m){
  x <- x[,c(1:m)]
  y <- y[,c(1:m)]
  stat1 <- AN.test(x, y)$statistic
  return(stat1)
}

###########################################################################
#Shen and Faraway

SF <- function(x,y,m){
  data1 <- rbind(x, y)
  label <- data1[,m+1]
  data1 <- data1[,-c(m+1)]
  data1 <- t(data1)
  fanova1 <- fanova.tests(data1, group.label = label, test = "FN")
  stat1 <- as.numeric(as.character(unlist(fanova1$FN[2])))
  return(stat1)
}

###########################################################################
#Truncated Hotellings chi-squared

truncated_chi <- function(x,y,m){
  x <- x[,c(1:m)]
  y <- y[,c(1:m)]
  nx <- nrow(x)
  ny <- nrow(y)
  delta <- colMeans(x) - colMeans(y)
  p <- ncol(x)
  Sx <- cov(x)
  Sy <- cov(y)
  S_pooled <- ((nx - 1) * Sx + (ny - 1) * Sy) / (nx + ny - 2)
  
  L <- eigen(S_pooled)$values
  V <- eigen(S_pooled)$vectors
  A <- matrix(rep(0), nrow = m, ncol = m)
  
  val <- c()
  for (i in 1:m) {
    val[i] <- L[i] / L[1]
  }
  
  k <- tail(which(val > 10^-13), 1)
  
  t_val <- c()
  for (i in 1:k) {
    L_prime <- as.numeric(solve(L[i]))
    A1 <- L_prime * V[, i] %*% t(V[, i])
    A <- A + A1
    t_squared <- (nx * ny) / (nx + ny) * t(delta) %*% A %*% (delta)
    statistic <- (t_squared - i) * 1 / (sqrt(2 * i))
    t_val[i] <- statistic
  }
  return(max(t_val))
}


###########################################################################
#Truncated Hotellings F

truncated_F <- function(x,y,m){
  x <- x[,c(1:m)]
  y <- y[,c(1:m)]
  nx <- nrow(x)
  ny <- nrow(y)
  delta <- colMeans(x) - colMeans(y)
  p <- ncol(x)
  Sx <- cov(x)
  Sy <- cov(y)
  S_pooled <- ((nx - 1) * Sx + (ny - 1) * Sy) / (nx + ny - 2)
  
  L <- eigen(S_pooled)$values
  V <- eigen(S_pooled)$vectors
  A <- matrix(rep(0), nrow = m, ncol = m)
  
  val <- c()
  for (i in 1:m) {
    val[i] <- L[i] / L[1]
  }
  
  k <- tail(which(val > 10^-16), 1)
  
  t_val <- c()
  for (i in 1:k) {
    L_prime <- as.numeric(solve(L[i]))
    A1 <- L_prime * V[, i] %*% t(V[, i])
    A <- A + A1
    t_squared <- (nx * ny) / (nx + ny) * t(delta) %*% A %*% (delta)
    statistic <- t_squared * (nx + ny - i - 1) / (i * (nx + ny - 2))
    t_val[i] <- statistic
  }
  return(max(t_val))
}

###########################################################################
#Makambi

makambi <- function(x,y,m){
  pval <- matrix(nrow=m,ncol=1)
  se <- matrix(nrow=m,ncol=1)
  for (i in 1:m) {
    pval[i,1] <- t.test(x[, i], y[, i])$p.value
    se[i,1] <- t.test(x[, i], y[, i])$stderr
  }
  s_i <- 2 * log(pval[,1])
  s_bar <- sum(s_i)/m
  q_t <- sum( (s_i -s_bar)/(m-1)  )
  rho <- -2.167 + (10.028 - (4*q_t)/3 )^(1/2)
  weights <- 1/se^2
  weights <- weights / sum(weights)
  
  double_sum <- 0
  # Iterate over each pair of elements in pvals
  for (i in seq_along(se)) {
    for (j in seq_along(se)) {
      # Exclude squares
      if (i != j) {
        # Compute the product and add it to the double sum
        double_sum <- double_sum + se[i] * se[j]
      }
    }
  }
  
  var <- 4*sum( (se^2 ) ) + double_sum * (3.25*rho + 0.75*rho^2)
  v <- 8/var
  m <- sum( weights* (-2 *log(pval)) )
  result <- v*m/2
  return(result)
}


###########################################################################
#Hartung

hartung <- function(x,y,m){
  stat <- matrix(nrow=m,ncol=1)
  se <- matrix(nrow=m,ncol=1)
  for (i in 1:m) {
    stat[i,1] <- t.test(x[, i], y[, i])$statistic
    se[i,1] <- t.test(x[, i], y[, i])$stderr
  }
  probabilities <- pnorm(stat)
  t <- qnorm(probabilities)
  lambda <- sqrt(c(1:25))
  
  n <- m #number of p-values there are 25 time points
  q <- 1/(n-1) * sum(  (t - (1/n * sum(t) ))^2 )
  q_hat <- 1-q
  q_star <- max(-1/(n-1), q_hat )
  K <- 0.2
  lambda <- sqrt(c(1:m))
  numerator <- sum(lambda*t)
  denominator <- sqrt( sum( lambda^2 ) + 
                         ( (sum(lambda))^2 - sum( lambda^2 )  ) * 
                         (q_star + K * sqrt(2/(n+1)) * ( 1 - q_star  ) ) ) 
  return(numerator/denominator)
}


###########################################################################
#Westfall Young

wy <- function(x,y,m){
  data1 <- rbind(x, y)
  label <- data1[,m+1]
  label <- ifelse(label == "A", 0, ifelse(label == "B", 1, NA))
  data1 <- data1[,-c(m+1)]
  data1 <- t(data1)
  wy1 <- invisible({mt.maxT(data1,classlabel=label,test="t")})
  stat1 <- max(wy1$teststat)
  return(stat1)
}










###############################################simulation###############################################


# Define collections of parameters
parameter_sets <- list( list(m = 10, n_1 = 20, n_2 = 30, s_1 = 0.05, s_2 = 0.05),
  list(m = 10, n_1 = 20, n_2 = 30, s_1 = 0.2, s_2 = 0.2),
  list(m = 10, n_1 = 20, n_2 = 30, s_1 = 0.2, s_2 = 0.4),
  list(m = 10, n_1 = 20, n_2 = 30, s_1 = 0.4, s_2 = 0.2),
  list(m = 10, n_1 = 20, n_2 = 30, s_1 = 0.2, s_2 = 0.8),
  list(m = 10, n_1 = 20, n_2 = 30, s_1 = 0.8, s_2 = 0.2),
  list(m = 10, n_1 = 40, n_2 = 60, s_1 = 0.05, s_2 = 0.05),
  list(m = 10, n_1 = 40, n_2 = 60, s_1 = 0.2, s_2 = 0.2),
  list(m = 10, n_1 = 40, n_2 = 60, s_1 = 0.2, s_2 = 0.4),
  list(m = 10, n_1 = 40, n_2 = 60, s_1 = 0.4, s_2 = 0.2),
  list(m = 10, n_1 = 40, n_2 = 60, s_1 = 0.2, s_2 = 0.8),
  list(m = 10, n_1 = 40, n_2 = 60, s_1 = 0.8, s_2 = 0.2),
  list(m = 15, n_1 = 20, n_2 = 30, s_1 = 0.05, s_2 = 0.05),
  list(m = 15, n_1 = 20, n_2 = 30, s_1 = 0.2, s_2 = 0.2),
  list(m = 15, n_1 = 20, n_2 = 30, s_1 = 0.2, s_2 = 0.4),
  list(m = 15, n_1 = 20, n_2 = 30, s_1 = 0.4, s_2 = 0.2),
  list(m = 15, n_1 = 20, n_2 = 30, s_1 = 0.2, s_2 = 0.8),
  list(m = 15, n_1 = 20, n_2 = 30, s_1 = 0.8, s_2 = 0.2),
  list(m = 15, n_1 = 40, n_2 = 60, s_1 = 0.05, s_2 = 0.05),
  list(m = 15, n_1 = 40, n_2 = 60, s_1 = 0.2, s_2 = 0.2),
  list(m = 15, n_1 = 40, n_2 = 60, s_1 = 0.2, s_2 = 0.4),
  list(m = 15, n_1 = 40, n_2 = 60, s_1 = 0.4, s_2 = 0.2),
  list(m = 15, n_1 = 40, n_2 = 60, s_1 = 0.2, s_2 = 0.8),
  list(m = 15, n_1 = 40, n_2 = 60, s_1 = 0.8, s_2 = 0.2) )


# Define list of functions
function_list <- list( maxt, AN, SF, truncated_chi, truncated_F, makambi, hartung, wy )


# Define your function to be applied in parallel
parallel_function <- function(params) {
  pval <- matrix(nrow = 1000, ncol = length(function_list)) # Adjusted matrix size
  
  for (z in 1:1000) { # Increase outer loop iterations
    stats <- matrix(ncol = length(function_list), nrow = 2001) # Adjusted matrix size
    m <- params$m
    t <- seq(from = 0, to = 1, length.out = m)
    n_1 <- params$n_1
    n_2 <- params$n_2
    s_1 <- params$s_1
    s_2 <- params$s_2
    
    x <- as.data.frame(do.call(rbind, replicate(n_1, t * (1 - t) + rnorm(m, mean = 0, sd = s_1), simplify = FALSE)))
    y <- as.data.frame(do.call(rbind, replicate(n_2, t * (1 - t) + rnorm(m, mean = 0, sd = s_2), simplify = FALSE)))
    x$group <- c("A")
    y$group <- c("B")
    data <- rbind(x, y)
    
    for (f in seq_along(function_list)) {
      stats[1, f] <- function_list[[f]](x, y, m)
    }  
    
    for (i in 1:2000) { # Increase inner loop iterations
      data$group <- sample(data$group, replace = FALSE)
      x <- subset(data, data$group == "A")
      y <- subset(data, data$group == "B")
      for (f in seq_along(function_list)) {
        stats[i + 1, f] <- function_list[[f]](x, y, m)
      }
    }
    
    for (col in 1:ncol(stats)) {
      pval[z, col] <- sum(stats[-1, col] > stats[1, col])
    }
  }
  pval <- pval / 2000 # Adjusted division
  
  results <- matrix(0, nrow = 1, ncol = length(function_list))
  for (col in 1:ncol(pval)) {
    results[1, col] <- sum(pval[, col] <= 0.05)
  }
  results <- results / 1000 # Adjusted division
  colnames(results) <- c("maxt", "AN", "SF", "truncated_chi", "truncated_F", "makambi", "hartung", "wy")
  rownames(results) <- paste("Parameter", p, sep = "")
  results
}

# Apply the function in parallel to parameter sets
future_results <- future_lapply(parameter_sets, parallel_function, future.seed = TRUE)

# Retrieve results
results <- as.data.frame(future_results)
print(results)


