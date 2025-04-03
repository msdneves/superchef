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

function venderdelivery()

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
                on init ( zera_tabelas_delivery(), habilita_campos_delivery() )
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


                @ 180,005 grid grid_generico;
                          parent form_vender;
                          width 190;
                          height 295;
                          headers {'codigo','id_venda','Nome','Hora','Total R$'};
                          widths {1,1,80,45,80};
                          on dblclick consumir_delivery();
                          font 'verdana' size 7;
                          backcolor WHITE;
                          fontcolor BLUE
                /*
                  botões
                */
                @ 490,005 buttonex botao_abre;
                          parent form_vender;
                          caption 'ABRIR';
                          width 190 height 40;
                          picture path_imagens+'img_abre_mesa.bmp';
                          action abrir_delivery();
                          font 'courier new' size 10;
                          bold;
                		  notabstop
                @ 535,005 buttonex botao_consumo;
                          parent form_vender;
                          caption 'LIMPAR';
                          width 190 height 40;
                          picture path_imagens+'img_consumo_mesa.bmp';
                          action limpar_delivery();
                          font 'courier new' size 10;
                          bold;
                		  notabstop
                @ 580,005 buttonex botao_fecha;
                          parent form_vender;
                          caption 'FECHAR VENDA';
                          width 190 height 40;
                          picture path_imagens+'img_fecha_mesa.bmp';
                          action fecha_pedido_delivery();
                          font 'courier new' size 10;
                          bold;
                		  notabstop
*                @ 580,005 buttonex botao_escolhe_venda;
*                          parent form_vender;
*                          caption 'MENU ESCOLHA';
*                          width 190 height 40;
*                          picture path_imagens+'adicionar.bmp';
*                          action ativa_menu_escolha();
*                          font 'courier new' size 10 bold;
*                          fontcolor BLUE;
*                		  notabstop
                @ 625,005 buttonex botao_sair_tela;
                          parent form_vender;
                          caption 'SAIR TELA VENDA';
                          width 190 height 40;
                          picture path_imagens+'exit24_h.bmp';
                          action pergunta_saida_delivery();
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
                          action cadastrar_novo_produto_delivery();
                          font 'courier new' size 10;
                          bold;
                		  notabstop;
                          tooltip 'Clique aqui para cadastrar um produto novo, sem precisar sair desta tela'
                /*
                  botão cadastrar novo cliente
                */
                @ 090,860 buttonex botao_cadastra_cliente;
                          parent form_vender;
                          caption 'Novo Cliente';
                          width 150 height 40;
                          picture path_imagens+'img_cadastra.bmp';
                          action cadastrar_novo_cliente_delivery();
                          font 'courier new' size 10;
                          bold;
                		  notabstop;
                          tooltip 'Clique aqui para cadastrar um cliente novo, sem precisar sair desta tela'
				/*
				  procurar cliente - delivery
				*/
                @ 045,320 label label_telefone;
     		  			  of form_vender;
                          value 'Telefone';
                          autosize;
                          font 'courier new' size 12;
                          fontcolor _preto_001;
                          transparent
                @ 045,420 textbox tbox_telefone;
                          of form_vender;
                          height 030;
                          width 100;
                          value '';
                          maxlength 015;
                          font 'courier new' size 12;
                          bold;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1;
                          on enter procura_cliente_delivery('form_vender','tbox_telefone')
                * mostrar nome do cliente
                @ 045,525 label label_nome_cliente;
                          of form_vender;
                          value '';
                          autosize;
                          font 'courier new' size 012;
                          bold;
                          fontcolor BLUE;
                          transparent
                * mostrar o endereço
                @ 080,420 label label_endereco_001;
                          of form_vender;
                          value '';
                          autosize;
                          font 'courier new' size 012;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 095,420 label label_endereco_002;
                          of form_vender;
                          value '';
                          autosize;
                          font 'courier new' size 012;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 110,420 label label_endereco_003;
                          of form_vender;
                          value '';
                          autosize;
                          font 'courier new' size 012;
                          bold;
                          fontcolor _preto_001;
                          transparent
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
			           onchange pega_tamanho_delivery()
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
                          on enter procura_pizza_delivery(1)
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
			           on gotfocus verifica_campo_vazio_delivery(1)
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
                          action fecha_montagem_pizza_delivery();
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
                          on enter procura_pizza_delivery(2)
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
                          on enter procura_pizza_delivery(3)
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
                          on enter procura_pizza_delivery(4)

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
                          on enter procura_produto_delivery()
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
						  on gotfocus verifica_campo_vazio_delivery(2)
                /*
                  botão grava produto
                */
                @ 320,890 buttonex botao_gravar_produto;
                          parent form_vender;
                          caption 'GRAVAR';
                          width 120 height 40;
                          picture path_imagens+'img_gravar.bmp';
                          action transfere_produto_pedido_delivery();
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
                          action excluir_item_pedido_delivery();
                		  notabstop;
                		  font 'courier new' size 10 bold;
                		  fontcolor RED
                @ 495,890 buttonex botao_cupom;
                          parent form_vender;
                          caption 'COMANDA';
                          width 120 height 40;
                          picture path_imagens+'print.bmp';
                          action emitir_comanda_delivery(_id_venda);
                		  notabstop;
                		  font 'courier new' size 10 bold
                @ 625,890 buttonex botao_sair;
                          parent form_vender;
                          caption 'VOLTAR';
                          width 120 height 40;
                          picture path_imagens+'img_voltar.bmp';
                          action desabilita_botao_voltar_delivery();
                		  notabstop;
                		  font 'courier new' size 10 bold

              	on key escape action pergunta_saida_delivery()
              
         end window
         
         form_vender.center
         form_vender.activate

         return(nil)
*-------------------------------------------------------------------------------
static function pergunta_saida_delivery()

	   if form_vender.tbox_produto.enabled == .F.
	   	  if msgyesno('Confirma fechar janela ?','Mensagem')
	      	 form_vender.release
 		  endif
	   else
	      desabilita_botao_voltar_delivery()
	   endif

	   return(nil)
