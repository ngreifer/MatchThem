% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/with.R
\name{with}
\alias{with}
\alias{with.mimids}
\alias{with.wimids}
\title{Evaluates an Expression in Matched or Weighted Multiply Imputed Datasets}
\usage{
\method{with}{mimids}(data, expr, cluster, ...)

\method{with}{wimids}(data, expr, ...)
}
\arguments{
\item{data}{A \code{mimids} or \code{wimids} object, typically produced by a previous call to the \code{\link[=matchthem]{matchthem()}} or \code{\link[=weightthem]{weightthem()}}.}

\item{expr}{An expression (usually a call to a modeling function like \code{glm()}, \code{coxph()}, \code{svyglm()}, etc.) to evaluate in each (matched or weighted) multiply imputed dataset. See Details.}

\item{cluster}{When a function from \pkg{survey} (e.g., \code{\link[survey:svyglm]{survey::svyglm()}}) is supplied in \code{expr}, whether the standard errors should incorporate clustering due to dependence between matched pairs. This is done by supplying the variable containing pair membership to the \code{ids} argument of \code{\link[survey:svydesign]{survey::svydesign()}}. If unspecified, it will be set to \code{TRUE} if subclasses (i.e., pairs) are present in the output and there are 20 or more unique subclasses. It will be ignored for matching methods that don't return subclasses (e.g., matching with replacement).}

\item{...}{Additional arguments to be passed to \code{expr}.}
}
\value{
An object from the \code{mimira} class containing the output of the analyses.
}
\description{
\code{with()} runs a model on the \code{n} multiply imputed datasets of the supplied \code{mimids} or \code{wimids} object. The typical sequence of steps to do a matching or weighting procedure on multiply imputed datasets are:
\enumerate{
\item Multiply impute the missing values using the \code{mice()} function (from the \pkg{mice} package) or the \code{amelia()} function (from the \pkg{Amelia} package), resulting in a multiply imputed dataset (an object of the \code{mids} or \code{amelia} class);
\item Match or weight each multiply imputed dataset using \code{matchthem()} or \code{weightthem()}, resulting in an object of the \code{mimids} or \code{wimids} class;
\item Check the extent of balance of covariates in the datasets (using functions from the \pkg{cobalt} package);
\item Fit the statistical model of interest on each dataset by the \code{with()} function, resulting in an object of the \code{mimira} class; and
\item Pool the estimates from each model into a single set of estimates and standard errors, resulting in an object of the \code{mimipo} class.
}
}
\details{
\code{with()} applies the supplied model in \code{expr} to the (matched or weighted) multiply imputed datasets, automatically incorporating the (matching) weights when possible. The argument to \code{expr} should be of the form \code{glm(y ~ z, family = quasibinomial)}, for example, excluding the data or weights argument, which are automatically supplied.

Functions from the \pkg{survey} package, such as \code{svyglm()}, are treated a bit differently. No \code{svydesign} object needs to be supplied because \code{with()} automatically constructs and supplies it with the imputed dataset and estimated weights. When \code{cluster = TRUE} (or \code{with()} detects that pairs should be clustered; see the \code{cluster} argument above), pair membership is supplied to the \code{ids} argument of \code{svydesign()}.

After weighting using \code{weightthem()}, \code{glm_weightit()} and related functions in \pkg{WeightIt} should be used as the modeling functions to fit outcome models. They correctly produce robust standard errors that account for estimation of the weights, if possible. See \code{\link[WeightIt:glm_weightit]{WeightIt::glm_weightit()}} for details. Otherwise, \code{\link[survey:svyglm]{survey::svyglm()}} and other functions in \pkg{survey} (e.g., \code{\link[survey:svycoxph]{survey::svycoxph()}}) should be used rather than \code{glm()} in order to correctly compute standard errors.
}
\examples{
\donttest{#Loading libraries
library(survey)

#Loading the dataset
data(osteoarthritis)

#Multiply imputing the missing values
imputed.datasets <- mice::mice(osteoarthritis, m = 5)

#Matching in the multiply imputed datasets
matched.datasets <- matchthem(OSP ~ AGE + SEX + BMI + RAC + SMK,
                              imputed.datasets,
                              approach = 'within',
                              method = 'nearest')

#Analyzing the matched datasets
models <- with(matched.datasets,
               svyglm(KOA ~ OSP, family = binomial),
               cluster = TRUE)

#Weghting in the multiply imputed datasets
weighted.datasets <- weightthem(OSP ~ AGE + SEX + BMI + RAC + SMK,
                               imputed.datasets,
                               approach = 'within',
                               method = 'glm')

#Analyzing the matched datasets
models <- with(weighted.datasets,
               WeightIt::glm_weightit(KOA ~ OSP,
                                      family = binomial))
}
}
\references{
Stef van Buuren and Karin Groothuis-Oudshoorn (2011). \code{mice}: Multivariate Imputation by Chained Equations in \code{R}. \emph{Journal of Statistical Software}, 45(3): 1-67. \doi{10.18637/jss.v045.i03}
}
\seealso{
\code{\link[=matchthem]{matchthem()}}

\code{\link[=weightthem]{weightthem()}}

\code{\link[mice:with.mids]{mice::with.mids()}}
}
\author{
Farhad Pishgar and Noah Greifer
}
