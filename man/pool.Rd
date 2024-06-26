% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pool.R
\name{pool}
\alias{pool}
\title{Pools Estimates by Rubin's Rules}
\usage{
pool(object, dfcom = NULL)
}
\arguments{
\item{object}{An object of the \code{\link{mimira}} class (produced by a previous call to \code{with()}).}

\item{dfcom}{A positive number representing the degrees of freedom in the data analysis. The default is \code{NULL}, which means to extract this information from the fitted model with the lowest number of observations or the first fitted model (when that fails the parameter is set to \code{999999}).}
}
\value{
This function returns an object from the \code{mimipo} class. Methods for \code{mimipo} objects (e.g., \code{print()}, \code{summary()}, etc.) are imported from the \pkg{mice} package.
}
\description{
\code{pool()} pools estimates from the analyses done within each multiply imputed dataset. The typical sequence of steps to do a matching or weighting procedure on multiply imputed datasets are:
\enumerate{
\item Multiply impute the missing values using the \code{mice()} function (from the \pkg{mice} package) or the \code{amelia()} function (from the \pkg{Amelia} package), resulting in a multiply imputed dataset (an object of the \code{mids} or \code{amelia} class);
\item Match or weight each multiply imputed dataset using \code{matchthem()} or \code{weightthem()}, resulting in an object of the \code{mimids} or \code{wimids} class;
\item Check the extent of balance of covariates in the datasets (using functions from the \pkg{cobalt} package);
\item Fit the statistical model of interest on each dataset by the \code{with()} function, resulting in an object of the \code{mimira} class; and
\item Pool the estimates from each model into a single set of estimates and standard errors, resulting in an object of the \code{mimipo} class.
}
}
\details{
\code{pool()} function averages the estimates of the model and computes the total variance over the repeated analyses by Rubin’s rules. It calls \code{\link[mice:pool]{mice::pool()}} after computing the model degrees of freedom.
}
\examples{
\donttest{#Loading libraries
#Loading the dataset
data(osteoarthritis)

#Multiply imputing the missing values
imputed.datasets <- mice::mice(osteoarthritis, m = 5)

#Weighting the multiply imputed datasets
weighted.datasets <- weightthem(OSP ~ AGE + SEX + BMI + RAC + SMK,
                                imputed.datasets,
                                approach = 'within',
                                method = 'glm')

#Analyzing the weighted datasets
models <- with(weighted.datasets,
               WeightIt::glm_weightit(KOA ~ OSP,
                                      family = binomial))

#Pooling results obtained from analyzing the datasets
results <- pool(models)
summary(results)}
}
\references{
Stef van Buuren and Karin Groothuis-Oudshoorn (2011). \code{mice}: Multivariate Imputation by Chained Equations in \code{R}. \emph{Journal of Statistical Software}, 45(3): 1-67. \doi{10.18637/jss.v045.i03}
}
\seealso{
\code{\link[=with]{with()}}

\code{\link[mice:pool]{mice::pool()}}
}
