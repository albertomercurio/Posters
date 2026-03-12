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
title_text = "QuantumToolbox.jl: An efficient Julia framework \n for simulating open quantum systems"

authors_text = L"\textbf{Alberto Mercurio}, Yi-Te Huang, Li-Xun Cai, \n Yueh-Nan Chen, Vincenzo Savona and Franco Nori $ $"

affiliations_text = [
    "École Polytechnique Fédérale de Lausanne (EPFL), Lausanne, Switzerland",
    "RIKEN Center for Quantum Computing, RIKEN, Wakoshi, Saitama Japan",
    "Center for Quantum Frontiers of Research and Technology (QFort), Tainan, Taiwan"
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

rowgap!(grid_affiliations, 10)

# ----------- Content ------------

# ----------- ### Motivation of the package ### ------------

grid_content_main = make_content_box!(left_column[1, 1], "Motivation of the package")

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/se-me-mc-solve.pdf")));
LTeX(grid_content_main[1, 1], pdf_doc, scale=2.3, alignmode = Outside(0, 0, 10, 10), tellwidth=false)
Label(grid_content_main[2, 1], L"QuantumToolbox.jl provides an \textbf{efficient framework} for simulating open quantum systems in Julia. As an example we consider the Jaynes-Cummings model in presence of single photon and atomic losses. The density matrix evolves according to the \textbf{Lindblad master equation} $ $", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

Label(grid_content_main[3, 1], L"\frac{\mathrm{d} \hat{\rho}}{\mathrm{d} t} = -i [ \hat{H}, \hat{\rho} ] + \kappa \mathcal{D}[\hat{a}] \hat{\rho} + \gamma \mathcal{D}[\hat{\sigma}_-] \hat{\rho} \quad \text{with} \quad \mathcal{D}[\hat{O}] \hat{\rho} = \hat{O} \hat{\rho} \hat{O}^\dagger - \frac{1}{2} \{ \hat{O}^\dagger \hat{O}, \hat{\rho} \}", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left, lineheight=10)

code_example = """
ωc, ωa, g, κ, γ = 1, 1, 0.1, 0.01, 0.01

# cavity
N = 10 # Cutoff of the cavity Hilbert space
a = tensor(destroy(N), qeye(2)) #annihilation operator

# atom
σz = tensor(qeye(N), sigmaz()) # Pauli-Z operator
σm = tensor(qeye(N), sigmam()) # annihilation operator
σp = tensor(qeye(N), sigmap()) # creation operator

H = ωc * a' * a + ωa/2 * σz + g * (a * σp + a' * σm)

ψ0 = tensor(fock(N, 0), basis(2, 0)) 

C1 = sqrt(κ) * a
C2 = sqrt(γ) * σm
c_ops = [C1, C2]
e_ops = [a' * a] # average photon number

tlist = range(0, 10*π/g, 1000)
sol_me = mesolve(H, ψ0, tlist, c_ops, e_ops=e_ops)
"""
code_block = GridLayout(grid_content_main[4, 1], tellwidth=false)
Box(code_block[1, 1], color=(COLOR_EPFL, 0.12), strokecolor=COLOR_EPFL, strokewidth=2, cornerradius=12)
Label(code_block[1, 1], code_example,
    font="Menlo",
    fontsize=CONTENT_BODY_FONT_SIZE - 12,
    justification=:left,
    halign=:left,
    valign=:top,
    lineheight=1.2,
    padding=(24, 24, 18, 18),
    word_wrap=false)


# ----------- ### Structure of the package ### ------------

grid_content_main = make_content_box!(left_column[2, 1], "Structure of the package")

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/package_structure.pdf")));
LTeX(grid_content_main[1, 1], pdf_doc, scale=0.5, alignmode = Outside(0, 0, 10, 10), tellwidth=false)

# ----------- ### Automatic Differentiation ### ------------

grid_content_main = make_content_box!(right_column[1, 1], "Automatic Differentiation")

Label(grid_content_main[1, 1], L"We consider a two-qubit system initialized in $|0,0\rangle$, with \textbf{the goal of generating the Bell state} $|\Phi^+\rangle = (|0,0\rangle + |1,1\rangle)/\sqrt{2}$ at a final time $t_f$. In the absence of losses, this state can be ideally prepared with the time-dependent Hamiltonian", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

Label(grid_content_main[2, 1], L"\hat{H}_\mathrm{Bell}(t) = \hat{H}^{(1)}_\mathrm{H}(t) + \hat{H}_\mathrm{CNOT}(t)", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

Label(grid_content_main[3, 1], L"\hat{H}^{(1)}_\mathrm{H}(t) = f_\mathrm{H}(t) \, \frac{\pi}{t_f \sqrt{2}} \left( \hat{\sigma}_x^{(1)} - \hat{\sigma}_z^{(1)} \right) \quad \text{and} \quad \hat{H}_\mathrm{CNOT}(t) = f_\mathrm{CNOT}(t) \, \frac{\pi}{t_f} \left(\hat{I}^{(1)} + \hat{\sigma}_z^{(1)} \right) \otimes \left( \hat{I}^{(2)} - \hat{\sigma}_x^{(2)} \right)", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

plot_grid = GridLayout(grid_content_main[4, 1])
caption_plot_grid = GridLayout(plot_grid[1, 2])

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/autodiff_bell.pdf")))
LTeX(plot_grid[1, 1], pdf_doc, scale=2.0, tellwidth=false)

Label(caption_plot_grid[1, 1], L"We now assume the functional forms of $f_\mathrm{H}(t)$ and $f_\mathrm{CNOT}(t)$ are unknown, and instead \textbf{optimize their shapes through gradient-based algorithms.}", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

Label(caption_plot_grid[2, 1], L"\tilde{f}_\mathrm{H,opt}(t) = \sum_{i=1}^N \theta_i^\mathrm{H}\,\chi_i(t)", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

Label(caption_plot_grid[3, 1], L"\tilde{f}_\mathrm{CNOT,opt}(t) = \sum_{i=1}^N \theta_i^\mathrm{CNOT}\,\chi_i(t)", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)


# ----------- ### Benchmarks ### ------------

grid_content_main = make_content_box!(right_column[2, 1], "Benchmarks")

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/benchmarks.pdf")))
LTeX(grid_content_main[1, 1], pdf_doc, scale=2.0, tellwidth=false)


# ----------- ### References ### ------------

grid_content_main = make_content_box!(right_column[3, 1], "References")

qr_code_grid = GridLayout(grid_content_main[1, 2])

references_text = """
[1] A. Mercurio, et al., Quantum 9, 1866 (2025)

[2] J.R. Johansson, et al., Computer Physics Communications 183, 1760–1772 (2012)

[3] Sebastian Krämer, et al., Computer Physics Communications 227, 109 (2018)
"""

Label(grid_content_main[1, 1], references_text, fontsize=CONTENT_BODY_FONT_SIZE - 10, justification=:left, halign=:left, word_wrap=false, padding=0, tellheight=false)

pdf_doc = PDFDocument(read(joinpath(@__DIR__, "figures/qr-code.pdf")))
LTeX(qr_code_grid[1, 1], pdf_doc, scale=0.15, tellwidth=false)

Label(qr_code_grid[2, 1], "Scan the QR code to access the full paper", fontsize=CONTENT_BODY_FONT_SIZE-10, word_wrap=true)

# colgap!(grid_content_main, 10)

# ----------- Spacing ------------

rowgap!(fig.layout, 50) # Gap between all the Grids
rowgap!(grid_title, 50) # Gap between title and affiliations
colgap!(grid_content, 30) # Gap between left and right column
rowgap!(left_column, 80) # Gap between left column elements
rowgap!(right_column, 80) # Gap between right column elements

# %% ----------- Save ------------

save(joinpath(@__DIR__, "poster.pdf"), fig, pt_per_unit=1)

fig
