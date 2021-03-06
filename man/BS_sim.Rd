% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BS_sim.R
\name{BS_sim}
\alias{BS_sim}
\title{Simulate Stock Price and Price of Underlying Asset}
\usage{
BS_sim(vol, mu, dt, V_0, D, r, T.)
}
\arguments{
\item{vol}{numeric scalar with \eqn{\sigma} value.}

\item{mu}{numeric scalar with \eqn{\mu} value.}

\item{dt}{numeric scalar with time increments between observations.}

\item{V_0}{numeric scalar with starting value of the underlying asset, \eqn{S_{0}}.}

\item{D}{numeric vector or scalar with debt due in \code{T.}.}

\item{r}{numeric vector or scalar with risk free rates.}

\item{T.}{numeric vector or scalar with time to maturity.}
}
\description{
At least one of \code{D}, \code{r}, or \code{T.} needs to have
the desired length of the simulated series. All vectors with length greater
than one needs to have the same length.
}
\examples{
library(DtD)
set.seed(79156879)
sims <- BS_sim(
  vol = .1, mu = .05, dt = .2, V_0 = 100, T. = 1, D = rep(80, 20), r = .01)

# plot underlying
plot(sims$V)

# plot stock
plot(sims$S)

}
\seealso{
\code{\link{BS_fit}}
}
