import BigNumber

checkTeste :: BigNumber -> BigNumber -> String
checkTeste a b = if a == b  then "Passou no teste"
                            else "Falhou no teste"

checkTesteDiv :: (BigNumber, BigNumber) -> (BigNumber, BigNumber) -> String
checkTesteDiv (a, b) (c, d) = if a == c && b == d  then "Passou no teste"
                            else "Falhou no teste"

checkTesteOutput :: String -> String -> String
checkTesteOutput a b = if a == b  then "Passou no teste"
                else "Falhou no teste"
                            

testesSoma =
    do
        print ("Teste 2 + 3..." ++ checkTeste (somaBN [2] [3]) [5])
        print ("Teste 2 + (-3)..." ++ checkTeste (somaBN [2] [-3]) [-1])
        print ("Teste 2 + (-1)..." ++ checkTeste (somaBN [2] [-1]) [1])
        print ("Teste 2 + (-2)..." ++ checkTeste (somaBN [2] [-2]) [])
        print ("Teste 2 + 13..." ++ checkTeste (somaBN [2] [13]) [1,5])
        print ("Teste 92 + 8..." ++ checkTeste (somaBN [9,2] [8]) [1,0,0])
        print ("Teste 92 + 18..." ++ checkTeste (somaBN [9,2] [1,8]) [1,1,0])
        print ("Teste 100 + (-9)..." ++ checkTeste (somaBN [1, 0, 0] [-9]) [9, 1])
        print ("Teste (-19) + (-21)..." ++ checkTeste (somaBN [-1, -9] [-2, -1]) [-4, 0])
        print ("Teste (-19) + 21..." ++ checkTeste (somaBN [-1, -9] [2, 1]) [2])
        print ("Teste 20203 + 40192..." ++ checkTeste (somaBN [2, 0, 2, 0, 3] [4, 0, 1, 9, 2]) [6, 0, 3, 9, 5])

testesSubtracao =
    do
        print ("Teste 2 - 3..." ++ checkTeste (subBN [2] [3]) [-1])
        print ("Teste 2 - (-3)..." ++ checkTeste (subBN [2] [-3]) [5])
        print ("Teste 2 - (-1)..." ++ checkTeste (subBN [2] [-1]) [3])
        print ("Teste 2 - (-2)..." ++ checkTeste (subBN [2] [-2]) [4])
        print ("Teste 2 - 13..." ++ checkTeste (subBN [2] [13]) [-1,-1])
        print ("Teste 92 - 8..." ++ checkTeste (subBN [9,2] [8]) [8, 4])
        print ("Teste 92 - 18..." ++ checkTeste (subBN [9,2] [1,8]) [7, 4])
        print ("Teste 100 - (-9)..." ++ checkTeste (subBN [1, 0, 0] [-9]) [1, 0, 9])
        print ("Teste (-19) - (-21)..." ++ checkTeste (subBN [-1, -9] [-2, -1]) [2])
        print ("Teste (-19) - 21..." ++ checkTeste (subBN [-1, -9] [2, 1]) [-4, 0])
        print ("Teste 20203 - 40192..." ++ checkTeste (subBN [2, 0, 2, 0, 3] [4, 0, 1, 9, 2]) [-1, -9, -9, -8, -9])

testesMul = 
    do
        print ("Teste scanner 0 * 2" ++ checkTeste (mulBN [] [2]) ([]))
        print ("Teste scanner -3 * 13..." ++ checkTeste (mulBN [-3] [1, 3]) ([-3, -9]))
        print ("Teste scanner -10 * -100" ++ checkTeste (mulBN [-1, 0] [-1, 0, 0]) ([1, 0, 0, 0]))
testesDiv=
    do
        print ("Teste 2 / 3..." ++ checkTesteDiv (divBN [2] [3]) ([], [2]))
        print ("Teste 23 / (-5)..." ++ checkTesteDiv (divBN [2,3] [-5]) ([-4], [-3]))
testesScanners =
    do 
        print ("Teste scanner 00130..." ++ checkTeste (scanner "00130") ([1, 3, 0]))
        print ("Teste scanner -00130..." ++ checkTeste (scanner "-00130") ([-1, -3, 0]))
        print ("Teste scanner -0..." ++ checkTeste (scanner "-0") ([]))

testesOutput =
    do
        print ("Teste output [1, 2, 3, 4]" ++ checkTesteOutput ( output [1, 2, 3, 4]) ("1234"))
        print ("Teste scanner [-1, 0, 0]" ++ checkTesteOutput (output [-1, 0, 0]) ("-100"))
        print ("Teste scanner []" ++ checkTesteOutput (output []) ("0"))

