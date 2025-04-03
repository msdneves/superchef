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

function relatorio_resumo()

       local x_codigo     := ''
	   local x_descricao  := ''
	   local x_pagamento  := ''
	   local x_taxa_e     := 0
	   local x_taxa_m     := 0
	   local x_total      := 0
	   local x_ncaixa     :=''

	   public x_borda     := 0

	   public x_gra       := 0
	   public x_med       := 0
	   *-refrigerqante
	   public x_ref       := 0
	   public x_tre       := 0
	   *-cerveja
	   public x_cer       := 0
	   public x_tce       := 0
	   *esfiha
	   public x_esf       := 0
   	   public x_vef       := 0
   	   *suco
	   public x_suc       := 0
	   public x_tsu       := 0

	   public x_qpi       := 0
	   public x_tpi       := 0

 	   public x_vgr       := 0
	   public x_vme       := 0

	   public x_qtb       := 0
       public x_vlgeral   := 0

	   public x_cartao    := 0
	   public x_dinheiro  := 0


         define window form_resumo_001;
                at 000,000;
                width 400;
                height 250;
                title 'Pizzas mais vendidas';
                icon path_imagens+'icone.ico';
                modal;
                nosize

                @ 010,010 label lbl_001;
                          of form_resumo_001;
                          value 'Escolha o intervalo de datas';
                          autosize;
                          font 'tahoma' size 010;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 040,010 datepicker dp_inicio;
                          parent form_resumo_001;
                          value date();
                          width 150;
                          height 030;
                          font 'verdana' size 014
                @ 080,010 label lbl_002;
                          of form_resumo_001;
                          value 'Informe o numero do caixa:';
                          autosize;
                          font 'tahoma' size 010;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 100,010 textbox tbox_001;
                          of form_resumo;
                          height 027;
                          width 060;
                          value '';
                          maxlength 04;
                          font 'tahoma' size 010;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1;
                          uppercase


                * linha separadora
                define label linha_rodape
                       col 000
                       row form_resumo_001.height-090
                       value ''
                       width form_resumo_001.width
                       height 001
                       backcolor _preto_001
                       transparent .F.
                end label

                * botões
                define buttonex button_ok
                       picture path_imagens+'img_relatorio.bmp'
                       col form_resumo_001.width-255
                       row form_resumo_001.height-085
                       width 150
                       height 050
                       caption 'Ok, imprimir'
                       action gerarel()
                       fontbold .T.
                       tooltip 'Gerar o relatório'
                       flat .F.
                       noxpstyle .T.
                end buttonex
                define buttonex button_cancela
                       picture path_imagens+'img_sair.bmp'
                       col form_resumo_001.width-100
                       row form_resumo_001.height-085
                       width 090
                       height 050
                       caption 'Voltar'
                       action form_resumo_001.release
                       fontbold .T.
                       tooltip 'Sair desta tela'
                       flat .F.
                       noxpstyle .T.
                end buttonex

                on key escape action thiswindow.release

         end window
         
         form_resumo_001.center
         form_resumo_001.activate

         return(nil)
         
static function gerarel()


         local x_ncaixa   := form_resumo_001.tbox_001.value
         local xdp_inicio := form_resumo_001.dp_inicio.value

		 local xchave := x_ncaixa //+dtoc(xdp_inicio)

  		 *- arquivo  de venda
         dbselectarea('temp_vendas')
         temp_vendas->(ordsetfocus('nccaixa_venda'))
         temp_vendas->(dbgotop())
         temp_vendas->(dbseek(xchave))
