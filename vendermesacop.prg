/*
  sistema     : superchef pizzaria
  programa    : venda delivery
  compilador  : xharbour 1.2 simplex
  lib gráfica : minigui 1.7 extended
  programador : marcelo neves
*/

#include 'minigui.ch'
#include 'miniprint.ch'
*#include 'hbcompat.ch'

#define ENTER chr(13) + chr(10)

function vendermesa()

		 local x_observacao_1 := ''
		 local x_observacao_2 := ''
		 local a_bordas := {}

		 a_tamanhos_pedacos := {}
		 if .not. empty(_tamanho_001)
	  	 	aadd(a_tamanhos_pedacos,_tamanho_001+' - '+alltrim(str(_pedaco_001))+' pedaços')
	  	 endif
		 if .not. empty(_tamanho_002)
	  	 	aadd(a_tamanhos_pedacos,_tamanho_002+' - '+alltrim(str(_pedaco_002))+' pedaços')
	  	 endif
		 if .not. empty(_tamanho_003)
	  	 	aadd(a_tamanhos_pedacos,_tamanho_003+' - '+alltrim(str(_pedaco_003))+' pedaços')
	  	 endif
		 if .not. empty(_tamanho_004)
	  	 	aadd(a_tamanhos_pedacos,_tamanho_004+' - '+alltrim(str(_pedaco_004))+' pedaços')
	  	 endif
		 if .not. empty(_tamanho_005)
	  	 	aadd(a_tamanhos_pedacos,_tamanho_005+' - '+alltrim(str(_pedaco_005))+' pedaços')
	  	 endif
		 if .not. empty(_tamanho_006)
	  	 	aadd(a_tamanhos_pedacos,_tamanho_006+' - '+alltrim(str(_pedaco_006))+' pedaços')
	  	 endif

         private _conta_pizza := 1
         private _total_pedido := 0
         private _preco_antes_borda := 0
         public _tamanho_selecionado
         public _numero_tamanho := 1
         
         public _conta_sequencia := 100

         a_nome_borda  := {}
         a_valor_borda := {}

		 sele bordas
		 go top
		 while .not. eof()
		       if .not. empty(bordas->nome)
		       	  aadd(a_bordas,bordas->nome+'-'+trans(bordas->preco,'@E 999.99'))
		       	  aadd(a_nome_borda,bordas->nome)
		       	  aadd(a_valor_borda,bordas->preco)
		       endif
			   skip
		 end
		 
		 sele montagem
		 zap
		 pack
		 *sele temp_vendas
		 *zap
		 *pack
		 sele tmp_tela
		 zap
		 pack

         define window form_vender;
                at 0,0;
                width 1020;
                height 700;
                title 'VENDER : Delivery, Mesas e Balcão';
                icon path_imagens+'icone.ico';
                modal;
                nosize;
                on init ( zera_tabelas_mesa(), desabilita_campos_mesa() )
                /*
                  cabeçalho da tela : onde mostra qual a operação de venda escolhida
                */
                @ 000,000 label label_cabecalho;
                          of form_vender;
                          width form_vender.width;
                          height 40;
                          value '';
                          font 'verdana' size 22;
                          bold;
                          backcolor _preto_001;
                          fontcolor _cinza_001;
                          centeralign


                /*
                  botões
                */
                @ 490,005 buttonex botao_abre;
                          parent form_vender;
                          caption 'ABRIR';
                          width 190 height 40;
                          picture path_imagens+'img_abre_mesa.bmp';
                          action abrir_mesa();
                          font 'courier new' size 10;
                          bold;
                		  notabstop
                @ 535,005 buttonex botao_consumo;
                          parent form_vender;
                          caption 'LIMPAR';
                          width 190 height 40;
                          picture path_imagens+'img_consumo_mesa.bmp';
                          action limpar_mesa();
                          font 'courier new' size 10;
                          bold;
                		  notabstop
                @ 580,005 buttonex botao_fecha;
                          parent form_vender;
                          caption 'FECHAR VENDA';
                          width 190 height 40;
                          picture path_imagens+'img_fecha_mesa.bmp';
                          action fecha_pedido_mesa();
                          font 'courier new' size 10;
                          bold;
                		  notabstop
                @ 625,005 buttonex botao_sair_tela;
                          parent form_vender;
                          caption 'SAIR TELA VENDA';
                          width 190 height 40;
                          picture path_imagens+'exit24_h.bmp';
                          action pergunta_saida_mesa();
                          font 'courier new' size 10;
                          bold;
                		  notabstop
                /*
                  botão cadastrar novo produto
                */
                @ 045,860 buttonex botao_cadastra_produto;
                          parent form_vender;
                          caption 'Novo Produto';
                          width 150 height 40;
                          picture path_imagens+'img_cadastra.bmp';
                          action cadastrar_novo_produto_mesa();
                          font 'courier new' size 10;
                          bold;
                		  notabstop;
                          tooltip 'Clique aqui para cadastrar um produto novo, sem precisar sair desta tela'

				/*
				  separadores
				*/
                define label label_separador
                       col 200
                       row 040
                       value ''
                       width 002
                       height form_vender.height
                       transparent .F.
                       backcolor {0,0,0}
                end label
                define label label_separador_3
                       col 202
                       row 135
                       value ''
                       width 820
                       height 2
                       transparent .F.
                       backcolor {192,192,192}
                end label
                define label label_separador_4
                       col 202
                       row 300
                       value ''
                       width 820
                       height 2
                       transparent .F.
                       backcolor {192,192,192}
                end label
                define label label_separador_5
                       col 202
                       row 370
                       value ''
                       width 820
                       height 2
                       transparent .F.
                       backcolor {192,192,192}
                end label
                /*
                  venda de PIZZA e de PRODUTOS
                */
                /*
                  tamanho da pizza
                */
			    @ 140,210 label label_pizza;
     		  			  of form_vender;
                          value 'Tamanho';
                          autosize;
                          font 'courier new' size 12;
                          bold;
                          fontcolor _preto_001;
                          transparent
     		    define comboboxex cbo_tamanhos
         	  		   row 160
                       col 210
	              	   width 100
			           height 400
			           listwidth 300
			           items a_tamanhos_pedacos
			           value 1
			           fontname 'courier new'
			           fontsize 10
			           fontcolor BLUE
			           onchange pega_tamanho_mesa()
         	    end comboboxex
         	    /*
         	      selecionar a(s) pizza(s)
         	    */
			    @ 140,370 label label_pizza_2;
     		  			  of form_vender;
                          value 'Sabor(es) Escolhido(s)';
                          autosize;
                          font 'courier new' size 12;
                          bold;
                          fontcolor _preto_001;
                          transparent
         	    /*
         	      composição da pizza, escolha do sabor, borda, quantidade e observação
         	    */
         	    /*
         	      composição 1
         	    */
     		    define comboboxex cbo_composicao_1
         	  		   row 160
                       col 315
	              	   width 50
			           height 300
			           listwidth 150
			           items a_composicao
			           value 1
			           fontname 'courier new'
			           fontsize 10
			           fontcolor BLUE
         	    end comboboxex
         	    /*
         	      pizza 1
         	    */
                @ 160,370 textbox tbox_pizza_1;
                          of form_vender;
                          height 030;
                          width 050;
                          font 'courier new' size 14;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1;
                          on enter procura_pizza_mesa(1)
			    @ 160,425 label label_nome_pizza_1;
     		  			  of form_vender;
						  width 220;
						  height 40;
                          value '';
                          font 'courier new' size 12;
                          fontcolor BLUE;
                          transparent
                /*
                  borda - escolha do cliente
                */
			    @ 140,750 label label_borda;
     		  			  of form_vender;
                          value 'Borda';
                          autosize;
                          font 'courier new' size 12;
                          bold;
                          fontcolor _preto_001;
                          transparent
     		    define comboboxex cbo_bordas
         	  		   row 160
                       col 750
	              	   width 120
			           height 400
			           listwidth 250
			           items a_bordas
			           value 1
			           fontname 'courier new'
			           fontsize 12
			           fontcolor BLUE
			           on gotfocus verifica_campo_vazio_mesa(1)
         	    end comboboxex
         	    /*
         	      quantidade
         	    */
			    @ 140,900 label label_quantidade;
     		  			  of form_vender;
                          value 'Quantidade';
                          autosize;
                          font 'courier new' size 12;
                          bold;
                          fontcolor _preto_001;
                          transparent
		  		@ 160,900 spinner sp_quantidade;
		  		          range 1,900;
				  		  value 1;
						  width 100;
						  height 30;
						  font 'courier new' size 12;
						  bold
				/*
				  observações
				*/
			    @ 195,750 label label_observacao;
     		  			  of form_vender;
                          value 'Observações';
                          autosize;
                          font 'courier new' size 12;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 215,750 textbox tbox_observacao;
                          of form_vender;
                          height 030;
                          width 250;
                          value '';
                          maxlength 40;
                          font 'courier new' size 14;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1
                /*
                  botão grava pizza
                */
                @ 255,890 buttonex botao_gravar_pizza;
                          parent form_vender;
                          caption 'GRAVAR';
                          width 120 height 040;
                          picture path_imagens+'img_gravar.bmp';
                          action fecha_montagem_pizza_mesa();
                		  font 'courier new' size 12 bold;
                		  backcolor {217,217,255}
				/*
				  composição 2
				*/
     		    define comboboxex cbo_composicao_2
         	  		   row 195
                       col 315
	              	   width 50
			           height 300
			           listwidth 150
			           items a_composicao
			           value 1
			           fontname 'courier new'
			           fontsize 10
			           fontcolor BLUE
         	    end comboboxex
         	    /*
         	      pizza 2
         	    */
                @ 195,370 textbox tbox_pizza_2;
                          of form_vender;
                          height 030;
                          width 050;
                          font 'courier new' size 14;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1;
                          on enter procura_pizza_mesa(2)
			    @ 195,425 label label_nome_pizza_2;
     		  			  of form_vender;
						  width 220;
						  height 40;
                          value '';
                          font 'courier new' size 12;
                          fontcolor BLUE;
                          transparent
				/*
				  composição 3
				*/
     		    define comboboxex cbo_composicao_3
         	  		   row 230
                       col 315
	              	   width 50
			           height 300
			           listwidth 150
			           items a_composicao
			           value 1
			           fontname 'courier new'
			           fontsize 10
			           fontcolor BLUE
         	    end comboboxex
         	    /*
         	      pizza 3
         	    */
                @ 230,370 textbox tbox_pizza_3;
                          of form_vender;
                          height 030;
                          width 050;
                          font 'courier new' size 14;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1;
                          on enter procura_pizza_mesa(3)
			    @ 230,425 label label_nome_pizza_3;
     		  			  of form_vender;
						  width 220;
						  height 40;
                          value '';
                          font 'courier new' size 12;
                          fontcolor BLUE;
                          transparent
         	    /*
         	      composição 4
         	    */
     		    define comboboxex cbo_composicao_4
         	  		   row 265
                       col 315
	              	   width 50
			           height 300
			           listwidth 150
			           items a_composicao
			           value 1
			           fontname 'courier new'
			           fontsize 10
			           fontcolor BLUE
         	    end comboboxex
         	    /*
         	      pizza 4
         	    */
                @ 265,370 textbox tbox_pizza_4;
                          of form_vender;
                          height 030;
                          width 050;
                          font 'courier new' size 14;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1;
                          on enter procura_pizza_mesa(4)

			    @ 265,425 label label_nome_pizza_4;
     		  			  of form_vender;
						  width 220;
						  height 40;
                          value '';
                          font 'courier new' size 12;
                          fontcolor BLUE;
                          transparent
				*--------------------------------*
				*                                *
				*       VENDA DE PRODUTOS        *
				*                                *
				*--------------------------------*
                * escolher código do produto
                @ 310,210 label label_produto;
                          of form_vender;
                          value 'Produto';
                          autosize;
                          font 'courier new' size 012;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 330,210 textbox tbox_produto;
                          of form_vender;
                          height 030;
                          width 50;
                          value '';
                          maxlength 015;
                          font 'courier new' size 014;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1;
                          on enter procura_produto_mesa()
                @ 330,265 label label_nome_produto;
                          of form_vender;
                          value '';
                          autosize;
                          font 'courier new' size 014;
                          fontcolor BLUE;
                          transparent
                * quantidade
			    @ 310,780 label label_quantidade_2;
     		  			  of form_vender;
                          value 'Quantidade';
                          autosize;
                          font 'courier new' size 12;
                          bold;
                          fontcolor _preto_001;
                          transparent
		  		@ 330,780 spinner sp_quantidade_2;
		  		          range 1,900;
				  		  value 1;
						  width 100;
						  height 30;
						  font 'courier new' size 12;
						  bold;
						  on gotfocus verifica_campo_vazio_mesa(2)
                /*
                  botão grava produto
                */
                @ 320,890 buttonex botao_gravar_produto;
                          parent form_vender;
                          caption 'GRAVAR';
                          width 120 height 40;
                          picture path_imagens+'img_gravar.bmp';
                          action transfere_produto_pedido_mesa();
                		  font 'courier new' size 12 bold;
                		  backcolor {217,217,255}
				*--------------------------------*
				*                                *
				*       GRID ITENS VENDIDOS      *
				*                                *
				*--------------------------------*
                @ 375,205 grid grid_pedido;
                          parent form_vender;
                          width 680;
                          height 290;
                          headers {'ID_VENDA','Item','Qtd','Unit.R$','SubTotal R$','ID Ligacao'};
                          widths {1,400,50,90,110,1};
                          font 'courier new' size 10;
                          backcolor {255,255,236};
                          fontcolor {0,0,0}
				*--------------------------------*
				*                                *
				*         TOTAL DA VENDA         *
				*                                *
				*--------------------------------*
			    @ 380,890 label label_total_nome;
     		  			  of form_vender;
                          value 'TOTAL R$';
                          width 120;
                          font 'courier new' size 14 bold;
                          fontcolor WHITE;
                          backcolor BLUE;
                          centeralign
			    @ 410,900 label label_total;
     		  			  of form_vender;
                          value _total_pedido;
                          autosize;
                          font 'courier new' size 14 bold;
                          fontcolor BLUE;
                          transparent
				*--------------------------------*
				*                                *
				*       FINALIZAÇÃO VENDA        *
				*                                *
				*--------------------------------*
                @ 450,890 buttonex botao_excluir;
                          parent form_vender;
                          caption 'EXCLUIR';
                          width 120 height 40;
                          picture path_imagens+'img_cancela.bmp';
                          action excluir_item_pedido_mesa();
                		  notabstop;
                		  font 'courier new' size 10 bold;
                		  fontcolor RED
                @ 495,890 buttonex botao_cupom;
                          parent form_vender;
                          caption 'COMANDA';
                          width 120 height 40;
                          picture path_imagens+'print.bmp';
                          action emitir_comanda_mesa(_id_venda);
                		  notabstop;
                		  font 'courier new' size 10 bold
                @ 625,890 buttonex botao_sair;
                          parent form_vender;
                          caption 'VOLTAR';
                          width 120 height 40;
                          picture path_imagens+'img_voltar.bmp';
                          action desabilita_botao_voltar_mesa();
                		  notabstop;
                		  font 'courier new' size 10 bold

              	on key escape action pergunta_saida_mesa()
              
         end window
         
         form_vender.center
         form_vender.activate

         return(nil)
