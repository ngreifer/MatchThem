% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cbind.R
\name{cbind}
\alias{cbind}
\alias{cbind.mimids}
\alias{cbind.wimids}
\title{Combine \code{mimids} and \code{wimids} Objects by Columns}
\usage{
cbind(..., deparse.level = 1)

\method{cbind}{mimids}(..., deparse.level = 1)

\method{cbind}{wimids}(..., deparse.level = 1)
}
\arguments{
\item{...}{Objects to combine columnwise. The first argument should be a \code{mimids} or \code{wimids} object. Additional \code{data.frame}s, \code{matrix}es, \code{factor}s, or \code{vector}s can be supplied. These can be given as named arguments.}

\item{deparse.level}{Ignored.}
}
\value{
An object with the same class as the first input object with the additional datasets or variables added to the components.
}
\description{
This function combines a \code{\link{mimids}} or \code{\link{wimids}} object columnwise with additional datasets or variables. Typically these would be variables not included in the original multiple imputation and therefore absent in the \code{mimids} or \code{wimids} object. \code{with()} can then be used on the output to run models with the added variables.
}
\examples{
\donttest{#Loading libraries
library(survey)

#Loading the dataset
data(osteoarthritis)

#Multiply imputing the missing values
imputed.datasets <- mice::mice(osteoarthritis, m = 5)

#Weighting the multiply imputed datasets
weighted.datasets <- weightthem(OSP ~ AGE + SEX + BMI + RAC + SMK,
                                imputed.datasets,
                                approach = 'within')

#Adding additional variables
weighted.datasets <- cbind(weighted.datasets,
                           logAGE = log(osteoarthritis$AGE))

#Using the additional variables in an analysis
models <- with(weighted.datasets,
               svyglm(KOA ~ OSP + logAGE, family = quasibinomial))

#Pooling results obtained from analyzing the datasets
results <- pool(models)
summary(results)}
}
\seealso{
\code{\link[=cbind]{cbind()}}
}
\author{
Farhad Pishgar and Noah Greifer
}
