# Canonical OI ggplot style.
# Fonts, colors, and sizes from:
#   scheme-opp_insights_nontech.scheme
#   temp_event_study.do   (graph set svg fontface "Lucida Sans";
#                          xsize(17) ysize(9); gs10 axes; 22pt inside legend)
#
# Stata relativesize is a percent of min(xsize, ysize), not a point size.
# The scheme page is 8 x 5 in, so the short side is 5 in. The do file's
# 17 x 9 slide uses the same percentages, which only become ~24 pt because
# the page is 9 in tall. ggplot stores points absolutely, so using that
# 24 pt (and the 63 pt vhuge title) on a normal SVG makes the type too big.
# Sizes below are those same percentages of the scheme's 5 in short side.
# The do-file legend is an absolute 22 pt on the 9 in slide, scaled by 5/9.

#' @export
OI_FONT <- "Lucida Sans"

#' Slide size used by the event-study do file (inches).
#' @export
OI_WIDTH <- 17
#' @export
OI_HEIGHT <- 9

# scheme p1-p14. "*0.50" lightens toward white: rgb * 0.5 + 255 * 0.5.
.oi_rgb <- function(r, g, b) rgb(r, g, b, maxColorValue = 255)
.oi_intensity <- function(r, g, b, intensity) {
  .oi_rgb(
    round(r * intensity + 255 * (1 - intensity)),
    round(g * intensity + 255 * (1 - intensity)),
    round(b * intensity + 255 * (1 - intensity))
  )
}

#' The OI color palette (scheme p1-p14)
#' @export
OI_COLORS <- c(
  .oi_rgb(41, 182, 164),            # p1
  .oi_rgb(250, 165, 35),            # p2
  .oi_rgb(0, 58, 79),               # p3
  .oi_rgb(133, 198, 255),           # p4
  .oi_rgb(167, 29, 49),             # p5
  .oi_rgb(19, 83, 75),              # p6
  .oi_rgb(180, 109, 4),             # p7
  .oi_rgb(234, 133, 148),           # p8
  .oi_rgb(255, 212, 0),             # p9
  .oi_rgb(107, 189, 69),            # p10
  .oi_intensity(41, 182, 164, 0.5), # p11
  .oi_intensity(229, 64, 96, 0.5),  # p12
  .oi_rgb(0, 58, 79),               # p13
  .oi_rgb(229, 64, 96)              # p14
)

# gs10 / gs12 from the do file (axis lines, ticks, enrollment shade)
OI_GS10 <- .oi_rgb(160, 160, 160)
OI_GS12 <- .oi_rgb(192, 192, 192)
OI_SHADE <- ggplot2::alpha(OI_GS12, 0.40) # gs12%40

# Scheme graphsize is x = 8, y = 5, so the short side is 5 in.
OI_REF_IN <- 5

.oi_pt <- function(rel) rel / 100 * OI_REF_IN * 72
.oi_mm <- function(pt) pt * 25.4 / 72

OI_SIZE_AXIS <- .oi_pt(3.7)          # axis title and tick labels, ~13 pt
OI_SIZE_TITLE <- .oi_pt(9.7222)      # heading vhuge, ~35 pt
OI_SIZE_LEGEND <- 22 * (OI_REF_IN / OI_HEIGHT) # 22 pt on the 9 in slide, ~12 pt
OI_SIZE_SMALL <- .oi_pt(2.777)       # gsize small (in-plot italic notes)
OI_LW_AXIS <- .oi_mm(.oi_pt(0.15))   # linewidth vthin
OI_LW_LINE <- .oi_mm(.oi_pt(0.45))   # linewidth medthick
OI_PT_SIZE <- .oi_mm(.oi_pt(1.25))   # symbolsize medsmall
OI_TICK_PT <- .oi_pt(1.3888)         # gsize tick tiny
OI_TITLE_GAP <- .oi_pt(1.3888 + 1)   # axis_title_gap tiny + margin(+1)
OI_LEGEND_ROWGAP <- .oi_pt(1.2)      # rowgap(small)
OI_LEGEND_TMARGIN <- .oi_pt(-3)      # bmargin(t-3)

#' @export
scale_color_oi <- function(...) scale_color_manual(values = OI_COLORS, ...)

#' @export
scale_fill_oi <- function(...) scale_fill_manual(values = OI_COLORS, ...)