*-------------------------------------------------------------------------------
static function procura_cliente_delivery(cform,ctextbtn)

       local flag    := .F.
       local creg    := ''
       local nreg_01 := getproperty(cform,ctextbtn,'value')
       local nreg_02 := nreg_01
       local x_texto := alltrim(form_vender.label_cabecalho.value)

       if empty(nreg_02)
          creg := getcode_clientes_delivery(getproperty(cform,ctextbtn,'value'))
          if .not. empty(creg)
             dbselectarea('clientes')
             clientes->(ordsetfocus('fixo'))
             clientes->(dbgotop())
             clientes->(dbseek(creg))
             if found()
                __codigo_cliente := clientes->codigo
                setproperty('form_vender','label_nome_cliente','value',clientes->nome)
                setproperty('form_vender','label_endereco_001','value',alltrim(clientes->endereco)+', '+alltrim(clientes->numero))
                setproperty('form_vender','label_endereco_002','value',alltrim(clientes->complem))
                setproperty('form_vender','label_endereco_003','value',alltrim(clientes->bairro)+', '+alltrim(clientes->cidade))
                if !empty(creg)
                   setproperty(cform,ctextbtn,'value',creg)
                endif
                *historico_cliente(__codigo_cliente)
                form_vender.cbo_tamanhos.setfocus
       	  		/*
          		  mostra no cabeçalho
                */
 		  		setproperty('form_vender','label_cabecalho','value',alltrim(x_texto)+' '+alltrim(clientes->obs))
   	 	  		setproperty('form_vender','label_cabecalho','fontcolor',{0,225,0})
   	  	  		/*
   	  	  		*/
                return(nil)
             endif
          endif
          if .not. empty(creg)
             dbselectarea('clientes')
             clientes->(ordsetfocus('celular'))
             clientes->(dbgotop())
             clientes->(dbseek(creg))
             if found()
                __codigo_cliente := clientes->codigo
                setproperty('form_vender','label_nome_cliente','value',clientes->nome)
                setproperty('form_vender','label_endereco_001','value',alltrim(clientes->endereco)+', '+alltrim(clientes->numero))
                setproperty('form_vender','label_endereco_002','value',alltrim(clientes->complem))
                setproperty('form_vender','label_endereco_003','value',alltrim(clientes->bairro)+', '+alltrim(clientes->cidade))
                if !empty(creg)
                   setproperty(cform,ctextbtn,'value',creg)
                endif
               * historico_cliente(__codigo_cliente)
                form_vender.cbo_tamanhos.setfocus
       	  		/*
          		  mostra no cabeçalho
                */
 		  		setproperty('form_vender','label_cabecalho','value',alltrim(x_texto)+' '+alltrim(clientes->obs))
   	 	  		setproperty('form_vender','label_cabecalho','fontcolor',{0,225,0})
   	  	  		/*
   	  	  		*/
                return(nil)
             endif
          endif
       else
          while .T.
                dbselectarea('clientes')
                clientes->(ordsetfocus('fixo'))
                clientes->(dbgotop())
                clientes->(dbseek(nreg_02))
                if found()
                   __codigo_cliente := clientes->codigo
                   setproperty('form_vender','label_nome_cliente','value',clientes->nome)
                   setproperty('form_vender','label_endereco_001','value',alltrim(clientes->endereco)+', '+alltrim(clientes->numero))
                   setproperty('form_vender','label_endereco_002','value',alltrim(clientes->complem))
                   setproperty('form_vender','label_endereco_003','value',alltrim(clientes->bairro)+', '+alltrim(clientes->cidade))
                  * historico_cliente(__codigo_cliente)
                   form_vender.cbo_tamanhos.setfocus
       	  		   /*
          		   	 mostra no cabeçalho
                   */
 		  		   setproperty('form_vender','label_cabecalho','value',alltrim(x_texto)+' '+alltrim(clientes->obs))
   	 	  		   setproperty('form_vender','label_cabecalho','fontcolor',{0,225,0})
   	  	  		   /*
   	  	  		   */
                   exit
                endif
                dbselectarea('clientes')
                clientes->(ordsetfocus('celular'))
                clientes->(dbgotop())
                clientes->(dbseek(nreg_02))
                if found()
                   __codigo_cliente := clientes->codigo
                   setproperty('form_vender','label_nome_cliente','value',clientes->nome)
                   setproperty('form_vender','label_endereco_001','value',alltrim(clientes->endereco)+', '+alltrim(clientes->numero))
                   setproperty('form_vender','label_endereco_002','value',alltrim(clientes->complem))
                   setproperty('form_vender','label_endereco_003','value',alltrim(clientes->bairro)+', '+alltrim(clientes->cidade))
                  * historico_cliente(__codigo_cliente)
                   form_vender.cbo_tamanhos.setfocus
       	  		   /*
          		   	 mostra no cabeçalho
                   */
 		  		   setproperty('form_vender','label_cabecalho','value',alltrim(x_texto)+' '+alltrim(clientes->obs))
   	 	  		   setproperty('form_vender','label_cabecalho','fontcolor',{0,225,0})
   	  	  		   /*
   	  	  		   */
                   exit
                else
                   msgalert('Telefone não está cadastrado','Atenção')
                   form_vender.tbox_telefone.setfocus
                   return(nil)
                endif
          end
       endif

       return(nil)
*-------------------------------------------------------------------------------
static function getcode_clientes_delivery(value)

       local creg := ''
       local nreg := 1

       dbselectarea('clientes')
       clientes->(ordsetfocus('nome'))
       clientes->(dbgotop())

       define window form_pesquisa;
              at 000,000;
              width 690;
              height 500;
              title 'Pesquisa por nome';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              define label label_pesquisa
                     col 005
                     row 440
                     value 'Buscar'
                     autosize .T.
                     fontname 'verdana'
                     fontsize 012
                     fontbold .T.
                     fontcolor _preto_001
                     transparent .T.
              end label
              define textbox txt_pesquisa
                     col 075
                     row 440
                     width 600
                     maxlength 040
                     onchange find_clientes_delivery()
                     uppercase .T.
              end textbox

              define browse browse_pesquisa
                     row 002
                     col 002
                     width 680
                     height 430
                     headers {'Fixo','Celular','Nome'}
                     widths {150,150,350}
                     workarea clientes
                     fields {'clientes->fixo','clientes->celular','clientes->nome'}
                     value nreg
                     fontname 'courier new'
                     fontsize 012
                     fontbold .T.
                     backcolor _ciano_001
                     nolines .T.
                     lock .T.
                     readonly {.T.,.T.,.T.}
                     justify {BROWSE_JTFY_LEFT,BROWSE_JTFY_LEFT,BROWSE_JTFY_LEFT}
                     on dblclick (iif(empty(clientes->fixo),creg:=clientes->celular,creg:=clientes->fixo),thiswindow.release)
              end browse

              on key escape action thiswindow.release

       end window

       form_pesquisa.browse_pesquisa.setfocus

       form_pesquisa.center
       form_pesquisa.activate

       return(creg)
*-------------------------------------------------------------------------------
static function find_clientes_delivery()

       local pesquisa := alltrim(form_pesquisa.txt_pesquisa.value)

       clientes->(dbgotop())

       if pesquisa == ''
          return(nil)
       elseif clientes->(dbseek(pesquisa))
          form_pesquisa.browse_pesquisa.value := clientes->(recno())
       endif

       return(nil)
*-------------------------------------------------------------------------------
static function procura_produto_delivery()

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
     	  mostra_listagem_produto_delivery()
       endif

       return(nil)
*-------------------------------------------------------------------------------
static function mostra_listagem_produto_delivery()

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
                     onchange find_descricao_delivery()
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
static function find_descricao_delivery()

       local pesquisa := alltrim(form_pesquisa.txt_pesquisa.value)

       produtos->(dbgotop())

       if pesquisa == ''
          return(nil)
       elseif produtos->(dbseek(pesquisa))
          form_pesquisa.browse_pesquisa.value := produtos->(recno())
       endif

       return(nil)
