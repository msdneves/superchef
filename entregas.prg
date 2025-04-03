/*
  sistema     : superchef pizzaria
  programa    : entregas
  compilador  : xharbour 1.2 simplex
  lib gráfica : minigui 1.7 extended
  programador : marcelo neves
*/

#include 'minigui.ch'
#include 'hbcompat.ch'

function movimento_do_dia()

         define window form_movimento;
                at 000,000;
                width getdesktopwidth();
                height getdesktopheight();
                title 'Movimento do Dia';
                icon path_imagens+'icone.ico';
                modal;
                on init popula_grid_movimento()
                /*
                  grid
                */
                @ 000,005 grid grid_movimento;
                          parent form_movimento;
                          width getdesktopwidth()-015;
                          height getdesktopheight()-125;
                          headers {'id_venda','id','Data','Hora','Tipo','Valor R$','Telefone','Nome'};
                          widths {1,1,120,100,200,150,100,350};
                          font 'verdana' size 10;
                          backcolor WHITE;
                          fontcolor BLUE
				/*
				  botões
				*/
                @ getdesktopheight()-110,005 buttonex botao_f6;
                          parent form_movimento;
                          caption 'Imprimir Comanda';
                          width 200 height 040;
                          picture path_imagens+'img_relatorio.bmp';
                          font 'tahoma' size 010;
                          bold;
                          action imprimir_comanda()
                @ getdesktopheight()-110,210 buttonex botao_f9;
                          parent form_movimento;
                          caption 'Imprimir Resumo';
                          width 200 height 040;
                          picture path_imagens+'img_relatorio.bmp';
                          font 'tahoma' size 010;
                          bold;
                          action imprimir_resumo()
                @ getdesktopheight()-110,415 buttonex botao_esc;
                          parent form_movimento;
                          caption 'ESC - Sair';
                          width 140 height 040;
                          picture path_imagens+'img_sair.bmp';
                          font 'tahoma' size 010;
                          bold;
                          action form_movimento.release
                          
                on key escape action thiswindow.release

         end window

         form_movimento.maximize
         form_movimento.activate

         return(nil)
*-------------------------------------------------------------------------------
static function popula_grid_movimento()

	   local v_old_idvenda, v_old_id, v_old_data, v_old_hora, v_old_tipo, v_old_valor, v_old_telefone, v_old_nomecliente, v_old_nomebalcao, v_old_fechado
	   local v_soma := 0
	   local x_data_pesquisa := dtos(date())

       delete item all from grid_movimento of form_movimento

	   dbselectarea('temp_vendas')
 	   temp_vendas->(ordsetfocus('data'))
  	   temp_vendas->(dbgotop())
   	   temp_vendas->(dbseek(x_data_pesquisa))
   	   if found()
       	  while .T.
		  		v_old_idvenda     := temp_vendas->id_venda
				v_old_id          := temp_vendas->id
				v_old_data        := temp_vendas->data
				v_old_hora        := temp_vendas->hora
				v_old_tipo        := temp_vendas->descricao
				v_old_valor       := temp_vendas->subtotal
				v_old_telefone    := temp_vendas->telefone
				v_old_nomecliente := alltrim(temp_vendas->nome_cli)
				v_old_nomebalcao  := alltrim(temp_vendas->nome_bal)
				v_old_fechado     := temp_vendas->fechado
       	        v_soma            := v_soma + temp_vendas->subtotal
             	temp_vendas->(dbskip())
             	if dtos(temp_vendas->data) <> x_data_pesquisa .and. v_old_fechado == 0
             	   if v_old_fechado == 0
					  v_soma := 0
				   endif
       		 	   add item {alltrim(v_old_idvenda),alltrim(v_old_id),dtoc(v_old_data),alltrim(v_old_hora),alltrim(v_old_tipo),trans(v_soma,'@E 999,999.99'),v_old_telefone,v_old_nomecliente+v_old_nomebalcao} to grid_movimento of form_movimento
       		 	   v_soma := 0
             	   exit
             	endif
             	if temp_vendas->id_venda <> v_old_idvenda .and. v_old_fechado == 0
             	   if v_old_fechado == 0
					  v_soma := 0
				   endif
       		 	   add item {alltrim(v_old_idvenda),alltrim(v_old_id),dtoc(v_old_data),alltrim(v_old_hora),alltrim(v_old_tipo),trans(v_soma,'@E 999,999.99'),v_old_telefone,v_old_nomecliente+v_old_nomebalcao} to grid_movimento of form_movimento
       		 	   v_soma := 0
				endif
          end
       else
		  msginfo('Não existe movimento para hoje','Atenção')
	   endif

	   return(nil)