*-------------------------------------------------------------------------------
static function pergunta_saida_mesa()

	   if form_vender.tbox_produto.enabled == .F.
	   	  if msgyesno('Confirma fechar janela ?','Mensagem')
	      	 form_vender.release
 		  endif
	   else
	      desabilita_botao_voltar_mesa()
	   endif

	   return(nil)
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
static function procura_produto_mesa()

       local x_codigo := alltrim(form_vender.tbox_produto.value)

       if empty(x_codigo)
          x_codigo := '9999'
       endif

       dbselectarea('produtos')
       produtos->(ordsetfocus('codigo'))
       produtos->(dbgotop())
       produtos->(dbseek(x_codigo))

       if found() .and. !produtos->pizza
     	  setproperty('form_vender','label_nome_produto','value',produtos->nome_longo)
       else
     	  mostra_listagem_produto_mesa()
       endif

       return(nil)
*-------------------------------------------------------------------------------
static function mostra_listagem_produto_mesa()

       local creg := ''
       local nreg := 1

       dbselectarea('produtos')
       produtos->(ordsetfocus('nomelongos'))
       produtos->(dbgotop())

       define window form_pesquisa;
              at 0,0;
              width 560;
              height 610;
              title 'Pesquisa produto por nome';
              icon 'icone';
              modal;
              nosize

              define label label_pesquisa
                     col 5
                     row 550
                     value 'PESQUISE'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 10
                     fontbold .T.
                     fontcolor BLACK
                     transparent .T.
              end label
              define textbox txt_pesquisa
                     col 080
                     row 550
                     width 470
                     maxlength 40
                     onchange find_descricao_mesa()
                     uppercase .T.
              end textbox

              define browse browse_pesquisa
                     row 2
                     col 2
                     width 550
                     height 540
                     headers {'Cód.','Descrição','Preço R$','Qtd.Est.'}
                     widths {50,280,100,80}
                     workarea produtos
                     fields {'produtos->codigo','produtos->nome_longo','produtos->vlr_venda','produtos->qtd_estoq'}
                     value nreg
                     fontname 'verdana'
                     fontsize 10
                     fontbold .F.
                     backcolor WHITE
                     nolines .F.
                     lock .T.
                     readonly {.T.,.T.}
                     justify {BROWSE_JTFY_LEFT,BROWSE_JTFY_LEFT,BROWSE_JTFY_LEFT,BROWSE_JTFY_LEFT}
                     on dblclick (setproperty('form_vender','tbox_produto','value',produtos->codigo),setproperty('form_vender','label_nome_produto','value',produtos->nome_longo),thiswindow.release)
              end browse

              on key escape action thiswindow.release

       end window

       form_pesquisa.txt_pesquisa.setfocus

       form_pesquisa.center
       form_pesquisa.activate

       return(nil)
*-------------------------------------------------------------------------------
static function find_descricao_mesa()

       local pesquisa := alltrim(form_pesquisa.txt_pesquisa.value)

       produtos->(dbgotop())

       if pesquisa == ''
          return(nil)
       elseif produtos->(dbseek(pesquisa))
          form_pesquisa.browse_pesquisa.value := produtos->(recno())
       endif

       return(nil)
*-------------------------------------------------------------------------------
static function mostra_informacao_produto_mesa()

       local x_codigo := valor_coluna('grid_pesquisa','form_pesquisa',1)
       local x_nome   := valor_coluna('grid_pesquisa','form_pesquisa',2)
       local x_preco  := 0
       
       setproperty('form_vender','tbox_produto','value',alltrim(x_codigo))
       setproperty('form_vender','label_nome_produto','value',alltrim(x_nome))

       form_pesquisa.release

       return(nil)
*-------------------------------------------------------------------------------
static function procura_pizza_mesa(p_numero)

       local x_codigo

	   if p_numero == 1
	   	  x_codigo := alltrim(form_vender.tbox_pizza_1.value)
	   elseif p_numero == 2
	   	  x_codigo := alltrim(form_vender.tbox_pizza_2.value)
	   elseif p_numero == 3
	   	  x_codigo := alltrim(form_vender.tbox_pizza_3.value)
	   elseif p_numero == 4
	   	  x_codigo := alltrim(form_vender.tbox_pizza_4.value)
	   endif
	   
       if empty(x_codigo)
          x_codigo := '9999'
       endif
       
       dbselectarea('produtos')
       produtos->(ordsetfocus('codigo'))
       produtos->(dbgotop())
       produtos->(dbseek(x_codigo))
       
       if found() .and. produtos->pizza
       	  if p_numero == 1
         	 setproperty('form_vender','label_nome_pizza_1','value',produtos->nome_longo)
          elseif p_numero == 2
 	  		 setproperty('form_vender','label_nome_pizza_2','value',produtos->nome_longo)
          elseif p_numero == 3
         	 setproperty('form_vender','label_nome_pizza_3','value',produtos->nome_longo)
          elseif p_numero == 4
         	 setproperty('form_vender','label_nome_pizza_4','value',produtos->nome_longo)
          endif
       else
     	  mostra_listagem_pizza_mesa(p_numero)
       endif
       
       return(nil)
*-------------------------------------------------------------------------------
static function mostra_listagem_pizza_mesa(p_numero)

       define window form_pesquisa;
              at 000,000;
              width 1020;
              height 610;
              title 'Pizzas';
              icon path_imagens+'icone.ico';
              modal;
              nosize;
              on init popula_pizza_mesa()

              define grid grid_pesquisa
                     parent form_pesquisa
                     col 000
                     row 000
                     width 1010
                     height 550
                     headers {'','Descrição',alltrim(_tamanho_001),alltrim(_tamanho_002),alltrim(_tamanho_003),alltrim(_tamanho_004),alltrim(_tamanho_005),alltrim(_tamanho_006)}
                     widths {001,300,120,120,120,120,120,120}
                     showheaders .T.
                     nolines .F.
                     fontname 'courier new'
                     fontsize 012
                     backcolor WHITE
                     fontcolor BLUE
                     ondblclick mostra_informacao_mesa(p_numero)
              end grid

			  @ 552,001 textbox tbox_pesquisa;
     		  			height 30;
            			width 1015;
               			value '';
                  		maxlength 040;
                    	font 'verdana' size 010;
                     	backcolor _fundo_get;
                      	fontcolor _letra_get_1;
                       	uppercase;
              		  	on change pesquisar_pizza_mesa()

              on key escape action thiswindow.release
              
       end window
       
       form_pesquisa.tbox_pesquisa.setfocus

       form_pesquisa.center
       form_pesquisa.activate

       return(nil)
*-------------------------------------------------------------------------------
static function popula_pizza_mesa()

       delete item all from grid_pesquisa of form_pesquisa

       dbselectarea('produtos')
       produtos->(ordsetfocus('nome_longo'))
       produtos->(dbgotop())

       while .not. eof()
             if produtos->pizza
                add item {produtos->codigo,alltrim(produtos->nome_longo),trans(produtos->val_tm_001,'@E 99,999.99'),trans(produtos->val_tm_002,'@E 99,999.99'),trans(produtos->val_tm_003,'@E 99,999.99'),trans(produtos->val_tm_004,'@E 99,999.99'),trans(produtos->val_tm_005,'@E 99,999.99'),trans(produtos->val_tm_006,'@E 99,999.99')} to grid_pesquisa of form_pesquisa
             endif
             produtos->(dbskip())
       end

       return(nil)
*-------------------------------------------------------------------------------
static function pesquisar_pizza_mesa()

       local cPesq        := alltrim(form_pesquisa.tbox_pesquisa.value)
       local nTamNomePesq := len(cPesq)

       dbselectarea('produtos')
       produtos->(ordsetfocus('nome_longo'))
       produtos->(dbseek(cPesq))

       delete item all from grid_pesquisa of form_pesquisa

       while .not. eof()
             if produtos->pizza
             if substr(field->nome_longo,1,nTamNomePesq) == cPesq
                add item {alltrim(produtos->codigo),alltrim(produtos->nome_longo),trans(produtos->val_tm_001,'@E 99,999.99'),trans(produtos->val_tm_002,'@E 99,999.99'),trans(produtos->val_tm_003,'@E 99,999.99'),trans(produtos->val_tm_004,'@E 99,999.99'),trans(produtos->val_tm_005,'@E 99,999.99'),trans(produtos->val_tm_006,'@E 99,999.99')} to grid_pesquisa of form_pesquisa
             elseif substr(field->nome_longo,1,nTamNomePesq) > cPesq
                exit
             endif
             endif
             produtos->(dbskip())
       end

       return(nil)
*-------------------------------------------------------------------------------
static function mostra_informacao_mesa(p_numero)

       local x_codigo := valor_coluna('grid_pesquisa','form_pesquisa',1)
       local x_nome   := valor_coluna('grid_pesquisa','form_pesquisa',2)

	   if p_numero == 1
       	  setproperty('form_vender','tbox_pizza_1','value',x_codigo)
       	  setproperty('form_vender','label_nome_pizza_1','value',alltrim(x_nome))
       elseif p_numero == 2
       	  setproperty('form_vender','tbox_pizza_2','value',x_codigo)
       	  setproperty('form_vender','label_nome_pizza_2','value',alltrim(x_nome))
       elseif p_numero == 3
       	  setproperty('form_vender','tbox_pizza_3','value',x_codigo)
       	  setproperty('form_vender','label_nome_pizza_3','value',alltrim(x_nome))
       elseif p_numero == 4
       	  setproperty('form_vender','tbox_pizza_4','value',x_codigo)
       	  setproperty('form_vender','label_nome_pizza_4','value',alltrim(x_nome))
       endif
       
       form_pesquisa.release

       return(nil)
*-------------------------------------------------------------------------------
static function zera_tabelas_mesa()

       dbselectarea('tmp_pizza')
       zap
       pack
       
       dbselectarea('tmp_produto')
       zap
       pack

       return(nil)