*		 if .not.found()
*		 else
*	         msgexclamation('Não foi localizado esse numero de Caixa!!!','Atenção')
*             return(nil)
*		 endif
		 
		 *-gerar as rotinas de barda pizza grande pizza media ref.cer.suc.
		 while .not. eof()

				*-saltar caixa não correspondente
				if ncaixa<>xchave
                   temp_vendas->(dbskip())
				endif

                if substr(f_pagam,1,6)=='CARTAO'
                   x_cartao=x_cartao+qtd_p*vlr_p
			    elseif substr(f_pagam,1,8)=='DINHEIRO'
		           x_dinheiro=x_dinheiro+qtd_p*vlr_p
				endif

				*-total das esfihas...
                if substr(temp_vendas->nome,2,1) == '/' .and. substr(temp_vendas->nome,5,3) == 'ESF'
                   x_vef := (x_vef+(qtd_p*vlr_p))
				elseif substr(temp_vendas->nome,2,1) == '/'
                   *-total de pizzas
	        	   x_qpi := x_qpi+qtd_p
				   x_tpi := x_tpi+vlr_p
				endif

                if substr(temp_vendas->nome,1,3) == 'CER'
                   x_cer := x_cer+qtd
                   x_tce := (x_tce+(qtd_p*vlr_p))
                elseif substr(temp_vendas->nome,1,3) == 'REF'
                   x_ref := x_ref+qtd
                   x_tre := (x_tre+(qtd_p*vlr_p))
		        elseif substr(temp_vendas->nome,1,3) == 'SUC'
                   x_suc := x_suc+qtd
                   x_tsu := (x_tsu+(qtd_p*vlr_p))
                endif
			 
     			if substr(temp_vendas->nome,1,2) == '->' // tamamho
                   if substr(temp_vendas->nome,4,3) == 'GRA'
                      x_gra := x_gra+qtd
                      x_vgr := x_vgr+subtotal
                      elseif substr(temp_vendas->nome,4,3) == 'MED'
                      x_med := x_med+qtd
                      x_vme := x_vme+subtotal
                      elseif substr(temp_vendas->nome,4,3) == 'ESF'
                      x_esf := x_esf+qtd
                   endif
				elseif substr(temp_vendas->nome,1,3) == '-->' // borda
				   x_qtb   := x_qtb+1
				   x_borda := x_borda + temp_vendas->subtotal
				endif

				*-saltar para o proximo
                temp_vendas->(dbskip())

		 end


  		 *- arquivo  de venda
         dbselectarea('temp_vendas')
         temp_vendas->(ordsetfocus('produtos'))
         temp_vendas->(dbgotop())

         while .not. eof()
         
            *-rejeitar se o campo produto estiver em branco
		    if substr(temp_vendas->produto,1,3) == space(3)
		       temp_vendas->(dbskip())
		    endif

            *-guardar o codigo para ver se existe no arquivo temporario..
            x_codigo    := temp_vendas->produto

            if substr(x_codigo,1,10) <> space(10)
			   x_descricao := temp_vendas->descricao
			   x_pagamento := temp_vendas->f_pagam
			   x_taxa_e    := temp_vendas->taxa_deliv
			   x_taxa_m    := temp_vendas->taxa_mesa
			   x_quant     := temp_vendas->qtd_p
			   x_vtotal    := temp_vendas->vlr_p*x_quant
			   
			   *-arquivo temporario
               dbselectarea('temp_curva')
               temp_curva->(ordsetfocus('produto'))
               temp_curva->(dbgotop())
               temp_curva->(dbseek(x_codigo))
			   if .not. found()
				  *-se não existir ele grava um novo.
	              dbselectarea('temp_curva')
                  temp_curva->(dbappend())
                  replace produto     with x_codigo
                  replace qtd         with x_quant
				  replace descricao   with x_descricao
				  replace pagamento   with x_pagamento
				  replace taxa_e      with x_taxa_e
				  replace taxa_m      with x_taxa_m
				  replace vtotal      with x_vtotal
                  temp_curva->(dbcommit())
                  temp_curva->(dbgotop())
		       else
				  *-se existir grava a soma da quantidade.
			      dbselectarea('temp_curva')
                  if lock_reg()
                     replace qtd    with qtd + x_quant
                     replace vtotal with vtotal + x_vtotal
                     temp_curva->(dbcommit())
                     temp_curva->(dbgotop())
				  endif
               endif

			endif
			
    	   *-volta para o arquivo principal e vai pra o proximo registro
           dbselectarea('temp_vendas')
           temp_vendas->(dbskip())

         end

         *-chamar o relatorio.
		 relresumo(x_gra,x_med,x_borda,x_cer,x_ref,x_esf,x_suc)
         
         return(nil)