*-------------------------------------------------------------------------------
static function imprimir_comanda()

	   local v_parametro := alltrim(valor_coluna('grid_movimento','form_movimento',1))

       local x_nome
	   local x_fixo
	   local x_endereco
	   local x_numero
	   
	   local x_tipo_venda
	   local x_nome_balcao
	   local x_telefone_cliente
       local x_nome_cliente
       local x_endereco_1
       local x_endereco_2
       local x_endereco_3
       
       local x_total
       local v_total_comanda := 0
       local v_calcula_10 := 0
       local v_old_id, v_old_hora, v_old_tipo
       local v_nome_venda, m_nome_mesa
       
       if empty(v_parametro)
          msgalert('Não existe informação para ser impressa a comanda, tecle ENTER','Atenção')
          return(nil)
       endif

	   /*
	     encontra informações
	   */
       dbselectarea('temp_vendas')
 	   temp_vendas->(ordsetfocus('id_venda'))
  	   temp_vendas->(dbgotop())
   	   temp_vendas->(dbseek(v_parametro))
   	   if found()
	   	  x_tipo_venda       := temp_vendas->tipo_venda
	   	  x_nome_balcao      := temp_vendas->nome_bal
	   	  x_telefone_cliente := temp_vendas->telefone
       	  x_nome_cliente     := temp_vendas->nome_cli
       	  x_endereco_1       := temp_vendas->end_1
       	  x_endereco_2       := temp_vendas->end_2
       	  x_endereco_3       := temp_vendas->end_3
       	  m_nomemesa         := alltrim(temp_vendas->descricao)
   	   endif

       if x_tipo_venda == 1
          v_nome_venda := 'DELIVERY'
       elseif x_tipo_venda == 2
          v_nome_venda := 'BALCÃO'
       elseif x_tipo_venda == 3
          v_nome_venda := 'MESA'
       endif

       dbselectarea('empresa')
       empresa->(dbgotop())
       x_nome     := alltrim(empresa->nome)
       x_fixo     := alltrim(empresa->fixo_1)
       x_endereco := alltrim(empresa->endereco)
       x_numero   := alltrim(empresa->numero)

	   Try

          SET PRINTER ON
          SET PRINTER TO LPT1
          SET CONSOLE OFF

          ? x_nome
          ? x_endereco+', '+x_numero+', '+x_fixo
          ? '------------------------------------------------'
          ? '        COMANDA PARA SIMPLES CONFERENCIA'
          ? '             NAO E DOCUMENTO FISCAL'
          ? '                VENDA : '+m_nomemesa
          ? '================================================'
          if x_tipo_venda == 1
          	 ? 'CLIENTE:'+x_telefone_cliente+'-'+x_nome_cliente
          	 ? ' '+x_endereco_1
          	 ? ' '+x_endereco_2
          	 ? ' '+x_endereco_3
          elseif x_tipo_venda == 2
          	 ? 'CLIENTE:'+x_nome_balcao
          endif
          ? 'DATA      : '+dtoc(date())+'  HORA: '+time()
          ? '------------------------------------------------'
          ? 'PRODUTO                    QTD  UNIT.  SUB-TOTAL'
          ? ''
          /*
            imprime as pizzas
          */
          dbselectarea('temp_vendas')
       	  temp_vendas->(ordsetfocus('id_venda'))
       	  temp_vendas->(dbgotop())
       	  temp_vendas->(dbseek(v_parametro))
       	  if found()
          	 while .T.
                   v_old_id   := temp_vendas->id_venda
                   v_old_hora := temp_vendas->hora
                   v_old_tipo := temp_vendas->tipo
                   if temp_vendas->tipo == 1 //pizza
                   	  v_total_comanda := v_total_comanda + temp_vendas->subtotal
                   	  if substr(temp_vendas->nome,2,1) == '/'
                   	  	 ? alltrim(temp_vendas->nome)
                      elseif substr(temp_vendas->nome,1,3) == '-->'
                         ? substr(temp_vendas->nome,1,39)+'  '+trans(temp_vendas->subtotal,'@E 999.99')
                      elseif substr(temp_vendas->nome,1,2) == '->'
                         ? substr(temp_vendas->nome,1,39)+'  '+trans(temp_vendas->subtotal,'@E 999.99')
                      endif
				   endif
	   	  		   temp_vendas->(dbskip())
	   	  		   if temp_vendas->hora <> v_old_hora .and. v_old_tipo == 1
                      ? '------------------------------------------------'
	   	  		   endif
     	   	  	   if temp_vendas->id_venda <> v_old_id
  	  	 		   	  exit
	               endif
             end
          endif
          /*
            imprime os produtos
          */
          dbselectarea('temp_vendas')
       	  temp_vendas->(ordsetfocus('id_venda'))
       	  temp_vendas->(dbgotop())
       	  temp_vendas->(dbseek(v_parametro))
       	  if found()
          	 while .T.
                   v_old_id := temp_vendas->id_venda
                   if temp_vendas->tipo == 2 //produtos
                   	  v_total_comanda := v_total_comanda + temp_vendas->subtotal
                      ? substr(temp_vendas->nome,1,25)+'  '+str(temp_vendas->qtd,3)+' '+trans(temp_vendas->unitario,'@E 999.99')+'   '+trans(temp_vendas->subtotal,'@E 9,999.99')
                      //? '------------------------------------------------'
				   endif
	   	  		   temp_vendas->(dbskip())
     	   	  	   if temp_vendas->id_venda <> v_old_id
  	  	 		   	  exit
	               endif
             end
          endif
          ? '================================================'
  	      if x_tipo_venda == 3 //mesas
  	         v_calcula_10 := ( ( v_total_comanda * 10 ) / 100 )
  	         ? '                     TOTAL CONSUMO : '+trans(v_total_comanda,'@E 999,999.99')
  	         ? '                               10% : '+trans(v_calcula_10,'@E 999,999.99')
  	         ? '                      TOTAL PEDIDO : '+trans(v_total_comanda+v_calcula_10,'@E 999,999.99')
  	      else
  	         ? '                      TOTAL PEDIDO : '+trans(v_total_comanda,'@E 999,999.99')
  	      endif
          ? ''
          ? ''
          ? ''
          ? ''
          ? ''
          ? ''
          ? ''
          ? ''
          ? ''
          ? ''
          ? ''

          SET CONSOLE ON
          SET PRINTER TO
          SET PRINTER OFF

       Catch e

  		  msgexclamation('A IMPRESSORA está DESLIGADA, por favor verifique','Atenção')
  		  return(nil)

       End

	   return(nil)
