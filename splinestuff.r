# Reszpekt to https://tamas-ferenci.github.io/FerenciTamas_SimitasSplineRegresszioAdditivModellek/index.html 
library(ggplot2)
set.seed(12345)

n <- 30
x <- runif(n, 0, 1)
xgrid <- seq(0, 1, length.out = 100)
ygrid <- 100*xgrid^2
yobs <- 100*x^2 + rnorm(n, 0, 5)
p <- ggplot(data.frame(x, yobs)) + geom_point(aes(x = x, y = yobs)) +
  geom_line(data = data.frame(xgrid, ygrid), aes(x = xgrid, y = ygrid),
            color = "orange", lwd = 1)
p

xk <- 1:4/5
q <- length(xk) + 2

rk <- function( x, z ) {
  ((z-0.5)^2-1/12)*((x-0.5)^2-1/12)/4-((abs(x-z)-0.5)^4-(abs(x-z)-0.5)^2/2+7/240)/24
}

d <- data.frame( x= seq(0,1, length.out = 100))

rd <- rep( 0, 97)
for (i in 4:100) {
  rd[i-3] <- rk( d$x[i],0.2)
}
plot(d$x[4:100],rd)
abline(v=.2,col='red')

####

X <- matrix(1, n, q) 

X[, 2] <- x

X[, 3:q] <- outer(x, xk, FUN = rk)

spl.X <- function(x, xk) {
  q <- length(xk) + 2
  n <- length(x)
  X <- matrix(1, n, q)
  X[, 2] <- x
  X[, 3:q] <- outer(x, xk, FUN = rk)
  X
}

fit <- lm(yobs ~ X - 1 )

Xp <- spl.X(xgrid, xk)
yp <- Xp%*%coef(fit)
p + geom_line(data = data.frame(xgrid, yp), aes(x = xgrid, y = yp))
