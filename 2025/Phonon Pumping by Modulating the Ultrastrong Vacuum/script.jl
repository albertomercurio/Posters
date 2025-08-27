ENV["PATH"] *= ":/Library/TeX/texbin" # Needed on MacOS

using CairoMakie
using MakieTeX

include("cairomakie_setup.jl")

latex_preamble = raw"""
\usepackage{amsmath}
\usepackage{physics}
\usepackage{fix-cm} % Allows arbitrary font sizes for Computer Modern
"""

# %%
title_text = "Phonon Pumping by Modulating the \n Ultrastrong Vacuum"

authors_text = "Fabrizio Minganti, Alberto Mercurio, Fabio Mauceri, \n Marco Scigliuzzo, Salvatore Savasta and Vincenzo Savona"

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

# # ----------- Top and Bottom ------------

top_box = Box(grid_top, color=COLOR_EPFL, strokevisible=false, height=TOP_BOX_HEIGHT)

pdf_doc = PDFDocument(read("figures/header.pdf"))
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

# ----------- ### The System ### ------------

grid_content_main = make_content_box!(left_column[1, 1], "The System")

pdf_doc = PDFDocument(read("figures/virtual_photons_mirror.pdf"))
LTeX(grid_content_main[1, 1], pdf_doc, scale=0.6, alignmode = Outside(0, 0, 60, 40), tellwidth=false)
Label(grid_content_main[2, 1], "A cavity is ultrastrongly coupled to a qubit. The cavity also interacts with a vibrating mirror. The frequency of the qubit is adiabatically modulated, and the USC virtual photon population oscillations cause the exchitation of the mirror.", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

# ----------- ### The Model ### ------------

grid_content_main = make_content_box!(left_column[2, 1], "The Model")

hamiltonian = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
\hat{H}(t) =& \ \hat{H}_{\rm R} + \hat{H}_{\rm opt} + \hat{H}_{\rm M}(t) \\[20pt]
\hat{H}_{\rm R} =& \ \omega_a \hat{a}^\dagger \hat{a} +\omega_{\sigma} \hat{\sigma}_+ \hat{\sigma}_- + \lambda (\hat{a} + \hat{a}^\dagger )(\hat{\sigma}_-  + \hat{\sigma}_+ ), \\[20pt]
\hat{H}_{\rm opt} =& \ \omega_{b}\hat{b}^\dagger \hat{b} + \frac{g}{2} (\hat{a}+\hat{a}^\dagger)^2 (\hat{b}^\dagger + \hat{b}) \\[20pt]
\hat{H}_{\rm M}(t) =& \ \frac{1}{2} \Delta_\omega \left[ 1 + \cos ( \omega_d t ) \right] \hat{\sigma}_+ \hat{\sigma}_-  = \Omega_{\sigma}(t) \hat{\sigma}_+ \hat{\sigma}_-
\end{align*}
\endgroup
"""
tex = TEXDocument(hamiltonian, true, preamble=latex_preamble)
LTeX(grid_content_main[1, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

Label(grid_content_main[2, 1], "The system evolves according to the Lindblad master equation", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

lindblad = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
\dot{\hat{\rho}} = -i \comm{\hat{H} (t)}{\hat{\rho}} + (1 + n_{\rm th}) \gamma_b \mathcal{D} \left[ \hat{b} \right] \hat{\rho} + n_{\rm th} \gamma_b \mathcal{D} \left[ \hat{b}^\dagger \right] \hat{\rho} + \gamma_{\rm D} \mathcal{D} \left[ \hat{b}^\dagger \hat{b} \right] \hat{\rho}
\end{align*}
\endgroup
"""
tex = TEXDocument(lindblad, true, preamble=latex_preamble)
LTeX(grid_content_main[3, 1], tex, alignmode = Outside(0, 0, 20, 10), tellwidth=false)

# ----------- ### Dispersive Approximation ### ------------

grid_content_main = make_content_box!(left_column[3, 1], "Dispersive Approximation")

Label(grid_content_main[1, 1], L"In the regime $g \ll \omega_d \simeq \omega_b \ll \omega_a \simeq \omega_{\sigma}$, the entanglement between the mechanical motion and the USC subsystem is negligible, and the state of the system can be factored as $|{\Psi(t)}\rangle \simeq | \psi (t)\rangle \otimes |{\phi_b(t)}\rangle$, where $| \psi (t) \rangle$ and $| \phi_b(t) \rangle$ are the USC and mirror states, respectively.", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

hamiltonian = raw"""
\begingroup
\fontsize{40pt}{46pt}\selectfont
\begin{align*}
\hat{H}_b(t) &= \bra{\psi_{0}(t)}
    \hat{H}_{\rm opt} \ket{\psi_{0}(t)}  = \omega_b \hat{b}^\dagger \hat{b} + \frac{g}{2} \mathcal{N}(t) \left( \hat{b} + \hat{b}^\dagger \right)~,
\end{align*}
\endgroup
"""
tex = TEXDocument(hamiltonian, true, preamble=latex_preamble)
LTeX(grid_content_main[2, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

Label(grid_content_main[3, 1], L"with $\mathcal{N}(t) = \langle{{\psi}_{0}(t)}|{2\hat{a}^\dagger \hat{a} +  \hat{a}^2 +  \hat{a}^{\dagger 2}}|{{\psi}_{0}(t)}\rangle$", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

# ----------- ### Results ### ------------

grid_content_main = make_content_box!(right_column[1, 1], "Results")

plot1_grid = GridLayout(grid_content_main[1, 1])
plot2_grid = GridLayout(grid_content_main[2, 1])

plot1_label_grid = GridLayout(plot1_grid[1, 2])
plot2_label_grid = GridLayout(plot2_grid[1, 1])

pdf_doc = PDFDocument(read("figures/closed_dynamics_rabi.pdf"))
LTeX(plot1_grid[1, 1], pdf_doc, scale=1.6, tellwidth=true)

equation = raw"""
\begingroup
\fontsize{32}{36pt}\selectfont
\begin{equation*}
\mathcal{N}(t) = \sum_{k=-\infty}^{+\infty} \mathcal{N}_k e^{i k \omega_d t}
\end{equation*}
\endgroup
"""
tex = TEXDocument(equation, true, preamble=latex_preamble)
LTeX(plot1_label_grid[1, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

# --

pdf_doc = PDFDocument(read("figures/spectrum_and_nth_rabi.pdf"))
LTeX(plot2_grid[1, 2], pdf_doc, scale=1.6, tellwidth=true)

# Label(plot2_label_grid[1, 1], "Some text", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

equation = raw"""
\begingroup
\fontsize{32}{36pt}\selectfont
\begin{equation*}
\expval*{\hat{b}^\dagger \hat{b}}_{\rm ss} &=& \frac{\gamma + \gamma_{\rm D}}{\gamma} \left|\expval*{\hat{b}}_{\rm ss} \right| ^2 + n_{\rm th}
\end{equation*}

with

\begin{equation*}
\langle \hat{b} \rangle_\mathrm{ss} = (g \mathcal{N}_{\bar{k}})/[2 \Delta_{\bar{k}} + i (\gamma + \gamma_{D})]
\end{equation*}
\endgroup
"""
tex = TEXDocument(equation, true, preamble=latex_preamble)
LTeX(plot2_label_grid[1, 1], tex, alignmode = Outside(0, 0, 20, 5), tellwidth=false)

# ----------- ### Experimental Proposal ### ------------

grid_content_main = make_content_box!(right_column[2, 1], "Experimental Proposal")

pdf_doc = PDFDocument(read("figures/circuitv2.pdf"))
LTeX(grid_content_main[1, 1], pdf_doc, scale=1.7, tellwidth=false)

Label(grid_content_main[2, 1], L"(a) Lumped element circuit of a resonator containing a mechanical capacitor, capacitively coupled to a frequency tunable transmon qubit. (b) Design of a 60\,$\mu m$ mechanical drum with 200\,$nm$ vacuum gap to the bottom electrode.", fontsize=CONTENT_BODY_FONT_SIZE, word_wrap=true, justification=:left)

rowgap!(grid_content_main, 20)

# ----------- ### References ### ------------

grid_content_main = make_content_box!(right_column[3, 1], "References")

Label(grid_content_main[1, 1], "[1] Frisk Kockum, Anton, et al., Nat. Rev. Phys. 1.1 (2019): 19-40.", fontsize=CONTENT_BODY_FONT_SIZE, justification=:left, halign=:left)

Label(grid_content_main[2, 1], "[2] Aspelmeyer, Markus, et al., Rev. Mod. Phys. 86.4 (2014): 1391-1452.", fontsize=CONTENT_BODY_FONT_SIZE, justification=:left, halign=:left)

Label(grid_content_main[3, 1], "[3] Minganti, Fabrizio, et al., SciPost Phys. 17.1 (2024): 027.", fontsize=CONTENT_BODY_FONT_SIZE, justification=:left, halign=:left)

pdf_doc = PDFDocument(read("figures/qr-code.pdf"))
LTeX(grid_content_main[4, 1], pdf_doc, scale=0.18, tellwidth=false)

Label(grid_content_main[5, 1], "Scan the QR code to access the full paper", fontsize=24)


# # ----------- Spacing ------------

rowgap!(fig.layout, 50) # Gap between all the Grids
rowgap!(grid_title, 50) # Gap between title and affiliations
colgap!(grid_content, 30) # Gap between left and right column
rowgap!(left_column, 80) # Gap between left column elements
rowgap!(right_column, 80) # Gap between right column elements

# # ----------- Save ------------

save("poster.pdf", fig, pt_per_unit=1)

fig
