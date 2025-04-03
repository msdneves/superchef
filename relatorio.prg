/*
  sistema     : superchef pizzaria
  programa    : relatório pizzas mais vendidas - por período
  compilador  : xharbour 1.2 simplex
  lib gráfica : minigui 1.7 extended
  programador : marcelo neves
*/
*			   msginfo(temp_vendas->produto,'principal')

#include 'minigui.ch'
#include 'miniprint.ch'

function relatorio()

       local x_codigo := ''

*       *dbselectarea('temp_curva')
*       zap
*       pack

  		 *- arquivo  de venda
         dbselectarea('temp_vendas')
         temp_vendas->(ordsetfocus('produtos'))
         temp_vendas->(dbgotop())

         while .not. eof()
         
               *-rejeitar se o campo produto estiver em branco
			   if substr(temp_vendas->produto,1,3) == space(3)
				  temp_vendas->(dbskip())
			   endif

			   *-gardar o cosigo para pesquisar se existe no arquivo temporario.
               x_codigo := alltrim(temp_vendas->produto)

			   *-arquivo temporario
               dbselectarea('temp_curva')
               temp_curva->(ordsetfocus('produto'))
               temp_curva->(dbgotop())
               temp_curva->(dbseek(x_codigo))
			   if found()
                  append blank
                  replace produto with x_codigo
                  replace qtd     with temp_curva->qtd + temp_vendas->qtd_p
                  temp_curva->(dbcommit())
                  temp_curva->(dbgotop())
		       else
                  if lock_reg()
                     replace qtd  with temp_curva->qtd + temp_vendas->qtd_p
                     temp_curva->(dbcommit())
                     temp_curva->(dbgotop())
				  endif
               endif

               dbselectarea('temp_vendas')
               temp_vendas->(dbskip())

         end
         
         return(nil)
*--------------------------------------------