*-------------------------------------------------------------------------------
static function cadastrar_novo_produto_mesa()

       local x_codigo         := space(10)
       local x_nome_longo     := ''
       local x_nome_cupom     := ''
       local x_cbarra         := ''
       local x_pizza          := .T.
       local x_promocao       := .F.
       local x_baixa          := .F.
       local x_categoria      := 0
       local x_subcategoria   := 0
       local x_qtd_estoque    := 0
       local x_qtd_minimo     := 0
       local x_qtd_maximo     := 0
       local x_imposto        := 0
       local x_valor_custo    := 0
       local x_valor_venda    := 0
       local x_valor_001      := 0
       local x_valor_002      := 0
       local x_valor_003      := 0
       local x_valor_004      := 0
       local x_valor_005      := 0
       local x_valor_006      := 0

       define window form_dados;
              at 000,000;
       		  width 830;
       		  height 550;
              title 'Incluir novo produto';
              icon path_imagens+'icone.ico';
		      modal;
		      nosize

              * entrada de dados
              @ 005,005 frame frame_geral;
                        parent form_dados;
                        caption 'Informações do cadastro';
                        width 510;
                        height 440;
                        font 'verdana';
                        size 010;
                        bold;
                        opaque

              @ 025,015 label lbl_001;
                        of form_dados;
                        value 'Código';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 045,015 getbox tbox_001;
                        of form_dados;
                        height 027;
                        width 120;
                        value x_codigo;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1
              @ 025,145 label lbl_002;
                        of form_dados;
                        value 'Nome (longo)';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 045,145 textbox tbox_002;
                        of form_dados;
                        height 027;
                        width 360;
                        value x_nome_longo;
                        maxlength 040;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 075,015 label lbl_003;
                        of form_dados;
                        value 'Nome (cupom)';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 095,015 textbox tbox_003;
                        of form_dados;
                        height 027;
                        width 250;
                        value x_nome_cupom;
                        maxlength 015;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 075,275 label lbl_004;
                        of form_dados;
                        value 'Código Barra';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 095,275 textbox tbox_004;
                        of form_dados;
                        height 027;
                        width 230;
                        value x_cbarra;
                        maxlength 015;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              define checkbox tbox_005
					      row 130
					      col 015
					      width 150
					      caption 'Produto é PIZZA ?'
					      value x_pizza
					      fontname 'verdana'
                     fontsize 010
                     fontbold .T.
              end checkbox
              define checkbox tbox_006
					      row 130
					      col 175
					      width 130
					      caption 'Em Promoção ?'
					      value x_promocao
					      fontname 'verdana'
                     fontsize 010
                     fontbold .T.
              end checkbox
              define checkbox tbox_007
					      row 130
					      col 315
					      width 180
					      caption 'Baixa o estoque ?'
					      value x_baixa
					      fontname 'verdana'
                     fontsize 010
                     fontbold .T.
              end checkbox
              @ 180,015 label lbl_008;
                        of form_dados;
                        value 'Categoria';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 200,015 textbox tbox_008;
                        of form_dados;
                        height 027;
                        width 060;
                        value x_categoria;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric;
                        on enter procura_categoria('form_dados','tbox_008')
              @ 200,085 label lbl_nome_categoria;
                        of form_dados;
                        value '';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _azul_001;
                        transparent
              @ 230,015 label lbl_009;
                        of form_dados;
                        value 'Sub Categoria';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 250,015 textbox tbox_009;
                        of form_dados;
                        height 027;
                        width 060;
                        value x_subcategoria;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric;
                        on enter procura_subcategoria('form_dados','tbox_009')
              @ 250,085 label lbl_nome_subcategoria;
                        of form_dados;
                        value '';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _azul_001;
                        transparent
              @ 290,015 label lbl_010;
                        of form_dados;
                        value 'Qtd. em estoque';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 310,015 textbox tbox_010;
                        of form_dados;
                        height 027;
                        width 100;
                        value x_qtd_estoque;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric
              @ 290,130 label lbl_011;
                        of form_dados;
                        value 'Qtd. mínima';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 310,130 textbox tbox_011;
                        of form_dados;
                        height 027;
                        width 100;
                        value x_qtd_minimo;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric
              @ 290,240 label lbl_012;
                        of form_dados;
                        value 'Qtd. máxima';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 310,240 textbox tbox_012;
                        of form_dados;
                        height 027;
                        width 100;
                        value x_qtd_maximo;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric
              @ 340,015 label lbl_013;
                        of form_dados;
                        value 'Imposto';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 360,015 textbox tbox_013;
                        of form_dados;
                        height 027;
                        width 060;
                        value x_imposto;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric;
                        on enter procura_imposto('form_dados','tbox_013')
              @ 360,085 label lbl_nome_imposto;
                        of form_dados;
                        value '';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _azul_001;
                        transparent
              @ 390,015 label lbl_014;
                        of form_dados;
                        value 'Valor CUSTO R$';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _verde_001;
                        transparent
              @ 410,015 getbox tbox_014;
                        of form_dados;
                        height 027;
                        width 150;
                        value x_valor_custo;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
              @ 390,175 label lbl_015;
                        of form_dados;
                        value 'Valor VENDA R$';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 410,175 getbox tbox_015;
                        of form_dados;
                        height 027;
                        width 150;
                        value x_valor_venda;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
                        
              * valores referentes aos tamanhos
              @ 005,525 frame frame_valores;
                        parent form_dados;
                        caption 'Tamanhos e preços (pizza)';
                        width 290;
                        height 440;
                        font 'verdana';
                        size 010;
                        bold;
                        opaque
              @ 025,535 label lbl_t001;
                        of form_dados;
                        value 'Tamanhos';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 025,670 label lbl_t002;
                        of form_dados;
                        value 'Preços R$';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent

              * mostrar os tamanhos pré-definidos
              @ 050,535 label lbl_t003;
                        of form_dados;
                        value _tamanho_001;
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 090,535 label lbl_t004;
                        of form_dados;
                        value _tamanho_002;
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 130,535 label lbl_t005;
                        of form_dados;
                        value _tamanho_003;
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 170,535 label lbl_t006;
                        of form_dados;
                        value _tamanho_004;
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 210,535 label lbl_t007;
                        of form_dados;
                        value _tamanho_005;
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 250,535 label lbl_t008;
                        of form_dados;
                        value _tamanho_006;
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent

              * preços das pizzas
              @ 050,670 getbox tbox_preco_001;
                        of form_dados;
                        height 030;
                        width 140;
                        value x_valor_001;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
              @ 090,670 getbox tbox_preco_002;
                        of form_dados;
                        height 030;
                        width 140;
                        value x_valor_002;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
              @ 130,670 getbox tbox_preco_003;
                        of form_dados;
                        height 030;
                        width 140;
                        value x_valor_003;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
              @ 170,670 getbox tbox_preco_004;
                        of form_dados;
                        height 030;
                        width 140;
                        value x_valor_004;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
              @ 210,670 getbox tbox_preco_005;
                        of form_dados;
                        height 030;
                        width 140;
                        value x_valor_005;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
              @ 250,670 getbox tbox_preco_006;
                        of form_dados;
                        height 030;
                        width 140;
                        value x_valor_006;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
                        
			  /*
			    ordem de impressão na comanda
			  */
              @ 320,570 label lbl_ordem;
                        of form_dados;
                        value 'Ordem de impressão na comanda';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
	  		  @ 340,570 spinner sp_ordem;
       		  			range 1,99;
				  		value 1;
						width 100;
						height 30;
						font 'courier new' size 12;
						bold

              * linha separadora
              define label linha_rodape
                     col 000
                     row form_dados.height-090
                     value ''
                     width form_dados.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label

              * botões
              define buttonex button_ok
                     picture path_imagens+'img_gravar.bmp'
                     col form_dados.width-225
                     row form_dados.height-085
                     width 120
                     height 050
                     caption 'Ok, gravar'
                     action gravar_produto_mesa()
                     fontbold .T.
                     tooltip 'Confirmar as informações digitadas'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_cancela
                     picture path_imagens+'img_voltar.bmp'
                     col form_dados.width-100
                     row form_dados.height-085
                     width 090
                     height 050
                     caption 'Voltar'
                     action form_dados.release
                     fontbold .T.
                     tooltip 'Sair desta tela sem gravar informações'
                     flat .F.
                     noxpstyle .T.
              end buttonex

              on key escape action thiswindow.release

       end window

       sethandcursor(getcontrolhandle('button_ok','form_dados'))
       sethandcursor(getcontrolhandle('button_cancela','form_dados'))

       form_dados.center
       form_dados.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function gravar_produto_mesa()

       local codigo  := form_dados.tbox_001.value
       local retorna := .F.

       if empty(form_dados.tbox_001.value)
          retorna := .T.
       endif
       if empty(form_dados.tbox_002.value)
          retorna := .T.
       endif

       if retorna
          msgalert('Preencha todos os campos','Atenção')
          return(nil)
       endif

	   dbselectarea('produtos')
       produtos->(ordsetfocus('codigo'))
       produtos->(dbgotop())
       produtos->(dbseek(codigo))
       if found()
       	  msgalert('Este CÓDIGO JÁ EXISTE, tecle ENTER','Atenção')
          return(nil)
       else
   	      produtos->(dbappend())
          produtos->codigo     := form_dados.tbox_001.value
          produtos->cbarra     := form_dados.tbox_004.value
          produtos->nome_longo := form_dados.tbox_002.value
          produtos->nome_cupom := form_dados.tbox_003.value
          produtos->categoria  := form_dados.tbox_008.value
          produtos->scategoria := form_dados.tbox_009.value
          produtos->imposto    := form_dados.tbox_013.value
          produtos->baixa      := form_dados.tbox_007.value
          produtos->qtd_estoq  := form_dados.tbox_010.value
          produtos->qtd_min    := form_dados.tbox_011.value
          produtos->qtd_max    := form_dados.tbox_012.value
          produtos->vlr_custo  := form_dados.tbox_014.value
          produtos->vlr_venda  := form_dados.tbox_015.value
          produtos->promocao   := form_dados.tbox_006.value
          produtos->pizza      := form_dados.tbox_005.value
          produtos->val_tm_001 := form_dados.tbox_preco_001.value
          produtos->val_tm_002 := form_dados.tbox_preco_002.value
          produtos->val_tm_003 := form_dados.tbox_preco_003.value
          produtos->val_tm_004 := form_dados.tbox_preco_004.value
          produtos->val_tm_005 := form_dados.tbox_preco_005.value
          produtos->val_tm_006 := form_dados.tbox_preco_006.value
          produtos->seq_imp    := form_dados.sp_ordem.value
          produtos->(dbcommit())
          form_dados.release
       endif

	   return(nil)
*-------------------------------------------------------------------------------
static function fecha_pedido_mesa()

	   local p_parametro := 3 //form_vender.radio_tipo_venda.value
	   
	   local v_id                 := valor_coluna('grid_generico','form_vender',2)
	   local p_codigo             := valor_coluna('grid_generico','form_vender',1)
	   local v_nome_operacao      := alltrim(valor_coluna('grid_generico','form_vender',3))
       local x_old_pizza          := space(10)
       local x_old_valor          := 0
       local x_total_pedido       := 0
       local x_total_recebido     := 0
       local x_tipo_venda         := 0
       local x_valor_taxa_entrega := 0
	   local x_ponto_referencia   := ''
	   local x_observacoes        := ''
	   local x_borda              := form_vender.cbo_bordas.value
	   local x_preco              := 0
	   local x_percentual_mesa    := 0
	   local v_soma_compra        := 0
	   local x_old_id, v_codigo
	   
       private x_valor_pizza := 0
       private x_valor_prod  := 0
       
       v_codigo := v_id

	   if empty(v_id)
	      msgalert('Não existe venda realizada, tecle ENTER','Atenção')
	      return(nil)
	   endif
	   /*
	     encontrar valores da compra
	   */
       dbselectarea('temp_vendas')
       ordsetfocus('id_venda')
       temp_vendas->(dbgotop())
       temp_vendas->(dbseek(v_id))
       if found()
          while .T.
				x_old_id     := temp_vendas->id_venda
				x_tipo_venda := temp_vendas->tipo_venda
				if temp_vendas->tipo == 1 //pizza
				   x_valor_pizza := x_valor_pizza + temp_vendas->subtotal
				elseif temp_vendas->tipo == 2 //outros prod.
				   x_valor_prod := x_valor_prod + temp_vendas->subtotal
				endif
				temp_vendas->(dbskip())
				if temp_vendas->id_venda <> x_old_id
				   exit
				endif
          end
          x_percentual_mesa := ( ( x_valor_pizza + x_valor_prod ) * 10 ) / 100
	   else
	      msgalert('Não existe venda realizada, ','Atenção')
	   endif
       /*
         janela fechamento
       */
       define window form_fecha_pedido;
              at 000,000;
		      width 500;
		      height 600;
              title 'Fechamento do pedido';
              icon path_imagens+'icone.ico';
		      modal;
	 	      nosize
		      /*
              	linhas para separar os elementos na tela
              */
              define label label_sep_001
                     col 000
                     row 190
                     value ''
                     width 500
                     height 002
                     transparent .F.
                     backcolor _cinza_002
              end label
              define label label_sep_002
                     col 000
                     row 390
                     value ''
                     width 500
                     height 002
                     transparent .F.
                     backcolor _cinza_002
              end label
              /*
                mostra informações
              */
              @ 010,020 label label_001;
                        of form_fecha_pedido;
                        value 'SUBTOTAL PIZZAS';
                        autosize;
                        font 'verdana' size 012;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 010,250 label label_001_valor;
                        of form_fecha_pedido;
                        value trans(x_valor_pizza,'@E 999,999.99');
                        autosize;
                        font 'courier new' size 016;
                        bold;
                        fontcolor BLUE;
                        transparent
                        /*
                        if .not. empty(x_preco)
              			   @ 004,390 label label_b001;
                           	 of form_fecha_pedido;
                        	 value 'valor da borda';
                        	 autosize;
                        	 font 'tahoma' size 8;
                        	 bold;
                        	 fontcolor BLACK;
                        	 transparent
              			   @ 018,390 label label_b002;
                           	 of form_fecha_pedido;
                        	 value trans(x_preco,'@E 9,999.99');
                        	 autosize;
                        	 font 'courier new' size 014;
                        	 bold;
                        	 fontcolor BLUE;
                        	 transparent
                        endif
                        */
              *--------
              @ 040,020 label label_002;
                        of form_fecha_pedido;
                        value 'SUBTOTAL PRODUTOS';
                        autosize;
                        font 'verdana' size 012;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 040,250 label label_002_valor;
                        of form_fecha_pedido;
                        value trans(x_valor_prod,'@E 999,999.99');
                        autosize;
                        font 'courier new' size 016;
                        bold;
                        fontcolor BLUE;
                        transparent
              *--------
              @ 070,020 label label_003;
                        of form_fecha_pedido;
                        value 'TAXA DE ENTREGA';
                        autosize;
                        font 'verdana' size 012;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 070,250 getbox tbox_taxa;
                        of form_fecha_pedido;
                        height 030;
                        width 130;
                        value x_valor_taxa_entrega;
                        font 'courier new' size 016;
                        bold;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 9,999.99'
              *--------
              @ 110,020 label label_004;
                        of form_fecha_pedido;
                        value 'DESCONTO';
                        autosize;
                        font 'verdana' size 012;
                        bold;
                        fontcolor _vermelho_002;
                        transparent
              @ 110,250 getbox tbox_desconto;
                        of form_fecha_pedido;
                        height 030;
                        width 130;
                        value 0;
                        font 'courier new' size 016;
                        bold;
                        backcolor _fundo_get;
                        fontcolor _vermelho_002;
                        picture '@E 9,999.99';
                        on change setproperty('form_fecha_pedido','label_005_valor','value',trans((x_valor_pizza+x_valor_prod+form_fecha_pedido.tbox_taxa.value+x_preco)-form_fecha_pedido.tbox_desconto.value,'@E 999,999.99'));
                        on lostfocus setproperty('form_fecha_pedido','label_005_valor','value',trans((x_valor_pizza+x_valor_prod+form_fecha_pedido.tbox_taxa.value+x_preco)-form_fecha_pedido.tbox_desconto.value,'@E 999,999.99'))
              *--------
              @ 150,020 label label_005;
                        of form_fecha_pedido;
                        value 'TOTAL DESTE PEDIDO';
                        autosize;
                        font 'verdana' size 012;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 150,250 label label_005_valor;
                        of form_fecha_pedido;
                        value '';
                        autosize;
                        font 'courier new' size 016;
                        bold;
                        fontcolor BLUE;
                        transparent
                        
              * escolher formas de recebimento
              @ 200,020 label label_006;
                        of form_fecha_pedido;
                        value 'Você pode escolher até 3 formas de recebimento';
                        autosize;
                        font 'verdana' size 012;
                        bold;
                        fontcolor _preto_001;
                        transparent
              /*
                formas de recebimento
              */
              * 1º
		        @ 230,020 combobox combo_1;
			               itemsource formas_recebimento->nome;
			               valuesource formas_recebimento->codigo;
			               value 1;
			               width 250;
			               font 'courier new' size 010
              @ 230,300 getbox tbox_fr001;
                        of form_fecha_pedido;
                        height 030;
                        width 130;
                        value 0;
                        font 'courier new' size 014;
                        bold;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 99,999.99'
              * 2º
		        @ 270,020 combobox combo_2;
			               itemsource formas_recebimento->nome;
			               valuesource formas_recebimento->codigo;
			               value 1;
			               width 250;
			               font 'courier new' size 010
              @ 270,300 getbox tbox_fr002;
                        of form_fecha_pedido;
                        height 030;
                        width 130;
                        value 0;
                        font 'courier new' size 014;
                        bold;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 99,999.99'
              * 3º
		        @ 310,020 combobox combo_3;
			               itemsource formas_recebimento->nome;
			               valuesource formas_recebimento->codigo;
			               value 1;
			               width 250;
			               font 'courier new' size 010
              @ 310,300 getbox tbox_fr003;
                        of form_fecha_pedido;
                        height 030;
                        width 130;
                        value 0;
                        font 'courier new' size 014;
                        bold;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 99,999.99';
                        on lostfocus calcula_final_mesa(x_preco)

              @ 360,020 label label_011;
                        of form_fecha_pedido;
                        value 'TOTAL RECEBIDO';
                        autosize;
                        font 'verdana' size 012;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 360,250 label label_011_valor;
                        of form_fecha_pedido;
                        value '';
                        autosize;
                        font 'courier new' size 016;
                        bold;
                        fontcolor BLUE;
                        transparent
              *--------
              @ 400,020 label label_012;
                        of form_fecha_pedido;
                        value 'TROCO';
                        autosize;
                        font 'verdana' size 012;
                        bold;
                        fontcolor _vermelho_002;
                        transparent
              @ 400,250 label label_012_valor;
                        of form_fecha_pedido;
                        value '';
                        autosize;
                        font 'courier new' size 016;
                        bold;
                        fontcolor BLUE;
                        transparent
              /*
                soma para achar o total da compra
              */
              v_soma_compra := ( x_valor_pizza + x_valor_prod + x_valor_taxa_entrega ) - ( form_fecha_pedido.tbox_desconto.value )
              /*
                botões
              */
              @ 460,005 buttonex botao_cupom;
                        parent form_fecha_pedido;
                        caption 'Imprimir CUPOM';
                        width 155 height 040;
                        picture path_imagens+'img_relatorio.bmp';
                        action imprimir_cupom_mesa(v_id,x_valor_pizza,x_valor_prod,form_fecha_pedido.tbox_desconto.value,x_percentual_mesa,x_valor_taxa_entrega,x_ponto_referencia,x_observacoes,v_nome_operacao);
                        tooltip 'Clique aqui imprimir o cupom'
              @ 460,165 buttonex botao_ok;
                        parent form_fecha_pedido;
                        caption 'Fechar pedido';
                        width 140 height 040;
                        picture path_imagens+'img_pedido.bmp';
                        action fechamento_geral_mesa(v_soma_compra,x_tipo_venda,v_id,p_codigo);
                        tooltip 'Clique aqui para finalizar o pedido'
              @ 460,310 buttonex botao_voltar;
                        parent form_fecha_pedido;
                        caption 'Voltar tela anterior';
                        width 180 height 040;
                        picture path_imagens+'img_sair.bmp';
                        action form_fecha_pedido.release;
                        tooltip 'Clique aqui para voltar a vender'
			  /*
			    mostra ponto de referência e observação se houver no cliente
			  */
              @ 520,010 label label_observacao;
                        of form_fecha_pedido;
                        value x_observacoes;
                        autosize;
                        font 'courier new' size 012;
                        bold;
                        fontcolor RED;
                        transparent
              @ 545,010 label label_ponto_referencia;
                        of form_fecha_pedido;
                        value x_ponto_referencia;
                        autosize;
                        font 'courier new' size 012;
                        bold;
                        fontcolor BLUE;
                        transparent

              on key escape action thiswindow.release
              
       end window
       
       setproperty('form_fecha_pedido','tbox_taxa','value',x_percentual_mesa)
       setproperty('form_fecha_pedido','label_003','value','     10%')
       
       form_fecha_pedido.center
       form_fecha_pedido.activate

       return(nil)
