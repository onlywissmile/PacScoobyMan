######################################################################
#                                                                    #
#       Universidade de Brasília                                     #
#       Instituto de Ciências Exatas                                 #
#       Departamento de Ciência da Computação                        #
#       Introdução aos Sistemas Computacionais – 2024.1              #
#       Professor: Marcus Vinicius Lamar                             #
#       Alunos: Igor dos Santos Rodrigues e Júlia Paulo Amorim       #
#       Inspirado no jogo Pac-Man                                    #
#                                                                    #
######################################################################


.data

#Posição inicial dos personagens
scoobyX: .word 153
scoobyY: .word 83

blinkyX: .word 271
blinkyY: .word 34

#Número de Notas a tocar
NUM: .word 41
#Lista de nota, duração, nota, duração...
NOTAS: 57,380,57,190,52,190,59,190,61,190,59,190,57,190,56,380,57,190,52,190,57,190,59,380,59,190,61,380,61,380,59,190,57,380,57,190,54,380,57,190,52,190,59,190,61,190,59,190,61,190,57,380,57,190,50,190,59,190,61,190,59,190,57,190,56,380,57,190,52,190,59,190,61,190,59,190,61,190,57,380,57,1140

.include "bin/telainicial.data"              #Tela incial do menu
.include "bin/mapa1.data"                    #Mapa 1
.include "bin/scoobydoo.data"                #Scooby Doo
.include "bin/scoobyloo.data"                #Scooby Loo
.include "bin/fantasmablinky.data"           #Fantasma Blinky
.include "bin/segundoataque.data"            #Segundo Ataque
.include "bin/mapadecores.data"              #Mapa 2
.include "bin/gameovertemporario.data"       #Game over temporário


.text

PRINTMENU:
        li t1, 0xFF000000                #Endereço inicial da Memória VGA - Frame0
        li t2, 0xFF012C00                #Endereço final
        la s1, telainicial               #Endereço dos dados da tela na memória
        addi s1, s1, 8                   #Primeiro pixels depois das informações de número de linhas e colunas


LOOPMENU:
        beq t1, t2, MUSICAMENU           #Se for o último endereço vai para MUSICAMENU
        lw t3, 0(s1)                     #Lê um conjunto de 4 pixels (word)
        sw t3, 0(t1)                     #Escreve a word na memória VGA
        addi t1, t1, 4                   #Soma 4 ao endereço
        addi s1, s1, 4                   #Soma 4 ao endereço da telainicial
        j LOOPMENU                       #Volta para o LOOPMENU


MUSICAMENU:
        la s0, NUM                         #Define o endereço do número de notas
        lw s1, 0(s0)                       #Lê o número de notas
        la s0, NOTAS                       #Define o endereço das notas
        li t0, 0                           #Zera o contador de notas
        li a2, 0                           #Define o instrumento
        li a3, 127                         #Define o volume


LOOPMUSICA: 
        beq t0, s1, FORAMENU               #Contador chegou no final? Vai para FORAMENU
        lw a0, 0(s0)                       #Lê o valor da nota
        lw a1, 4(s0)                       #Lê a duração da nota
        li a7, 31                          #Define a chamada de syscall
        ecall                              #Toca a nota
        mv a0, a1                          #Passa a duração da nota para a pausa
        li a7, 32                          #Define a chamada de syscal
        ecall                              #Realiza uma pausa de a0
        addi s0, s0, 8                     #Incrementa para o endereço a próxima nota
        addi t0, t0, 1                     #Incrementa o contador de notas
        j LOOPMUSICA                       #Volta para LOOPMUSICA


FORAMENU:
        li s1, 49                        #Valor da tecla 1
        li t1, 0xFF200000                #Carrega o endereço de controle do KDMMIO


LOOPTECLADOMENU:
        lw t0, 0(t1)                     #Lê o bit de controle do teclado
        andi t0, t0, 0x0001              #Ignora o bit menos significativo
        beq t0, zero, LOOPTECLADOMENU    #Se nenhuma tecla foi pressionada volta para LOOPTECLADOMENU
        lw t2, 4(t1)                     #Lê o valor da tecla
        beq s1, t2, MAPA1                #Se o valor da tecla for igual a '1'(49) vai para MAPA1
        j LOOPTECLADOMENU                #Volta par LOOPTECLADOMENU


