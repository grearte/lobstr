% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/size.R
\name{obj_size}
\alias{obj_size}
\alias{obj_sizes}
\title{Calculate the size of an object.}
\usage{
obj_size(..., env = parent.frame())

obj_sizes(..., env = parent.frame())
}
\arguments{
\item{...}{Set of objects to compute size.}

\item{env}{Environment in which to terminate search. This defaults to the
current environment so that you don't include the size of objects that
are already stored elsewhere.}
}
\value{
An estimate of the size of the object, in bytes.
}
\description{
\code{obj_size()} computes the size of an object or set of objects;
\code{obj_sizes()} breaks down the individual contribution of multiple objects
to the total size.
}
\section{Compared to \code{object.size()}}{

Compared to \code{\link[=object.size]{object.size()}}, \code{obj_size()}:
\itemize{
\item Accounts for all types of shared values, not just strings in
the global string pool.
\item Includes the size of environments (up to \code{env})
\item Accurately measures the size of ALTREP objects.
}
}

\section{Environments}{

\code{obj_size()} attempts to take into account the size of the
environments associated with an object. This is particularly important
for closures and formulas, since otherwise you may not realise that you've
accidentally captured a large object. However, it's easy to over count:
you don't want to include the size of every object in every environment
leading back to the \code{\link[=emptyenv]{emptyenv()}}. \code{obj_size()} takes
a heuristic approach: it never counts the size of the global env,
the base env, the empty env, or any namespace.

Additionally, the \code{env} argument allows you to specify another
environment at which to stop. This defaults to the environment from which
\code{obj_size()} is called to prevent double-counting of objects created
elsewhere.
}

\examples{
# obj_size correctly accounts for shared references
x <- runif(1e4)
obj_size(x)

z <- list(a = x, b = x, c = x)
obj_size(z)

# this means that object size is not transitive
obj_size(x)
obj_size(z)
obj_size(x, z)

# use obj_size() to see the unique contribution of each component
obj_sizes(x, z)
obj_sizes(z, x)
obj_sizes(!!!z)

# obj_size() also includes the size of environments
f <- function() {
  x <- 1:1e4
  a ~ b
}
obj_size(f())

#' # In R 3.5 and greater, `:` creates a special "ALTREP" object that only
# stores the first and last elements. This will make some vectors much
# smaller than you'd otherwise expect
obj_size(1:1e6)
}