*-------------------------------------------------------------------------------
static function imprimir_resumo()

	   local x_data := dtos(date())
	   local x_old_data

	   /*
	     zerar tabelas
	   */
	   sele tmp_txa
	   zap
	   pack
	   sele tmp_fpg
	   zap
	   pack
	   sele tmp_tipo
	   zap
	   pack
	   sele tmp_tpr
	   zap
	   pack
	   
       dbselectarea('temp_vendas')
 	   temp_vendas->(ordsetfocus('data'))
  	   temp_vendas->(dbgotop())
   	   temp_vendas->(dbseek(x_data))
   	   if found()

   	      while .T.
   	      
   	            x_old_data := temp_vendas->data
   	            
   	            /*
   	              guarda as taxas
   	            */
				sele tmp_txa
				if temp_vendas->tipo_venda == 1
				   append blank
				   replace nome with 'TAXA ENTREGA'
				   replace qtd with 1
				   replace valor with temp_vendas->taxa_deliv
				   commit
				endif
				if temp_vendas->tipo_venda == 3
				   append blank
				   replace nome with 'TAXA MESAS'
				   replace qtd with 1
				   replace valor with temp_vendas->taxa_mesa
				   commit
				endif
				
				/*
				  guarda forma pagamento
				*/
				sele tmp_fpg
				append blank
				replace nome with temp_vendas->f_pagam
	   			replace qtd with 1
				replace valor with temp_vendas->subtotal
				commit
				
				/*
				  guarda tipo venda
				*/
				sele tmp_tipo
				append blank
				replace nome with temp_vendas->descricao
	   			replace qtd with 1
				replace valor with temp_vendas->subtotal
				commit
				
				/*
				  guarda produto : pizza
				*/
				if temp_vendas->tipo == 1 .and. substr(temp_vendas->nome,1,1) <> '-'
				   sele tmp_tpr
				   append blank
				   replace nome with temp_vendas->nome
				   replace qtd with temp_vendas->qtd_p
				   replace valor with temp_vendas->vlr_p
				   replace tipo with 1 //pizza descrição
				   commit
				endif
				sele temp_vendas
				if temp_vendas->tipo == 1 .and. substr(temp_vendas->nome,1,2) == '->'
				   sele tmp_tpr
				   append blank
				   replace nome with temp_vendas->nome
				   replace qtd with temp_vendas->qtd
				   replace valor with temp_vendas->subtotal
				   replace tipo with 2 //pizza descrição montada
				   commit
				endif
				sele temp_vendas
				if temp_vendas->tipo == 1 .and. substr(temp_vendas->nome,1,3) == '-->'
				   sele tmp_tpr
				   append blank
				   replace nome with temp_vendas->nome
				   replace qtd with 1
				   replace valor with temp_vendas->subtotal
				   replace tipo with 3 //borda pizza
				   commit
				endif
				sele temp_vendas
				if temp_vendas->tipo == 2
				   sele tmp_tpr
				   append blank
				   replace nome with temp_vendas->nome
				   replace qtd with temp_vendas->qtd
				   replace valor with temp_vendas->subtotal
				   replace tipo with 4 //refri, cerveja, etc
				   commit
				endif

				sele temp_vendas
				
   	            temp_vendas->(dbskip())
   	            
   	            if dtos(temp_vendas->data) <> x_data
   	               exit
				endif
   	      end
   	   endif

       	  Try
          	 SET PRINTER ON
          	 SET PRINTER TO LPT1
			 /*
			   imprime cabeçalho
			 */
			 ? 'RELACAO DE VENDA POR PRODUTO : '+dtoc(date())
    		 ? '----------------------------------------'
			 /*
			   imprime caixa
			 */
       		 dbselectarea('ccaixa')
       		 ordsetfocus('data')
       		 ccaixa->(dbgobottom())
       		 ? 'CAIXA ABERTO:'+dtoc(ccaixa->data)+' '+alltrim(ccaixa->hora)+' R$'+trans(ccaixa->valor,'@E 999,999.99')
    		 ? '----------------------------------------'
			 /*
			   imprime venda 1 por 1
			 */
			 x_soma_geral := 0
			 x_old_tipo := 0
			 x_old_nome := ''
			 x_soma_qtd := 0
			 x_soma_vlr := 0
			 sele tmp_tpr
			 index on str(tipo,2)+nome to indxpt
			 go top
			 while .not. eof()
				   x_old_tipo := tmp_tpr->tipo
				   x_old_nome := alltrim(tmp_tpr->nome)
				   x_soma_qtd := ( x_soma_qtd + tmp_tpr->qtd )
				   x_soma_vlr := ( x_soma_vlr + tmp_tpr->valor )
				   tmp_tpr->(dbskip())
				   if alltrim(tmp_tpr->nome) <> x_old_nome
			 	   	  ? substr(x_old_nome,1,30)+'  '+str(x_soma_qtd,6)+'  '+trans(x_soma_vlr,'@E 999,999.99')
			 	      ? '----------------------------------------'
			 	      x_soma_geral := ( x_soma_geral + x_soma_vlr )
			 	   	  x_soma_qtd := 0
			 	   	  x_soma_vlr := 0
				   endif
			 end
    		 ? '----------------------------------------'
    		 ? '                 TOTAL R$ '+trans(x_soma_geral,'@E 999,999.99')
    		 ? '----------------------------------------'
    		 /*
    		   resume as taxas
    		 */
    		 s_soma_1 := 0
    		 s_soma_2 := 0
    		 s_soma_3 := 0
    		 xv_nome_old := ''
    		 sele tmp_txa
			 index on nome to indn01
			 go top
			 while .not. eof()
				   xv_nome_old := alltrim(tmp_txa->nome)
				   s_soma_1    := ( s_soma_1 + tmp_txa->valor )
				   s_soma_3    := ( s_soma_3 + tmp_txa->qtd )
				   tmp_txa->(dbskip())
				   if alltrim(tmp_txa->nome) <> xv_nome_old
				      ? substr(xv_nome_old,1,20)+' '+str(s_soma_3,3)+' '+trans(s_soma_1,'@E 999,999.99')
				      s_soma_2 := ( s_soma_2 + s_soma_1 )
				      s_soma_1 := 0
				      s_soma_3 := 0
				   endif
			 end
    		 ? '                 TOTAL R$ '+trans(s_soma_2,'@E 999,999.99')
    		 ? '----------------------------------------'
    		 /*
    		   resume as formas pagamento
    		 */
    		 s_soma_1 := 0
    		 s_soma_2 := 0
    		 s_soma_3 := 0
    		 xv_nome_old := ''
    		 sele tmp_fpg
			 index on nome to indn02
			 go top
			 while .not. eof()
				   xv_nome_old := alltrim(tmp_fpg->nome)
				   s_soma_1    := ( s_soma_1 + tmp_fpg->valor )
				   s_soma_3    := ( s_soma_3 + tmp_fpg->qtd )
				   tmp_fpg->(dbskip())
				   if alltrim(tmp_fpg->nome) <> xv_nome_old
				      ? substr(xv_nome_old,1,20)+' '+str(s_soma_3,3)+' '+trans(s_soma_1,'@E 999,999.99')
				      s_soma_2 := ( s_soma_2 + s_soma_1 )
				      s_soma_1 := 0
				      s_soma_3 := 0
				   endif
			 end
    		 ? '                 TOTAL R$ '+trans(s_soma_2,'@E 999,999.99')
    		 ? '----------------------------------------'
    		 /*
    		   resume os tipos de venda
    		 */
    		 s_soma_1 := 0
    		 s_soma_2 := 0
    		 s_soma_3 := 0
    		 xv_nome_old := ''
    		 sele tmp_tipo
			 index on nome to indn03
			 go top
			 while .not. eof()
				   xv_nome_old := alltrim(tmp_tipo->nome)
				   s_soma_1    := ( s_soma_1 + tmp_tipo->valor )
				   s_soma_3    := ( s_soma_3 + tmp_tipo->qtd )
				   tmp_tipo->(dbskip())
				   if alltrim(tmp_tipo->nome) <> xv_nome_old
				      ? substr(xv_nome_old,1,20)+' '+str(s_soma_3,3)+' '+trans(s_soma_1,'@E 999,999.99')
				      s_soma_2 := ( s_soma_2 + s_soma_1 )
				      s_soma_1 := 0
				      s_soma_3 := 0
				   endif
			 end
    		 ? '                 TOTAL R$ '+trans(s_soma_2,'@E 999,999.99')
    		 ? '----------------------------------------'
          	 SET PRINTER TO
          	 SET PRINTER OFF
          Catch e
  		     msgexclamation('A IMPRESSORA está DESLIGADA, por favor verifique','Atenção')
  		     return(nil)
          End

	   return(nil)