*-------------------------------------------------------------------------------
static function mostra_informacao_produto_delivery()

       local x_codigo := valor_coluna('grid_pesquisa','form_pesquisa',1)
       local x_nome   := valor_coluna('grid_pesquisa','form_pesquisa',2)
       local x_preco  := 0
       
       setproperty('form_vender','tbox_produto','value',alltrim(x_codigo))
       setproperty('form_vender','label_nome_produto','value',alltrim(x_nome))

       form_pesquisa.release

       return(nil)
*-------------------------------------------------------------------------------
static function procura_pizza_delivery(p_numero)

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
     	  mostra_listagem_pizza_delivery(p_numero)
       endif
       
       return(nil)
*-------------------------------------------------------------------------------
static function mostra_listagem_pizza_delivery(p_numero)

       define window form_pesquisa;
              at 000,000;
              width 1020;
              height 610;
              title 'Pizzas';
              icon path_imagens+'icone.ico';
              modal;
              nosize;
              on init popula_pizza_delivery()

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
                     ondblclick mostra_informacao_delivery(p_numero)
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
              		  	on change pesquisar_pizza_delivery()

              on key escape action thiswindow.release
              
       end window
       
       form_pesquisa.tbox_pesquisa.setfocus

       form_pesquisa.center
       form_pesquisa.activate

       return(nil)
*-------------------------------------------------------------------------------
static function popula_pizza_delivery()

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
static function pesquisar_pizza_delivery()

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
static function mostra_informacao_delivery(p_numero)

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
static function zera_tabelas_delivery()

       dbselectarea('tmp_pizza')
       zap
       pack
       
       dbselectarea('tmp_produto')
       zap
       pack

       return(nil)
*-------------------------------------------------------------------------------
static function cadastrar_novo_produto_delivery()

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
                     action gravar_produto_delivery()
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
static function gravar_produto_delivery()

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
static function cadastrar_novo_cliente_delivery()

       local x_nome     := ''
       local x_fixo     := ''
       local x_celular  := ''
       local x_endereco := ''
       local x_numero   := ''
       local x_complem  := ''
       local x_bairro   := ''
       local x_cidade   := 'Guarulhos'
       local x_uf       := 'SP'
       local x_cep      := ''
       local x_email    := ''
       local x_aniv_dia := 0
       local x_aniv_mes := 0
       local x_taxaent  := 0
       local x_pontoref := space(70)
       local x_obs      := space(40)

       define window form_incluir_novo_cliente;
              at 000,000;
		        width 590;
		        height 480;
              title 'Incluir novo cliente';
              icon path_imagens+'icone.ico';
		        modal;
		        nosize

              * entrada de dados
              @ 010,005 label lbl_001;
                        of form_dados;
                        value 'Nome';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 030,005 textbox tbox_001;
                        of form_dados;
                        height 027;
                        width 310;
                        value x_nome;
                        maxlength 040;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 010,325 label lbl_002;
                        of form_dados;
                        value 'Telefone fixo';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 030,325 textbox tbox_002;
                        of form_dados;
                        height 027;
                        width 120;
                        value x_fixo;
                        maxlength 010;
                        font 'verdana' size 012;
                        bold;
                        backcolor BLUE;
                        fontcolor WHITE;
                        uppercase
              @ 010,455 label lbl_003;
                        of form_dados;
                        value 'Telefone celular';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 030,455 textbox tbox_003;
                        of form_dados;
                        height 027;
                        width 120;
                        value x_celular;
                        maxlength 010;
                        font 'verdana' size 012;
                        bold;
                        backcolor BLUE;
                        fontcolor WHITE;
                        uppercase
              @ 060,005 label lbl_004;
                        of form_dados;
                        value 'Endereço';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 080,005 textbox tbox_004;
                        of form_dados;
                        height 027;
                        width 310;
                        value x_endereco;
                        maxlength 040;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 060,325 label lbl_005;
                        of form_dados;
                        value 'Número';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 080,325 textbox tbox_005;
                        of form_dados;
                        height 027;
                        width 060;
                        value x_numero;
                        maxlength 006;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 060,395 label lbl_006;
                        of form_dados;
                        value 'Complemento';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 080,395 textbox tbox_006;
                        of form_dados;
                        height 027;
                        width 180;
                        value x_complem;
                        maxlength 020;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,005 label lbl_007;
                        of form_dados;
                        value 'Bairro';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,005 textbox tbox_007;
                        of form_dados;
                        height 027;
                        width 180;
                        value x_bairro;
                        maxlength 020;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,195 label lbl_008;
                        of form_dados;
                        value 'Cidade';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,195 textbox tbox_008;
                        of form_dados;
                        height 027;
                        width 180;
                        value x_cidade;
                        maxlength 020;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,385 label lbl_009;
                        of form_dados;
                        value 'UF';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,385 textbox tbox_009;
                        of form_dados;
                        height 027;
                        width 040;
                        value x_uf;
                        maxlength 002;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,435 label lbl_010;
                        of form_dados;
                        value 'CEP';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,435 textbox tbox_010;
                        of form_dados;
                        height 027;
                        width 080;
                        value x_cep;
                        maxlength 008;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 160,005 label lbl_011;
                        of form_dados;
                        value 'e-mail';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 180,005 textbox tbox_011;
                        of form_dados;
                        height 027;
                        width 450;
                        value x_email;
                        maxlength 050;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        lowercase
              @ 210,005 label lbl_012;
                        of form_dados;
                        value 'Ponto de Refêrencia';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 230,005 textbox tbox_012;
                        of form_dados;
                        height 027;
                        width 450;
                        value x_pontoref;
                        maxlength 070;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase

              @ 270,005 label lbl_013;
                        of form_dados;
                        value 'Observações';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 290,005 textbox tbox_013;
                        of form_dados;
                        height 027;
                        width 450;
                        value x_obs;
                        maxlength 040;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 320,005 label lbl_014;
                        of form_dados;
                        value 'Dia aniversário';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 340,005 textbox tbox_014;
                        of form_dados;
                        height 027;
                        width 080;
                        value x_aniv_dia;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric
              @ 320,120 label lbl_015;
                       of form_dados;
                        value 'Mês aniversário';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 340,120 textbox tbox_015;
                        of form_dados;
                        height 027;
                        width 080;
                        value x_aniv_mes;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric
              @ 320,320 label lbl_016;
                        of form_dados;
                        value 'Taxa de Entrega R$';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _verde_001;
                        transparent
              @ 340,320 getbox tbox_016;
                        of form_dados;
                        height 027;
                        width 150;
                        value x_taxaent;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'

              * texto de observação
              @ 373,005 label lbl_observacao;
                        of form_dados;
                        value '* os campos na cor azul, telefones fixo e celular, serão utilizados no DELIVERY';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent

              * linha separadora
              define label linha_rodape
                     col 000
                     row form_incluir_novo_cliente.height-090
                     value ''
                     width form_incluir_novo_cliente.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label

              * botões
              define buttonex button_ok
                     picture path_imagens+'img_gravar.bmp'
                     col form_incluir_novo_cliente.width-225
                     row form_incluir_novo_cliente.height-085
                     width 120
                     height 050
                     caption 'Ok, gravar'
                     action gravar_novo_cliente_delivery()
                     fontbold .T.
                     tooltip 'Confirmar as informações digitadas'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_cancela
                     picture path_imagens+'img_voltar.bmp'
                     col form_incluir_novo_cliente.width-100
                     row form_incluir_novo_cliente.height-085
                     width 090
                     height 050
                     caption 'Voltar'
                     action form_incluir_novo_cliente.release
                     fontbold .T.
                     tooltip 'Sair desta tela sem gravar informações'
                     flat .F.
                     noxpstyle .T.
              end buttonex

              on key escape action thiswindow.release
              
       end window

       sethandcursor(getcontrolhandle('button_ok','form_incluir_novo_cliente'))
       sethandcursor(getcontrolhandle('button_cancela','form_incluir_novo_cliente'))

       form_incluir_novo_cliente.center
       form_incluir_novo_cliente.activate

       return(nil)
