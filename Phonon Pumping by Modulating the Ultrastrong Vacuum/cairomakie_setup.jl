# A0 format for the poster
mm_to_pt = 2.83465
plot_figsize_width_pt = 841 * mm_to_pt
plot_figsize_height_pt = 1189 * mm_to_pt

my_theme_Cairo = Theme(
    fontsize=32,
    figure_padding=(0, 0, 0, 0),
    size=(plot_figsize_width_pt, plot_figsize_height_pt),
    Axis=(
        spinewidth=0.7,
        xgridvisible=false,
        ygridvisible=false,
        xtickwidth=0.75,
        ytickwidth=0.75,
        xminortickwidth=0.5,
        yminortickwidth=0.5,
        xticksize=3,
        yticksize=3,
        xminorticksize=1.5,
        yminorticksize=1.5,
        xlabelpadding=1,
        ylabelpadding=1,
    ),
    Legend=(
        merge=true,
        framevisible=false,
        patchsize=(15, 2),
    ),
    Lines=(
        linewidth=1.6,
    ),
)
my_theme_Cairo = merge(my_theme_Cairo, theme_latexfonts())

CairoMakie.set_theme!(my_theme_Cairo)
CairoMakie.activate!(type="svg", pt_per_unit=1)
CairoMakie.enable_only_mime!(MIME"image/svg+xml"())

# --------------- Colors ---------------

const COLOR_EPFL = colorant"#c73727"

# --------------- Constants ---------------

const TOP_BOX_HEIGHT = 100
const BOTTOM_BOX_HEIGHT = 50

const TITLE_FONT_SIZE = 92
const AUTHOR_FONT_SIZE = 58
const AFFILIATION_FONT_SIZE = 48
const CONTENT_TITLE_FONT_SIZE = 48
const CONTENT_BODY_FONT_SIZE = 42

const TITLE_BACKGROUND_COLOR = :transparent
const TITLE_STROKE_WIDTH = 12
const TITLE_CORNER_RADIUS = 50
const CONTENT_BACKGROUND_COLOR = :transparent
const CONTENT_STROKE_WIDTH = 10
const CONTENT_CORNER_RADIUS = 50

# --------------- Functions ---------------

function make_content_box!(grid_layout, title)
    grid_layout2 = GridLayout(grid_layout)
    grid_content_title = GridLayout(grid_layout2[1, 1], alignmode=Outside(0, 0, 80, 0), tellwidth=false) # We shift it to overlap with the content box
    grid_content_main = GridLayout(grid_layout2[2, 1], alignmode=Outside(40, 40, 50, 0)) # We shift it to create some padding with the inner content

    Box(grid_layout, color=CONTENT_BACKGROUND_COLOR, strokecolor=COLOR_EPFL, strokewidth=CONTENT_STROKE_WIDTH, cornerradius = CONTENT_CORNER_RADIUS)

    Box(grid_content_title[1, 1], color=:white, strokevisible=false)
    Label(grid_content_title[1, 1], title, color = COLOR_EPFL, fontsize=CONTENT_TITLE_FONT_SIZE, font=:bold, padding=(60, 60, 0, 0))

    rowgap!(grid_layout2, 0)
    rowsize!(grid_layout2, 1, Fixed(80))

    return grid_content_main
end