MAPA1:
        li t1, 0xFF000000                #Endereço inicial da Memória VGA - Frame0
        li t2, 0xFF012C00                #Endereço final
        la s1, mapa1                     #Endereço dos dados da tela na memória
        addi s1, s1, 8                   #Primeiro pixels depois das informações de número de linhas e colunas


LOOPMAPA1:
        beq t1, t2, SCOOBYDOO            #Se for o último endereço vai para SCOOBYDOO
        lw t3, 0(s1)                     #Lê um conjunto de 4 pixels (word)
        sw t3, 0(t1)                     #Escreve a word na memória VGA
        addi t1, t1, 4                   #Soma 4 ao endereço
        addi s1, s1, 4                   #Soma 4 ao endereço da mapa1
        j LOOPMAPA1                      #Volta para o LOOPMAPA1


SCOOBYDOO:                               #Carregando os dados do Scooby Doo
        li t6, 0                         #Inicializando o contador dos prints
        li t5, 0                         #Inicializando a comparação com t6
        la a0, scoobydoo
        lw a1, scoobyX
        lw a2, scoobyY
        j PRINTAPERSONAGEM


FANTASMABLINKY:                          #Carregando os dados do fantasma Blinky
        addi t6, t6, 1                   #Adiciona 1 ao contador t6
        la a0, fantasmablinky
        lw a1, blinkyX
        lw a2, blinkyY
        j PRINTAPERSONAGEM


PRINTAPERSONAGEM:
        lw s0, 0(a0)                     #Guarda em s0 a largura da imagem
        lw s1, 4(a0)                     #Guarda em s1 a altura da imagem
        mv s2, a0                        #Copia o endereço da imagem para s2
        addi s2, s2, 8                   #Primeiro pixels depois das informações de número de linhas e colunas
	      li s3, 0xFF000000                #Carrega em s3 o endereço do bitmap display
        li t1, 320                       #t1 é o tamanho de uma linha no bitmap display
      	mul t1, t1, a2                   #Multiplica t1 pela posição Y desejada no bitmap display.
      	add t1, t1, a1                   #Soma a posição X para chegar na coluna certa
      	add s3, s3, t1                   #Adiciona t1 para adicionar ao endereço do bitmap
      	blt a1, zero, FORAPERSONAGEM     #Se X < 0, não renderizar
      	blt a2, zero, FORAPERSONAGEM     #Se Y < 0, não renderizar
      	li t1, 320                       #Carrega 320 em t1
      	add t0, s0, a1                   #Soma a largura e o X
      	bgt t0, t1, FORAPERSONAGEM       #Se X + larg > 320, não renderizar
      	li t1, 240                       #Carrega 240 em t1
      	add t0, s1, a2                   #Soma a altura e o Y
      	bgt t0, t1, FORAPERSONAGEM       #Se Y + alt > 240, não renderizar
      	li t1, 0                         #t1 = Y (linha) atual


LINESPERSONAGEM:
        bge t1, s1, FORAPERSONAGEM       #Se terminamos a última linha da imagem, encerrar
	      li t0, 0                         #t0 = X (coluna) atual


COLUNPERSO:
	      bge t0, s0, COLPERSEND           #Se terminamos a linha atual, ir pra próxima
	      lb t2, 0(s2)                     #Pega o pixel da imagem
	      sb t2, 0(s3)                     #Põe o pixel no display
	      addi s2, s2, 1                   #Incrementa o endereço da imagem
	      addi s3, s3, 1                   #Incrementa o endereço do bitmap display
	      addi t0, t0, 1                   #Contador de colunas
	      j COLUNPERSO                     #Volta para COLUNPERSO


COLPERSEND:
      	addi s3, s3, 320                 #Próxima linha no bitmap display
      	sub s3, s3, s0                   #Reposiciona o endereço de coluna no bitmap display
        addi t1, t1, 1                   #Incrementa o contador de altura
	      j LINESPERSONAGEM                #Volta para LINESPERSONAGEM


FORAPERSONAGEM:
        beq t6, t5, FANTASMABLINKY       #Se t5 for igual a t6 vai para FANTASMABLINKY
        j TECLADO2


