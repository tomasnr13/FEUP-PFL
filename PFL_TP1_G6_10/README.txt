README

BigNumber.hs:

clearZeros:permite converter um Big Number com zeros à esquerda num Big Number sem eles, utilizando recursividade.

scannerRec: através de recursividade, retorna um Big Number equivalente à string de argumento, um carater de cada vez.

scanner: converte uma string num Big Number sem zeros à esquerda, utilizando as funções scannerRec e clearZeros 

output:realiza o inverso da função scanner, retornando uma String equivalente ao Big Number dado como argumento, utilizando também recursividade

safeInit: realiza a operação de init, retornando todos os elementos da lista menos o último, sem o risco de erro no caso de ser realizada com uma lista vazia

safeLast: retorna o último elemento de uma lista de inteiros, sem o risco de erro no caso de ser realizada com uma lista vazia

gteAbsBN: retorna um boleano indicando qual dos argumentos tem o maior valor absoluto, recursivamente

isNegBN: verifica se um Big Number é negativo verificanfo recursivamente se algum dos inteiros que o compoem são negativos

somaBNCheck:condição que é verificada no somaBN, para poder lidar com alguns casos específicos com números negativos

somaBN: realiza a soma, chamando a função somaBNCarry.

somaBNCarry: realiza a soma de forma recursiva, adicionado o c(pode ser 0 ou 1) para o próximo digito

subBN: realiza a subtração entre dois Big Numbers, utilizando a função somaBN com o segundo argumento multiplicado por -1

mulBN:multiplica dois Big Numbers, realizando recursivamente a operação de soma 

addTuples: usando a operação somaBN, retorna um tuplo composto por dois Big Numbers, resultado da soma de dois tuplos também de dois Big Numbers, elemento a elemento.

divPositivoBN: reliaza a divisão. Subtraindo ao dividendo multiplos do dividendo multiplicado por 2^n

maptuple:aplica a função f a cada um dos elementos do tuplo de argumento, composto por dois Big Numbers

divBN: realiza a divisão, chamando a função divPositivoBN com ambos os elementos positivos. O resultado fica positivo se ambos forem positivos ou iguais

safeDivBN: safe version of divBN, returns a type Maybe, after verifying if the second argument is zero. If it is, returns Nothing and if it isn't returns the result given by divBN


Fib.hs

fibRec: calcula o número de Fibonacci de índice n, calculando recursivamente os dois números anteriores e somando-os

fibLista: retorna uma lista com todos os números de Fibonacci até n, juntando à lista de retorno de fibLista n-1 os seus dois últimos elementos somados

fibListaInfinita: lista de Fibonacci inifinita, criada através da soma dos dois elementos dos tuplos retornados pelo zip de si com a sua própria tail

fibRecBN: versão da função fibRec mas para Big Numbers, faz exatamente os mesmo que a outra, mas usando operações entre Big Numbers
 
getBN: retorna o elemento n de uma lista de Big Numbers, sendo n também um Big Number

fibListaBN: versão da função fibLista mas para Big Numbers, faz exatamente os mesmo que a outra, mas usando operações entre Big Numbers

fibListaInfinitBN: versão da função fibListaInfinita mas para Big Numbers, utilizando a operação somaBN 