*--------------------------------------------
static function relresumo(x_gra,x_med,x_borda,x_cer,x_ref,x_esf,x_suc)


	   local x_chave := ''
	   local p_linha := 061
       local u_linha := 260
       local linha   := p_linha
       local pagina  := 1
	   local x_de    := date()
	   local x_ate   := date()
	   local x_qua   := 0

	   *-somar o valor das pizzas mais as bordas..
	   x_tpi   := x_tpi + x_borda


       SELECT PRINTER DIALOG PREVIEW

       START PRINTDOC NAME 'Gerenciador de impressão'
       START PRINTPAGE

	   *-imprimir cabeçalho
       cabresumo(pagina)

		  *-abrir o arquivo temporario para impressao
          dbselectarea('temp_curva')
          temp_curva->(ordsetfocus('xquant'))
          temp_curva->(dbgotop())
          while .not. eof()

				*-quardar o codigo do produto para pesquisar a descricao
				x_chave  := temp_curva->produto
				x_qtd    := qtd
				x_vtotal := vtotal
				x_geral  := x_vtotal

				*-capturar o nome do produto.
	            dbselectarea('produtos')
                produtos->(ordsetfocus('codigo'))
                produtos->(dbgotop())
                produtos->(dbseek(x_chave))
                if found()
	               x_nome := nome_longo
			    else
				   x_nome :='NÃO LOCALIZADO'
		        endif

                @ linha,020 PRINT x_nome FONT 'courier new' SIZE 010
                @ linha,105 PRINT strzero(temp_curva->qtd,6) FONT 'courier new' SIZE 010
                @ linha,130 PRINT trans(x_geral,'@E 999,999.99') FONT 'courier new' SIZE 010

				*-total geral.
				x_vlgeral=x_vlgeral+x_borda+x_geral

   				*-voltar para o curva
                dbselectarea('temp_curva')
                temp_curva->(dbskip())

                linha += 5

                if linha >= u_linha
                   END PRINTPAGE
                   START PRINTPAGE
                   pagina ++
                   cabresumo(pagina)
                   linha := p_linha
                endif
          end

		  *-imprimir o tamaho das pizzas
		    linha +=20
          @ linha,020 PRINT 'GRANDE.:'+strzero(x_gra,6) FONT 'courier new' SIZE 010
          @ linha,080 PRINT+ trans(x_vgr,'@E 999,999.99') FONT 'courier new' SIZE 010
			linha +=5
          @ linha,020 PRINT 'MEDIA..:'+strzero(x_med,6) FONT 'courier new' SIZE 010
          @ linha,080 PRINT+ trans(x_vme,'@E 999,999.99') FONT 'courier new' SIZE 010
			linha +=5
          @ linha,020 PRINT 'BORDAS.:'+strzero(x_qtb,6) FONT 'courier new' SIZE 010
		  @ linha,080 PRINT trans(x_borda,'@E 999,999.99') FONT 'courier new' SIZE 010
			linha +=5
          @ linha,020 PRINT 'REF....:'+strzero(x_ref,6) FONT 'courier new' SIZE 010
          @ linha,080 PRINT+ trans(x_tre,'@E 999,999.99') FONT 'courier new' SIZE 010
			linha +=5
          @ linha,020 PRINT 'CER....:'+strzero(x_cer,6) FONT 'courier new' SIZE 010
          @ linha,080 PRINT+ trans(x_tce,'@E 999,999.99') FONT 'courier new' SIZE 010
			linha +=5
          @ linha,020 PRINT 'SUCO...:'+strzero(x_suc,6) FONT 'courier new' SIZE 010
          @ linha,080 PRINT+ trans(x_tsu,'@E 999,999.99') FONT 'courier new' SIZE 010
			linha +=10
		  @ linha,020 PRINT 'T.PIZZA:'+strzero(x_qpi,6) FONT 'courier new' SIZE 010
		  @ linha,080 PRINT+ trans(x_tpi,'@E 999,999.99') FONT 'courier new' SIZE 010
			linha +=5
          @ linha,020 PRINT 'T.ESF..:'+strzero(x_esf,6) FONT 'courier new' SIZE 010
		  @ linha,080 PRINT trans(x_vef,'@E 999,999.99') FONT 'courier new' SIZE 010
			linha +=5
		  @ linha,020 PRINT '------------------------------------------------------------------------------------------------'
			x_vlgeral := x_vlgeral+ccaixa->valor
			linha +=5
		  @ linha,020 PRINT 'T.GERAL:'  FONT 'courier new' SIZE 015
          @ linha,080 PRINT trans(x_vlgeral,'@E 999,999.99') FONT 'courier new' SIZE 010
        	linha +=5
		  @ linha,020 PRINT '------------------------------------------------------------------------------------------------'
			linha +=5
		  @ linha,020 PRINT 'CARTÃO..:'  FONT 'courier new' SIZE 015
          @ linha,080 PRINT trans(x_cartao,'@E 999,999.99') FONT 'courier new' SIZE 010
        	linha +=5
		  @ linha,020 PRINT 'DINHEIRO:'  FONT 'courier new' SIZE 015
          @ linha,080 PRINT trans(x_dinheiro,'@E 999,999.99') FONT 'courier new' SIZE 010
        	linha +=5
		  @ linha,020 PRINT '------------------------------------------------------------------------------------------------'
			linha +=5

       rodresumo()

       END PRINTPAGE
       END PRINTDOC

       return(nil)
