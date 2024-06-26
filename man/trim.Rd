% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trim.R
\name{trim}
\alias{trim}
\alias{trim.wimids}
\title{Trim Weights}
\usage{
\method{trim}{wimids}(x, at = 0, lower = FALSE, ...)
}
\arguments{
\item{x}{A \code{wimids} object; the output of a call to \code{\link[=weightthem]{weightthem()}}.}

\item{at}{\code{numeric}; either the quantile of the weights above which
weights are to be trimmed. A single number between .5 and 1, or the number
of weights to be trimmed (e.g., \code{at = 3} for the top 3 weights to be
set to the 4th largest weight).}

\item{lower}{\code{logical}; whether also to trim at the lower quantile
(e.g., for \code{at = .9}, trimming at both .1 and .9, or for \code{at = 3},
trimming the top and bottom 3 weights). Default is \code{FALSE} to only trim the higher weights.}

\item{...}{Ignored.}
}
\value{
An object from the \code{wimids} class, identical to the original object except with \code{trim()} applied to each of the \code{weightit} objects in the \code{models} component.
}
\description{
Trims (i.e., truncates) large weights by setting all weights higher than that at a given quantile to the weight at the quantile. This can be useful in controlling extreme weights, which can reduce effective sample size by enlarging the variability of the weights.
}
\details{
\code{trim.wimids()} works by calling \code{\link[WeightIt:trim]{WeightIt::trim()}} on each \code{weightit} object stored in the \code{models} component of the \code{wimids} object. Because \code{trim()} itself is not exported from \pkg{MatchThem}, it must be called using \code{WeightIt::trim()} or by attaching \pkg{WeightIt} (i.e., running \code{library(WeightIt)}) before use.
}
\examples{
\donttest{#Loading the dataset
data(osteoarthritis)

#Multiply imputing the missing values
imputed.datasets <- mice::mice(osteoarthritis, m = 5)

#Estimating weights of observations in the multiply imputed datasets
weighted.datasets <- weightthem(OSP ~ AGE + SEX + BMI + RAC + SMK,
                                imputed.datasets,
                                approach = 'within',
                                method = 'glm',
                                estimand = "ATE")

#Trimming the top 10\% of weights in each dataset
#to the 90th percentile
trimmed.datasets <- trim(weighted.datasets, at = 0.9)}
}
\seealso{
\code{\link[WeightIt:trim]{WeightIt::trim()}}
}
\author{
Noah Greifer
}
