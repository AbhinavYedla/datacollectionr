##################################################
# Get available languages of a Wikipedia page
##################################################
#'
#' @param language
#' Language of wikipedia page
#'
#' @param pageTitle
#' Title of the page to get views
#'
#' @export
#' @return
#' An list with page, page title and language
#'
#' @author
#' Abhinav Yedla \email{abhinavyedla@gmail.com}
#'
#' @examples
#' wp_linked_pages("India")
#'
#' @seealso
#' \code{\link{}}
#'
#' @keywords
#' Wikipedia Page language


if (require("wikipediatrend")) {
  print("wikipediatrend is loaded")
} else {
  print("Trying to install wikipediatrend")
  install.packages("wikipediatrend")
  if (require(wikipediatrend)) {
    print("wikipediatrend installed and loaded")
  } else {
    stop("Could not install wikipediatrend")
  }
}

wikiPageAllLanguages <- function(pageTitle,language = "en"){
  library(wikipediatrend)
  wp_linked_pages(pageTitle,language)
}
