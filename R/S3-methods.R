#' @importFrom nlme getData getCovariateFormula
#' @export
model.matrix.gls <- function(object, ...) {
  mm <- cbind(`(Intercept)` = 1,
              nlme::getData(object)[, all.vars(nlme::getCovariateFormula(object))])
  return(mm)
}

#' @importFrom nlme getResponse getData getCovariateFormula
#' @export
model.frame.gls <- function(formula, ...) {
  if (all(class(formula) != "gls")) {
    stop("`formula` needs to be an object of class `gls`.", call. = F)
    return(NULL)
  } else {
    y <- nlme::getResponse(formula)
    mf <- cbind(y, nlme::getData(formula)[, all.vars(nlme::getCovariateFormula(formula))])
    colnames(mf)[1] <- sjmisc::get_label(y, def.value = "Response")
    return(mf)
  }
}

#' @export
print.sjstats_r2 <- function(x, ...) {
  if (length(x) > 1) {
    if (identical(names(x[[2]]), "Nagelkerke")) {
      s1 <- "Cox & Snell's R-squared"
      s2 <- "Nagelkerke's R-squared"
    } else if (identical(names(x[[2]]), "adj.R2")) {
      s1 <- "R-squared"
      s2 <- "adjusted R-squared"
    } else if (identical(names(x[[2]]), "O2")) {
      s1 <- "R-squared"
      s2 <- "Omega-squared"
    } else if (identical(names(x[[2]]), "R2(tau-11)")) {
      s1 <- "R-squared (tau-00)"
      s2 <- "R-squared (tau-11)"
    } else {
      return(NULL)
    }
    cat(sprintf("%s: %.4f; %s: %.4f\n", s1, x[[1]], s2, x[[2]]))
  } else {
    if (identical(names(x[[1]]), "D")) {
      s1 <- "Tjur's D"
    } else {
      return(NULL)
    }
    cat(sprintf("%s: %.4f\n", s1, x[[1]]))
  }
}


#' @export
print.icc.lme4 <- function(x, comp, ...) {
  # print model information
  cat(sprintf("%s\n Family: %s (%s)\nFormula: %s\n\n",
              attr(x, "model", exact = T),
              attr(x, "family", exact = T),
              attr(x, "link", exact = T),
              paste(as.character(attr(x, "formula"))[c(2, 1, 3)], collapse = " ")))
  if (!missing(comp) && !is.null(comp) && comp == "var") {
    # get parameters
    tau.00 <- attr(x, "tau.00", exact = TRUE)
    tau.01 <- attr(x, "tau.01", exact = TRUE)
    tau.11 <- attr(x, "tau.11", exact = TRUE)
    rho.01 <- attr(x, "rho.01", exact = TRUE)
    # print within-group-variance sigma^2
    tmp <- sprintf("%.3f", attr(x, "sigma_2", exact = TRUE))
    cat(sprintf("      Within-group-variance: %8s\n", tmp))
    # print between-group-variance tau00
    for (i in 1:(length(tau.00))) {
      tmp <- sprintf("%.3f", tau.00[i])
      cat(sprintf("     Between-group-variance: %8s (%s)\n",
                  tmp, names(tau.00)[i]))
    }
    # print random-slope-variance tau11
    for (i in 1:length(tau.11)) {
      tau.rs <- tau.11[i]
      # any random slope?
      if (!sjmisc::is_empty(tau.rs)) {
        tmp <- sprintf("%.3f", tau.rs)
        cat(sprintf("      Random-slope-variance: %8s (%s)\n",
                    tmp, names(tau.rs)))
      }
    }
    # print random-slope-covariance tau01
    for (i in 1:length(tau.01)) {
      tau.rs <- tau.01[i]
      # any random slope?
      if (!sjmisc::is_empty(tau.rs)) {
        tmp <- sprintf("%.3f", tau.rs)
        cat(sprintf(" Slope-Intercept-covariance: %8s (%s)\n",
                    tmp, names(tau.rs)))
      }
    }
    # print random-slope-correlation rho01
    for (i in 1:length(rho.01)) {
      rho.rs <- rho.01[i]
      # any random slope?
      if (!sjmisc::is_empty(rho.rs)) {
        tmp <- sprintf("%.3f", rho.rs)
        cat(sprintf("Slope-Intercept-correlation: %8s (%s)\n",
                    tmp, names(rho.rs)))
      }
    }
  } else {
    # get longest rand. effect name
    len <- max(nchar(names(x)))
    # print icc
    for (i in 1:length(x)) {
      # create info string
      infs <- sprintf("ICC (%s)", names(x[i]))
      # print info line, formatting all ICC values so they're
      # aligned properly
      cat(sprintf("%*s: %f\n",
                  len + 8,
                  infs,
                  as.vector(x[i])))
    }
  }
}