*-------------------------------------------------------------------------------
static function gravar_novo_cliente_delivery()

       local codigo  := 0
       local retorna := .F.

       if empty(form_incluir_novo_cliente.tbox_001.value)
          retorna := .T.
       endif

       if retorna
          msgalert('Preencha o campo nome','Atenção')
          return(nil)
       endif

       while .T.
             dbselectarea('conta')
             conta->(dbgotop())
             if lock_reg()
                codigo := conta->c_clientes
                replace c_clientes with c_clientes + 1
                conta->(dbcommit())
                conta->(dbunlock())
                exit
             else
                msgexclamation('Servidor congestionado, tecle ENTER e aguarde','Atenção')
                loop
             endif
       end
       dbselectarea('clientes')
       clientes->(dbappend())
       clientes->codigo   := codigo
       clientes->nome     := form_dados.tbox_001.value
       clientes->fixo     := form_dados.tbox_002.value
       clientes->celular  := form_dados.tbox_003.value
       clientes->endereco := form_dados.tbox_004.value
       clientes->numero   := form_dados.tbox_005.value
       clientes->complem  := form_dados.tbox_006.value
       clientes->bairro   := form_dados.tbox_007.value
       clientes->cidade   := form_dados.tbox_008.value
       clientes->uf       := form_dados.tbox_009.value
       clientes->cep      := form_dados.tbox_010.value
       clientes->email    := form_dados.tbox_011.value
	   clientes->pontoref := form_dados.tbox_012.value
	   clientes->obs      := form_dados.tbox_013.value
       clientes->aniv_dia := form_dados.tbox_014.value
	   clientes->aniv_mes := form_dados.tbox_015.value
       clientes->taxa_ent := form_dados.tbox_016.value
       clientes->(dbcommit())
       clientes->(dbgotop())

       form_incluir_novo_cliente.release

       if .not. empty(form_incluir_novo_cliente.tbox_002.value)
          setproperty('form_vender','tbox_telefone','value',form_incluir_novo_cliente.tbox_002.value)
          form_vender.tbox_telefone.setfocus
       else
          setproperty('form_vender','tbox_telefone','value',form_incluir_novo_cliente.tbox_003.value)
          form_vender.tbox_telefone.setfocus
       endif
       
       return(nil)
*-------------------------------------------------------------------------------
static function gravar_adicionar_delivery()
/*
       dbselectarea('tmp_pizza')
       tmp_pizza->(dbappend())
       tmp_pizza->id_produto := form_vender.tbox_pizza.value
       tmp_pizza->nome       := form_vender.label_nome_pizza.value
       tmp_pizza->(dbcommit())
       tmp_pizza->(dbgotop())

       form_vender.grid_pizzas.refresh
       form_vender.grid_pizzas.setfocus
	    form_vender.grid_pizzas.value := recno()

       form_vender.tbox_pizza.value := ''
       form_vender.tbox_pizza.setfocus
*/
       return(nil)
*-------------------------------------------------------------------------------
static function excluir_pizza_delivery()
/*
       if empty(tmp_pizza->nome)
          msgalert('Escolha o que deseja excluir primeiro','Atenção')
          return(nil)
       endif
       
       if msgyesno('Excluir : '+alltrim(tmp_pizza->nome),'Excluir')
          tmp_pizza->(dbdelete())
       endif

       form_vender.grid_pizzas.refresh
	    form_vender.grid_pizzas.setfocus
	    form_vender.grid_pizzas.value := recno()
*/
	    return(nil)
*-------------------------------------------------------------------------------
static function excluir_produto_delivery()
/*
       if empty(tmp_produto->nome)
          msgalert('Escolha o que deseja excluir primeiro','Atenção')
          return(nil)
       endif

       if msgyesno('Excluir : '+alltrim(tmp_produto->nome),'Excluir')
          tmp_produto->(dbdelete())
       endif

       form_vender.grid_produtos.refresh
	    form_vender.grid_produtos.setfocus
	    form_vender.grid_produtos.value := recno()
*/
	    return(nil)
*-------------------------------------------------------------------------------
static function fecha_pizza_delivery()
/*
       dbselectarea('tmp_pizza')
       tmp_pizza->(dbgotop())
       if eof()
          msgexclamation('Nenhuma pizza foi selecionada ainda','Atenção')
          return(nil)
       endif

       define window form_finaliza_pizza;
              at 000,000;
		        width 1000;
		        height 400;
              title 'Finalizar pizza';
              icon path_imagens+'icone.ico';
		        modal;
		        nosize

              @ 005,005 label lbl_001;
                        of form_finaliza_pizza;
                        value '1- Selecione o tamanho da pizza';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 025,005 label lbl_002;
                        of form_finaliza_pizza;
                        value '2- Você poderá escolher entre o menor e o maior preço à ser cobrado, no caso de ter mais de 1 sabor na mesma pizza';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 045,005 label lbl_003;
                        of form_finaliza_pizza;
                        value '3- Caso deseje, ao fechamento deste pedido, poderá conceder um desconto especial ao cliente';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 065,005 label lbl_004;
                        of form_finaliza_pizza;
                        value '4- Para finalizar esta pizza e continuar vendendo, dê duplo-clique ou enter sobre o tamanho/preço escolhido';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 085,005 label lbl_005;
                        of form_finaliza_pizza;
                        value '5- ESC fecha esta janela e retorna para a tela de vendas';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _vermelho_002;
                        transparent

              define grid grid_finaliza_pizza
                     parent form_finaliza_pizza
                     col 005
                     row 105
                     width 985
                     height 260
                     headers {'id','Pizza',_tamanho_001,_tamanho_002,_tamanho_003,_tamanho_004,_tamanho_005,_tamanho_006}
                     widths {001,250,120,120,120,120,120,120}
                     value 1
                     celled .T.
                     fontname 'verdana'
                     fontsize 010
                     fontbold .T.
                     backcolor _cinza_005
                     fontcolor _preto_001
                     ondblclick pega_tamanho_valor_pizza()
              end grid

              on key escape action thiswindow.release

       end window

       monta_informacao_pizza()
       
       form_finaliza_pizza.center
       form_finaliza_pizza.activate
*/
       return(nil)
