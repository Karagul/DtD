% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rolling.R
\name{BS_fit_rolling}
\alias{BS_fit_rolling}
\title{Fit Black-Scholes Parameters Over Rolling Window}
\usage{
BS_fit_rolling(S, D, T., r, time, dt, vol_start, method = c("iterative",
  "mle"), tol = 1e-12, eps = 1e-08, grp, width, min_obs)
}
\arguments{
\item{S}{numeric vector with observed stock prices.}

\item{D}{numeric vector or scalar with debt due in \code{T.}.}

\item{T.}{numeric vector or scalar with time to maturity.}

\item{r}{numeric vector or scalar with risk free rates.}

\item{time}{numeric vector with the observation times.}

\item{dt}{numeric scalar with time increments between observations.}

\item{vol_start}{numeric scalar with starting value for \eqn{\sigma}.}

\item{method}{string to specify which estimation method to use.}

\item{tol}{numeric scalar with tolerance to \code{\link{get_underlying}}.
The difference is scaled  if the absolute of \code{S} is large than \code{tol}
as in the \code{tolerance} argument to \code{\link{all.equal.numeric}}.}

\item{eps}{numeric scalar with convergence threshold.}

\item{grp}{integer vector with the group identifier (e.g., units of
months).}

\item{width}{integer scalar with the units of \code{grp} to include in the
rolling window.}

\item{min_obs}{integer scalar for the minimum number of observation required
in each window.}
}
\value{
Matrix with the \code{grp}, number of observation in the window, parameter
estimates, and \code{'n_iter'} as in \code{\link{BS_fit}}, and whether the
estimation method was successful.

An \code{error} attribute is added in case other code than
\code{\link{optim}} fails. It is a list of lists with the \code{grp} index
where the method failed and the output from \code{\link{try}}.
}
\description{
Function to estimate the volatility, \eqn{\sigma}, and drift, \eqn{\mu}. E.g.,
the window can be over a given number of months. See
\code{vignette("Distance-to-default", package = "DtD")} for details.
}
\examples{
# Simulate data
set.seed(55770945)
n <- 21L * 3L * 12L # 21 trading days for 3 years w/ 12 months
sims <- BS_sim(
  vol = .1, mu = .05, dt = .1, V_0 = 100, T. = 1,
  D = runif(n, 80, 90), r = runif(n, 0, .01))
sims$month <- (1:nrow(sims) - 1L) \%/\% 21L + 1L

# throw out some months
sims <- subset(sims, !month \%in\% 15:24)

# assign parameters
grp <- sims$month
width <- 12L        # window w/ 12 month width
min_obs <- 21L * 3L # require 3 months of data

# estimate results with R loop which is slightly simpler then the
# implementation
grps <- unique(grp)
out <- matrix(
  NA_real_, nrow = length(grps), ncol = 6,
  dimnames = list(NULL, c("mu", "vol", "n_iter", "success", "n_obs", "grp")))
for(g in grps){
  idx <- which(grps == g)
  keep <- which(grp \%in\% (g - width + 1L):g)
  out[idx, c("n_obs", "grp")] <- c(length(keep), g)
  if(length(keep) < min_obs)
    next
  res <- with(
    sims[keep, ],
    BS_fit(S = S, D = D, T. = T, r = r, time = time, method = "iterative",
           vol_start = 1))
  out[idx, c("mu", "vol", "n_iter", "success")] <- rep(
    do.call(c, res[c("ests", "n_iter", "success")]), each = length(idx))
}

# we get the same with the R function
out_func <- with(sims, BS_fit_rolling(
  S = S, D = D, T. = T, r = r, time = time, method = "iterative",
  grp = month, width = width, min_obs = min_obs))

all.equal(out[, names(out) != "n_iter"],
          out_func[, names(out_func) != "n_iter"])

}
\seealso{
\code{\link{BS_fit}}
}