TECLADO2:
        li s1, 106
        li t1, 0xFF200000


LOOPTECLADO2:
        lw t0, 0(t1)                     #Lê o bit de controle do teclado
        andi t0, t0, 0x0001              #Ignora o bit menos significativo
        beq t0, zero, LOOPTECLADO2       #Se nenhuma tecla foi pressionada volta para LOOPTECLADOF
        lw t2, 4(t1)                     #Lê o valor da tecla
        beq s1, t2, MAPA2             #Se o valor da tecla for igual a 'j'(106) vai para GAMEOVER
        j LOOPTECLADO2                   #Volta par LOOPTECLADO

MAPA2:
        li t1, 0xFF000000                #Endereço inicial da Memória VGA - Frame0
        li t2, 0xFF012C00                #Endereço final
        la s1, mapadecores               #Endereço dos dados da tela na memória
        addi s1, s1, 8                   #Primeiro pixels depois das informações de número de linhas e colunas

LOOPMAPA2:
        beq t1, t2, SCOOBYLOO            #Se for o último endereço vai para SCOOBYLOO
        lw t3, 0(s1)                     #Lê um conjunto de 4 pixels (word)
        sw t3, 0(t1)                     #Escreve a word na memória VGA
        addi t1, t1, 4                   #Soma 4 ao endereço
        addi s1, s1, 4                   #Soma 4 ao endereço da mapa1
        j LOOPMAPA2                      #Volta para o LOOPMAPA2


SCOOBYLOO:                               #Carregando os dados do Scooby Loo
        li t6, 0                         #Inicializando o contador dos prints
        li t5, 0                         #Inicializando a comparação com t6
        la a0, scoobyloo
        lw a1, scoobyX
        lw a2, scoobyY
        j PRINTAPERSONAGEM2


PRINTAPERSONAGEM2:
        lw s0, 0(a0)                     #Guarda em s0 a largura da imagem
        lw s1, 4(a0)                     #Guarda em s1 a altura da imagem
        mv s2, a0                        #Copia o endereço da imagem para s2
        addi s2, s2, 8                   #Primeiro pixels depois das informações de número de linhas e colunas
	      li s3, 0xFF000000                #Carrega em s3 o endereço do bitmap display
        li t1, 320                       #t1 é o tamanho de uma linha no bitmap display
      	mul t1, t1, a2                   #Multiplica t1 pela posição Y desejada no bitmap display.
      	add t1, t1, a1                   #Soma a posição X para chegar na coluna certa
      	add s3, s3, t1                   #Adiciona t1 para adicionar ao endereço do bitmap
      	blt a1, zero, FORAPERSONAGEM2    #Se X < 0, não renderizar
      	blt a2, zero, FORAPERSONAGEM2    #Se Y < 0, não renderizar
      	li t1, 320                       #Carrega 320 em t1
      	add t0, s0, a1                   #Soma a largura e o X
      	bgt t0, t1, FORAPERSONAGEM2      #Se X + larg > 320, não renderizar
      	li t1, 240                       #Carrega 240 em t1
      	add t0, s1, a2                   #Soma a altura e o Y
      	bgt t0, t1, FORAPERSONAGEM2      #Se Y + alt > 240, não renderizar
      	li t1, 0                         #t1 = Y (linha) atual


LINESPERSONAGEM2:
        bge t1, s1, FORAPERSONAGEM2      #Se terminamos a última linha da imagem, encerrar
	      li t0, 0                         #t0 = X (coluna) atual


COLUNPERSO2:
      	bge t0, s0, COLPERSEND2          #Se terminamos a linha atual, ir pra próxima
      	lb t2, 0(s2)                     #Pega o pixel da imagem
      	sb t2, 0(s3)                     #Põe o pixel no display
      	addi s2, s2, 1                   #Incrementa o endereço da imagem
      	addi s3, s3, 1                   #Incrementa o endereço do bitmap display
      	addi t0, t0, 1                   #Contador de colunas
      	j COLUNPERSO2                    #Volta para COLUNPERSO2


COLPERSEND2:
      	addi s3, s3, 320                 #Próxima linha no bitmap display
      	sub s3, s3, s0                   #Reposiciona o endereço de coluna no bitmap display
        addi t1, t1, 1                   #Incrementa o contador de altura
      	j LINESPERSONAGEM2               #Volta para LINESPERSONAGEM2