*-------------------------------------------------------------------------------
static function monta_informacao_pizza_delivery()
/*
       dbselectarea('tmp_pizza')
       tmp_pizza->(dbgotop())

       delete item all from grid_finaliza_pizza of form_finaliza_pizza
       
       while .not. eof()
             dbselectarea('produtos')
             produtos->(ordsetfocus('codigo'))
             produtos->(dbgotop())
             produtos->(dbseek(tmp_pizza->id_produto))
             if found()
                add item {produtos->codigo,alltrim(produtos->nome_longo)+iif(produtos->promocao,' (promoção)',''),trans(produtos->val_tm_001,'@E 99,999.99'),trans(produtos->val_tm_002,'@E 99,999.99'),trans(produtos->val_tm_003,'@E 99,999.99'),trans(produtos->val_tm_004,'@E 99,999.99'),trans(produtos->val_tm_005,'@E 99,999.99'),trans(produtos->val_tm_006,'@E 99,999.99')} to grid_finaliza_pizza of form_finaliza_pizza
             endif
             dbselectarea('tmp_pizza')
             tmp_pizza->(dbskip())
       end
*/
       return(nil)
*-------------------------------------------------------------------------------
static function pega_tamanho_valor_pizza_delivery()
/*
       local valor_do_grid  := form_finaliza_pizza.grid_finaliza_pizza.value
       local item_valor     := form_finaliza_pizza.grid_finaliza_pizza.cell(getproperty('form_finaliza_pizza','grid_finaliza_pizza','value')[1],getproperty('form_finaliza_pizza','grid_finaliza_pizza','value')[2])
       local x_preco        := val(strtran(item_valor,','))/100
       local x_coluna       := valor_do_grid[2]
       local x_nome_tamanho := space(30)

       if x_coluna == 1
          return(nil)
       elseif x_coluna == 2
          return(nil)
       elseif x_coluna == 3
          x_nome_tamanho := alltrim(_tamanho_001)+' '+alltrim(str(_pedaco_001))+'ped'
       elseif x_coluna == 4
          x_nome_tamanho := alltrim(_tamanho_002)+' '+alltrim(str(_pedaco_002))+'ped'
       elseif x_coluna == 5
          x_nome_tamanho := alltrim(_tamanho_003)+' '+alltrim(str(_pedaco_003))+'ped'
       elseif x_coluna == 6
          x_nome_tamanho := alltrim(_tamanho_004)+' '+alltrim(str(_pedaco_004))+'ped'
       elseif x_coluna == 7
          x_nome_tamanho := alltrim(_tamanho_005)+' '+alltrim(str(_pedaco_005))+'ped'
       elseif x_coluna == 8
          x_nome_tamanho := alltrim(_tamanho_006)+' '+alltrim(str(_pedaco_006))+'ped'
       endif

       dbselectarea('tmp_pizza')
       tmp_pizza->(dbgotop())
       while .not. eof()
             if empty(tmp_pizza->sequencia)
                replace sequencia with 'pizza '+alltrim(str(_conta_pizza))
                replace tamanho with x_nome_tamanho
                replace preco with x_preco
             endif
             tmp_pizza->(dbskip())
       end
       
       _conta_pizza ++
       
       form_finaliza_pizza.release
       form_vender.grid_pizzas.refresh
       form_vender.grid_pizzas.setfocus
       form_vender.tbox_observacoes.setfocus
*/
       return(nil)
*-------------------------------------------------------------------------------
static function fecha_pedido_delivery()

	   local p_parametro := 1 //form_vender.radio_tipo_venda.value
	   
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
	   local v_soma_compra        := 0
	   local x_telefone, x_old_id, v_codigo
	   local v_id_cliente
	   
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
				x_telefone   := alltrim(temp_vendas->telefone)
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
             dbselectarea('clientes')
             clientes->(ordsetfocus('fixo'))
             clientes->(dbgotop())
             clientes->(dbseek(x_telefone))
             if found()
				v_id_cliente         := clientes->codigo
				x_valor_taxa_entrega := clientes->taxa_ent
				x_ponto_referencia   := clientes->pontoref
				x_observacoes        := clientes->obs
			 else
             	dbselectarea('clientes')
             	clientes->(ordsetfocus('celular'))
             	clientes->(dbgotop())
             	clientes->(dbseek(x_telefone))
             	if found()
				   v_id_cliente         := clientes->codigo
				   x_valor_taxa_entrega := clientes->taxa_ent
				   x_ponto_referencia   := clientes->pontoref
				   x_observacoes        := clientes->obs
				endif
			 endif
             dbselectarea('temp_vendas')
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
                        on lostfocus calcula_final_delivery(x_preco)

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
                        action imprimir_cupom_delivery(v_id,x_valor_pizza,x_valor_prod,form_fecha_pedido.tbox_desconto.value,x_valor_taxa_entrega,x_ponto_referencia,x_observacoes,v_nome_operacao);
                        tooltip 'Clique aqui imprimir o cupom'
              @ 460,165 buttonex botao_ok;
                        parent form_fecha_pedido;
                        caption 'Fechar pedido';
                        width 140 height 040;
                        picture path_imagens+'img_pedido.bmp';
                        action fechamento_geral_delivery(v_id_cliente,v_soma_compra,x_tipo_venda,v_id,p_codigo);
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
       
       form_fecha_pedido.center
       form_fecha_pedido.activate

       return(nil)
*-------------------------------------------------------------------------------
static function calcula_final_delivery(p_borda)

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
static function fechamento_geral_delivery(p_cliente,p_soma,p_tipo,p_id_geral,p_codigo)

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
                   replace taxa_deliv with v_taxa
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
	   p_tipo := 1

          	 dbselectarea('delivery')
          	 delivery->(ordsetfocus('codigo'))
          	 delivery->(dbgotop())
          	 delivery->(dbseek(x_procura))
          	 if found()
             	if lock_reg()
                   delivery->id       := ''
                   delivery->hora     := ''
                   delivery->data     := x_data_limpa
                   delivery->situacao := ''
                   delivery->usuario  := ''
				   delivery->total    := 0
                   delivery->(dbcommit())
                   delivery->(dbunlock())
                endif
             endif

	   mostra_info_grid_delivery(p_tipo)

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
          contas_receber->cliente := __codigo_cliente
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
          contas_receber->cliente := __codigo_cliente
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
          contas_receber->cliente := __codigo_cliente
          contas_receber->(dbcommit())
       endif


	   x_desc_venda := ''
       x_desc_venda := 'Delivery'
	   
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


	   * ultimas compras do cliente
       dbselectarea('ultimas_compras')
       ultimas_compras->(dbappend())
       ultimas_compras->id_cliente := p_cliente
       ultimas_compras->data       := date()
       ultimas_compras->hora       := x_hora
       ultimas_compras->onde       := p_tipo //1=delivery 2=balcão 3=mesa
       ultimas_compras->valor      := p_soma
       ultimas_compras->(dbcommit())

       * detalhamento - ultimas compras do cliente
	   * produtos
       dbselectarea('temp_vendas')
       index on tipo to indtip2 for id_venda = m_id_geral .and. tipo == 2
       temp_vendas->(dbgotop())
       if .not. eof()
       	  while .not. eof()
             dbselectarea('detalhamento_compras')
             detalhamento_compras->(dbappend())
             detalhamento_compras->id_cliente := p_cliente
             detalhamento_compras->data       := date()
             detalhamento_compras->hora       := x_hora
             detalhamento_compras->id_prod    := temp_vendas->produto
             detalhamento_compras->qtd        := temp_vendas->qtd
             detalhamento_compras->unitario   := temp_vendas->unitario
             detalhamento_compras->subtotal   := temp_vendas->subtotal
             detalhamento_compras->(dbcommit())
             dbselectarea('temp_vendas')
             temp_vendas->(dbskip())
          end
       endif
       set index to
       * pizzas
       dbselectarea('temp_vendas')
       index on tipo to indtip3 for id_venda = m_id_geral .and. tipo == 1
       temp_vendas->(dbgotop())
       if .not. eof()
       	  while .not. eof()
             dbselectarea('detalhamento_compras')
             detalhamento_compras->(dbappend())
             detalhamento_compras->id_cliente := p_cliente
             detalhamento_compras->data       := date()
             detalhamento_compras->hora       := x_hora
             detalhamento_compras->id_prod    := temp_vendas->produto
             detalhamento_compras->subtotal   := temp_vendas->subtotal
             detalhamento_compras->(dbcommit())
             dbselectarea('temp_vendas')
             temp_vendas->(dbskip())
          end
       endif
       set index to


	   
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
static function pega_tamanho_delivery()

	   _numero_tamanho := 0
	   
	   _tamanho_selecionado := alltrim(substr(form_vender.cbo_tamanhos.displayvalue,1,10))
	   _numero_tamanho      := form_vender.cbo_tamanhos.value
	   
	   *form_vender.grid_pizzas.setfocus

	   return(nil)
