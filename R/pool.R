#' @title Combines Estimates by Rubin’s Rules
#'
#' @aliases pool
#'
#' @rdname pool
#'
#' @param object This argument specifies an object of the \code{mira} class (produced by a previous call to \code{with()} function) or a list with model fits.
#' @param dfcom This argument specifies a positive number representing the degrees of freedom in the complete data analysis. The default is \code{NULL}, which means to extract this information from the first fitted model or the fitted model with the lowest number of observations (when that fails the warning \code{Large sample assumed} is printed and the parameter is set to \code{999999}).
#'
#' @description The \code{pool()} function combines the estimates from \code{n} repeated complete data analyses. The typical sequence of steps to do a matching procedure on the imputed datasets are:
#' \enumerate{
#'  \item Impute the missing values by the \code{mice} function (from the \pkg{mice} package), resulting in a multiple imputed dataset (an object of the \code{mids} class);
#'  \item Match each imputed dataset using a matching model by the \code{matchthem()} function, resulting in an object of the \code{mimids} class;
#'  \item Fit the statistical model of interest on each matched dataset by the \code{with()} function, resulting in an object of the \code{mira} class;
#'  \item Pool the estimates from each model into a single set of estimates and standard errors, resulting in an object of the \code{mipo} class.
#' }
#'
#' @details The \code{pool()} function averages the estimates of the complete data model and computes the total variance over the repeated analyses by Rubin’s rules.
#'
#' @return This function returns an object of the \code{mipo} class (multiple imputation pooled outcome).
#'
#' @seealso \code{\link[=with]{with}}
#'
#' @author Extracted from the \pkg{mice} package written by Stef van Buuren et al. with few changes
#'
#' @references Stef van Buuren and Karin Groothuis-Oudshoorn (2011). \code{mice}: Multivariate Imputation by Chained Equations in \code{R}. \emph{Journal of Statistical Software}, 45(3): 1-67. \url{https://www.jstatsoft.org/v45/i03/}
#'
#' @export
#'
#' @examples
#' \donttest{
#' #Loading the dataset
#' data(osteoarthritis)
#'
#' #Multiply imputing the missing values
#' imputed.datasets <- mice(osteoarthritis, m = 5, maxit = 10,
#'                          method = c("", "", "", "mean", "polyreg", "logreg", "logreg", "logreg"))
#'
#' #Matching the multiply imputed datasets
#' matched.datasets <- matchthem(OSP ~ AGE + SEX + BMI + RAC + SMK, imputed.datasets,
#'                               approach = 'within', method = 'nearest')
#'
#' #Analyzing the matched datasets
#' models <- with(data = matched.datasets,
#'                exp = glm(KOA ~ OSP, family = binomial))
#'
#' #Pooling results obtained from analysing the datasets
#' pool(models)
#' }

pool <- function (object, dfcom = NULL) {

  #External function

  #Based on: The mice::pool()
  #URL: <https://cran.r-project.org/package=mice>
  #URL: <https://github.com/stefvanbuuren/mice>
  #URL: <https://cran.r-project.org/web/packages/mice/mice.pdf>
  #URL: <https://www.jstatsoft.org/article/view/v045i03/v45i03.pdf>
  #Authors: Stef van Buuren et al.
  #Changes: Few

  #Importing functions
  #' @importFrom mice pool
  #' @importFrom mice getfit
  #' @importFrom stats sd
  mice::pool
  mice::getfit
  stats::sd
  #' @export

  #Handling unequal dfs
  if (is.null(dfcom) & sd(summary(getfit(object), type = "glance")$df.residual) != 0) dfcom <- min(summary(getfit(object), type = "glance")$df.residual)

  #Returning output
  output <- mice::pool(object, dfcom = dfcom)
  return(output)
}