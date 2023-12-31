package repl

import (
	"bufio"
	"fmt"
	"io"
	"main/lexer"
	"main/token"
)

const PROMPT = ">> "

func Start(in io.Reader, out io.Writer) {
	scanner := bufio.NewScanner(in)
	var tok token.Token
	for {
		fmt.Fprint(out, PROMPT)
		scanned := scanner.Scan()
		if !scanned {
			return
		}
		line := scanner.Text()
		l := lexer.New(line)
		for tok = l.NextToken(); tok.Type != token.EOF; tok = l.NextToken() {
			//fmt.Fprintf(out, "%+v\n", tok)
			fmt.Fprintf(out, "{token.%v, \"%s\"},\n", tok.Type, tok.Literal)
		}
		fmt.Fprintf(out, "{token.%v, \"%s\"},\n", tok.Type, tok.Literal)
	}
}