*-------------------------------------------------------------------------------
static function adiciona_montagem_delivery()
	   return(nil)
*-------------------------------------------------------------------------------
static function transfere_produto_pedido_delivery()

	   local v_tipo      := 1//form_vender.radio_tipo_venda.value
	   local p_codigo    := alltrim(form_vender.tbox_produto.value)
	   local p_nome      := alltrim(form_vender.label_nome_produto.value)
	   local p_qtd       := form_vender.sp_quantidade_2.value
	   local x_unitario  := 0
	   local total_geral := 0
       /* dados do cliente */
       local v_telefone     := form_vender.tbox_telefone.value
       local v_nome_cliente := form_vender.label_nome_cliente.value
       local v_endereco_1   := form_vender.label_endereco_001.value
       local v_endereco_2   := form_vender.label_endereco_002.value
       local v_endereco_3   := form_vender.label_endereco_003.value
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
  	   replace telefone with v_telefone
  	   replace nome_cli with v_nome_cliente
  	   replace end_1 with v_endereco_1
  	   replace end_2 with v_endereco_2
  	   replace end_3 with v_endereco_3
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
	      dbselectarea('delivery')
       	  delivery->(ordsetfocus('id'))
       	  delivery->(dbgotop())
       	  delivery->(dbseek(_id_venda))
       	  if found()
             if lock_reg()
                delivery->total := delivery->total + (x_unitario*p_qtd)
                delivery->(dbunlock())
                delivery->(dbcommit())
             endif
       	  endif
	   	  mostra_info_grid_delivery(1)
	   /*
	     mostra total da venda na tela
	   */
	   _total_pedido := ( _total_pedido + (x_unitario * p_qtd) )
	   setproperty('form_vender','label_total','value',trans(_total_pedido,'@E 99,999.99'))
 	   /*
       	 mostrar do grid a venda
  	   */
   	   mostra_venda_delivery(_id_venda)
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
static function excluir_sabor_delivery()
	   Return(Nil)
*-------------------------------------------------------------------------------
static function excluir_item_pedido_delivery()

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
	      dbselectarea('delivery')
       	  delivery->(ordsetfocus('id'))
       	  delivery->(dbgotop())
       	  delivery->(dbseek(_id_venda))
       	  if found()
             if lock_reg()
                delivery->total := delivery->total - v_total
                delivery->(dbunlock())
                delivery->(dbcommit())
             endif
       	  endif
	   	  mostra_info_grid_delivery(1)
	   /*
	     apaga o conteúdo do grid e atualiza
	   */
       mostra_venda_delivery(_id_venda)
       
	   return(nil)
*-------------------------------------------------------------------------------
static function fecha_montagem_pizza_delivery()

	   local v_tipo_venda    := 1//form_vender.radio_tipo_venda.value
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
       /* dados do cliente */
       local v_telefone      := form_vender.tbox_telefone.value
       local v_nome_cliente  := form_vender.label_nome_cliente.value
       local v_endereco_1    := form_vender.label_endereco_001.value
       local v_endereco_2    := form_vender.label_endereco_002.value
       local v_endereco_3    := form_vender.label_endereco_003.value
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
			 replace telefone with iif(v_tipo_venda=1,v_telefone,'')
			 replace nome_cli with iif(v_tipo_venda=1,v_nome_cliente,'')
			 replace end_1 with iif(v_tipo_venda=1,v_endereco_1,'')
			 replace end_2 with iif(v_tipo_venda=1,v_endereco_2,'')
			 replace end_3 with iif(v_tipo_venda=1,v_endereco_3,'')
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
			 replace telefone with iif(v_tipo_venda=1,v_telefone,'')
			 replace nome_cli with iif(v_tipo_venda=1,v_nome_cliente,'')
			 replace end_1 with iif(v_tipo_venda=1,v_endereco_1,'')
			 replace end_2 with iif(v_tipo_venda=1,v_endereco_2,'')
			 replace end_3 with iif(v_tipo_venda=1,v_endereco_3,'')
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
			 replace telefone with iif(v_tipo_venda=1,v_telefone,'')
			 replace nome_cli with iif(v_tipo_venda=1,v_nome_cliente,'')
			 replace end_1 with iif(v_tipo_venda=1,v_endereco_1,'')
			 replace end_2 with iif(v_tipo_venda=1,v_endereco_2,'')
			 replace end_3 with iif(v_tipo_venda=1,v_endereco_3,'')
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
			 replace telefone with iif(v_tipo_venda=1,v_telefone,'')
			 replace nome_cli with iif(v_tipo_venda=1,v_nome_cliente,'')
			 replace end_1 with iif(v_tipo_venda=1,v_endereco_1,'')
			 replace end_2 with iif(v_tipo_venda=1,v_endereco_2,'')
			 replace end_3 with iif(v_tipo_venda=1,v_endereco_3,'')
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
		  replace telefone with iif(v_tipo_venda=1,v_telefone,'')
		  replace nome_cli with iif(v_tipo_venda=1,v_nome_cliente,'')
		  replace end_1 with iif(v_tipo_venda=1,v_endereco_1,'')
		  replace end_2 with iif(v_tipo_venda=1,v_endereco_2,'')
		  replace end_3 with iif(v_tipo_venda=1,v_endereco_3,'')
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
		  	 replace telefone with iif(v_tipo_venda=1,v_telefone,'')
		  	 replace nome_cli with iif(v_tipo_venda=1,v_nome_cliente,'')
		  	 replace end_1 with iif(v_tipo_venda=1,v_endereco_1,'')
		  	 replace end_2 with iif(v_tipo_venda=1,v_endereco_2,'')
		  	 replace end_3 with iif(v_tipo_venda=1,v_endereco_3,'')
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
	      	 dbselectarea('delivery')
       	  	 delivery->(ordsetfocus('id'))
       	  	 delivery->(dbgotop())
       	  	 delivery->(dbseek(_id_venda))
       	  	 if found()
             	if lock_reg()
                   delivery->total := delivery->total + (x_valor_cobrado*v_qtd_pizza) + v_valor_borda
                   delivery->(dbunlock())
                   delivery->(dbcommit())
                endif
       	     endif
	   	     mostra_info_grid_delivery(1)
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
       	  mostra_venda_delivery(_id_venda)
       	  /*
       	    focar a escolha do tamanho
       	  */
       	  form_vender.cbo_tamanhos.setfocus
	   endif

	   return(nil)