*-------------------------------------------------------------------------------
static function calcula_final_mesa(p_borda)

       local x_val_001  := 0
       local x_val_002  := 0
       local x_val_003  := 0
       local x_val_004  := 0
       local x_val_005  := 0
       local x_val_006  := 0
       local x_val_007  := 0
       local x_total    := 0
       local x_recebido := 0
       local x_troco    := 0
       
       x_val_001 := x_valor_pizza
       x_val_002 := x_valor_prod
       x_val_003 := form_fecha_pedido.tbox_taxa.value
       x_val_004 := form_fecha_pedido.tbox_desconto.value
       x_val_005 := form_fecha_pedido.tbox_fr001.value
       x_val_006 := form_fecha_pedido.tbox_fr002.value
       x_val_007 := form_fecha_pedido.tbox_fr003.value

       x_total    := (x_val_001+x_val_002+x_val_003+p_borda)-(x_val_004)
       x_recebido := (x_val_005+x_val_006+x_val_007)
       x_troco    := (x_recebido-x_total)

       setproperty('form_fecha_pedido','label_011_valor','value',trans(x_recebido,'@E 999,999.99'))
       setproperty('form_fecha_pedido','label_012_valor','value',trans(x_troco,'@E 999,999.99'))

       return(nil)
*-------------------------------------------------------------------------------
static function fechamento_geral_mesa(p_soma,p_tipo,p_id_geral,p_codigo)

       local x_val_001     := 0
       local x_val_002     := 0
       local x_val_003     := 0
       local x_val_004     := 0
       local x_val_005     := 0
       local x_val_006     := 0
       local x_val_007     := 0
       local x_total       := 0
       local x_recebido    := 0
       local x_cod_forma_1 := 0
       local x_cod_forma_2 := 0
       local x_cod_forma_3 := 0
       local x_dias        := 0
       local x_procura     := 0
       local x_data_limpa  := ctod('  /  /  ')
       local v_calcula
       local v_parametro     := p_id_geral
       local v_nome_venda
       local v_nome_recebe_1  := form_fecha_pedido.combo_1.value
       local v_nome_recebe_2  := form_fecha_pedido.combo_2.value
       local v_nome_recebe_3  := form_fecha_pedido.combo_3.value
       local v_valor_recebe_1 := form_fecha_pedido.tbox_fr001.value
       local v_valor_recebe_2 := form_fecha_pedido.tbox_fr002.value
       local v_valor_recebe_3 := form_fecha_pedido.tbox_fr003.value
       local v_valor_troco    := form_fecha_pedido.label_012_valor.value
       local v_fpagamento := alltrim(form_fecha_pedido.combo_1.item(v_nome_recebe_1))
       local v_taxa       := form_fecha_pedido.tbox_taxa.value
       local m_idvenda, m_tipovenda
       /*
         gravar forma de pagamento e taxa de entrega em separado
       */
  	   dbselectarea('temp_vendas')
   	   temp_vendas->(ordsetfocus('id_venda'))
   	   temp_vendas->(dbgotop())
   	   temp_vendas->(dbseek(v_parametro))
   	   if found()
  		  m_tipovenda := temp_vendas->tipo_venda
   	      while .T.
          		m_idvenda := temp_vendas->id_venda
          		if lock_reg()
    		       replace f_pagam with v_fpagamento
  		       	   replace ncaixa  with y_ncaixa
                   replace taxa_mesa with v_taxa
             	   temp_vendas->(dbcommit())
             	   temp_vendas->(dbunlock())
          		endif
          		temp_vendas->(dbskip())
          		if temp_vendas->id_venda <> m_idvenda
          		   exit
				endif
   	      end
   	   endif



	   ******************************************
	   *
	   * zera as informações do que foi utilizado
	   *
	   *
       x_procura := val(p_codigo)

          	 dbselectarea('mesas')
          	 mesas->(ordsetfocus('codigo'))
          	 mesas->(dbgotop())
          	 mesas->(dbseek(x_procura))
          	 if found()
             	if lock_reg()
                   mesas->id       := ''
                   mesas->hora     := ''
                   mesas->data     := x_data_limpa
                   mesas->situacao := ''
                   mesas->usuario  := ''
                   mesas->total    := 0
                   mesas->(dbcommit())
                   mesas->(dbunlock())
                endif
             endif

	   mostra_info_grid_mesa(p_tipo)

       ******************************
       
       x_val_001     := x_valor_pizza
       x_val_002     := x_valor_prod
       x_val_003     := form_fecha_pedido.tbox_taxa.value
       x_val_004     := form_fecha_pedido.tbox_desconto.value
       x_cod_forma_1 := form_fecha_pedido.combo_1.value
       x_cod_forma_2 := form_fecha_pedido.combo_2.value
       x_cod_forma_3 := form_fecha_pedido.combo_3.value
       x_val_005     := form_fecha_pedido.tbox_fr001.value
       x_val_006     := form_fecha_pedido.tbox_fr002.value
       x_val_007     := form_fecha_pedido.tbox_fr003.value

       x_total    := (x_val_001+x_val_002+x_val_003)-(x_val_004)
       x_recebido := (x_val_005+x_val_006+x_val_007)

       *********************************************
       
       * formas de recebimento
       * 1
       if .not. empty(x_val_005)
          dbselectarea('formas_recebimento')
          formas_recebimento->(ordsetfocus('codigo'))
          formas_recebimento->(dbgotop())
          formas_recebimento->(dbseek(x_cod_forma_1))
          if found()
             x_dias := formas_recebimento->dias_receb
          endif
          dbselectarea('contas_receber')
          contas_receber->(dbappend())
          contas_receber->id      := substr(alltrim(str(HB_RANDOM(0001240003,9999999999))),1,10)
          contas_receber->data    := date() + x_dias
          contas_receber->valor   := x_val_005
          contas_receber->forma   := x_cod_forma_1
          contas_receber->(dbcommit())
       endif
       * 2
       if .not. empty(x_val_006)
          dbselectarea('formas_recebimento')
          formas_recebimento->(ordsetfocus('codigo'))
          formas_recebimento->(dbgotop())
          formas_recebimento->(dbseek(x_cod_forma_2))
          if found()
             x_dias := formas_recebimento->dias_receb
          endif
          dbselectarea('contas_receber')
          contas_receber->(dbappend())
          contas_receber->id      := substr(alltrim(str(HB_RANDOM(0001240003,9999999999))),1,10)
          contas_receber->data    := date() + x_dias
          contas_receber->valor   := x_val_006
          contas_receber->forma   := x_cod_forma_2
          contas_receber->(dbcommit())
       endif
       * 3
       if .not. empty(x_val_007)
          dbselectarea('formas_recebimento')
          formas_recebimento->(ordsetfocus('codigo'))
          formas_recebimento->(dbgotop())
          formas_recebimento->(dbseek(x_cod_forma_3))
          if found()
             x_dias := formas_recebimento->dias_receb
          endif
          dbselectarea('contas_receber')
          contas_receber->(dbappend())
          contas_receber->id      := substr(alltrim(str(HB_RANDOM(0001240003,9999999999))),1,10)
          contas_receber->data    := date() + x_dias
          contas_receber->valor   := x_val_007
          contas_receber->forma   := x_cod_forma_3
          contas_receber->(dbcommit())
       endif


          v_calcula := 0
          v_calcula := ( ( p_soma * 10 ) / 100 )
          p_soma    := p_soma + v_calcula
       
	      x_desc_venda := 'Mesa'
	   
       dbselectarea('caixa')
       caixa->(dbappend())
       caixa->id        := substr(alltrim(str(HB_RANDOM(0010023003,9999999999))),1,10)
       caixa->data      := date()
       caixa->historico := x_desc_venda
       caixa->entrada   := p_soma
       caixa->saida     := 0
       caixa->(dbcommit())

       * baixar os produtos
       
       x_old_id   := ''
       m_id_geral := ''
       m_id_geral := alltrim(p_id_geral)
       
       dbselectarea('temp_vendas')
       ordsetfocus('id_venda')
       temp_vendas->(dbgotop())
       temp_vendas->(dbseek(m_id_geral))
       if found()
          while .T.
				x_old_id := temp_vendas->id_venda
				if temp_vendas->tipo == 2 //outros prod.
             	   dbselectarea('produtos')
             	   produtos->(ordsetfocus('codigo'))
             	   produtos->(dbgotop())
             	   produtos->(dbseek(temp_vendas->produto))
             	   if found()
                   	  if lock_reg()
                   	  	 produtos->qtd_estoq := produtos->qtd_estoq - temp_vendas->qtd
                   		 produtos->(dbcommit())
              		  endif
                   endif
				endif
				temp_vendas->(dbskip())
				if temp_vendas->id_venda <> x_old_id
				   exit
				endif
          end
       endif

       * baixar matéria prima
