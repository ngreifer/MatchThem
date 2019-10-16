as2.mids <- function(long, where = NULL, .imp = ".imp", .id = ".id") {

  #Internal function
  #S3 method

  #Based on: The mice::as.mids()
  #URL: <https://cran.r-project.org/package=mice>
  #URL: <https://github.com/stefvanbuuren/mice>
  #URL: <https://cran.r-project.org/web/packages/mice/mice.pdf>
  #URL: <https://www.jstatsoft.org/article/view/v045i03/v45i03.pdf>
  #Authors: Stef van Buuren et al.
  #Changes: Few

  #Importing functions
  #' @importFrom mice mice
  #' @importFrom stats na.omit
  mice::mice
  stats::na.omit

  if (is.numeric(.imp)) .imp <- names(long)[.imp]
  if (is.numeric(.id)) .id <- names(long)[.id]
  if (!.imp %in% names(long)) stop("Imputation index `.imp` not found")

  # no missings allowed in .imp
  imps <- unlist(long[, .imp], use.names = FALSE)
  if (anyNA(imps)) stop("Missing values in imputation index `.imp`")

  # number of records within .imp should be the same
  if (any(diff(table(imps))) != 0)
    stop("Unequal group sizes in imputation index `.imp`")

  # get original data part
  keep <- setdiff(names(long), stats::na.omit(c(.imp, .id)))
  data <- long[imps == 0, keep, drop = FALSE]
  n <- nrow(data)
  if (n == 0)
    stop("Original data not found.\n Use `complete(..., action = 'long', include = TRUE)` to save original data.")

  # determine m
  m <- length(unique(imps)) - 1

  # use mice to get info on data
  if (is.null(where)) where <- is.na(matrix(nrow = n, ncol = length(keep)))
  colnames(where) <- keep

  ini <- mice::mice(data, m = m, where = where, maxit = 0,
                    remove.collinear = FALSE, allow.na = TRUE)

  # store any .id as row names
  if (!is.na(.id))
    rownames(ini$data) <- unlist(long[imps == 0, .id], use.names = FALSE)

  # copy imputations from long into proper ini$imp elements
  names  <- names(ini$imp)
  for (i in seq_along(names)) {
    varname <- names[i]
    if(!is.null(ini$imp[[varname]])) {
      for(j in seq_len(m)) {
        idx <- imps == j & where[, varname]
        ini$imp[[varname]][j] <- long[idx, varname]
      }
    }
  }
  return(ini)
}

barnard2.rubin <- function(m, b, t, dfcom = 999999) {

  #Internal function

  #Based on: The mice:::barnard.rubin()
  #URL: <https://cran.r-project.org/package=mice>
  #URL: <https://github.com/stefvanbuuren/mice>
  #URL: <https://cran.r-project.org/web/packages/mice/mice.pdf>
  #URL: <https://www.jstatsoft.org/article/view/v045i03/v45i03.pdf>
  #Authors: Stef van Buuren et al.
  #Changes: NA

  lambda <- (1 + 1 / m) * b / t
  lambda[lambda < 1e-04] <- 1e-04
  dfold <- (m - 1) / lambda ^ 2
  dfobs <- (dfcom + 1) / (dfcom + 3) * dfcom * (1 - lambda)
  dfold * dfobs / (dfold + dfobs)
}

df.residual.mira <- function(object, ...) {

  #Internal function

  #Based on: The mice:::df.residual()
  #URL: <https://cran.r-project.org/package=mice>
  #URL: <https://github.com/stefvanbuuren/mice>
  #URL: <https://cran.r-project.org/web/packages/mice/mice.pdf>
  #URL: <https://www.jstatsoft.org/article/view/v045i03/v45i03.pdf>
  #Authors: Stef van Buuren et al.
  #Changes: NA

  #Importing functions
  #' @importFrom stats df.residual
  stats::df.residual

  fit <- object$analyses[[1]]
  return(df.residual(fit))
}