#' ggplot clone of the OI Stata scheme
#'
#' @param high_contrast Black text when TRUE. FALSE uses the softer gray text
#'   from the previous oi_style.
#' @param font SVG fontface from the do file. On this Mac the installed Lucida
#'   face is "Lucida Grande"; pass that if "Lucida Sans" is not registered.
#' @param ... extra arguments passed to [ggplot2::theme], so
#'   `theme_oi(legend.position = "bottom")` still works.
#' @export
theme_oi <- function(high_contrast = TRUE, font = OI_FONT, ...) {
  colors <- list(
    titles = ifelse(high_contrast, "black", "#222222"),
    axes = ifelse(high_contrast, "black", "#747577"),
    line = ifelse(high_contrast, OI_GS10, "#747577")
  )

  ggplot2::`%+replace%`(
    ggplot2::theme_classic(base_family = font, base_size = OI_SIZE_AXIS),
    ggplot2::theme(
      text = ggplot2::element_text(family = font, color = "black"),
      plot.title = ggplot2::element_text(
        family = font,
        size = OI_SIZE_TITLE,
        color = colors$titles,
        hjust = 0.5,
        margin = ggplot2::margin(b = 15)
      ),
      plot.subtitle = ggplot2::element_text(
        family = font,
        size = OI_SIZE_AXIS,
        color = colors$titles,
        hjust = 0.5,
        margin = ggplot2::margin(t = -9, b = 16)
      ),
      legend.position = "inside",
      legend.position.inside = c(0.02, 0.98),
      legend.justification = c(0, 1),
      legend.justification.inside = c(0, 1),
      legend.background = ggplot2::element_blank(),
      legend.box.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(
        family = font,
        size = OI_SIZE_LEGEND,
        color = colors$titles
      ),
      legend.margin = ggplot2::margin(t = OI_LEGEND_TMARGIN, unit = "pt"),
      legend.spacing.y = grid::unit(OI_LEGEND_ROWGAP, "pt"),
      axis.title = ggplot2::element_text(
        family = font,
        size = OI_SIZE_AXIS,
        color = colors$axes
      ),
      axis.text = ggplot2::element_text(
        family = font,
        size = OI_SIZE_AXIS,
        color = colors$axes
      ),
      axis.text.x = ggplot2::element_text(angle = 0, hjust = 0.5),
      axis.ticks = ggplot2::element_line(color = colors$line, linewidth = OI_LW_AXIS),
      axis.ticks.length = grid::unit(OI_TICK_PT, "pt"),
      axis.line = ggplot2::element_line(color = colors$line, linewidth = OI_LW_AXIS),
      panel.grid = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      # graph margin "2 2 5 7" is left, right, bottom, top
      plot.margin = ggplot2::margin(
        t = .oi_pt(7), r = .oi_pt(2), b = .oi_pt(5), l = .oi_pt(2),
        unit = "pt"
      ),
      axis.title.x = ggplot2::element_text(
        hjust = 0.5,
        margin = ggplot2::margin(t = OI_TITLE_GAP)
      ),
      axis.title.y = ggplot2::element_text(
        angle = 90,
        vjust = 0.5,
        margin = ggplot2::margin(r = OI_TITLE_GAP)
      ),
      strip.text = ggplot2::element_text(
        family = font, size = OI_SIZE_AXIS, hjust = 0, color = "black"
      )
    )
  ) + ggplot2::theme(...)
}

expand_axis <- function(ymin = 0, expand = c(0, 0)) {
  list(
    scale_y_continuous(limits = c(ymin, NA), expand = expand),
    scale_x_continuous(expand = expand)
  )
}

#' Use the OI theme and color palette for all plots generated in this session
#'
#' @param ... args to pass to `theme_oi`
#' @export
set_oi_theme <- function(...) {
  ggplot2::theme_set(theme_oi(...))

  ggplot2::update_geom_defaults("point", list(
    colour = OI_COLORS[1], size = OI_PT_SIZE
  ))
  ggplot2::update_geom_defaults("line", list(
    colour = OI_COLORS[1], linewidth = OI_LW_LINE
  ))
  ggplot2::update_geom_defaults("smooth", list(colour = OI_COLORS[1]))

  options(
    ggplot2.discrete.colour = OI_COLORS,
    ggplot2.discrete.fill = OI_COLORS
  )
}

#' @export
oi_style <- function(...) {
  .Deprecated("theme_oi")
  theme_oi(...)
}

#' @export
set_oi_palette <- function(...) {
  .Deprecated("set_oi_theme")
  set_oi_theme(...)
}