*-------------------------------------------------------------------------------
static function mostra_venda_delivery(p_parametro)

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
static function imprimir_cupom_delivery(p_id,p_vlr_pizza,p_vlr_prod,p_desconto,p_taxa_entrega,p_ponto_ref,p_obs,p_nome_operacao)

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
                   replace taxa_deliv with v_taxa
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
          	 if x_tipo_venda == 1
          	 	? 'CLIENTE:'+alltrim(temp_vendas->telefone)+'-'+alltrim(temp_vendas->nome_cli)
          	 	? ' '+alltrim(temp_vendas->end_1)
          	 	? ' '+alltrim(temp_vendas->end_2)
          	 	? ' '+alltrim(temp_vendas->end_3)
				if .not. empty(p_ponto_ref)
          		   ? '('+alltrim(p_ponto_ref)+')'
                endif
             	if .not. empty(p_obs)
          		   ? '('+alltrim(p_obs)+')'
          		endif
             elseif x_tipo_venda == 2
          	    ? 'CLIENTE:'+alltrim(temp_vendas->nome_bal)
             endif
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
     	  if x_tipo_venda == 1
          ? '                   TAXA DE ENTREGA : '+trans(p_taxa_entrega,'@E 999,999.99')
          elseif x_tipo_venda == 3
          ? '                               10% : '+trans(p_taxa_entrega,'@E 999,999.99')
          endif
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
static function adiciona_borda_delivery()
	   return(nil)
*-------------------------------------------------------------------------------
static function emitir_comanda_delivery(p_parametro)

       local x_nome, x_fixo, x_endereco, x_numero
	   local x_tipo_venda       := 1//form_vender.radio_tipo_venda.value
	   local x_telefone_cliente := alltrim(form_vender.tbox_telefone.value)
       local x_nome_cliente     := alltrim(form_vender.label_nome_cliente.value)
       local x_endereco_1       := alltrim(form_vender.label_endereco_001.value)
       local x_endereco_2       := alltrim(form_vender.label_endereco_002.value)
       local x_endereco_3       := alltrim(form_vender.label_endereco_003.value)
       local x_total            := alltrim(form_vender.label_total.value)
       local v_total_comanda := 0
       local v_calcula_10 := 0
       local v_parametro := alltrim(p_parametro)
       local v_old_id, v_old_hora, v_old_tipo
       local v_nome_venda
       
       v_nome_venda := 'DELIVERY'

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
          if x_tipo_venda == 1
          	 ? 'CLIENTE:'+x_telefone_cliente+'-'+x_nome_cliente
          	 ? ' '+x_endereco_1
          	 ? ' '+x_endereco_2
          	 ? ' '+x_endereco_3
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
          ? '                      TOTAL PEDIDO : '+trans(v_total_comanda,'@E 999,999.99')
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
static function seleciona_tipo_de_venda_delivery()

	   local v_tipo := 1//form_vender.radio_tipo_venda.value
	   
	      setproperty('form_vender','label_cabecalho','value','DELIVERY')
	      setproperty('form_vender','label_cabecalho','fontcolor',{0,225,0})
       	  mostra_info_grid_delivery(1)
       	  setproperty('form_vender','grid_generico','enabled',.T.)
       	  setproperty('form_vender','botao_abre','enabled',.T.)
       	  setproperty('form_vender','botao_consumo','enabled',.T.)
       	  setproperty('form_vender','botao_fecha','enabled',.T.)
	   
	   return(nil)
*-------------------------------------------------------------------------------
static function habilita_campos_delivery()

       setproperty('form_vender','botao_cadastra_produto','enabled',.T.)
       setproperty('form_vender','botao_cadastra_cliente','enabled',.T.)
       setproperty('form_vender','label_telefone','enabled',.T.)
       setproperty('form_vender','tbox_telefone','enabled',.T.)
       setproperty('form_vender','label_nome_cliente','enabled',.T.)
       setproperty('form_vender','label_endereco_001','enabled',.T.)
       setproperty('form_vender','label_endereco_002','enabled',.T.)
       setproperty('form_vender','label_endereco_003','enabled',.T.)
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
       
       form_vender.tbox_telefone.setfocus
       
	   return(nil)
*-------------------------------------------------------------------------------
static function mostra_info_grid_delivery(p_parametro)

	   /*
	     p_parametro :
	     : 1 - delivery
	   */

       delete item all from grid_generico of form_vender

       	  dbselectarea('delivery')
       	  delivery->(ordsetfocus('codigo'))
       	  delivery->(dbgotop())
       	  while .not. eof()
             	add item {alltrim(str(delivery->codigo)),alltrim(delivery->id),alltrim(delivery->nome),substr(delivery->hora,1,5),trans(delivery->total,'@E 999,999.99')} to grid_generico of form_vender
             	delivery->(dbskip())
          end
	   
       return(nil)
*-------------------------------------------------------------------------------
static function desabilita_campos_delivery()

       setproperty('form_vender','grid_generico','enabled',.F.)
       setproperty('form_vender','botao_abre','enabled',.F.)
       setproperty('form_vender','botao_consumo','enabled',.F.)
       setproperty('form_vender','botao_fecha','enabled',.F.)
       setproperty('form_vender','botao_cadastra_produto','enabled',.F.)
       setproperty('form_vender','botao_cadastra_cliente','enabled',.F.)
       setproperty('form_vender','label_telefone','enabled',.F.)
       setproperty('form_vender','tbox_telefone','enabled',.F.)
       setproperty('form_vender','label_nome_cliente','enabled',.F.)
       setproperty('form_vender','label_endereco_001','enabled',.F.)
       setproperty('form_vender','label_endereco_002','enabled',.F.)
       setproperty('form_vender','label_endereco_003','enabled',.F.)
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
static function abrir_delivery()

	   local p_parametro := 1//form_vender.radio_tipo_venda.value
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
       _id_tipo_venda := 1

       x_procura := val(x_codigo)


		     _total_pedido := 0
          	 dbselectarea('delivery')
          	 delivery->(ordsetfocus('codigo'))
          	 delivery->(dbgotop())
          	 delivery->(dbseek(x_procura))
          	 if found()
             	if lock_reg()
                   delivery->id       := _id_venda
                   delivery->hora     := time()
                   delivery->data     := date()
                   delivery->situacao := 'A'
                   delivery->usuario  := '-'
                   delivery->(dbcommit())
                   delivery->(dbunlock())
                endif
             endif
             /*
               mostra no cabeçalho
             */
    		 setproperty('form_vender','label_cabecalho','value',alltrim(x_nome))
	      	 setproperty('form_vender','label_cabecalho','fontcolor',{0,225,0})
       	  	 /*
       	  	 */
             habilita_campos_delivery()
             /*
               mostra no cabeçalho
             */
    		 setproperty('form_vender','label_cabecalho','value',alltrim(x_nome))
	      	 setproperty('form_vender','label_cabecalho','fontcolor',{255,100,100})
       	  	 /*
      	  	 */

	   mostra_info_grid_delivery(p_parametro)
	   