/*
       x_old := space(10)
       
       dbselectarea('temp_vendas')
       index on tipo to indtip0 for tipo == 1
       temp_vendas->(dbgotop())
       if .not. eof()
       while .not. eof()
             dbselectarea('produto_composto')
             produto_composto->(ordsetfocus('id_produto'))
             produto_composto->(dbgotop())
             produto_composto->(dbseek(temp_vendas->produto))
             if found()
                while .T.
                      x_old := produto_composto->id_produto
                      dbselectarea('materia_prima')
                      materia_prima->(ordsetfocus('codigo'))
                      materia_prima->(dbgotop())
                      materia_prima->(dbseek(produto_composto->id_mprima))
                      if found()
                         if lock_reg()
                            materia_prima->qtd := materia_prima->qtd - produto_composto->quantidade
                            materia_prima->(dbcommit())
                            materia_prima->(dbunlock())
                         endif
                      endif
                      dbselectarea('produto_composto')
                      produto_composto->(dbskip())
                      if produto_composto->id_produto <> x_old
                         exit
                      endif
                end
             endif
             dbselectarea('temp_vendas')
             temp_vendas->(dbskip())
       end
       endif
       set index to
*/
       x_hora := space(08)
       x_hora := time()

	   /*
	     gravar como fechado o pedido, para não aparecer na tela de movimento
	   */
       dbselectarea('temp_vendas')
       ordsetfocus('id_venda')
       temp_vendas->(dbgotop())
       temp_vendas->(dbseek(m_id_geral))
       if found()
          while .T.
				x_old_id := temp_vendas->id_venda
				if lock_reg()
				   replace fechado with 1
              	   replace ncaixa  with y_ncaixa
				   temp_vendas->(dbcommit())
                   temp_vendas->(dbunlock())
				endif
				temp_vendas->(dbskip())
				if temp_vendas->id_venda <> x_old_id
				   exit
				endif
		  end
	   endif

       * fechar janela
       form_fecha_pedido.release

       return(nil)
*-------------------------------------------------------------------------------
static function pega_tamanho_mesa()

	   _numero_tamanho := 0
	   
	   _tamanho_selecionado := alltrim(substr(form_vender.cbo_tamanhos.displayvalue,1,10))
	   _numero_tamanho      := form_vender.cbo_tamanhos.value
	   
	   *form_vender.grid_pizzas.setfocus

	   return(nil)
*-------------------------------------------------------------------------------
static function adiciona_montagem_mesa()
	   return(nil)
*-------------------------------------------------------------------------------
static function transfere_produto_pedido_mesa()

	   local v_tipo      := 3//form_vender.radio_tipo_venda.value
	   local p_codigo    := alltrim(form_vender.tbox_produto.value)
	   local p_nome      := alltrim(form_vender.label_nome_produto.value)
	   local p_qtd       := form_vender.sp_quantidade_2.value
	   local x_unitario  := 0
	   local total_geral := 0
       local x_hora         := time()
       local x_data         := date()

	   if val(p_codigo) == 0
	      return(nil)
	   endif

	   *-pegar o numero do caixa.
       dbselectarea('ccaixa')
       ordsetfocus('data')
       ccaixa->(dbgobottom())
       y_ncaixa := ccaixa->ncaixa

       dbselectarea('produtos')
       produtos->(ordsetfocus('codigo'))
       produtos->(dbgotop())
       produtos->(dbseek(p_codigo))
       if found()
          x_unitario := produtos->vlr_venda
       endif

	   dbselectarea('temp_vendas')
	   append blank
	   replace id with alltrim(str(hb_random(0111222233,9999999889)))
	   replace tipo with 2
	   replace produto with p_codigo
	   replace nome with alltrim(p_nome)
	   replace qtd with p_qtd
	   replace unitario with x_unitario
	   replace subtotal with x_unitario * p_qtd
	   replace id_venda with _id_venda
	   replace tipo_venda with v_tipo
  	   replace hora with x_hora
  	   replace data with x_data
  	   replace descricao with _nome_da_venda
  	   replace qtd_p with p_qtd
  	   replace vlr_p with x_unitario * p_qtd
	   replace ncaixa  with y_ncaixa
	   *--------------------------*
	   *                          *
	   *  atualiza valor no grid  *
	   *                          *
	   *--------------------------*
	      dbselectarea('mesas')
       	  mesas->(ordsetfocus('id'))
       	  mesas->(dbgotop())
       	  mesas->(dbseek(_id_venda))
       	  if found()
             if lock_reg()
                mesas->total := mesas->total + (x_unitario*p_qtd)
                mesas->(dbunlock())
                mesas->(dbcommit())
             endif
       	  endif
	   	  mostra_info_grid_mesa(3)
	   /*
	     mostra total da venda na tela
	   */
	   _total_pedido := ( _total_pedido + (x_unitario * p_qtd) )
	   setproperty('form_vender','label_total','value',trans(_total_pedido,'@E 99,999.99'))
 	   /*
       	 mostrar do grid a venda
  	   */
   	   mostra_venda_mesa(_id_venda)
	   /*
	     zera campos
	   */
	   setproperty('form_vender','tbox_produto','value','')
	   setproperty('form_vender','label_nome_produto','value','')
	   setproperty('form_vender','sp_quantidade_2','value',1)
	   /*
	     volta o foco para lançar outro produto
	   */
	   form_vender.tbox_produto.setfocus
	   
	   return(nil)
*-------------------------------------------------------------------------------
static function excluir_sabor_mesa()
	   Return(Nil)
*-------------------------------------------------------------------------------
static function excluir_item_pedido_mesa()

	   local v_id_liga := alltrim(valor_coluna('grid_pedido','form_vender',6))
	   local v_total := 0
	   local v_tipo_venda := 0
	   local v_old_liga

	   if empty(v_id_liga)
	      msgalert('Não há nenhuma venda realizada para excluir, tecle ENTER','Atenção')
	      return(nil)
	   endif
	   
	   dbselectarea('temp_vendas')
       temp_vendas->(ordsetfocus('id'))
       temp_vendas->(dbgotop())
       temp_vendas->(dbseek(v_id_liga))
       
       if found()
          while .T.
                v_old_liga := temp_vendas->id
             	if lock_reg()
             	   v_total := v_total + temp_vendas->subtotal
             	   v_tipo_venda := temp_vendas->tipo_venda
                   temp_vendas->(dbdelete())
                   temp_vendas->(dbunlock())
             	endif
             	temp_vendas->(dbskip())
             	if temp_vendas->id <> v_old_liga
				   exit
				endif
          end
       else
          msginfo('Não foram encontrados produtos para serem excluídos, tecle ENTER','Mensagem')
          return(nil)
       endif
	   *---------------------------------------*
	   *                                       *
	   * diminui valor total do pedido na tela *
	   *                                       *
	   *---------------------------------------*
	   _total_pedido := ( _total_pedido - v_total )
	   setproperty('form_vender','label_total','value',trans(_total_pedido,'@E 99,999.99'))
	   *--------------------------*
	   *                          *
	   *  atualiza valor no grid  *
	   *                          *
	   *--------------------------*
	      dbselectarea('mesas')
       	  mesas->(ordsetfocus('id'))
       	  mesas->(dbgotop())
       	  mesas->(dbseek(_id_venda))
       	  if found()
             if lock_reg()
                mesas->total := mesas->total - v_total
                mesas->(dbunlock())
                mesas->(dbcommit())
             endif
       	  endif
	   	  mostra_info_grid_mesa(3)
	   /*
	     apaga o conteúdo do grid e atualiza
	   */
       mostra_venda_mesa(_id_venda)
       
	   return(nil)
