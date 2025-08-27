ENV["PATH"] *= ":/Library/TeX/texbin" # Needed on MacOS

using CairoMakie
using MakieTeX

include("cairomakie_setup.jl")

mkpath(joinpath(@__DIR__, "figures"))

latex_preamble = raw"""
\usepackage{amsmath}
\usepackage{physics}
\usepackage{fix-cm} % Allows arbitrary font sizes for Computer Modern
"""

# %%
title_text = "Renormalization and Low-Energy Effective Models \n in Cavity and Circuit QED"

authors_text = "Daniele Lamberto, Alberto Mercurio, Omar Di Stefano, \n Vincenzo Savona and Salvatore Savasta"

affiliations_text = [
    "École Polytechnique Fédérale de Lausanne (EPFL), Lausanne, Switzerland",
    "Università degli Studi di Messina, Messina, Italy"
]

# %%

fig = Figure()

grid_top = fig[1, 1]

grid_title = GridLayout(fig[2, 1], tellwidth=false)
grid_authors = grid_title[2, 1]
grid_affiliations = GridLayout(grid_title[3, 1])

grid_content = GridLayout(fig[3, 1], alignmode=Outside(30, 30, 10, 90), tellheight=false, valign=:top)
left_column = GridLayout(grid_content[1, 1], valign=:top)
right_column = GridLayout(grid_content[1, 2], valign=:top)

grid_bottom = fig[4, 1]

# ----------- Top and Bottom ------------

top_box = Box(grid_top, color=COLOR_EPFL, strokevisible=false, height=TOP_BOX_HEIGHT)

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/header.pdf")))
LTeX(grid_top, pdf_doc, tellwidth=false, tellheight=true)

bottom_box = Box(grid_bottom, color=COLOR_EPFL, strokevisible=false, height=BOTTOM_BOX_HEIGHT)

# ----------- Title ------------

Label(grid_title[1, 1], title_text, fontsize=TITLE_FONT_SIZE)
Label(grid_authors, authors_text, fontsize=AUTHOR_FONT_SIZE)
for (i, affiliation) in enumerate(affiliations_text)
    Label(grid_affiliations[i, 1], affiliation, fontsize=AFFILIATION_FONT_SIZE, font=:italic)
end
title_box = Box(grid_title[1:3, 1], alignmode = Outside(-70, -70, -50, -100), color=TITLE_BACKGROUND_COLOR, strokecolor=COLOR_EPFL, strokewidth=TITLE_STROKE_WIDTH, cornerradius = TITLE_CORNER_RADIUS)

translate!(title_box.blockscene, 0, 0, -100)

# ----------- Content ------------

# ----------- ### The Quantum Rabi Model ### ------------

