% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LLE_functions.R
\name{plotLLE}
\alias{plotLLE}
\title{plotLLE}
\usage{
plotLLE(LLE)
}
\arguments{
\item{LLE}{The output from TSIR_LLE}
}
\description{
Function to plot the Local Lyapunov Exponents. The output is of class ggplot2 so you can add standard
ggplot2 options to it if desired.
}
\examples{


\dontrun{
require(kernlab)
require(ggplot2)
require(kernlab)
London <- twentymeas[["London"]]
## just analyze the biennial portion of the data
London <- subset(London, time > 1950)

## define the interval to be 2 weeks
IP <- 2

## first estimate paramters from the London data
parms <- estpars(data=London, IP=2, regtype='gaussian',family='poisson',link='log')

## look at beta and alpha estimate
plotbeta(parms)

## simulate the fitted parameters
sim <- simulatetsir(data=London,parms=parms,IP=2,method='deterministic',nsim=2)

## now lets predict forward 200 years using the mean birth rate,
## starting from rough initial conditions
times <- seq(1965,2165, by = 1/ (52/IP))
births <- rep(mean(London$births),length(times))
S0 <- parms$sbar
I0 <- 1e-5*mean(London$pop)

pred <- predicttsir(times=times,births=births,
                   beta=parms$contact$beta,alpha=parms$alpha,
                  S0=S0,I0=I0,
                  nsim=50,stochastic=T)

## take the last 10 years
pred <- lapply(pred, function(x)  tail(x, 52/IP * 20) )

## now compute the Lyapunov Exponent for the simulate and predicted model

simLE <- TSIR_LE(
time=sim$res$time,
S=sim$simS$mean,
I=sim$res$mean,
alpha=sim$alpha,
  beta=sim$contact$beta,
IP=IP
)

predLE <- TSIR_LE(
time=pred$I$time,
S=pred$S$X3,
I=pred$I$X3,
alpha=parms$alpha,
beta=parms$contact$beta,
IP=IP
)

simLE$LE
predLE$LE

simLLE <- TSIR_LLE(simLE)
predLLE <- TSIR_LLE(predLE)

plotLLE(simLLE)
plotLLE(predLLE)
}

}