*-------------------------------------------------------------------------------
static function fecha_montagem_pizza_mesa()

	   local v_tipo_venda    := 3//form_vender.radio_tipo_venda.value
       local v_tamanho_pizza := form_vender.cbo_tamanhos.value
       local v_composicao_1  := form_vender.cbo_composicao_1.value
       local v_composicao_2  := form_vender.cbo_composicao_2.value
       local v_composicao_3  := form_vender.cbo_composicao_3.value
       local v_composicao_4  := form_vender.cbo_composicao_4.value
	   local v_id_pizza_1    := form_vender.tbox_pizza_1.value
       local v_id_pizza_2    := form_vender.tbox_pizza_2.value
       local v_id_pizza_3    := form_vender.tbox_pizza_3.value
  	   local v_id_pizza_4    := form_vender.tbox_pizza_4.value
       local v_nome_pizza_1  := form_vender.label_nome_pizza_1.value
       local v_nome_pizza_2  := form_vender.label_nome_pizza_2.value
       local v_nome_pizza_3  := form_vender.label_nome_pizza_3.value
       local v_nome_pizza_4  := form_vender.label_nome_pizza_4.value
       local v_borda         := form_vender.cbo_bordas.value
	   local v_qtd_pizza     := form_vender.sp_quantidade.value
       local v_obs_pizza     := form_vender.tbox_observacao.value
	   local x_valor         := 0
	   local x_maior_valor   := 0
	   local x_soma          := 0
	   local x_qtd           := 0
	   local x_valor_cobrado := 0
	   local a_nome_pizza    := {}
	   local v_nome_tamanho  := a_tamanho_da_pizza[v_tamanho_pizza]
	   local v_liga_produto  := alltrim(str(hb_random(0000011111,9999999999)))
	   local x_codigo
	   local x_nome
	   local x_hora := time()
	   local x_data := date()
	   /*
	     limpar tabelas temporárias
	   */
	   dbselectarea('temp_cpz')
	   pack
	   zap
	   dbselectarea('montagem')
	   pack
	   zap
	   /*
	     verifica se foram escolhidas pizzas
	   */
	   if val(v_id_pizza_1)+val(v_id_pizza_2)+val(v_id_pizza_3)+val(v_id_pizza_4) == 0
	      msginfo('Não existe(m) sabor(es) selecionado(s), tecle ENTER','Atenção')
	      return(nil)
	   else
	      /*
	        achar os valores das pizzas
	      */
	      /*
	        1 pizza escolhida
	      */
	      if .not. empty(v_id_pizza_1)
	         x_qtd ++
       	  	 x_codigo := alltrim(v_id_pizza_1)
       		 dbselectarea('produtos')
       		 produtos->(ordsetfocus('codigo'))
       		 produtos->(dbgotop())
       		 produtos->(dbseek(x_codigo))
       		 if found()
				if _numero_tamanho == 1
				   x_valor := produtos->val_tm_001
				elseif _numero_tamanho == 2
				   x_valor := produtos->val_tm_002
				elseif _numero_tamanho == 3
				   x_valor := produtos->val_tm_003
				elseif _numero_tamanho == 4
				   x_valor := produtos->val_tm_004
				elseif _numero_tamanho == 5
				   x_valor := produtos->val_tm_005
				elseif _numero_tamanho == 6
				   x_valor := produtos->val_tm_006
				endif
				x_soma := x_soma + x_valor
				dbselectarea('temp_cpz')
				append blank
				replace preco with x_valor
				dbselectarea('temp_vendas')
       		 endif
		  endif
	      /*
	        2 pizza escolhida
	      */
	      if .not. empty(v_id_pizza_2)
	         x_qtd ++
       	  	 x_codigo := alltrim(v_id_pizza_2)
       		 dbselectarea('produtos')
       		 produtos->(ordsetfocus('codigo'))
       		 produtos->(dbgotop())
       		 produtos->(dbseek(x_codigo))
       		 if found()
				if _numero_tamanho == 1
				   x_valor := produtos->val_tm_001
				elseif _numero_tamanho == 2
				   x_valor := produtos->val_tm_002
				elseif _numero_tamanho == 3
				   x_valor := produtos->val_tm_003
				elseif _numero_tamanho == 4
				   x_valor := produtos->val_tm_004
				elseif _numero_tamanho == 5
				   x_valor := produtos->val_tm_005
				elseif _numero_tamanho == 6
				   x_valor := produtos->val_tm_006
				endif
				x_soma := x_soma + x_valor
				dbselectarea('temp_cpz')
				append blank
				replace preco with x_valor
				dbselectarea('temp_vendas')
       		 endif
	      endif
	      /*
	        3 pizza escolhida
	      */
	      if .not. empty(v_id_pizza_3)
	         x_qtd ++
       	  	 x_codigo := alltrim(v_id_pizza_3)
       		 dbselectarea('produtos')
       		 produtos->(ordsetfocus('codigo'))
       		 produtos->(dbgotop())
       		 produtos->(dbseek(x_codigo))
       		 if found()
				if _numero_tamanho == 1
				   x_valor := produtos->val_tm_001
				elseif _numero_tamanho == 2
				   x_valor := produtos->val_tm_002
				elseif _numero_tamanho == 3
				   x_valor := produtos->val_tm_003
				elseif _numero_tamanho == 4
				   x_valor := produtos->val_tm_004
				elseif _numero_tamanho == 5
				   x_valor := produtos->val_tm_005
				elseif _numero_tamanho == 6
				   x_valor := produtos->val_tm_006
				endif
				x_soma := x_soma + x_valor
				dbselectarea('temp_cpz')
				append blank
				replace preco with x_valor
				dbselectarea('temp_vendas')
       		 endif
	      endif
	      /*
	        4 pizza escolhida
	      */
	      if .not. empty(v_id_pizza_4)
	         x_qtd ++
       	  	 x_codigo := alltrim(v_id_pizza_4)
       		 dbselectarea('produtos')
       		 produtos->(ordsetfocus('codigo'))
       		 produtos->(dbgotop())
       		 produtos->(dbseek(x_codigo))
       		 if found()
				if _numero_tamanho == 1
				   x_valor := produtos->val_tm_001
				elseif _numero_tamanho == 2
				   x_valor := produtos->val_tm_002
				elseif _numero_tamanho == 3
				   x_valor := produtos->val_tm_003
				elseif _numero_tamanho == 4
				   x_valor := produtos->val_tm_004
				elseif _numero_tamanho == 5
				   x_valor := produtos->val_tm_005
				elseif _numero_tamanho == 6
				   x_valor := produtos->val_tm_006
				endif
				x_soma := x_soma + x_valor
				dbselectarea('temp_cpz')
				append blank
				replace preco with x_valor
				dbselectarea('temp_vendas')
       		 endif
	      endif
	      /*
	        define se o valor cobrado será o maior entre as pizzas
	        ou a média entre elas, conforme configuração do usuário
	      */
       	  dbselectarea('temp_cpz')
	   	  index on preco to indpcpz descend
	   	  go top
	   	  x_maior_valor := temp_cpz->preco
	   	  if _tipo_cobranca == 1 /* maior valor */
	      	 x_valor_cobrado := x_maior_valor
	      elseif _tipo_cobranca == 2 /* média do valor */
		     x_valor_cobrado := ( x_soma / x_qtd )
	      endif
	      /*
	        gravar o nome da pizza vendida
	      */
	      /*
	        1 pizza escolhida
	      */
	      if .not. empty(v_id_pizza_1)
       	  	 x_codigo := alltrim(v_id_pizza_1)
       		 x_nome   := a_composicao[v_composicao_1]+' '+alltrim(v_nome_pizza_1)
	   		 dbselectarea('temp_vendas')
	   		 append blank
			 replace id with v_liga_produto
			 replace tipo with 1
			 replace produto with x_codigo
			 replace nome with x_nome
			 replace tamanho with v_nome_tamanho
			 replace id_venda with _id_venda
			 replace tipo_venda with v_tipo_venda
			 replace hora with x_hora
			 replace data with x_data
			 replace descricao with _nome_da_venda
			 replace qtd_p with v_qtd_pizza
			 replace vlr_p with x_valor_cobrado
			 commit
		  endif
	      /*
	        2 pizza escolhida
	      */
	      if .not. empty(v_id_pizza_2)
       	  	 x_codigo := alltrim(v_id_pizza_2)
       		 x_nome   := a_composicao[v_composicao_2]+' '+alltrim(v_nome_pizza_2)
	   		 dbselectarea('temp_vendas')
	   		 append blank
			 replace id with v_liga_produto
			 replace tipo with 1
			 replace produto with x_codigo
			 replace nome with x_nome
			 replace tamanho with v_nome_tamanho
			 replace id_venda with _id_venda
			 replace tipo_venda with v_tipo_venda
			 replace hora with x_hora
			 replace data with x_data
			 replace descricao with _nome_da_venda
			 replace qtd_p with v_qtd_pizza
			 replace vlr_p with x_valor_cobrado
			 commit
		  endif
	      /*
	        3 pizza escolhida
	      */
	      if .not. empty(v_id_pizza_3)
       	  	 x_codigo := alltrim(v_id_pizza_3)
       		 x_nome   := a_composicao[v_composicao_3]+' '+alltrim(v_nome_pizza_3)
	   		 dbselectarea('temp_vendas')
	   		 append blank
			 replace id with v_liga_produto
			 replace tipo with 1
			 replace produto with x_codigo
			 replace nome with x_nome
			 replace tamanho with v_nome_tamanho
			 replace id_venda with _id_venda
			 replace tipo_venda with v_tipo_venda
			 replace hora with x_hora
			 replace data with x_data
			 replace descricao with _nome_da_venda
			 replace qtd_p with v_qtd_pizza
			 replace vlr_p with x_valor_cobrado
			 commit
		  endif
	      /*
	        4 pizza escolhida
	      */
	      if .not. empty(v_id_pizza_4)
       	  	 x_codigo := alltrim(v_id_pizza_4)
       		 x_nome   := a_composicao[v_composicao_4]+' '+alltrim(v_nome_pizza_4)
	   		 dbselectarea('temp_vendas')
	   		 append blank
			 replace id with v_liga_produto
			 replace tipo with 1
			 replace produto with x_codigo
			 replace nome with x_nome
			 replace tamanho with v_nome_tamanho
			 replace id_venda with _id_venda
			 replace tipo_venda with v_tipo_venda
			 replace hora with x_hora
			 replace data with x_data
			 replace descricao with _nome_da_venda
			 replace qtd_p with v_qtd_pizza
			 replace vlr_p with x_valor_cobrado
			 commit
	      endif
	      /*
	        grava registro resumindo a pizza e associando
	        aos sabores escolhidos
	      */
 		  dbselectarea('temp_vendas')
	   	  append blank
		  replace id with v_liga_produto
		  replace tipo with 1
		  replace nome with '-> '+alltrim(v_nome_tamanho)+iif(empty(v_obs_pizza),'','('+alltrim(v_obs_pizza)+')')
		  replace qtd with v_qtd_pizza
		  replace subtotal with (x_valor_cobrado*v_qtd_pizza)
		  replace id_venda with _id_venda
		  replace tipo_venda with v_tipo_venda
		  replace hora with x_hora
		  replace data with x_data
		  replace descricao with _nome_da_venda
		  commit
		  /*
		    grava borda : se houver
		  */
		  v_valor_borda := 0
		  v_valor_borda := a_valor_borda[v_borda]
		  if v_valor_borda <> 0
 		  	 dbselectarea('temp_vendas')
	   	  	 append blank
		  	 replace id with v_liga_produto
		  	 replace tipo with 1
		  	 replace nome with '--> Borda :'+alltrim(a_nome_borda[v_borda])
		  	 replace subtotal with v_valor_borda
		  	 replace id_venda with _id_venda
		  	 replace tipo_venda with v_tipo_venda
			 replace hora with x_hora
			 replace data with x_data
			 replace descricao with _nome_da_venda
		  	 commit
		  endif
	   	  *--------------------------*
	   	  *                          *
	   	  *  atualiza valor no grid  *
	   	  *                          *
	   	  *--------------------------*
	         dbselectarea('mesas')
       	  	 mesas->(ordsetfocus('id'))
       	  	 mesas->(dbgotop())
       	  	 mesas->(dbseek(_id_venda))
       	  	 if found()
             	if lock_reg()
                   mesas->total := mesas->total + (x_valor_cobrado*v_qtd_pizza) + v_valor_borda
                   mesas->(dbunlock())
                   mesas->(dbcommit())
                endif
       	     endif
	   	  	 mostra_info_grid_mesa(3)
	      /*
	        mostra na tela o total
	      */
	   	  _total_pedido := ( _total_pedido + (x_valor_cobrado*v_qtd_pizza) + v_valor_borda )
	   	  setproperty('form_vender','label_total','value',trans(_total_pedido,'@E 99,999.99'))
		  /*
		    limpar campos
		  */
       	  setproperty('form_vender','cbo_tamanhos','value',1)
       	  setproperty('form_vender','cbo_composicao_1','value',1)
       	  setproperty('form_vender','cbo_composicao_2','value',1)
       	  setproperty('form_vender','cbo_composicao_3','value',1)
       	  setproperty('form_vender','cbo_composicao_4','value',1)
	   	  setproperty('form_vender','tbox_pizza_1','value','')
       	  setproperty('form_vender','label_nome_pizza_1','value','')
       	  setproperty('form_vender','tbox_pizza_2','value','')
       	  setproperty('form_vender','label_nome_pizza_2','value','')
       	  setproperty('form_vender','tbox_pizza_3','value','')
       	  setproperty('form_vender','label_nome_pizza_3','value','')
  	   	  setproperty('form_vender','tbox_pizza_4','value','')
       	  setproperty('form_vender','label_nome_pizza_4','value','')
       	  setproperty('form_vender','cbo_bordas','value',1)
	   	  setproperty('form_vender','sp_quantidade','value',1)
       	  setproperty('form_vender','tbox_observacao','value','')
       	  /*
       	    mostrar do grid a venda
       	  */
       	  mostra_venda_mesa(_id_venda)
       	  /*
       	    focar a escolha do tamanho
       	  */
       	  form_vender.cbo_tamanhos.setfocus
	   endif

	   return(nil)
*-------------------------------------------------------------------------------
static function mostra_venda_mesa(p_parametro)

	   local v_old_id
	   local v_parametro := alltrim(p_parametro)
	   
	   _total_venda_grid := 0
	   
       delete item all from grid_pedido of form_vender

       dbselectarea('temp_vendas')
       temp_vendas->(ordsetfocus('id_venda'))
       temp_vendas->(dbgotop())
       temp_vendas->(dbseek(v_parametro))
       if found()
       	  while .T.
       	        v_old_id := temp_vendas->id_venda
       	        _total_venda_grid := _total_venda_grid + temp_vendas->subtotal
             	add item {alltrim(temp_vendas->id_venda),alltrim(temp_vendas->nome),str(temp_vendas->qtd,4),trans(temp_vendas->unitario,'@E 99,999.99'),trans(temp_vendas->subtotal,'@E 999,999.99'),alltrim(temp_vendas->id)} to grid_pedido of form_vender
             	temp_vendas->(dbskip())
             	if temp_vendas->id_venda <> v_old_id
				   exit
				endif
          end
       endif

	   return(nil)
*-------------------------------------------------------------------------------
static function imprimir_cupom_mesa(p_id,p_vlr_pizza,p_vlr_prod,p_desconto,p_perc_mesa,p_taxa_entrega,p_ponto_ref,p_obs,p_nome_operacao)

       local x_nome, x_fixo, x_endereco, x_numero
	   local x_tipo_venda    := 0
       local v_total_comanda := 0
       local v_parametro     := p_id
       local v_old_id, v_old_hora, v_old_tipo
       local v_nome_venda
       
       local v_nome_recebe_1  := form_fecha_pedido.combo_1.value
       local v_nome_recebe_2  := form_fecha_pedido.combo_2.value
       local v_nome_recebe_3  := form_fecha_pedido.combo_3.value
       local v_valor_recebe_1 := form_fecha_pedido.tbox_fr001.value
       local v_valor_recebe_2 := form_fecha_pedido.tbox_fr002.value
       local v_valor_recebe_3 := form_fecha_pedido.tbox_fr003.value
       local v_valor_troco    := form_fecha_pedido.label_012_valor.value
       
       local v_fpagamento := alltrim(form_fecha_pedido.combo_1.item(v_nome_recebe_1))
       local v_taxa       := form_fecha_pedido.tbox_taxa.value
       local m_idvenda, m_tipovenda
       
       /*
         gravar forma de pagamento e taxa de entrega em separado
       */
  	   dbselectarea('temp_vendas')
   	   temp_vendas->(ordsetfocus('id_venda'))
   	   temp_vendas->(dbgotop())
   	   temp_vendas->(dbseek(v_parametro))
   	   if found()
  		  m_tipovenda := temp_vendas->tipo_venda
   	      while .T.
          		m_idvenda := temp_vendas->id_venda
          		if lock_reg()
    		       replace f_pagam with v_fpagamento
                   replace taxa_mesa with v_taxa
             	   temp_vendas->(dbcommit())
             	   temp_vendas->(dbunlock())
          		endif
          		temp_vendas->(dbskip())
          		if temp_vendas->id_venda <> m_idvenda
          		   exit
				endif
   	      end
   	   endif

	   /*
	     acha dados da empresa
	   */
       dbselectarea('empresa')
       empresa->(dbgotop())
       x_nome     := alltrim(empresa->nome)
       x_fixo     := alltrim(empresa->fixo_1)
       x_endereco := alltrim(empresa->endereco)
       x_numero   := alltrim(empresa->numero)

	   *Try

          SET PRINTER ON
          SET PRINTER TO LPT1
          SET CONSOLE OFF

          ? x_nome
          ? x_endereco+', '+x_numero+', '+x_fixo
          ? '------------------------------------------------'
          ? '         CUPOM PARA SIMPLES CONFERENCIA'
          ? '             NAO E DOCUMENTO FISCAL'
          ? '                VENDA : '+p_nome_operacao
          ? '================================================'
          dbselectarea('temp_vendas')
       	  temp_vendas->(ordsetfocus('id_venda'))
       	  temp_vendas->(dbgotop())
       	  temp_vendas->(dbseek(v_parametro))
       	  if found()
		  	 x_tipo_venda := temp_vendas->tipo_venda
		  endif
          ? 'DATA      : '+dtoc(date())+'  HORA: '+time()
          ? '------------------------------------------------'
          ? 'PRODUTO                    QTD  UNIT.  SUB-TOTAL'
          ? '------------------------------------------------'
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

                         if substr(temp_vendas->nome,1,3) == '1/1'
                            ? substr(temp_vendas->nome,3,39)
						 else
						    ? substr(temp_vendas->nome,1,39)
						 endif
                      elseif substr(temp_vendas->nome,1,3) == '-->'
                         ? substr(temp_vendas->nome,1,40)+'  '+trans(temp_vendas->subtotal,'@E 999.99')
                      elseif substr(temp_vendas->nome,1,2) == '->'
                        if substr(temp_vendas->nome,4,6) == 'ESFIHA'
                         ? substr(temp_vendas->nome,10,25)+'  '+str(temp_vendas->qtd,3)+'            '+trans(temp_vendas->subtotal,'@E 999.99')
						 else
                         ? substr(temp_vendas->nome,1,25)+'  '+str(temp_vendas->qtd,3)+'            '+trans(temp_vendas->subtotal,'@E 999.99')
                         endif
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
          /*
          dbselectarea('temp_vendas')
       	  temp_vendas->(ordsetfocus('id_venda'))
       	  temp_vendas->(dbgotop())
       	  temp_vendas->(dbseek(v_parametro))
       	  if found()
          	 while .T.
                   v_old_id := temp_vendas->id_venda
                   v_total_comanda := v_total_comanda + temp_vendas->subtotal
                   if substr(temp_vendas->nome,2,1) == '/'
                   	  ? alltrim(temp_vendas->nome)
                   elseif substr(temp_vendas->nome,1,2) == '->'
                      ? substr(temp_vendas->nome,1,39)+'  '+trans(temp_vendas->subtotal,'@E 999.99')
                   elseif substr(temp_vendas->nome,1,3) == '-->'
                      ? substr(temp_vendas->nome,1,39)+'  '+trans(temp_vendas->subtotal,'@E 999.99')
                   else
                      ? '------------------------------------------------'
                      ? substr(temp_vendas->nome,1,25)+'  '+str(temp_vendas->qtd,3)+' '+trans(temp_vendas->unitario,'@E 999.99')+'   '+trans(temp_vendas->subtotal,'@E 9,999.99')
                   endif
             	   temp_vendas->(dbskip())
             	   if temp_vendas->id_venda <> v_old_id
				   	  exit
				   endif
             end
          endif
          */
          ? '================================================'
          ? '                      TOTAL PEDIDO : '+trans(p_vlr_pizza+p_vlr_prod,'@E 999,999.99')
          ? '                               10% : '+trans(p_taxa_entrega,'@E 999,999.99')
          ? '                          DESCONTO : '+trans(p_desconto,'@E 999,999.99')
          ? '                             TOTAL : '+trans((p_vlr_pizza+p_vlr_prod+p_taxa_entrega)-(p_desconto),'@E 999,999.99')
          ? '------------------------------------------------'
     	  if x_tipo_venda == 1
			 if .not. empty(v_valor_recebe_1)
			    ? 'PAGAMENTO COM : '+alltrim(v_fpagamento)
			 endif
			 if .not. empty(v_valor_recebe_2)
			    ? 'PAGAMENTO COM : '+alltrim(v_fpagamento)
			 endif
			 if .not. empty(v_valor_recebe_3)
			    ? 'PAGAMENTO COM : '+alltrim(v_fpagamento)
			 endif
		  if val(v_valor_troco) <> 0
			 ? 'TROCO : R$ '+v_valor_troco
		  endif
		  
     	  endif
          ? '------------------------------------------------'
          ? 'Agradecemos a preferencia, Volte Sempre !'
          ? '------------------------------------------------'
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
          ? ''

          SET CONSOLE ON
          SET PRINTER TO
          SET PRINTER OFF

       *Catch e

  		  *msgexclamation('A IMPRESSORA está DESLIGADA, por favor verifique','Atenção')
  		  *return(nil)

       *End

       return(nil)
