
all: paper.pdf | tidy
view: paper.pdf
	qvm-open-in-dvm paper.pdf &
%.pdf: %.tex
	latexmk -pdf ${<}

tidy:
	latexmk -c

clean:
	latexmk -C

grammar: | languagetool style

languagetool:
	perl -npe 's/^\s*[\%].*$//' <paper.tex | languagetool -l en-GB -d WHITESPACE_RULE,UPPERCASE_SENTENCE_START,MORFOLOGIK_RULE_EN_GB,EN_UNPAIRED_BRACKETS,CURRENCY,COMMA_PARENTHESIS_WHITESPACE,EN_QUOTES  -

style-long:
	detex paper.tex | style -l 27

style-passive:
	detex paper.tex | style -p

diction:
	detex paper.tex | diction -bs
