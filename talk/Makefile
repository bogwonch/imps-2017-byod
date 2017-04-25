imps-talk.pdf: imps-talk.tex
	xelatex $< 
imps-talk.tex: imps-talk.md
	pandoc $< -s -f markdown -t beamer -o $@