*-------------------------------------------------------------------------------
static function adiciona_borda_mesa()
	   return(nil)
*-------------------------------------------------------------------------------
static function emitir_comanda_mesa(p_parametro)

       local x_nome, x_fixo, x_endereco, x_numero
	   local x_tipo_venda       := 3//form_vender.radio_tipo_venda.value
       local x_total            := alltrim(form_vender.label_total.value)
       local v_total_comanda := 0
       local v_calcula_10 := 0
       local v_parametro := alltrim(p_parametro)
       local v_old_id, v_old_hora, v_old_tipo
       local v_nome_venda
       
          v_nome_venda := 'MESA'

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
          ? '                VENDA : '+_nome_da_venda
          ? '================================================'
          ? 'DATA      : '+dtoc(date())+'  HORA: '+time()
          ? '------------------------------------------------'
          ? 'PRODUTO                    QTD  UNIT.  SUB-TOTAL'
          ? '------------------------------------------------'
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
                   	  
						 if substr(temp_vendas->nome,1,3) == '1/1'
                            ? substr(temp_vendas->nome,3,39)
						 else
						    ? substr(temp_vendas->nome,1,39)
						 endif

				      elseif substr(temp_vendas->nome,1,3) == '-->'
                         ? substr(temp_vendas->nome,1,25)+'                 '+trans(temp_vendas->subtotal,'@E 999.99')
                      elseif substr(temp_vendas->nome,1,2) == '->'
                        if substr(temp_vendas->nome,4,6) == 'ESFIHA'
                         ? substr(temp_vendas->nome,10,25)+'  '+str(temp_vendas->qtd,3)+'            '+trans(temp_vendas->subtotal,'@E 999.99')
						 else
                         ? substr(temp_vendas->nome,1,25)+'  '+str(temp_vendas->qtd,3)+'            '+trans(temp_vendas->subtotal,'@E 999.99')
                         endif
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
          /*
          dbselectarea('temp_vendas')
       	  temp_vendas->(ordsetfocus('id_venda'))
       	  temp_vendas->(dbgotop())
       	  temp_vendas->(dbseek(v_parametro))
       	  if found()
          	 while .T.
                   v_old_id := temp_vendas->id_venda
                   v_total_comanda := v_total_comanda + temp_vendas->subtotal
                   if substr(temp_vendas->nome,2,1) == '/'
                   	  ? alltrim(temp_vendas->nome)
                   elseif substr(temp_vendas->nome,1,2) == '->'
                      ? substr(temp_vendas->nome,1,39)+'  '+trans(temp_vendas->subtotal,'@E 999.99')
                   elseif substr(temp_vendas->nome,1,3) == '-->'
                      ? substr(temp_vendas->nome,1,39)+'  '+trans(temp_vendas->subtotal,'@E 999.99')
                   else
                      ? '------------------------------------------------'
                      ? substr(temp_vendas->nome,1,25)+'  '+str(temp_vendas->qtd,3)+' '+trans(temp_vendas->unitario,'@E 999.99')+'   '+trans(temp_vendas->subtotal,'@E 9,999.99')
                   endif
             	   temp_vendas->(dbskip())
             	   if temp_vendas->id_venda <> v_old_id
				   	  exit
				   endif
             end
          endif
          */
          ? '================================================'
  	      if x_tipo_venda == 3 //mesas
  	         v_calcula_10 := ( ( v_total_comanda * 10 ) / 100 )
  	         ? '                     TOTAL CONSUMO : '+trans(v_total_comanda,'@E 999,999.99')
  	         ? '                               10% : '+trans(v_calcula_10,'@E 999,999.99')
  	         ? '                      TOTAL PEDIDO : '+trans(v_total_comanda+v_calcula_10,'@E 999,999.99')
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
static function seleciona_tipo_de_venda_mesa()

	   local v_tipo := 3//form_vender.radio_tipo_venda.value
	   
	      setproperty('form_vender','label_cabecalho','value','MESA')
	      setproperty('form_vender','label_cabecalho','fontcolor',{255,100,100})
       	  mostra_info_grid_mesa(3)
       	  setproperty('form_vender','grid_generico','enabled',.T.)
       	  setproperty('form_vender','botao_abre','enabled',.T.)
       	  setproperty('form_vender','botao_consumo','enabled',.T.)
       	  setproperty('form_vender','botao_fecha','enabled',.T.)
	   
	   return(nil)
*-------------------------------------------------------------------------------
static function habilita_campos_mesa_mesa() // aqui é duas mesa mesmo

       setproperty('form_vender','grid_generico','enabled',.T.)
       setproperty('form_vender','botao_abre','enabled',.T.)
       setproperty('form_vender','botao_consumo','enabled',.T.)
       setproperty('form_vender','botao_fecha','enabled',.T.)
       setproperty('form_vender','botao_cadastra_produto','enabled',.T.)
       setproperty('form_vender','label_pizza','enabled',.T.)
	   setproperty('form_vender','cbo_tamanhos','enabled',.T.)
       setproperty('form_vender','label_pizza_2','enabled',.T.)
       setproperty('form_vender','cbo_composicao_1','enabled',.T.)
       setproperty('form_vender','tbox_pizza_1','enabled',.T.)
       setproperty('form_vender','label_nome_pizza_1','enabled',.T.)
       setproperty('form_vender','label_borda','enabled',.T.)
       setproperty('form_vender','cbo_bordas','enabled',.T.)
       setproperty('form_vender','label_quantidade','enabled',.T.)
	   setproperty('form_vender','sp_quantidade','enabled',.T.)
       setproperty('form_vender','label_observacao','enabled',.T.)
       setproperty('form_vender','tbox_observacao','enabled',.T.)
       setproperty('form_vender','botao_gravar_pizza','enabled',.T.)
       setproperty('form_vender','cbo_composicao_2','enabled',.T.)
	   setproperty('form_vender','tbox_pizza_2','enabled',.T.)
       setproperty('form_vender','label_nome_pizza_2','enabled',.T.)
       setproperty('form_vender','cbo_composicao_3','enabled',.T.)
       setproperty('form_vender','tbox_pizza_3','enabled',.T.)
       setproperty('form_vender','label_nome_pizza_3','enabled',.T.)
       setproperty('form_vender','cbo_composicao_4','enabled',.T.)
       setproperty('form_vender','tbox_pizza_4','enabled',.T.)
       setproperty('form_vender','label_nome_pizza_4','enabled',.T.)
       setproperty('form_vender','label_produto','enabled',.T.)
       setproperty('form_vender','tbox_produto','enabled',.T.)
       setproperty('form_vender','label_nome_produto','enabled',.T.)
       setproperty('form_vender','label_quantidade_2','enabled',.T.)
	   setproperty('form_vender','sp_quantidade_2','enabled',.T.)
       setproperty('form_vender','botao_gravar_produto','enabled',.T.)
	   setproperty('form_vender','grid_pedido','enabled',.T.)
       setproperty('form_vender','label_total_nome','enabled',.T.)
       setproperty('form_vender','label_total','enabled',.T.)
       setproperty('form_vender','botao_excluir','enabled',.T.)
       setproperty('form_vender','botao_cupom','enabled',.T.)
       setproperty('form_vender','botao_sair','enabled',.T.)

	   form_vender.cbo_tamanhos.setfocus
	   form_vender.cbo_tamanhos.value := 1
	   
	   return(nil)
*-------------------------------------------------------------------------------
static function mostra_info_grid_mesa(p_parametro)

	   /*
	     p_parametro :
	     : 3 - mesa
	   */

       delete item all from grid_generico of form_vender

       	  dbselectarea('mesas')
       	  mesas->(ordsetfocus('codigo'))
       	  mesas->(dbgotop())
       	  while .not. eof()
             	add item {alltrim(str(mesas->codigo)),alltrim(mesas->id),alltrim(mesas->nome),substr(mesas->hora,1,5),trans(mesas->total,'@E 999,999.99')} to grid_generico of form_vender
             	mesas->(dbskip())
          end
	   
       return(nil)
*-------------------------------------------------------------------------------
static function desabilita_campos_mesa()

       setproperty('form_vender','grid_generico','enabled',.F.)
       setproperty('form_vender','botao_abre','enabled',.F.)
       setproperty('form_vender','botao_consumo','enabled',.F.)
       setproperty('form_vender','botao_fecha','enabled',.F.)
       setproperty('form_vender','botao_cadastra_produto','enabled',.F.)
       setproperty('form_vender','label_pizza','enabled',.F.)
	   setproperty('form_vender','cbo_tamanhos','enabled',.F.)
       setproperty('form_vender','label_pizza_2','enabled',.F.)
       setproperty('form_vender','cbo_composicao_1','enabled',.F.)
       setproperty('form_vender','tbox_pizza_1','enabled',.F.)
       setproperty('form_vender','label_nome_pizza_1','enabled',.F.)
       setproperty('form_vender','label_borda','enabled',.F.)
       setproperty('form_vender','cbo_bordas','enabled',.F.)
       setproperty('form_vender','label_quantidade','enabled',.F.)
	   setproperty('form_vender','sp_quantidade','enabled',.F.)
       setproperty('form_vender','label_observacao','enabled',.F.)
       setproperty('form_vender','tbox_observacao','enabled',.F.)
       setproperty('form_vender','botao_gravar_pizza','enabled',.F.)
       setproperty('form_vender','cbo_composicao_2','enabled',.F.)
	   setproperty('form_vender','tbox_pizza_2','enabled',.F.)
       setproperty('form_vender','label_nome_pizza_2','enabled',.F.)
       setproperty('form_vender','cbo_composicao_3','enabled',.F.)
       setproperty('form_vender','tbox_pizza_3','enabled',.F.)
       setproperty('form_vender','label_nome_pizza_3','enabled',.F.)
       setproperty('form_vender','cbo_composicao_4','enabled',.F.)
       setproperty('form_vender','tbox_pizza_4','enabled',.F.)
       setproperty('form_vender','label_nome_pizza_4','enabled',.F.)
       setproperty('form_vender','label_produto','enabled',.F.)
       setproperty('form_vender','tbox_produto','enabled',.F.)
       setproperty('form_vender','label_nome_produto','enabled',.F.)
       setproperty('form_vender','label_quantidade_2','enabled',.F.)
	   setproperty('form_vender','sp_quantidade_2','enabled',.F.)
       setproperty('form_vender','botao_gravar_produto','enabled',.F.)
	   setproperty('form_vender','grid_pedido','enabled',.F.)
       setproperty('form_vender','label_total_nome','enabled',.F.)
       setproperty('form_vender','label_total','enabled',.F.)
       setproperty('form_vender','botao_excluir','enabled',.F.)
       setproperty('form_vender','botao_cupom','enabled',.F.)
       setproperty('form_vender','botao_sair','enabled',.F.)

	   return(nil)