grid_content_main = make_content_box!(left_column[1, 1], "The Quantum Rabi Model")

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/Renormalized_QRM_sketch.pdf")));
LTeX(grid_content_main[1, 1], pdf_doc, scale=2, alignmode = Outside(0, 0, 60, 40), tellwidth=false)
Label(grid_content_main[1, 2], "A single electron in a one-dimensional potential, interacting with a cavity mode. (a), Standard procedure for obtaining the QRM from the full Hamiltonian. (b), Renormalization of the QRM, which takes into account the interaction of photons with the higher-energy atomic levels.", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

# ----------- ### The Model ### ------------

grid_content_main = make_content_box!(left_column[2, 1], "The Model")

Label(grid_content_main[1, 1], "The full system is described by the following Hamiltonian", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

hamiltonian = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
    \label{eq:H_full_D}
    \hat H_{\rm D} =& \ \frac{\hat p^2}{2 m} + V(\hat x) + \hbar \omega_c \hat{a}^\dagger \hat{a} - i q \omega_c A_0 \hat x \left( \hat{a} - \hat{a}^\dagger \right) + \frac{\omega_c q^2 A_0^2}{\hbar} \hat x^2
\end{align*}
\endgroup
"""
tex = TEXDocument(hamiltonian, true, preamble=latex_preamble)
LTeX(grid_content_main[2, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

Label(grid_content_main[3, 1], "The standard QRM in the dipole gauge reads", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

lindblad = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
    \hat{\mathcal{H}}_{\rm D} = \hat{P} \hat H_{\rm D} \hat{P}  = \frac{\hbar \bar{\omega}_{10}}{2} \hat{\sigma}_z + \hbar \omega_c \hat{a}^\dagger \hat{a} - i \hbar g_{01} \hat{\sigma}_x \left( \hat{a} - \hat{a}^\dagger \right)
\end{align*}
\endgroup
"""
tex = TEXDocument(lindblad, true, preamble=latex_preamble)
LTeX(grid_content_main[4, 1], tex, alignmode = Outside(0, 0, 20, 10), tellwidth=false)

# ----------- ### The Renormalized QRM ### ------------

grid_content_main = make_content_box!(left_column[3, 1], "The Renormalized QRM")

Label(grid_content_main[1, 1], "We divide the full Hamiltonian into three terms", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

hamiltonian = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
    \hat{H}_\mathrm{D} = \hat{H}_{0^\prime} + \hat{H}_\mathrm{int, D}^\mathrm{L} + \hat{H}_\mathrm{int, D}^\mathrm{H}
\end{align*}
\endgroup
"""
tex = TEXDocument(hamiltonian, true, preamble=latex_preamble)
LTeX(grid_content_main[2, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

Label(grid_content_main[3, 1], "with", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

hamiltonian0 = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
    \hat{H}_{0^\prime} = \sum_j \hbar \omega^\prime_j \dyad{j}{j} + \hbar \omega_c \hat{a}^\dagger \hat{a}
\end{align*}
\endgroup
"""
tex = TEXDocument(hamiltonian0, true, preamble=latex_preamble)
LTeX(grid_content_main[4, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

Label(grid_content_main[5, 1], "We perform the SW transformation", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

SW_transformation = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
    e^{-\hat{S}} \hat{H}_\mathrm{D} e^{\hat{S}} = \hat{H}_\mathrm{D} + \comm{\hat{H}_\mathrm{D}}{\hat{S}} + \frac{1}{2} \comm{\comm{\hat{H}_\mathrm{D}}{\hat{S}}}{\hat{S}} + \ldots
\end{align*}
\endgroup
"""
tex = TEXDocument(SW_transformation, true, preamble=latex_preamble)
LTeX(grid_content_main[6, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

Label(grid_content_main[7, 1], L"The generator $\hat{S}$ is defined such that $[ \hat{H}_{0^\prime},  \hat{S} ] = - \hat{H}_\mathrm{int, D}^\mathrm{H}$, in order to eliminate the high-energy terms from the effective Hamiltonian. This leads to the following expression for the generator", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

renorm_QRM = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
    \hat{\mathcal{H}}_\mathrm{D}^\mathrm{eff} = & \frac{\hbar \tilde{\omega}_{10}}{2} \hat{\sigma}_z + \hbar \omega_c \hat{a}^\dagger \hat{a} \nonumber 
    + \hbar \left( B_+ + B_- \hat{\sigma}_z \right)\left( \hat{a} - \hat{a}^\dagger \right)^2 \\ 
    & - i \hbar \tilde{g}_{01} \hat{\sigma}_x \left( \hat{a} - \hat{a}^\dagger \right) - D_{01} \hat{\sigma}_y \left( \hat{a} + \hat{a}^\dagger \right)
\end{align*}
\endgroup
"""
tex = TEXDocument(renorm_QRM, true, preamble=latex_preamble)
LTeX(grid_content_main[8, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

# ----------- ### Results ### ------------

grid_content_main = make_content_box!(right_column[1, 1], "Results")

# plot1_grid = GridLayout(grid_content_main[1, 1])
# plot2_grid = GridLayout(grid_content_main[1, 2])

# plot1_label_grid = GridLayout(plot1_grid[1, 2])
# plot2_label_grid = GridLayout(plot2_grid[1, 1])


Label(grid_content_main[1, 1], "Eigenvalues", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/Renormalized_QRM_eigenvalues.pdf")))
LTeX(grid_content_main[2, 1], pdf_doc, scale=2.0, tellwidth=true)

Label(grid_content_main[1, 2], "Observables", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/observables_and_fidelity.pdf")))
LTeX(grid_content_main[2, 2], pdf_doc, scale=1.6, tellwidth=true)

colgap!(grid_content_main, 75)


# ----------- ### The Fluxonium qubit ### ------------

grid_content_main = make_content_box!(right_column[2, 1], "The Fluxonium qubit")

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/fluxonium.pdf")))
LTeX(grid_content_main[1, 1], pdf_doc, scale=2.0, tellwidth=false)

renorm_QRM_fluxonium = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
    \hat{\mathcal{H}}_{\rm fr}^{\rm eff} = & \ \hbar \omega_c \hat{a}^\dagger \hat{a} + \hbar \frac{\tilde{\omega}_{10}}{2} \hat{\sigma}_z + \hbar \left( \frac{G_{01}}{\omega_c} + A_{10} + A_{01} \right) \hat{\sigma}_x \nonumber \\
    - & \hbar \left( \frac{\tilde{g}_{11} + \tilde{g}_{00}}{2} \hat{I} + \frac{\tilde{g}_{11} - \tilde{g}_{00}}{2} \hat{\sigma}_z + \tilde{g}_{01} \hat{\sigma}_x \right) \left( \hat{a} + \hat{a}^\dagger \right) \nonumber \\
    - & \hbar \left( B_+ \hat{I} + B_- \hat{\sigma}_z + 2 B_{01} \hat{\sigma}_x \right) \left( \hat{a} + \hat{a}^\dagger \right)^2 \nonumber \\
    + & i \hbar \left(A_{10} - A_{01}\right) \hat{\sigma}_y \left( \hat{a}^2 - \hat{a}^{\dagger^2} \right) - i \hbar D_{01} \hat{\sigma}_y \left( \hat{a} - \hat{a}^\dagger \right)
\end{align*}
\endgroup
"""
tex = TEXDocument(renorm_QRM_fluxonium, true, preamble=latex_preamble)
LTeX(grid_content_main[2, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

# rowgap!(grid_content_main, 20)

# ----------- ### References ### ------------

grid_content_main = make_content_box!(right_column[3, 1], "References")

references_grid = GridLayout(grid_content_main[1, 1])
qr_code_grid = GridLayout(grid_content_main[1, 2])

Label(references_grid[1, 1], "[1] Frisk Kockum, et al., Nat. Rev. Phys. 1.1 (2019)", fontsize=CONTENT_BODY_FONT_SIZE - 10, justification=:left, halign=:left)

Label(references_grid[2, 1], "[2] De Bernardis, et al., Phys. Rev. A 98.5 (2018)", fontsize=CONTENT_BODY_FONT_SIZE - 10, justification=:left, halign=:left)

Label(references_grid[3, 1], "[3] Arwas, et al., Phys. Rev. A 108.2 (2023)", fontsize=CONTENT_BODY_FONT_SIZE - 10, justification=:left, halign=:left)

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/qr-code.pdf")))
LTeX(qr_code_grid[1, 1], pdf_doc, scale=0.12, tellwidth=false)

Label(qr_code_grid[2, 1], "Scan the QR code to access the full paper", fontsize=24)


# ----------- Spacing ------------

rowgap!(fig.layout, 50) # Gap between all the Grids
rowgap!(grid_title, 50) # Gap between title and affiliations
colgap!(grid_content, 30) # Gap between left and right column
rowgap!(left_column, 80) # Gap between left column elements
rowgap!(right_column, 80) # Gap between right column elements

# ----------- Save ------------

save(joinpath(@__DIR__, "poster.pdf"), fig, pt_per_unit=1)

fig