match2.data <- function(object, distance = "distance", weights = "weights", subclass = "subclass",
                        environment = environment()) {

  #Internal function

  #Based on: The MatchIt::match.data()
  #URL: <https://cran.r-project.org/package=MatchIt>
  #URL: <https://github.com/kosukeimai/MatchIt>
  #URL: <https://cran.r-project.org/web/packages/MatchIt/MatchIt.pdf>
  #URL: <https://imai.fas.harvard.edu/research/files/matchit.pdf>
  #Authors: Daniel Ho et al.
  #Changes: Few

  #Polishing variables
  data <- eval(object$call$data, envir = environment)
  treat <- object$treat
  wt <- object$weights
  vars <- names(data)

  #Binding the distance variable
  if (distance %in% vars)
    stop("The input for the datasets shouldn't have a variable named as 'distance'.")
  else if (!is.null(object$distance)) {
    dta <- data.frame(cbind(data, object$distance))
    names(dta) <- c(names(data), distance)
    data <- dta
  }

  #Binding the weights variable
  if (weights %in% vars)
    stop("The input for the datasets shouldn't have a variable named as 'weights'.")
  else if (!is.null(object$weights)){
    dta <- data.frame(cbind(data, object$weights))
    names(dta) <- c(names(data), weights)
    data <- dta
  }

  #Binding the subclass variable
  if (subclass %in% vars)
    stop("The input for the datasets shouldn't have a variable named as 'subclass'.")
  else if (!is.null(object$subclass)){
    dta <- data.frame(cbind(data, object$subclass))
    names(dta) <- c(names(data), subclass)
    data <- dta
  }

  #Returning output
  return(data[wt > 0,])
}

pool2.fitlist <- function (fitlist, dfcom = NULL) {

  #Internal function
  #S3 method

  #Based on: The mice:::pool.fitlist()
  #URL: <https://cran.r-project.org/package=mice>
  #URL: <https://github.com/stefvanbuuren/mice>
  #URL: <https://cran.r-project.org/web/packages/mice/mice.pdf>
  #URL: <https://www.jstatsoft.org/article/view/v045i03/v45i03.pdf>
  #Authors: Stef van Buuren et al.
  #Changes: Few

  #Importing functions
  #' @importFrom dplyr mutate
  #' @importFrom dplyr group_by
  #' @importFrom dplyr summarize
  #' @importFrom dplyr select
  #' @importFrom dplyr %>%
  #' @importFrom mice getfit
  #' @importFrom stats sd
  #' @importFrom stats var
  dplyr::mutate
  dplyr::group_by
  dplyr::summarize
  dplyr::select
  dplyr::`%>%`
  mice::getfit
  stats::sd
  stats::var

  #Preparing the summary
  w <- summary(fitlist, type = "tidy", exponentiate = FALSE)

  #Combine y.level and term into term (for multinom)
  if ("y.level" %in% names(w)) w$term <- paste(w$y.level, w$term, sep = ":")

  #Address the problem with checking in an unusual way, just to keep the original codes of the mice package
  .data <- NULL
  b <- NULL
  df <- NULL
  m <- NULL
  param <- NULL
  riv <- NULL
  term <- NULL
  ubar <- NULL

  #Rubin's rules for scalar estimates
  output <- w %>%
    dplyr::mutate(param = rep_len(1L:length(unique(term)), length.out = dplyr::n())) %>%
    dplyr::group_by(param) %>%
    dplyr::summarize(m = dplyr::n(),
                     term = .data$term[1L],
                     qbar = mean(.data$estimate),
                     ubar = mean(.data$std.error ^ 2),
                     b = stats::var(.data$estimate),
                     t = ubar + (1 + 1 / m) * b,
                     dfcom = dfcom,
                     df = barnard2.rubin(m, b, t, dfcom),
                     riv = (1 + 1 / m) * b / ubar,
                     lambda = (1 + 1 / m) * b / t,
                     fmi = (riv + 2 / (df + 3)) / (riv + 1)) %>%
    dplyr::select(-m, -param)
  output <- data.frame(output[, -1L],
                       row.names = output$term)
  names(output)[1L] <- "estimate"

  #Return the output
  return(output)
}