*-------------------------------------------------------------------------------
static function habilita_campos_mesa()

       setproperty('form_vender','grid_generico','enabled',.T.)
       setproperty('form_vender','botao_abre','enabled',.T.)
       setproperty('form_vender','botao_consumo','enabled',.T.)
       setproperty('form_vender','botao_fecha','enabled',.T.)
       setproperty('form_vender','botao_cadastra_produto','enabled',.T.)
       setproperty('form_vender','label_pizza','enabled',.T.)
	   setproperty('form_vender','cbo_tamanhos','enabled',.T.)
       setproperty('form_vender','label_pizza_2','enabled',.T.)
       setproperty('form_vender','cbo_composicao_1','enabled',.T.)
       setproperty('form_vender','tbox_pizza_1','enabled',.T.)
       setproperty('form_vender','label_nome_pizza_1','enabled',.T.)
       setproperty('form_vender','label_borda','enabled',.T.)
       setproperty('form_vender','cbo_bordas','enabled',.T.)
       setproperty('form_vender','label_quantidade','enabled',.T.)
	   setproperty('form_vender','sp_quantidade','enabled',.T.)
       setproperty('form_vender','label_observacao','enabled',.T.)
       setproperty('form_vender','tbox_observacao','enabled',.T.)
       setproperty('form_vender','botao_gravar_pizza','enabled',.T.)
       setproperty('form_vender','cbo_composicao_2','enabled',.T.)
	   setproperty('form_vender','tbox_pizza_2','enabled',.T.)
       setproperty('form_vender','label_nome_pizza_2','enabled',.T.)
       setproperty('form_vender','cbo_composicao_3','enabled',.T.)
       setproperty('form_vender','tbox_pizza_3','enabled',.T.)
       setproperty('form_vender','label_nome_pizza_3','enabled',.T.)
       setproperty('form_vender','cbo_composicao_4','enabled',.T.)
       setproperty('form_vender','tbox_pizza_4','enabled',.T.)
       setproperty('form_vender','label_nome_pizza_4','enabled',.T.)
       setproperty('form_vender','label_produto','enabled',.T.)
       setproperty('form_vender','tbox_produto','enabled',.T.)
       setproperty('form_vender','label_nome_produto','enabled',.T.)
       setproperty('form_vender','label_quantidade_2','enabled',.T.)
	   setproperty('form_vender','sp_quantidade_2','enabled',.T.)
       setproperty('form_vender','botao_gravar_produto','enabled',.T.)
	   setproperty('form_vender','grid_pedido','enabled',.T.)
       setproperty('form_vender','label_total_nome','enabled',.T.)
       setproperty('form_vender','label_total','enabled',.T.)
       setproperty('form_vender','botao_excluir','enabled',.T.)
       setproperty('form_vender','botao_cupom','enabled',.T.)
       setproperty('form_vender','botao_sair','enabled',.T.)
       
       form_vender.cbo_tamanhos.setfocus
       
	   return(nil)
*-------------------------------------------------------------------------------
static function abrir_mesa()

	   local p_parametro := 3//form_vender.radio_tipo_venda.value
       local x_codigo  := valor_coluna('grid_generico','form_vender',1)
       local x_id      := valor_coluna('grid_generico','form_vender',2)
       local x_nome    := valor_coluna('grid_generico','form_vender',3)
       local x_dia     := substr(dtoc(date()),1,2)
       local x_mes     := substr(dtoc(date()),4,2)
       local x_ano     := substr(dtoc(date()),7,4)
       local x_hora    := substr(time(),1,2)
       local x_minuto  := substr(time(),4,2)
       local x_segundo := substr(time(),7,2)
       local x_gera_id := alltrim(x_codigo)+x_dia+x_mes+x_ano+x_hora+x_minuto+x_segundo
       local x_procura := 0

	   _nome_da_venda := alltrim(x_nome)
	   
       if empty(x_nome)
          msgalert('Selecione primeiro e depois clique no botão ABRIR, tecle ENTER','Atenção')
          return(nil)
       endif

       if .not. empty(x_id)
          msgalert('Já está ABERTO, tecle ENTER','Atenção')
          return(nil)
       endif

       _id_venda := x_gera_id
       
	      _id_tipo_venda := 3

       x_procura := val(x_codigo)

       if msgyesno('Abrir : '+alltrim(x_nome),'Atenção')
		  if p_parametro == 3
		     _total_pedido := 0
          	 dbselectarea('mesas')
          	 mesas->(ordsetfocus('codigo'))
          	 mesas->(dbgotop())
          	 mesas->(dbseek(x_procura))
          	 if found()
             	if lock_reg()
                   mesas->id       := _id_venda
                   mesas->hora     := time()
                   mesas->data     := date()
                   mesas->situacao := 'A'
                   mesas->usuario  := '-'
                   mesas->(dbcommit())
                   mesas->(dbunlock())
                endif
             endif
             /*
               mostra no cabeçalho
             */
    		 setproperty('form_vender','label_cabecalho','value',alltrim(x_nome))
	      	 setproperty('form_vender','label_cabecalho','fontcolor',{255,100,100})
       	  	 /*
      	  	 */
             habilita_campos_mesa_mesa() // aque tambem é assim mesmo.
          endif
       endif

	   mostra_info_grid_mesa(p_parametro)
	   
	   desabilita_botoes_mesa(p_parametro)
	   
       return(nil)
*-------------------------------------------------------------------------------
static function consumir_mesa()

	   local p_parametro := 3//form_vender.radio_tipo_venda.value

       local x_codigo  := valor_coluna('grid_generico','form_vender',1)
       local x_id      := valor_coluna('grid_generico','form_vender',2)
       local x_nome    := valor_coluna('grid_generico','form_vender',3)
       local x_hora    := valor_coluna('grid_generico','form_vender',4)
       local x_procura := 0
	   local x_observacao := ''

	   _nome_da_venda := alltrim(x_nome)
	   
       if empty(x_hora)
          msgalert('Primeiro clique no botão ABRIR, tecle ENTER','Atenção')
          return(nil)
       endif
       
       _id_venda := alltrim(x_id)

	   _total_pedido := 0
	   
	      _id_tipo_venda := 3
       	  /*
          	mostra no cabeçalho
          */
 		  setproperty('form_vender','label_cabecalho','value',alltrim(x_nome))
   	 	  setproperty('form_vender','label_cabecalho','fontcolor',{255,100,100})
   	  	  /*
   	  	  */
       
       habilita_campos_mesa()
	   desabilita_botoes_mesa(p_parametro)

	   /*
	     popular o grid com as informações da venda
	   */
	   mostra_venda_mesa(_id_venda)

	   /*
	     pega o valor da variável pública "_total_venda_grid"
	     para atribuir à variável privada (deste prg) o valor
	     total da compra até o momento
	   */
	   _total_pedido := _total_venda_grid
	   /*
	     mostra na tela o total
	   */
	   setproperty('form_vender','label_total','value',trans(_total_pedido,'@E 99,999.99'))
	   
*-------------------------------------------------------------------------------
*static function ativa_menu_escolha()
*
*	   setproperty('form_vender','radio_tipo_venda','enabled',.T.)
*
*	   return(nil)
**-------------------------------------------------------------------------------
static function desabilita_botao_voltar_mesa()

	   limpa_campos_mesa()
	   habilita_botoes_mesa()
	   
       setproperty('form_vender','botao_cadastra_produto','enabled',.F.)
       setproperty('form_vender','label_pizza','enabled',.F.)
	   setproperty('form_vender','cbo_tamanhos','enabled',.F.)
       setproperty('form_vender','label_pizza_2','enabled',.F.)
       setproperty('form_vender','cbo_composicao_1','enabled',.F.)
       setproperty('form_vender','tbox_pizza_1','enabled',.F.)
       setproperty('form_vender','label_nome_pizza_1','enabled',.F.)
       setproperty('form_vender','label_borda','enabled',.F.)
       setproperty('form_vender','cbo_bordas','enabled',.F.)
       setproperty('form_vender','label_quantidade','enabled',.F.)
	   setproperty('form_vender','sp_quantidade','enabled',.F.)
       setproperty('form_vender','label_observacao','enabled',.F.)
       setproperty('form_vender','tbox_observacao','enabled',.F.)
       setproperty('form_vender','botao_gravar_pizza','enabled',.F.)
       setproperty('form_vender','cbo_composicao_2','enabled',.F.)
	   setproperty('form_vender','tbox_pizza_2','enabled',.F.)
       setproperty('form_vender','label_nome_pizza_2','enabled',.F.)
       setproperty('form_vender','cbo_composicao_3','enabled',.F.)
       setproperty('form_vender','tbox_pizza_3','enabled',.F.)
       setproperty('form_vender','label_nome_pizza_3','enabled',.F.)
       setproperty('form_vender','cbo_composicao_4','enabled',.F.)
       setproperty('form_vender','tbox_pizza_4','enabled',.F.)
       setproperty('form_vender','label_nome_pizza_4','enabled',.F.)
       setproperty('form_vender','label_produto','enabled',.F.)
       setproperty('form_vender','tbox_produto','enabled',.F.)
       setproperty('form_vender','label_nome_produto','enabled',.F.)
       setproperty('form_vender','label_quantidade_2','enabled',.F.)
	   setproperty('form_vender','sp_quantidade_2','enabled',.F.)
       setproperty('form_vender','botao_gravar_produto','enabled',.F.)
	   setproperty('form_vender','grid_pedido','enabled',.F.)
       setproperty('form_vender','label_total_nome','enabled',.F.)
       setproperty('form_vender','label_total','enabled',.F.)
       setproperty('form_vender','botao_excluir','enabled',.F.)
       setproperty('form_vender','botao_cupom','enabled',.F.)
       setproperty('form_vender','botao_sair','enabled',.F.)
       
       delete item all from grid_pedido of form_vender

	   return(nil)
*-------------------------------------------------------------------------------
static function limpa_campos_mesa()

	   setproperty('form_vender','cbo_tamanhos','value',1)
       setproperty('form_vender','cbo_composicao_1','value',1)
       setproperty('form_vender','tbox_pizza_1','value','')
       setproperty('form_vender','label_nome_pizza_1','value','')
       setproperty('form_vender','cbo_bordas','value',1)
	   setproperty('form_vender','sp_quantidade','value',1)
       setproperty('form_vender','tbox_observacao','value','')
       setproperty('form_vender','cbo_composicao_2','value',1)
	   setproperty('form_vender','tbox_pizza_2','value','')
       setproperty('form_vender','label_nome_pizza_2','value','')
       setproperty('form_vender','cbo_composicao_3','value',1)
       setproperty('form_vender','tbox_pizza_3','value','')
       setproperty('form_vender','label_nome_pizza_3','value','')
       setproperty('form_vender','cbo_composicao_4','value',1)
       setproperty('form_vender','tbox_pizza_4','value','')
       setproperty('form_vender','label_nome_pizza_4','value','')
       setproperty('form_vender','tbox_produto','value','')
       setproperty('form_vender','label_nome_produto','value','')
	   setproperty('form_vender','sp_quantidade_2','value',1)
	   setproperty('form_vender','grid_pedido','value',0)
       setproperty('form_vender','label_total','value','0,00')

	   return(nil)
*-------------------------------------------------------------------------------
static function limpar_mesa()

	   local p_parametro := 3//form_vender.radio_tipo_venda.value

       local x_codigo  := val(valor_coluna('grid_generico','form_vender',1))
       local x_id      := valor_coluna('grid_generico','form_vender',2)
       local x_nome    := valor_coluna('grid_generico','form_vender',3)
       local x_hora    := valor_coluna('grid_generico','form_vender',4)
       local x_total   := alltrim(valor_coluna('grid_generico','form_vender',5))
       local x_procura := 0
       local v_id_venda

       if empty(x_hora)
          msgalert('Procedimento incorreto, tecle ENTER','Atenção')
          return(nil)
       endif
       
       if msgyesno('Só utilize esta opção caso tenha aberto por engano','Atenção')
          if x_total == '0,00'
             if p_parametro == 3
          	 	dbselectarea('mesas')
        		mesas->(ordsetfocus('codigo'))
          		mesas->(dbgotop())
          		mesas->(dbseek(x_codigo))
          		if found()
             	   if lock_reg()
                	  mesas->id       := ''
                   	  mesas->hora     := ''
					  mesas->data     := ctod('  /  /  ')
					  mesas->situacao := ''
					  mesas->total    := 0
					  mesas->usuario  := ''
                	  mesas->(dbcommit())
                	  mesas->(dbunlock())
        		   endif
                endif
             endif
          else
			 msgalert('Existe consumo, não é possível limpar, tecle ENTER','Atenção')
			 return(nil)
		  endif
       endif

	   mostra_info_grid_mesa(p_parametro)

       return(nil)
*-------------------------------------------------------------------------------
static function verifica_campo_vazio_mesa(p_parametro)

	   local v_campo_1 := form_vender.tbox_pizza_1.value
	   local v_campo_2 := form_vender.tbox_produto.value
	   
	   if p_parametro == 1 //checa campo da pizza 1
	      if empty(v_campo_1)
	         form_vender.tbox_pizza_1.setfocus
	         return(nil)
	      endif
	   elseif p_parametro == 2 //checa campo do produto
	      if empty(v_campo_2)
	         form_vender.tbox_produto.setfocus
	         return(nil)
	      endif
	   endif

	   return(nil)
	   
static function desabilita_botoes_mesa(p_parametro)

	   limpa_campos_mesa()

       setproperty('form_vender','botao_abre','enabled',.F.)
       setproperty('form_vender','botao_consumo','enabled',.F.)
       setproperty('form_vender','botao_fecha','enabled',.F.)
       setproperty('form_vender','botao_escolhe_venda','enabled',.F.)
       setproperty('form_vender','botao_sair_tela','enabled',.F.)
       setproperty('form_vender','botao_cupom','enabled',.F.)

       delete item all from grid_pedido of form_vender

	   return(nil)
	   
static function habilita_botoes_mesa(p_parametro)

	   limpa_campos_mesa()

       setproperty('form_vender','botao_abre','enabled',.T.)
       setproperty('form_vender','botao_consumo','enabled',.T.)
       setproperty('form_vender','botao_fecha','enabled',.T.)
       setproperty('form_vender','botao_escolhe_venda','enabled',.T.)
       setproperty('form_vender','botao_sair_tela','enabled',.T.)

       delete item all from grid_pedido of form_vender

	   return(nil)
	   
	   