FORAPERSONAGEM2:
        beq t5, t6, FANTASMABLINKY2      #Se t5 for igual a t6 vai para FANTASMABLINKY2
        j TECLADOFINAL                   #Pula para TECLADOFINAL caso não seja igual


FANTASMABLINKY2:                         #Carregando os dados do fantasma Blinky
        addi t6, t6, 1                   #Adiciona 1 ao contador t6
        la a0, segundoataque             #Carrega em a0 o segundoataque
        lw a1, blinkyX                   #Carrega a posição X
        lw a2, blinkyY                   #Carrega a posição Y
        j PRINTAPERSONAGEM2              #Vai para PRINTAPERSONAGEM2


TECLADOFINAL:
        li s1, 106                       #Valor da tecla 'j'
        li t1, 0xFF200000                #Carrega o endereço de controle do KDMMIO


LOOPTECLADOF:
        lw t0, 0(t1)                     #Lê o bit de controle do teclado
        andi t0, t0, 0x0001              #Ignora o bit menos significativo
        beq t0, zero, LOOPTECLADOF       #Se nenhuma tecla foi pressionada volta para LOOPTECLADOF
        lw t2, 4(t1)                     #Lê o valor da tecla
        beq s1, t2, GAMEOVER             #Se o valor da tecla for igual a 'j'(106) vai para GAMEOVER
        j LOOPTECLADOF                   #Volta par LOOPTECLADOF


GAMEOVER:
        li t1, 0xFF000000                #Endereço inicial da Memória VGA - Frame0
        li t2, 0xFF012C00                #Endereço final
        la s1, gameovertemporario        #Endereço dos dados da tela na memória
        addi s1, s1, 8                   #Primeiro pixels depois das informações de número de linhas e colunas


LOOPFINAL:
        beq t1, t2, MUSICAFINAL          #Se for o último endereço vai para MUSICAFINAL
        lw t3, 0(s1)                     #Lê um conjunto de 4 pixels (word)
        sw t3, 0(t1)                     #Escreve a word na memória VGA
        addi t1, t1, 4                   #Soma 4 ao endereço
        addi s1, s1, 4                   #Soma 4 ao endereço da telainicial
        j LOOPFINAL                      #Volta para o LOOPFINAL


MUSICAFINAL:
        la s0, NUM                         #Define o endereço do número de notas
        lw s1, 0(s0)                       #Lê o número de notas
        la s0, NOTAS                       #Define o endereço das notas
        li t0, 0                           #Zera o contador de notas
        li a2, 0                           #Define o instrumento
        li a3, 127                         #Define o volume


LOOPMUSICAFINAL: 
        beq t0, s1, FORAFINAL              #Contador chegou no final? Vai para FORAFINAL
        lw a0, 0(s0)                       #Lê o valor da nota
        lw a1, 4(s0)                       #Lê a duração da nota
        li a7, 31                          #Define a chamada de syscall
        ecall                              #Toca a nota
        mv a0, a1                          #Passa a duração da nota para a pausa
        li a7, 32                          #Define a chamada de syscal
        ecall                              #Realiza uma pausa de a0
        addi s0, s0, 8                     #Incrementa para o endereço a próxima nota
        addi t0, t0, 1                     #Incrementa o contador de notas
        j LOOPMUSICAFINAL                  #Volta para LOOPMUSICAFINAL


FORAFINAL:
        li s1, 114                       #Valor da tecla 'r'
        li t1, 0xFF200000                #Carrega o endereço de controle do KDMMIO


LOOPTECLADOFINAL:
        lw t0, 0(t1)                     #Lê o bit de controle do teclado
        andi t0, t0, 0x0001              #Ignora o bit menos significativo
        beq t0, zero, LOOPTECLADOFINAL   #Se nenhuma tecla foi pressionada volta para LOOPTECLADOMENU
        lw t2, 4(t1)                     #Lê o valor da tecla
        beq s1, t2, END                  #Se o valor da tecla for igual a 'r'(114) vai para END
        j LOOPTECLADOFINAL               #Volta para LOOPTECLADOMENU


END:
        li a7, 10                        #Exit do programa
        ecall                            #Chamada ao sistema