*-------------------------------------------------------------------------------
static function cabresumo(pagina)

	   local x_de    := ccaixa->data
	   local x_ate   := ccaixa->data

	   *-pegar o caixa aberto..
       dbselectarea('ccaixa')
       ordsetfocus('data')
       ccaixa->(dbgobottom())
       x_caixa_aberto := 'CAIXA ABERTO:'+dtoc(ccaixa->data)+' '+alltrim(ccaixa->hora)+'           '+trans(ccaixa->valor,'@E 999,999.99')
	   x_valor_caixa  := ccaixa->valor

	   public x_caixa_aberto
	   public x_valor_caixa

       @ 007,010 PRINT IMAGE path_imagens+'logotipo.bmp' WIDTH 050 HEIGHT 020 STRETCH
       @ 010,070 PRINT 'CURVA DE VENDA POR QUANTIDADE' FONT 'courier new' SIZE 018 BOLD
       @ 018,070 PRINT dtoc(x_de)+' até '+dtoc(x_ate) FONT 'courier new' SIZE 014
       @ 030,070 PRINT 'página : '+strzero(pagina,4) FONT 'courier new' SIZE 012

       @ 036,000 PRINT LINE TO 036,205 PENWIDTH 0.5 COLOR _preto_001
   	   @ 038,020 PRINT x_caixa_aberto FONT 'courier new' SIZE 010
       @ 044,000 PRINT LINE TO 044,205 PENWIDTH 0.5 COLOR _preto_001

       @ 048,020 PRINT 'PRODUTO' FONT 'courier new' SIZE 010 BOLD
       @ 048,100 PRINT 'QUANTIDADE' FONT 'courier new' SIZE 010 BOLD
	   @ 048,130 PRINT 'Valor Total' FONT 'courier new' SIZE 010 BOLD

       return(nil)
*-------------------------------------------------------------------------------
static function rodresumo()

       @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR _preto_001
       @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008

       return(nil)





