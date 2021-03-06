% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/std_b.R
\name{std_beta}
\alias{std_beta}
\title{Standardized Beta coefficients and CI of lm and mixed models}
\usage{
std_beta(fit, include.ci = FALSE, type = "std")
}
\arguments{
\item{fit}{Fitted linear (mixed) model of class \code{\link{lm}} or
\code{\link[lme4]{merMod}} (\pkg{lme4} package).}

\item{include.ci}{Logical, if \code{TRUE}, a data frame with confidence
intervals will be returned, when \code{fit} is of class \code{lm}.
If \code{fit} is a \code{lmerMod} object (\pkg{lme4} package),
always returns standard error instead of confidence intervals
(hence, this parameter will be ignored when \code{fit} is a
\code{lmerMod} object).}

\item{type}{If \code{fit} is of class \code{lm}, normal standardized coefficients
are computed by default. Use \code{type = "std2"} to follow
\href{http://www.stat.columbia.edu/~gelman/research/published/standardizing7.pdf}{Gelman's (2008)}
suggestion, rescaling the estimates by deviding them by two standard
deviations, so resulting coefficients are directly comparable for
untransformed binary predictors.}
}
\value{
A vector with standardized beta coefficients of the fitted linear model, or a data frame
          with standardized beta coefficients and confidence intervals, if
          \code{include.ci = TRUE}.
}
\description{
Returns the standardized beta coefficients and confidence intervals
               of a fitted linear (mixed) models, i.e. \code{fit} must either
               be of class \code{lm} or \code{\link[lme4]{merMod}}.
}
\details{
"Standardized coefficients refer to how many standard deviations a dependent variable will change,
        per standard deviation increase in the predictor variable. Standardization of the coefficient is
        usually done to answer the question of which of the independent variables have a greater effect
        on the dependent variable in a multiple regression analysis, when the variables are measured
        in different units of measurement (for example, income measured in dollars and family size
        measured in number of individuals)." (Source: Wikipedia)
}
\note{
For \code{\link[nlme]{gls}}-objects, standardized beta coefficients may be wrong
        for categorical variables (\code{factors}), because the \code{model.matrix} for
        \code{gls} objects returns the original data of the categorical vector,
        and not the 'dummy' coded vectors as for other classes. See, as example: \cr \cr
        \code{head(model.matrix(lm(neg_c_7 ~ as.factor(e42dep), data = efc, na.action = na.omit)))}
        \cr \cr and \cr \cr
        \code{head(model.matrix(nlme::gls(neg_c_7 ~ as.factor(e42dep), data = efc, na.action = na.omit)))}.
        \cr \cr
        In such cases, use \code{\link{to_dummy}} to create dummies from
        factors.
}
\examples{
# fit linear model
fit <- lm(Ozone ~ Wind + Temp + Solar.R, data = airquality)
# print std. beta coefficients
std_beta(fit)

# print std. beta coefficients and ci
std_beta(fit, include.ci = TRUE)

# print std. beta coefficients and ci, using
# 2 sd and center binary predictors
std_beta(fit, include.ci = TRUE, type = "std2")

}
\references{
\itemize{
             \item \href{http://en.wikipedia.org/wiki/Standardized_coefficient}{Wikipedia: Standardized coefficient}
             \item Gelman A (2008) "Scaling regression inputs by dividing by two standard deviations." \emph{Statistics in Medicine 27: 2865–2873.} \url{http://www.stat.columbia.edu/~gelman/research/published/standardizing7.pdf}
             }
}