*	   desabilita_botoes_delivery(p_parametro)
	   
       return(nil)
*-------------------------------------------------------------------------------
static function consumir_delivery()

	   local p_parametro := 1//form_vender.radio_tipo_venda.value

       local x_codigo  := valor_coluna('grid_generico','form_vender',1)
       local x_id      := valor_coluna('grid_generico','form_vender',2)
       local x_nome    := valor_coluna('grid_generico','form_vender',3)
       local x_hora    := valor_coluna('grid_generico','form_vender',4)
       local x_procura := 0
	   local x_observacao := ''
       local x_telefone

	   _nome_da_venda := alltrim(x_nome)
	   
       if empty(x_hora)
          msgalert('Primeiro clique no botão ABRIR, tecle ENTER','Atenção')
          return(nil)
       endif
       
       _id_venda := alltrim(x_id)

	   _total_pedido := 0
	   
	      _id_tipo_venda := 1
	      /*
	        achar o telefone para achar observação, se houver
	      */
	   	  dbselectarea('temp_vendas')
	   	  temp_vendas->(ordsetfocus('id_venda'))
	   	  temp_vendas->(dbgotop())
	   	  temp_vendas->(dbseek(_id_venda))
	   	  if found()
       	  	 x_telefone := alltrim(temp_vendas->telefone)
             dbselectarea('clientes')
             clientes->(ordsetfocus('celular'))
             clientes->(dbgotop())
             clientes->(dbseek(x_telefone))
             if found()
                x_observacao := alltrim(clientes->obs)
             else
             	dbselectarea('clientes')
             	clientes->(ordsetfocus('fixo'))
             	clientes->(dbgotop())
             	clientes->(dbseek(x_telefone))
             	if found()
                   x_observacao := alltrim(clientes->obs)
             	endif
             endif
	      endif
       	  /*
          	mostra no cabeçalho
          */
 		  setproperty('form_vender','label_cabecalho','value',alltrim(x_nome)+' '+x_observacao)
   	 	  setproperty('form_vender','label_cabecalho','fontcolor',{0,225,0})
   	  	  /*
   	  	  */
       habilita_campos_delivery()
	   desabilita_botoes_delivery(p_parametro)

	   /*
	     popular o grid com as informações da venda
	   */
	   mostra_venda_delivery(_id_venda)

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
	   
	   /*
	     achar nome do cliente em temp_vendas
	     para mostrar desabilitado na tela
	   */
	   dbselectarea('temp_vendas')
	   temp_vendas->(ordsetfocus('id_venda'))
	   temp_vendas->(dbgotop())
	   temp_vendas->(dbseek(_id_venda))
	   if found()
       	  setproperty('form_vender','tbox_telefone','value',alltrim(temp_vendas->telefone))
       	  setproperty('form_vender','label_nome_cliente','value',alltrim(temp_vendas->nome_cli))
       	  setproperty('form_vender','label_endereco_001','value',alltrim(temp_vendas->end_1))
       	  setproperty('form_vender','label_endereco_002','value',alltrim(temp_vendas->end_2))
       	  setproperty('form_vender','label_endereco_003','value',alltrim(temp_vendas->end_3))
	   endif

       return(nil)
*-------------------------------------------------------------------------------
*static function ativa_menu_escolha()
*
*	   setproperty('form_vender','radio_tipo_venda','enabled',.T.)
*
*	   return(nil)
**-------------------------------------------------------------------------------
static function desabilita_botao_voltar_delivery()

	   limpa_campos_delivery()
	   habilita_botoes_delivery()
	   
       setproperty('form_vender','botao_cadastra_produto','enabled',.F.)
       setproperty('form_vender','botao_cadastra_cliente','enabled',.F.)
       setproperty('form_vender','label_telefone','enabled',.F.)
       setproperty('form_vender','tbox_telefone','enabled',.F.)
       setproperty('form_vender','label_nome_cliente','enabled',.F.)
       setproperty('form_vender','label_endereco_001','enabled',.F.)
       setproperty('form_vender','label_endereco_002','enabled',.F.)
       setproperty('form_vender','label_endereco_003','enabled',.F.)
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
static function limpa_campos_delivery()

       setproperty('form_vender','tbox_telefone','value','')
       setproperty('form_vender','label_nome_cliente','value','')
       setproperty('form_vender','label_endereco_001','value','')
       setproperty('form_vender','label_endereco_002','value','')
       setproperty('form_vender','label_endereco_003','value','')
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
static function limpar_delivery()

	   local p_parametro := 1//form_vender.radio_tipo_venda.value

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
          	 	dbselectarea('delivery')
        		delivery->(ordsetfocus('codigo'))
          		delivery->(dbgotop())
          		delivery->(dbseek(x_codigo))
          		if found()
             	   if lock_reg()
                	  delivery->id       := ''
                   	  delivery->hora     := ''
					  delivery->data     := ctod('  /  /  ')
					  delivery->situacao := ''
					  delivery->total    := 0
					  delivery->usuario  := ''
                	  delivery->(dbcommit())
                	  delivery->(dbunlock())
        		   endif
                endif
          else
			 msgalert('Existe consumo, não é possível limpar, tecle ENTER','Atenção')
			 return(nil)
    	  endif
		endif
	   mostra_info_grid_delivery(p_parametro)

       return(nil)
*-------------------------------------------------------------------------------
static function verifica_campo_vazio_delivery(p_parametro)

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
	   
static function desabilita_botoes_delivery(p_parametro)

	   limpa_campos_delivery()

       setproperty('form_vender','botao_abre','enabled',.F.)
       setproperty('form_vender','botao_consumo','enabled',.F.)
       setproperty('form_vender','botao_fecha','enabled',.F.)
       setproperty('form_vender','botao_escolhe_venda','enabled',.F.)
       setproperty('form_vender','botao_sair_tela','enabled',.F.)
       setproperty('form_vender','botao_cupom','enabled',.F.)


       delete item all from grid_pedido of form_vender

	   return(nil)
	   
static function habilita_botoes_delivery(p_parametro)

	   limpa_campos_delivery()

       setproperty('form_vender','botao_abre','enabled',.T.)
       setproperty('form_vender','botao_consumo','enabled',.T.)
       setproperty('form_vender','botao_fecha','enabled',.T.)
       setproperty('form_vender','botao_escolhe_venda','enabled',.T.)
       setproperty('form_vender','botao_sair_tela','enabled',.T.)

       delete item all from grid_pedido of form_vender

	   return(nil)
	   
