/*
  sistema     : pizzaria
  programa    : main
  compilador  : harbour 3.2
  lib gráfica : minigui extended
*/

#include 'minigui.ch'

function main()
		 /*
		   variáveis locais
		 */
 		 local aColors
		 local largura_maxima  := 0
		 local largura_botoes  := 0
		 local diferenca_entre := 0
		 local metade_entre    := 0
		 local coluna_inicia   := 0
		 /*
		   variáveis públicas
		 */
           public _id_venda
		 public _id_tipo_venda
		 public a_tamanho_da_pizza := {}
		 public _total_venda_grid := 0
		 public _nome_da_venda := ''
		 
		 public y_ncaixa          := ''
       public l_demo            := .F.
       public _limite_registros := 10
       public _nome_cliente_    := ''
       public _numero_serie_    := ''
       public __codigo_cliente  := 0
       public _codigo_usuario_  := 0
       public _nome_usuario_    := space(10)
       public _tipo_cobranca    := 0
       public _zero             := 0
       public _tamanho_001      := ''
       public _tamanho_002      := ''
       public _tamanho_003      := ''
       public _tamanho_004      := ''
       public _tamanho_005      := ''
       public _tamanho_006      := ''
       public _pedaco_001       := 0
       public _pedaco_002       := 0
       public _pedaco_003       := 0
       public _pedaco_004       := 0
       public _pedaco_005       := 0
       public _pedaco_006       := 0
       public a_nome_borda      := {}
       public a_valor_borda     := {}
       public a_nome_cobertura  := {}
       public a_valor_cobertura := {}
		 /*
		   caminho das tabelas, indices e imagens
		 */
         public path_dbf     := curdrive()+':\'+curdir()+'\tabelas\' 
         public path_imagens := curdrive()+':\'+curdir()+'\imagens\'
         /*
           cores padrão do sistema
         */
         public _branco_001     := {255,255,255}
         public _preto_001      := {000,000,000}
         public _azul_001       := {108,108,255}
         public _azul_002       := {000,000,255}
         public _azul_003       := {032,091,164}
         public _azul_004       := {023,063,115}
         public _azul_005       := {071,089,135}
         public _azul_006       := {000,073,148}
         public _laranja_001    := {255,163,070}
         public _verde_001      := {000,094,047}
         public _verde_002      := {000,089,045}
         public _cinza_001      := {128,128,128}
         public _cinza_002      := {192,192,192}
         public _cinza_003      := {229,229,229}
         public _cinza_004      := {226,226,226}
         public _cinza_005      := {245,245,245}
         public _vermelho_001   := {255,000,000}
         public _vermelho_002   := {160,000,000}
         public _vermelho_003   := {190,000,000}
         public _amarelo_001    := {255,255,255}
         public _amarelo_002    := {255,255,121}
         public _marrom_001     := {143,103,080}
         public _ciano_001      := {215,255,255}
         public _grid_001       := _branco_001
         public _grid_002       := {210,233,255}
         public _super          := {128,128,255}
         public _acompanhamento := {255,255,220}
         public _fundo_get      := {255,255,255}
         public _letra_get_1    := {000,000,255}
         public _nome_unidade   := 0
         public a_onde          := {'Delivery','Mesa','Balcão'}
         public a_situacao      := {'Montando','Assando','Sendo entregue','PEDIDO OK'}
         /*
           variáveis públicas para liberar acesso
         */
         public _a_001 := _a_002 := _a_003 := _a_004 := _a_005 := .F.
         public _a_006 := _a_007 := _a_008 := _a_009 := _a_010 := .F.
         public _a_011 := _a_012 := _a_013 := _a_014 := _a_015 := .F.
         public _a_016 := _a_017 := _a_018 := _a_019 := _a_020 := .F.
         public _a_021 := _a_022 := _a_023 := _a_024 := _a_025 := .F.
         public _a_026 := _a_027 := _a_028 := _a_029 := _a_030 := .F.
         public _a_031 := _a_032 := _a_033 := _a_034 := _a_035 := .F.
         public _a_036 := _a_037 := _a_038 := _a_039 := _a_040 := .F.
         public _a_041 := _a_042 := _a_043 := .F.
         /*
           tamanhos composição pizza
		 */
		 public a_composicao := {'1/1','1/2','1/3','1/4','2/3','3/4'}
		 /*
		   definir dbf e cdx como default
		 */
         REQUEST DBFCDX, DBFFPT
         RDDSETDEFAULT('DBFCDX')
         DBSETDRIVER('DBFCDX')
		 /*
		   definir idioma padrão da aplicação
		 */
         REQUEST HB_LANG_PT
         REQUEST HB_CODEPAGE_PT850
         HB_LANGSELECT('PT')
         HB_SETCODEPAGE('PT850')
		 /*
		   setamentos
		 */
         set autoadjust on
         set deleted on
         set interactiveclose off
         set date british
         set century on
         set epoch to 1960
         set browsesync on
         set multiple off warning
         set tooltipballoon on
         set navigation extended
         set codepage to portuguese
         set language to portuguese
		 /*
		   definir fonte do menu
		 */
		 define font font_1 fontname 'tahoma' size 10
		 fonte_menu := GetFontHandle('font_1')
		 /*
		   setar estilo do menu
		 */
		SET MENUSTYLE EXTENDED
		SET MENUCURSOR FULL
		SET MENUSEPARATOR SINGLE RIGHTALIGN
		SET MENUITEM BORDER 3D
		 /*
		   reconfigurar cores do menu
		 */
		aColors := GetMenuColors()
		aColors[ MNUCLR_SEPARATOR1 ] := RGB(128,128,128) //linha separadora
		aColors[ MNUCLR_IMAGEBACKGROUND1 ] := RGB(221,218,213) //fundo bmp do ítem
		aColors[ MNUCLR_IMAGEBACKGROUND2 ] := RGB(221,218,213) //fundo bmp do ítem
		aColors[ MNUCLR_MENUBARBACKGROUND1 ] := GetSysColor(15)
		aColors[ MNUCLR_MENUBARBACKGROUND2 ] := GetSysColor(15)
		aColors[ MNUCLR_MENUBARSELECTEDITEM1 ] := RGB(169,198,246) //ítem horizontal - opção mestre
		aColors[ MNUCLR_MENUBARSELECTEDITEM2 ] := RGB(169,198,246) //ítem horizontal - opção mestre
		aColors[ MNUCLR_MENUITEMSELECTEDTEXT ] := RGB(0,0,255) //texto do ítem selecionado
		aColors[ MNUCLR_SELECTEDITEMBORDER1 ] := RGB(169,198,246) //bordas do ítem
		aColors[ MNUCLR_SELECTEDITEMBORDER2 ] := RGB(169,198,246) //bordas do ítem
		aColors[ MNUCLR_SELECTEDITEMBORDER3 ] := RGB(169,198,246) //bordas do ítem
		aColors[ MNUCLR_SELECTEDITEMBORDER4 ] := RGB(169,198,246) //bordas do ítem
		aColors[ MNUCLR_MENUITEMBACKGROUND1 ] := RGB(240,240,240) //fundo geral menu
		aColors[ MNUCLR_MENUITEMBACKGROUND2 ] := RGB(240,240,240) //fundo geral menu
		aColors[ MNUCLR_MENUITEMSELECTEDBACKGROUND1 ] := RGB(169,198,246) //fundo ítem menu
		aColors[ MNUCLR_MENUITEMSELECTEDBACKGROUND2 ] := RGB(169,198,246) //fundo ítem menu
		SetMenuColors( aColors )
		 /*
		   form principal
		 */
     DEFINE WINDOW Form_Main ;
          AT 0,0 ;
          WIDTH GetDesktopWidth() ;
          HEIGHT GetDesktopHeight() ;
          TITLE 'Metre' ;
          ICON 'icon' ;
          WINDOWTYPE MAIN ;
          NOSHOW ;
          NOCAPTION ;
          NOSIZE ;
          BACKCOLOR BLACK ;
		    on init (cria_dbf_cdx(),login())          
          /*
               wallpaper
          */
          DEFINE IMAGE Wallpaper
               ROW 0
               COL -1
               HEIGHT GetDesktopHeight()-110
               WIDTH GetDesktopWidth()+1
               PICTURE 'wallpaper'
               STRETCH .T.
          END IMAGE
		/*
			opções secundárias
		*/
		Menu_opcoes()				
		/*
			opções principais
		*/
          DEFINE BUTTONEX Botao_venda_buffet
               ROW 10
               COL GetDesktopWidth()-820
               WIDTH 400
               HEIGHT 150
               PICTURE 'img_vender'
               CAPTION 'F1'+CRLF+'VENDER'
               ACTION confere_caixa(y_ncaixa)
               VERTICAL .F.
               LEFTTEXT .F.
               FLAT .T.
               FONTSIZE 14
               FONTBOLD .T.
               FONTCOLOR BLACK
               BACKCOLOR WHITE
               UPPERTEXT .F.
               NOHOTLIGHT .T.
               NOXPSTYLE .T.
          END BUTTONEX
          DEFINE BUTTONEX Botao_venda_delivery
               ROW 10
               COL GetDesktopWidth()-410
               WIDTH 400
               HEIGHT 150
               PICTURE 'img_resumo'
               CAPTION 'F2'+CRLF+'RESUMO VENDAS'
               ACTION relatorio_resumo()
               VERTICAL .F.
               LEFTTEXT .F.
               FLAT .T.
               FONTSIZE 14
               FONTBOLD .T.
               FONTCOLOR BLACK
               BACKCOLOR WHITE
               UPPERTEXT .F.
               NOHOTLIGHT .T.
               NOXPSTYLE .T.
          END BUTTONEX
          DEFINE BUTTONEX Botao_venda_balcao
               ROW 170
               COL GetDesktopWidth()-820
               WIDTH 400
               HEIGHT 150
               PICTURE 'img_movdia'
               CAPTION 'F3'+CRLF+'MOVIMENTO DIÁRIO'
               ACTION movimento_do_dia()
               VERTICAL .F.
               LEFTTEXT .F.
               FLAT .T.
               FONTSIZE 14
               FONTBOLD .T.
               FONTCOLOR BLACK
               BACKCOLOR WHITE
               UPPERTEXT .F.
               NOHOTLIGHT .T.
               NOXPSTYLE .T.
          END BUTTONEX
          DEFINE BUTTONEX Botao_venda_clientes
               ROW 170
               COL GetDesktopWidth()-410
               WIDTH 400
               HEIGHT 150
               PICTURE 'img_retag'
               CAPTION 'F4'+CRLF+'RETAGUARDA'
               ACTION retaguarda()
               VERTICAL .F.
               LEFTTEXT .F.
               FLAT .T.
               FONTSIZE 14
               FONTBOLD .T.
               FONTCOLOR BLACK
               BACKCOLOR WHITE
               UPPERTEXT .F.
               NOHOTLIGHT .T.
               NOXPSTYLE .T.
          END BUTTONEX
          DEFINE BUTTONEX Botao_produtos
               ROW 330
               COL GetDesktopWidth()-410
               WIDTH 400
               HEIGHT 150
               PICTURE 'img_abrecxa'               
               CAPTION 'F5'+CRLF+'ABRIR CAIXA'
               ACTION abre_caixa()
               VERTICAL .F.
               LEFTTEXT .F.
               FLAT .T.
               FONTSIZE 14
               FONTBOLD .T.
               FONTCOLOR BLACK
               BACKCOLOR GREEN
               UPPERTEXT .F.
               NOHOTLIGHT .T.
               NOXPSTYLE .T.
          END BUTTONEX
          DEFINE BUTTONEX Botao_caixa
               ROW 490
               COL GetDesktopWidth()-410
               WIDTH 400
               HEIGHT 150
               PICTURE 'img_fechacxa'               
               CAPTION 'F6'+CRLF+'FECHAR CAIXA'
               ACTION fecha_caixa()
               VERTICAL .F.
               LEFTTEXT .F.
               FLAT .T.
               FONTSIZE 14
               FONTBOLD .T.
               FONTCOLOR BLACK
               BACKCOLOR {171,182,209} 
               UPPERTEXT .F.
               NOHOTLIGHT .T.
               NOXPSTYLE .T.
          END BUTTONEX
/*
          	nome do cliente
         	*/
          DEFINE LABEL Nome_cliente
               COL 0
               ROW GetDesktopHeight()-70
               VALUE 'NOME DO SEU CLIENTE'
               AUTOSIZE .T.
               FONTNAME 'verdana'
               FONTSIZE 18
               FONTBOLD .F.
               FONTCOLOR WHITE
               TRANSPARENT .T.
          END LABEL          			
         	/*
			logotipo
 		*/
		@ GetDesktopHeight()-80, GetDesktopWidth()-220 IMAGE Logo_sistema ;
			PICTURE 'logo_sistema' ;
			ACTION MsgInfo('Você pode definir alguma ação clicando na imagem.') ;
			WIDTH 210 HEIGHT 70 
          /*
          	hora
         	*/
          DEFINE TIMER Timer_Relogio ;
               INTERVAL 1000 ;
               ACTION form_main.Label_Relogio.Value := Substr(Time(),1,5)
          DEFINE LABEL Label_Relogio
               COL 10
               ROW GetDesktopHeight()-300
               VALUE ''
               AUTOSIZE .T.
               FONTNAME 'arial'
               FONTSIZE 75
               FONTBOLD .F.
               FONTCOLOR WHITE
               TRANSPARENT .T.
          END LABEL
		/*
			data
		*/
          DEFINE LABEL Label_Data
               COL 10
               ROW GetDesktopHeight()-200
               VALUE Dia_Da_Semana(Date(),1)+', '+StrZero(Day(Date()),2)+' ' + ;
                     alltrim(Mes_Do_Ano(Month(Date()),2))+' '+StrZero(Year(Date()),4)
               AUTOSIZE .T.
               FONTNAME 'arial'
               FONTSIZE 35
               FONTBOLD .F.
               FONTCOLOR {220,220,220}
               TRANSPARENT .T.
          END LABEL	 
                
         on key F1 action confere_caixa(y_ncaixa)
         on key F2 action relatorio_resumo()
         on key F3 action movimento_do_dia()
         on key F4 action retaguarda()
         on key F5 action abre_caixa()
         on key F6 action fecha_caixa()
			/*	
  				tecla ESC para sair da janela
			*/
			ON KEY ESCAPE ACTION form_main.release

         end window

         form_main.activate

         return(nil)
*-------------------------------------------------------------------------------
STATIC FUNCTION Menu_opcoes()

	LOCAL nI, cItemName, HBtn1DropMenu, cFile, cAction
	
	DEFINE IMAGE Menu_opcoes
 	   ROW 5
   	COL 5
     	HEIGHT 52
      WIDTH 124
      PICTURE 'img_menu'
      ACTION { || ShowBtnDropMenu('form_main', This.Name, HBtn1DropMenu ) }
	END IMAGE	

	DEFINE CONTEXT MENU CONTROL Menu_opcoes
      menuitem 'Tamanhos de Pizza' action iif(libera(_a_039),tamanhos_pizza(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_tamanhos.bmp' font fonte_menu
      menuitem 'Bordas de Pizza' action bordas_pizza() image path_imagens+'img_borda.bmp' font fonte_menu
      menuitem 'Cobertura Extra' action cobertura_pizza() image path_imagens+'img_borda.bmp' font fonte_menu
      menuitem 'Configurar Venda de Pizza' action configurar_venda() image path_imagens+'img_prevda.bmp' font fonte_menu
      separator
      menuitem 'Incluir ou Excluir Promoção' action iif(libera(_a_041),promocao(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_promocoes.bmp' font fonte_menu
      menuitem 'Reajustar Preços de Produtos' action iif(libera(_a_042),reajuste(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_reajustar.bmp' font fonte_menu
      separator
	   menuitem 'Sair do Sistema' action form_main.release font fonte_menu
	END MENU

	HBtn1DropMenu := _HMG_xContextMenuHandle
	SET CONTEXT MENU CONTROL Menu_opcoes OF form_main OFF

	RETURN( Nil )      
*-------------------------------------------------------------------------------
FUNCTION ShowBtnDropMenu( cWin, cBut, HBtnDropMenu )

	LOCAL aPos := { 0, 0, 0, 0 }

	GetWindowRect( GetControlHandle( cBut, cWin ), /*@*/aPos )
	TrackPopupMenu( HBtnDropMenu, aPos[1], ;
 		aPos[2] + GetProperty(cWin,cBut,'Height'), GetFormHandle( cWin ) )

	RETURN( Nil )	   
*-------------------------------------------------------------------------------
static function cria_dbf_cdx()

       local a_dbf := {}
       local x_largura := getdesktopwidth()
       local x_altura := getdesktopheight()

	   if x_largura < 1024 .and. x_altura < 768
	      msgexclamation('O programa não funciona nesta resolução de vídeo, tecle ENTER','Atenção')
		  form_main.release
	   endif

       * dados da empresa
	    if .not. file(path_dbf+'empresa.dbf')
          aadd(a_dbf,{'nome','c',40,0})
          aadd(a_dbf,{'fixo_1','c',10,0})
          aadd(a_dbf,{'fixo_2','c',10,0})
          aadd(a_dbf,{'endereco','c',40,0})
          aadd(a_dbf,{'numero','c',06,0})
          aadd(a_dbf,{'complem','c',20,0})
          aadd(a_dbf,{'bairro','c',20,0})
          aadd(a_dbf,{'cidade','c',20,0})
          aadd(a_dbf,{'uf','c',02,0})
          aadd(a_dbf,{'cep','c',08,0})
          aadd(a_dbf,{'email','c',50,0})
          aadd(a_dbf,{'site','c',50,0})
          dbcreate(path_dbf+'empresa',a_dbf)
          dbclosearea()
	       if open_dbf('empresa','empresa',.T.)
             if add_reg()
                empresa->nome     := 'Nome do cliente pizzaria'
                empresa->fixo_1   := ''
                empresa->fixo_2   := ''
                empresa->endereco := ''
                empresa->numero   := ''
                empresa->complem  := ''
                empresa->bairro   := ''
                empresa->cidade   := ''
                empresa->uf       := ''
                empresa->cep      := ''
                empresa->email    := ''
                empresa->site     := ''
                empresa->(dbcommit())
                empresa->(dbunlock())
             endif
          endif
	       dbclosearea()
       endif

       * essas tabelas serão usadas somente localmente
       a_dbf := {}
       * temp para relatório de pizzas
	    if .not. file('tmprpza.dbf')
          aadd(a_dbf,{'produto','c',40,0})
          aadd(a_dbf,{'qtd','n',10,0})
          aadd(a_dbf,{'nome','c',40,0})
          dbcreate('tmprpza',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp para pizza
	    if .not. file('tmpza.dbf')
          aadd(a_dbf,{'id_produto','c',10,0})
          aadd(a_dbf,{'sequencia','c',10,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'tamanho','c',10,0})
          aadd(a_dbf,{'preco','n',10,2})
          dbcreate('tmpza',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp para produto
	    if .not. file('tmpprod.dbf')
          aadd(a_dbf,{'produto','c',10,0})
          aadd(a_dbf,{'nome','c',30,0})
          aadd(a_dbf,{'qtd','n',04,0})
          aadd(a_dbf,{'unitario','n',10,2})
          aadd(a_dbf,{'subtotal','n',12,2})
          dbcreate('tmpprod',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp para reajuste
	    if .not. file('tmpreaj.dbf')
          aadd(a_dbf,{'cod_prod','c',10,0})
          aadd(a_dbf,{'nom_prod','c',40,0})
          aadd(a_dbf,{'tam_001','n',10,2})
          aadd(a_dbf,{'tam_002','n',10,2})
          aadd(a_dbf,{'tam_003','n',10,2})
          aadd(a_dbf,{'tam_004','n',10,2})
          aadd(a_dbf,{'tam_005','n',10,2})
          aadd(a_dbf,{'tam_006','n',10,2})
          aadd(a_dbf,{'pre_reaj','n',10,2})
          aadd(a_dbf,{'id_cat','n',6,0})
          aadd(a_dbf,{'id_subcat','n',6,0})
          dbcreate('tmpreaj',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp para compras - produtos
	    if .not. file('tmpcpa1.dbf')
          aadd(a_dbf,{'id','c',10,0})
          aadd(a_dbf,{'fornecedor','n',06,0})
          aadd(a_dbf,{'forma_pag','n',06,0})
          aadd(a_dbf,{'num_parc','n',03,0})
          aadd(a_dbf,{'data_venc','d',08,0})
          aadd(a_dbf,{'dias_parc','n',03,0})
          aadd(a_dbf,{'produto','c',10,0})
          aadd(a_dbf,{'qtd','n',06,0})
          aadd(a_dbf,{'vlr_unit','n',12,2})
          aadd(a_dbf,{'num_doc','c',15,0})
          dbcreate('tmpcpa1',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp para compras - matéria prima
	    if .not. file('tmpcpa2.dbf')
          aadd(a_dbf,{'id','c',10,0})
          aadd(a_dbf,{'fornecedor','n',06,0})
          aadd(a_dbf,{'forma_pag','n',06,0})
          aadd(a_dbf,{'num_parc','n',03,0})
          aadd(a_dbf,{'data_venc','d',08,0})
          aadd(a_dbf,{'dias_parc','n',03,0})
          aadd(a_dbf,{'mat_prima','n',06,0})
          aadd(a_dbf,{'qtd','n',12,3})
          aadd(a_dbf,{'vlr_unit','n',12,2})
          aadd(a_dbf,{'num_doc','c',15,0})
          dbcreate('tmpcpa2',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp : taxas
	    if .not. file('tmp_txa.dbf')
          aadd(a_dbf,{'nome','c',40,0})
          aadd(a_dbf,{'qtd','n',6,0})
          aadd(a_dbf,{'valor','n',14,2})
          dbcreate('tmp_txa',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp : forma pagamento
	    if .not. file('tmp_fpg.dbf')
          aadd(a_dbf,{'nome','c',40,0})
          aadd(a_dbf,{'qtd','n',6,0})
          aadd(a_dbf,{'valor','n',14,2})
          dbcreate('tmp_fpg',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp : tipo venda
	    if .not. file('tmp_tipo.dbf')
          aadd(a_dbf,{'nome','c',40,0})
          aadd(a_dbf,{'qtd','n',6,0})
          aadd(a_dbf,{'valor','n',14,2})
          dbcreate('tmp_tipo',a_dbf)
          dbclosearea()
       endif
       a_dbf := {}
       * temp : diversos
	    if .not. file('tmp_tpr.dbf')
          aadd(a_dbf,{'nome','c',40,0})
          aadd(a_dbf,{'qtd','n',6,0})
          aadd(a_dbf,{'valor','n',14,2})
          aadd(a_dbf,{'tipo','n',2,0})
          dbcreate('tmp_tpr',a_dbf)
          dbclosearea()
       endif
       
       a_dbf := {}
       * temporario
	    if .not. file('tempro.dbf')
          aadd(a_dbf,{'produto','c',10,0})
          aadd(a_dbf,{'qtd','n',10,0})
		  aadd(a_dbf,{'descricao','c',20,0})
          aadd(a_dbf,{'pagamento','c',20,0})
          aadd(a_dbf,{'taxa_e','n',12,2})
          aadd(a_dbf,{'taxa_m','n',12,2})
          aadd(a_dbf,{'vtotal','n',12,2})
          dbcreate('tempro',a_dbf)
          dbclosearea()
		endif
       /*
       */
       a_dbf := {}
       * dbf igual ao temp para compras - produtos (rede)
	    if .not. file(path_dbf+'tcompra1.dbf')
          aadd(a_dbf,{'fornecedor','n',06,0})
          aadd(a_dbf,{'forma_pag','n',06,0})
          aadd(a_dbf,{'num_parc','n',03,0})
          aadd(a_dbf,{'data_venc','d',08,0})
          aadd(a_dbf,{'dias_parc','n',03,0})
          aadd(a_dbf,{'produto','c',10,0})
          aadd(a_dbf,{'qtd','n',06,0})
          aadd(a_dbf,{'vlr_unit','n',12,2})
          aadd(a_dbf,{'num_doc','c',15,0})
          dbcreate(path_dbf+'tcompra1',a_dbf)
          dbclosearea()
       endif

       a_dbf := {}
       * dbf igual ao temp para compras - matéria prima (rede)
	    if .not. file(path_dbf+'tcompra2.dbf')
          aadd(a_dbf,{'fornecedor','n',06,0})
          aadd(a_dbf,{'forma_pag','n',06,0})
          aadd(a_dbf,{'num_parc','n',03,0})
          aadd(a_dbf,{'data_venc','d',08,0})
          aadd(a_dbf,{'dias_parc','n',03,0})
          aadd(a_dbf,{'mat_prima','n',06,0})
          aadd(a_dbf,{'qtd','n',12,3})
          aadd(a_dbf,{'vlr_unit','n',12,2})
          aadd(a_dbf,{'num_doc','c',15,0})
          dbcreate(path_dbf+'tcompra2',a_dbf)
          dbclosearea()
       endif

       a_dbf := {}
       * tamanhos de pizza - pré definido
	    if .not. file(path_dbf+'tamanhos.dbf')
          aadd(a_dbf,{'nome','c',15,0})
          aadd(a_dbf,{'pedacos','n',02,0})
          dbcreate(path_dbf+'tamanhos',a_dbf)
          dbclosearea()
	       if open_dbf('tamanhos','tamanhos',.T.)
             if add_reg()
                tamanhos->nome    := ''
                tamanhos->pedacos := 0
	             tamanhos->(dbcommit())
	             tamanhos->(dbunlock())
             endif
             if add_reg()
                tamanhos->nome    := ''
                tamanhos->pedacos := 0
	             tamanhos->(dbcommit())
	             tamanhos->(dbunlock())
             endif
             if add_reg()
                tamanhos->nome    := ''
                tamanhos->pedacos := 0
	             tamanhos->(dbcommit())
	             tamanhos->(dbunlock())
             endif
             if add_reg()
                tamanhos->nome    := ''
                tamanhos->pedacos := 0
	             tamanhos->(dbcommit())
	             tamanhos->(dbunlock())
             endif
             if add_reg()
                tamanhos->nome    := ''
                tamanhos->pedacos := 0
	             tamanhos->(dbcommit())
	             tamanhos->(dbunlock())
             endif
             if add_reg()
                tamanhos->nome    := ''
                tamanhos->pedacos := 0
	             tamanhos->(dbcommit())
	             tamanhos->(dbunlock())
             endif
          endif
	       dbclosearea()
       endif

       a_dbf := {}
       * bordas de pizza - pré definido
	    if .not. file(path_dbf+'bordas.dbf')
          aadd(a_dbf,{'nome','c',15,0})
          aadd(a_dbf,{'preco','n',10,2})
          dbcreate(path_dbf+'bordas',a_dbf)
          dbclosearea()
	       if open_dbf('bordas','bordas',.T.)
             if add_reg()
                bordas->nome  := 'Sem borda'
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
             if add_reg()
                bordas->nome  := ''
                bordas->preco := 0
	            bordas->(dbcommit())
	            bordas->(dbunlock())
             endif
           endif
	       dbclosearea()
       endif

       a_dbf := {}
       * cobertura extra
	    if .not. file(path_dbf+'coberturas.dbf')
          aadd(a_dbf,{'nome','c',15,0})
          aadd(a_dbf,{'preco','n',10,2})
          dbcreate(path_dbf+'coberturas',a_dbf)
          dbclosearea()
	       if open_dbf('coberturas','coberturas',.T.)
             if add_reg()
                coberturas->nome  := 'S/Cobertura'
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
             if add_reg()
                coberturas->nome  := ''
                coberturas->preco := 0
	            coberturas->(dbcommit())
	            coberturas->(dbunlock())
             endif
           endif
	       dbclosearea()
       endif

       a_dbf := {}
       * códigos
	   if .not. file(path_dbf+'conta.dbf')
          aadd(a_dbf,{'c_clientes','n',06,0})
          aadd(a_dbf,{'c_fornec','n',06,0})
          aadd(a_dbf,{'c_gfornec','n',04,0})
          aadd(a_dbf,{'c_mprima','n',06,0})
          aadd(a_dbf,{'c_catprod','n',04,0})
          aadd(a_dbf,{'c_scatprod','n',04,0})
          aadd(a_dbf,{'c_mesas','n',04,0})
          aadd(a_dbf,{'c_balcao','n',04,0})
          aadd(a_dbf,{'c_delivery','n',04,0})
          aadd(a_dbf,{'c_frecebe','n',04,0})
          aadd(a_dbf,{'c_fpaga','n',04,0})
          aadd(a_dbf,{'c_umedida','n',04,0})
          aadd(a_dbf,{'c_bancos','n',04,0})
          aadd(a_dbf,{'c_impostos','n',04,0})
          aadd(a_dbf,{'c_atende','n',04,0})
          aadd(a_dbf,{'c_motent','n',04,0})
          aadd(a_dbf,{'c_operador','n',04,0})
          dbcreate(path_dbf+'conta',a_dbf)
          dbclosearea()
	       if open_dbf('conta','conta',.T.)
             if add_reg()
                conta->c_clientes := 1
                conta->c_fornec   := 1
                conta->c_gfornec  := 1
                conta->c_mprima   := 1
                conta->c_catprod  := 1
                conta->c_scatprod := 1
                conta->c_mesas    := 1
                conta->c_balcao   := 1
                conta->c_delivery := 1
                conta->c_frecebe  := 1
                conta->c_fpaga    := 1
                conta->c_umedida  := 1
                conta->c_bancos   := 1
                conta->c_impostos := 1
                conta->c_atende   := 1
                conta->c_motent   := 1
                conta->c_operador := 1
	             conta->(dbcommit())
	             conta->(dbunlock())
             endif
          endif
	       dbclosearea()
       endif

       a_dbf := {}
       * clientes
	   if .not. file(path_dbf+'clientes.dbf')
          aadd(a_dbf,{'codigo','n',06,0})
          aadd(a_dbf,{'nome','c',40,0})
          aadd(a_dbf,{'fixo','c',10,0})
          aadd(a_dbf,{'celular','c',10,0})
          aadd(a_dbf,{'endereco','c',40,0})
          aadd(a_dbf,{'numero','c',06,0})
          aadd(a_dbf,{'complem','c',20,0})
          aadd(a_dbf,{'bairro','c',20,0})
          aadd(a_dbf,{'cidade','c',20,0})
          aadd(a_dbf,{'uf','c',02,0})
          aadd(a_dbf,{'cep','c',08,0})
          aadd(a_dbf,{'email','c',50,0})
          aadd(a_dbf,{'aniv_dia','n',02,0})
          aadd(a_dbf,{'aniv_mes','n',02,0})
          aadd(a_dbf,{'pontoref','c',40,0})
          aadd(a_dbf,{'obs','c',40,0})
          aadd(a_dbf,{'taxa_ent','n',12,2})
          dbcreate(path_dbf+'clientes',a_dbf)
          dbclosearea()
          if open_dbf('clientes','clientes',.T.)
             if add_reg()
                clientes->codigo := 999999
                clientes->nome   := 'Cliente - venda mesa'
	             clientes->(dbcommit())
	             clientes->(dbunlock())
              endif
              dbclosearea()
          endif
       endif
       if .not. file(path_dbf+'clientes.cdx')
          if open_dbf('clientes','clientes',.F.)
             index on codigo tag codigo to (path_dbf)+'clientes.cdx'
             index on nome tag nome to (path_dbf)+'clientes.cdx'
             index on fixo tag fixo to (path_dbf)+'clientes.cdx'
             index on celular tag celular to (path_dbf)+'clientes.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * fornecedores
	    if .not. file(path_dbf+'fornec.dbf')
          aadd(a_dbf,{'codigo','n',06,0})
          aadd(a_dbf,{'nome','c',40,0})
          aadd(a_dbf,{'fixo','c',10,0})
          aadd(a_dbf,{'celular','c',10,0})
          aadd(a_dbf,{'endereco','c',40,0})
          aadd(a_dbf,{'numero','c',06,0})
          aadd(a_dbf,{'complem','c',20,0})
          aadd(a_dbf,{'bairro','c',20,0})
          aadd(a_dbf,{'cidade','c',20,0})
          aadd(a_dbf,{'uf','c',02,0})
          aadd(a_dbf,{'cep','c',08,0})
          aadd(a_dbf,{'email','c',50,0})
          aadd(a_dbf,{'grupo','n',04,0})
          dbcreate(path_dbf+'fornec',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'fornec.cdx')
          if open_dbf('fornec','fornecedores',.F.)
             index on codigo tag codigo to (path_dbf)+'fornec.cdx'
             index on nome tag nome to (path_dbf)+'fornec.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * grupo de fornecedores
	    if .not. file(path_dbf+'gfornec.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          dbcreate(path_dbf+'gfornec',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'gfornec.cdx')
          if open_dbf('gfornec','grupo_fornecedores',.F.)
             index on codigo tag codigo to (path_dbf)+'gfornec.cdx'
             index on nome tag nome to (path_dbf)+'gfornec.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * matéria prima
	    if .not. file(path_dbf+'mprima.dbf')
          aadd(a_dbf,{'codigo','n',06,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'unidade','n',04,0})
          aadd(a_dbf,{'preco','n',10,2})
          aadd(a_dbf,{'qtd','n',12,3})
          dbcreate(path_dbf+'mprima',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'mprima.cdx')
          if open_dbf('mprima','materia_prima',.F.)
             index on codigo tag codigo to (path_dbf)+'mprima.cdx'
             index on nome tag nome to (path_dbf)+'mprima.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * vendas
	   if .not. file(path_dbf+'vendas.dbf')
          aadd(a_dbf,{'id_venda','c',30,0})
          aadd(a_dbf,{'tipo','n',01,0})
          aadd(a_dbf,{'id_cliente','n',06,0})
          aadd(a_dbf,{'nome_cli','c',40,0})
          aadd(a_dbf,{'telefone','c',20,0})
          aadd(a_dbf,{'tamanho','n',02,0})
          aadd(a_dbf,{'borda','n',02,0})

          aadd(a_dbf,{'cobertura','n',02,0})

          aadd(a_dbf,{'obs_pizza','c',40,0})
          aadd(a_dbf,{'id_prod','c',10,0})
          aadd(a_dbf,{'nome_prod','c',40,0})
          aadd(a_dbf,{'qtd_prod','n',04,0})
          aadd(a_dbf,{'data_venda','d',08,0})
          aadd(a_dbf,{'hora_venda','c',10,0})
          aadd(a_dbf,{'vlr_unit','n',14,2})
          aadd(a_dbf,{'vlr_subt','n',14,2})
          aadd(a_dbf,{'id_usu','n',04,0})
          aadd(a_dbf,{'nome_usu','c',20,0})
          dbcreate(path_dbf+'vendas',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'vendas.cdx')
          if open_dbf('vendas','vendas',.F.)
             index on id_venda tag id_venda to (path_dbf)+'vendas.cdx'
             index on dtos(data_venda) tag data to (path_dbf)+'vendas.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * categoria de produtos
	    if .not. file(path_dbf+'catprod.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          dbcreate(path_dbf+'catprod',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'catprod.cdx')
          if open_dbf('catprod','categoria_produtos',.F.)
             index on codigo tag codigo to (path_dbf)+'catprod.cdx'
             index on nome tag nome to (path_dbf)+'catprod.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * sub-categoria de produtos
	    if .not. file(path_dbf+'scatprod.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          dbcreate(path_dbf+'scatprod',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'scatprod.cdx')
          if open_dbf('scatprod','subcategoria_produtos',.F.)
             index on codigo tag codigo to (path_dbf)+'scatprod.cdx'
             index on nome tag nome to (path_dbf)+'scatprod.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * mesas
	   if .not. file(path_dbf+'mesas.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'id','c',18,0})
          aadd(a_dbf,{'hora','c',10,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'situacao','c',1,0})
          aadd(a_dbf,{'total','n',14,2})
          aadd(a_dbf,{'usuario','c',20,0})
          dbcreate(path_dbf+'mesas',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'mesas.cdx')
          if open_dbf('mesas','mesas',.F.)
             index on codigo tag codigo to (path_dbf)+'mesas.cdx'
             index on nome tag nome to (path_dbf)+'mesas.cdx'
             index on id tag id to (path_dbf)+'mesas.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * balcão
	   if .not. file(path_dbf+'balcao.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'id','c',18,0})
          aadd(a_dbf,{'hora','c',10,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'situacao','c',1,0})
          aadd(a_dbf,{'total','n',14,2})
          aadd(a_dbf,{'usuario','c',20,0})
          dbcreate(path_dbf+'balcao',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'balcao.cdx')
          if open_dbf('balcao','balcao',.F.)
             index on codigo tag codigo to (path_dbf)+'balcao.cdx'
             index on nome tag nome to (path_dbf)+'balcao.cdx'
             index on id tag id to (path_dbf)+'balcao.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * delivery
	   if .not. file(path_dbf+'delivery.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'id','c',18,0})
          aadd(a_dbf,{'hora','c',10,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'situacao','c',1,0})
          aadd(a_dbf,{'total','n',14,2})
          aadd(a_dbf,{'usuario','c',20,0})
          dbcreate(path_dbf+'delivery',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'delivery.cdx')
          if open_dbf('delivery','delivery',.F.)
             index on codigo tag codigo to (path_dbf)+'delivery.cdx'
             index on nome tag nome to (path_dbf)+'delivery.cdx'
             index on id tag id to (path_dbf)+'delivery.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * formas de recebimento
	    if .not. file(path_dbf+'frecebe.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'banco','n',04,0})
          aadd(a_dbf,{'dias_receb','n',02,0})
          dbcreate(path_dbf+'frecebe',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'frecebe.cdx')
          if open_dbf('frecebe','formas_recebimento',.F.)
             index on codigo tag codigo to (path_dbf)+'frecebe.cdx'
             index on nome tag nome to (path_dbf)+'frecebe.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * formas de pagamento
	    if .not. file(path_dbf+'fpaga.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'banco','n',04,0})
          aadd(a_dbf,{'dias_paga','n',02,0})
          dbcreate(path_dbf+'fpaga',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'fpaga.cdx')
          if open_dbf('fpaga','formas_pagamento',.F.)
             index on codigo tag codigo to (path_dbf)+'fpaga.cdx'
             index on nome tag nome to (path_dbf)+'fpaga.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * unidades de medida
	    if .not. file(path_dbf+'umedida.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',10,0})
          dbcreate(path_dbf+'umedida',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'umedida.cdx')
          if open_dbf('umedida','unidade_medida',.F.)
             index on codigo tag codigo to (path_dbf)+'umedida.cdx'
             index on nome tag nome to (path_dbf)+'umedida.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * contas bancárias
	    if .not. file(path_dbf+'bancos.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'banco','c',10,0})
          aadd(a_dbf,{'agencia','c',10,0})
          aadd(a_dbf,{'conta_c','c',10,0})
          aadd(a_dbf,{'limite','n',12,2})
          aadd(a_dbf,{'titular','c',20,0})
          aadd(a_dbf,{'gerente','c',20,0})
          aadd(a_dbf,{'telefone','c',10,0})
          dbcreate(path_dbf+'bancos',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'bancos.cdx')
          if open_dbf('bancos','bancos',.F.)
             index on codigo tag codigo to (path_dbf)+'bancos.cdx'
             index on nome tag nome to (path_dbf)+'bancos.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * impostos e alíquotas
	    if .not. file(path_dbf+'impostos.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'aliquota','n',10,2})
          dbcreate(path_dbf+'impostos',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'impostos.cdx')
          if open_dbf('impostos','impostos',.F.)
             index on codigo tag codigo to (path_dbf)+'impostos.cdx'
             index on nome tag nome to (path_dbf)+'impostos.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * atendentes
	    if .not. file(path_dbf+'atende.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'comissao','n',10,2})
          dbcreate(path_dbf+'atende',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'atende.cdx')
          if open_dbf('atende','atendentes',.F.)
             index on codigo tag codigo to (path_dbf)+'atende.cdx'
             index on nome tag nome to (path_dbf)+'atende.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * motoboys ou entregadores
	    if .not. file(path_dbf+'motent.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'comissao','n',10,2})
          aadd(a_dbf,{'diaria','n',10,2})
          aadd(a_dbf,{'fixo','c',10,0})
          aadd(a_dbf,{'celular','c',10,0})
          aadd(a_dbf,{'endereco','c',40,0})
          aadd(a_dbf,{'numero','c',10,0})
          aadd(a_dbf,{'complem','c',20,0})
          aadd(a_dbf,{'bairro','c',20,0})
          aadd(a_dbf,{'cidade','c',20,0})
          aadd(a_dbf,{'uf','c',02,0})
          aadd(a_dbf,{'cep','c',08,0})
          aadd(a_dbf,{'email','c',40,0})
          dbcreate(path_dbf+'motent',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'motent.cdx')
          if open_dbf('motent','motoboys',.F.)
             index on codigo tag codigo to (path_dbf)+'motent.cdx'
             index on nome tag nome to (path_dbf)+'motent.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * temporario
	    if .not. file(path_dbf+'tempro.dbf')
          aadd(a_dbf,{'produto','c',10,0})
          aadd(a_dbf,{'qtd','n',10,0})
		  aadd(a_dbf,{'descricao','c',20,0})
          aadd(a_dbf,{'pagamento','c',20,0})
          aadd(a_dbf,{'taxa_e','n',12,2})
          aadd(a_dbf,{'taxa_m','n',12,2})
          aadd(a_dbf,{'vtotal','n',12,2})
          dbcreate(path_dbf+'tempro',a_dbf)
          dbclosearea()
		endif
        if .not. file(path_dbf+'tempro.cdx')
           if open_dbf('tempro','temp_curva',.F.)
              index on produto tag produto to (path_dbf)+'tempro.cdx'
              index on qtd tag xquant descend to (path_dbf)+'tempro.cdx'
           endif
           dbclosearea()
        endif

       a_dbf := {}
       * operadores do programa
	    if .not. file(path_dbf+'operador.dbf')
          aadd(a_dbf,{'codigo','n',04,0})
          aadd(a_dbf,{'nome','c',10,0})
          aadd(a_dbf,{'senha','c',10,0})
          dbcreate(path_dbf+'operador',a_dbf)
          dbclosearea()
          if open_dbf('operador','operadores',.T.)
             if add_reg()
                operadores->codigo := 9999
                operadores->nome   := 'SChef'
                operadores->senha  := '9999'
	             operadores->(dbcommit())
	             operadores->(dbunlock())
              endif
              dbclosearea()
          endif
       endif
       if .not. file(path_dbf+'operador.cdx')
          if open_dbf('operador','operadores',.F.)
             index on codigo tag codigo to (path_dbf)+'operador.cdx'
             index on nome tag nome to (path_dbf)+'operador.cdx'
             index on senha tag senha to (path_dbf)+'operador.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * definir acesso aos operadores do programa
	    if .not. file(path_dbf+'libusu.dbf')
          aadd(a_dbf,{'operador','n',04,0})   //id do operador
          aadd(a_dbf,{'acesso_001','l',01,0}) //venda delivery
          aadd(a_dbf,{'acesso_002','l',01,0}) //venda mesas
          aadd(a_dbf,{'acesso_003','l',01,0}) //venda balcão
          aadd(a_dbf,{'acesso_004','l',01,0}) //clientes
          aadd(a_dbf,{'acesso_005','l',01,0}) //produtos
          
          aadd(a_dbf,{'acesso_006','l',01,0}) //fornecedores
          aadd(a_dbf,{'acesso_007','l',01,0}) //grupo de fornecedores
          aadd(a_dbf,{'acesso_008','l',01,0}) //matéria prima
          aadd(a_dbf,{'acesso_009','l',01,0}) //categorias de produtos
          aadd(a_dbf,{'acesso_010','l',01,0}) //sub-categoria de produtos
          aadd(a_dbf,{'acesso_011','l',01,0}) //formas de recebimento
          aadd(a_dbf,{'acesso_012','l',01,0}) //formas de pagamento
          aadd(a_dbf,{'acesso_013','l',01,0}) //unidades de medida
          aadd(a_dbf,{'acesso_014','l',01,0}) //contas bancárias
          aadd(a_dbf,{'acesso_015','l',01,0}) //impostos e alíquotas
          aadd(a_dbf,{'acesso_016','l',01,0}) //mesas da pizzaria
          aadd(a_dbf,{'acesso_017','l',01,0}) //atendentes ou garçons
          aadd(a_dbf,{'acesso_018','l',01,0}) //motoboys ou entregadores
          aadd(a_dbf,{'acesso_019','l',01,0}) //operadores do programa
          
          aadd(a_dbf,{'acesso_020','l',01,0}) //fechamento do dia de trabalho
          aadd(a_dbf,{'acesso_021','l',01,0}) //movimentação do caixa
          aadd(a_dbf,{'acesso_022','l',01,0}) //movimentação bancária
          aadd(a_dbf,{'acesso_023','l',01,0}) //contas a pagar por período
          aadd(a_dbf,{'acesso_024','l',01,0}) //contas a pagar por fornecedor
          aadd(a_dbf,{'acesso_025','l',01,0}) //contas a receber por período
          aadd(a_dbf,{'acesso_026','l',01,0}) //contas a receber por cliente
          aadd(a_dbf,{'acesso_027','l',01,0}) //pizzas mais vendidas
          aadd(a_dbf,{'acesso_028','l',01,0}) //produtos mais vendidos
          aadd(a_dbf,{'acesso_029','l',01,0}) //relação estoque mínimo
          aadd(a_dbf,{'acesso_030','l',01,0}) //posição do estoque (produtos)
          aadd(a_dbf,{'acesso_031','l',01,0}) //posição do estoque (matéria prima)
          aadd(a_dbf,{'acesso_032','l',01,0}) //comissão motoboys/entregadores
          aadd(a_dbf,{'acesso_033','l',01,0}) //comissão atendentes/garçons
          
          aadd(a_dbf,{'acesso_034','l',01,0}) //movimentação do caixa
          aadd(a_dbf,{'acesso_035','l',01,0}) //movimentação bancária
          aadd(a_dbf,{'acesso_036','l',01,0}) //compras / entrada estoque
          aadd(a_dbf,{'acesso_037','l',01,0}) //contas a pagar
          aadd(a_dbf,{'acesso_038','l',01,0}) //contas a receber
          
          aadd(a_dbf,{'acesso_039','l',01,0}) //tamanhos de pizza
          aadd(a_dbf,{'acesso_040','l',01,0}) //cadastro da pizzaria
          aadd(a_dbf,{'acesso_041','l',01,0}) //incluir ou excluir promoção
          aadd(a_dbf,{'acesso_042','l',01,0}) //reajustar preços de produtos
          aadd(a_dbf,{'acesso_043','l',01,0}) //backup do banco de dados
          aadd(a_dbf,{'acesso_044','l',01,0})
          aadd(a_dbf,{'acesso_045','l',01,0})
          aadd(a_dbf,{'acesso_046','l',01,0})
          aadd(a_dbf,{'acesso_047','l',01,0})
          aadd(a_dbf,{'acesso_048','l',01,0})
          aadd(a_dbf,{'acesso_049','l',01,0})
          aadd(a_dbf,{'acesso_050','l',01,0})
          aadd(a_dbf,{'acesso_051','l',01,0})
          aadd(a_dbf,{'acesso_052','l',01,0})
          aadd(a_dbf,{'acesso_053','l',01,0})
          aadd(a_dbf,{'acesso_054','l',01,0})
          aadd(a_dbf,{'acesso_055','l',01,0})
          aadd(a_dbf,{'acesso_056','l',01,0})
          aadd(a_dbf,{'acesso_057','l',01,0})
          aadd(a_dbf,{'acesso_058','l',01,0})
          aadd(a_dbf,{'acesso_059','l',01,0})
          aadd(a_dbf,{'acesso_060','l',01,0})
          aadd(a_dbf,{'acesso_061','l',01,0})
          aadd(a_dbf,{'acesso_062','l',01,0})
          aadd(a_dbf,{'acesso_063','l',01,0})
          aadd(a_dbf,{'acesso_064','l',01,0})
          aadd(a_dbf,{'acesso_065','l',01,0})
          aadd(a_dbf,{'acesso_066','l',01,0})
          aadd(a_dbf,{'acesso_067','l',01,0})
          aadd(a_dbf,{'acesso_068','l',01,0})
          aadd(a_dbf,{'acesso_069','l',01,0})
          aadd(a_dbf,{'acesso_070','l',01,0})
          aadd(a_dbf,{'acesso_071','l',01,0})
          aadd(a_dbf,{'acesso_072','l',01,0})
          aadd(a_dbf,{'acesso_073','l',01,0})
          aadd(a_dbf,{'acesso_074','l',01,0})
          aadd(a_dbf,{'acesso_075','l',01,0})
          aadd(a_dbf,{'acesso_076','l',01,0})
          aadd(a_dbf,{'acesso_077','l',01,0})
          aadd(a_dbf,{'acesso_078','l',01,0})
          aadd(a_dbf,{'acesso_079','l',01,0})
          aadd(a_dbf,{'acesso_080','l',01,0})
          aadd(a_dbf,{'acesso_081','l',01,0})
          aadd(a_dbf,{'acesso_082','l',01,0})
          aadd(a_dbf,{'acesso_083','l',01,0})
          aadd(a_dbf,{'acesso_084','l',01,0})
          aadd(a_dbf,{'acesso_085','l',01,0})
          aadd(a_dbf,{'acesso_086','l',01,0})
          aadd(a_dbf,{'acesso_087','l',01,0})
          aadd(a_dbf,{'acesso_088','l',01,0})
          aadd(a_dbf,{'acesso_089','l',01,0})
          aadd(a_dbf,{'acesso_090','l',01,0})
          aadd(a_dbf,{'acesso_091','l',01,0})
          aadd(a_dbf,{'acesso_092','l',01,0})
          aadd(a_dbf,{'acesso_093','l',01,0})
          aadd(a_dbf,{'acesso_094','l',01,0})
          aadd(a_dbf,{'acesso_095','l',01,0})
          aadd(a_dbf,{'acesso_096','l',01,0})
          aadd(a_dbf,{'acesso_097','l',01,0})
          aadd(a_dbf,{'acesso_098','l',01,0})
          aadd(a_dbf,{'acesso_099','l',01,0})
          aadd(a_dbf,{'acesso_100','l',01,0})
          dbcreate(path_dbf+'libusu',a_dbf)
          dbclosearea()
          if open_dbf('libusu','acesso',.T.)
             if add_reg()
                acesso->operador   := 9999
                acesso->acesso_019 := .T.
	             acesso->(dbcommit())
	             acesso->(dbunlock())
              endif
              dbclosearea()
          endif
       endif
       if .not. file(path_dbf+'libusu.cdx')
          if open_dbf('libusu','acesso',.F.)
             index on operador tag operador to (path_dbf)+'libusu.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * produtos
	    if .not. file(path_dbf+'produtos.dbf')
          aadd(a_dbf,{'codigo','c',10,0})
          aadd(a_dbf,{'cbarra','c',15,0})
          aadd(a_dbf,{'nome_longo','c',40,0})
          aadd(a_dbf,{'nome_cupom','c',15,0})
          aadd(a_dbf,{'categoria','n',04,0})
          aadd(a_dbf,{'scategoria','n',04,0})
          aadd(a_dbf,{'imposto','n',04,0})
          aadd(a_dbf,{'baixa','l',01,0})
          aadd(a_dbf,{'qtd_estoq','n',06,0})
          aadd(a_dbf,{'qtd_min','n',06,0})
          aadd(a_dbf,{'qtd_max','n',06,0})
          aadd(a_dbf,{'vlr_custo','n',12,2})
          aadd(a_dbf,{'vlr_venda','n',12,2})
          aadd(a_dbf,{'promocao','l',01,0})
          aadd(a_dbf,{'pizza','l',01,0})
          aadd(a_dbf,{'val_tm_001','n',10,2})
          aadd(a_dbf,{'val_tm_002','n',10,2})
          aadd(a_dbf,{'val_tm_003','n',10,2})
          aadd(a_dbf,{'val_tm_004','n',10,2})
          aadd(a_dbf,{'val_tm_005','n',10,2})
          aadd(a_dbf,{'val_tm_006','n',10,2})
          aadd(a_dbf,{'seq_imp','n',2,0})
          dbcreate(path_dbf+'produtos',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'produtos.cdx')
          if open_dbf('produtos','produtos',.F.)
             index on codigo tag codigo to (path_dbf)+'produtos.cdx'
             index on cbarra tag cbarra to (path_dbf)+'produtos.cdx'
             index on nome_longo tag nome_longo to (path_dbf)+'produtos.cdx'
             index on nome_longo tag nomelongos to (path_dbf)+'produtos.cdx' for pizza = .F.
             index on nome_cupom tag nome_cupom to (path_dbf)+'produtos.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * ultimas compras do cliente
	    if .not. file(path_dbf+'cli_uc.dbf')
          aadd(a_dbf,{'id_cliente','n',06,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'hora','c',08,0})
          aadd(a_dbf,{'onde','n',01,0})
          aadd(a_dbf,{'valor','n',12,2})
          dbcreate(path_dbf+'cli_uc',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'cli_uc.cdx')
          if open_dbf('cli_uc','ultimas_compras',.F.)
             index on id_cliente tag id_cliente to (path_dbf)+'cli_uc.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * detalhamento - ultimas compras do cliente
	    if .not. file(path_dbf+'cli_dc.dbf')
          aadd(a_dbf,{'id_cliente','n',06,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'hora','c',08,0})
          aadd(a_dbf,{'id_prod','c',10,0})
          aadd(a_dbf,{'qtd','n',06,0})
          aadd(a_dbf,{'unitario','n',10,2})
          aadd(a_dbf,{'subtotal','n',12,2})
          dbcreate(path_dbf+'cli_dc',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'cli_dc.cdx')
          if open_dbf('cli_dc','detalhamento_compras',.F.)
             index on str(id_cliente,6)+dtos(data)+hora tag id to (path_dbf)+'cli_dc.cdx'
             index on dtos(data) tag data to (path_dbf)+'cli_dc.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * caixa
	   if .not. file(path_dbf+'ccaixa.dbf')
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'hora','c',08,0})
          aadd(a_dbf,{'valor','n',14,2})
          aadd(a_dbf,{'situacao','C',01,0})
          aadd(a_dbf,{'ncaixa','c',4,0})
          dbcreate(path_dbf+'ccaixa',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'ccaixa.cdx')
          if open_dbf('ccaixa','ccaixa',.F.)
             index on dtos(data) tag data to (path_dbf)+'ccaixa.cdx'
             index on ncaixa+dtos(data) tag nccaixa to (path_dbf)+'ccaixa.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * composição de produto
	    if .not. file(path_dbf+'prodcomp.dbf')
          aadd(a_dbf,{'id_produto','c',10,0})
          aadd(a_dbf,{'id_mprima','n',06,0})
          aadd(a_dbf,{'quantidade','n',12,3})
          dbcreate(path_dbf+'prodcomp',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'prodcomp.cdx')
          if open_dbf('prodcomp','produto_composto',.F.)
             index on id_produto tag id_produto to (path_dbf)+'prodcomp.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * caixa
	    if .not. file(path_dbf+'caixa.dbf')
          aadd(a_dbf,{'id','c',10,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'historico','c',30,0})
          aadd(a_dbf,{'entrada','n',12,2})
          aadd(a_dbf,{'saida','n',12,2})
          dbcreate(path_dbf+'caixa',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'caixa.cdx')
          if open_dbf('caixa','caixa',.F.)
             index on id tag id to (path_dbf)+'caixa.cdx'
             index on dtos(data) tag data to (path_dbf)+'caixa.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * movimento bancário
	    if .not. file(path_dbf+'movban.dbf')
          aadd(a_dbf,{'id','c',10,0})
          aadd(a_dbf,{'banco','n',04,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'historico','c',30,0})
          aadd(a_dbf,{'entrada','n',12,2})
          aadd(a_dbf,{'saida','n',12,2})
          dbcreate(path_dbf+'movban',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'movban.cdx')
          if open_dbf('movban','movimento_bancario',.F.)
             index on id tag id to (path_dbf)+'movban.cdx'
             index on dtos(data) tag data to (path_dbf)+'movban.cdx'
             index on str(banco,4)+dtos(data) tag composto to (path_dbf)+'movban.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * contas a pagar
	    if .not. file(path_dbf+'cpag.dbf')
          aadd(a_dbf,{'id','c',10,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'valor','n',12,2})
          aadd(a_dbf,{'forma','n',06,0})
          aadd(a_dbf,{'fornec','n',06,0})
          aadd(a_dbf,{'numero','c',15,0})
          aadd(a_dbf,{'obs','c',30,0})
          aadd(a_dbf,{'baixa','l',01,0})
          dbcreate(path_dbf+'cpag',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'cpag.cdx')
          if open_dbf('cpag','contas_pagar',.F.)
             index on id tag id to (path_dbf)+'cpag.cdx'
             index on dtos(data) tag data to (path_dbf)+'cpag.cdx'
             index on str(fornec,6)+dtos(data) tag composto to (path_dbf)+'cpag.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * contas a receber
	    if .not. file(path_dbf+'crec.dbf')
          aadd(a_dbf,{'id','c',10,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'valor','n',12,2})
          aadd(a_dbf,{'forma','n',06,0})
          aadd(a_dbf,{'cliente','n',06,0})
          aadd(a_dbf,{'numero','c',15,0})
          aadd(a_dbf,{'obs','c',30,0})
          aadd(a_dbf,{'baixa','l',01,0})
          dbcreate(path_dbf+'crec',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'crec.cdx')
          if open_dbf('crec','contas_receber',.F.)
             index on id tag id to (path_dbf)+'crec.cdx'
             index on dtos(data) tag data to (path_dbf)+'crec.cdx'
             index on str(cliente,6)+dtos(data) tag composto to (path_dbf)+'crec.cdx'
          endif
          dbclosearea()
       endif

       a_dbf := {}
       * comissões dos motoboys
	    if .not. file(path_dbf+'comissao.dbf')
          aadd(a_dbf,{'id','n',04,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'hora','c',08,0})
          aadd(a_dbf,{'valor','n',12,2})
          dbcreate(path_dbf+'comissao',a_dbf)
          dbclosearea()
       endif

       a_dbf := {}
       * comissões de atendentes/garçons
	    if .not. file(path_dbf+'com_mesa.dbf')
          aadd(a_dbf,{'id','n',04,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'hora','c',08,0})
          aadd(a_dbf,{'valor','n',12,2})
          dbcreate(path_dbf+'com_mesa',a_dbf)
          dbclosearea()
       endif

       a_dbf := {}
       * entregas
	    if .not. file(path_dbf+'entrega.dbf')
          aadd(a_dbf,{'cliente','c',30,0})
          aadd(a_dbf,{'endereco','c',30,0})
          aadd(a_dbf,{'hora','c',08,0})
          aadd(a_dbf,{'origem','c',10,0})
          aadd(a_dbf,{'telefone','c',10,0})
          aadd(a_dbf,{'cod_moto','n',04,0})
          aadd(a_dbf,{'motoboy','c',15,0})
          aadd(a_dbf,{'situacao','c',15,0})
          aadd(a_dbf,{'vlr_taxa','n',10,2})
          dbcreate(path_dbf+'entrega',a_dbf)
          dbclosearea()
       endif

       *----------
       
       a_dbf := {}
       * temp para pizza - em rede - compartilhado - venda mesas
	    if .not. file(path_dbf+'tmp_pza.dbf')
          aadd(a_dbf,{'id_mesa','c',18,0})
          aadd(a_dbf,{'id_produto','c',10,0})
          aadd(a_dbf,{'sequencia','c',10,0})
          aadd(a_dbf,{'nome','c',20,0})
          aadd(a_dbf,{'tamanho','c',10,0})
          aadd(a_dbf,{'preco','n',10,2})
          dbcreate(path_dbf+'tmp_pza',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'tmp_pza.cdx')
          if open_dbf('tmp_pza','temp_pizzas',.F.)
             index on id_mesa tag id to (path_dbf)+'tmp_pza.cdx'
          endif
          dbclosearea()
       endif
       *----
       a_dbf := {}
       * temp para pizzas e produtos na venda delivery
	    if .not. file(path_dbf+'tmp_vda.dbf')
          aadd(a_dbf,{'seq','n',10,0})
          aadd(a_dbf,{'id','c',15,0})
          aadd(a_dbf,{'tipo','n',1,0})
          aadd(a_dbf,{'produto','c',10,0})
          aadd(a_dbf,{'preco','n',10,2})
          aadd(a_dbf,{'sequencia','c',10,0})
          aadd(a_dbf,{'nome','c',60,0})
          aadd(a_dbf,{'qtd','n',04,0})
          aadd(a_dbf,{'unitario','n',10,2})
          aadd(a_dbf,{'subtotal','n',12,2})
          aadd(a_dbf,{'tamanho','c',20,0})
          aadd(a_dbf,{'id_venda','c',30,0})
          aadd(a_dbf,{'tipo_venda','n',01,0})
          aadd(a_dbf,{'nome_bal','c',30,0})
          aadd(a_dbf,{'telefone','c',12,0})
          aadd(a_dbf,{'nome_cli','c',40,0})
          aadd(a_dbf,{'end_1','c',40,0})
          aadd(a_dbf,{'end_2','c',40,0})
          aadd(a_dbf,{'end_3','c',40,0})
          aadd(a_dbf,{'data','d',08,0})
          aadd(a_dbf,{'hora','c',10,0})
          aadd(a_dbf,{'descricao','c',20,0})
          aadd(a_dbf,{'fechado','n',01,0})
          aadd(a_dbf,{'f_pagam','c',20,0})
          aadd(a_dbf,{'taxa_deliv','n',12,2})
          aadd(a_dbf,{'taxa_mesa','n',12,2})
          aadd(a_dbf,{'qtd_p','n',06,0})
          aadd(a_dbf,{'vlr_p','n',12,2})
          aadd(a_dbf,{'ncaixa','c',4,0})
          dbcreate(path_dbf+'tmp_vda',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'tmp_vda.cdx')
          if open_dbf('tmp_vda','temp_vendas',.F.)
             index on seq tag seq to (path_dbf)+'tmp_vda.cdx'
             index on id tag id to (path_dbf)+'tmp_vda.cdx'
             index on id_venda tag id_venda to (path_dbf)+'tmp_vda.cdx'
             index on dtos(data)+id_venda tag data to (path_dbf)+'tmp_vda.cdx'
             index on dtos(data)+id tag data_2 to (path_dbf)+'tmp_vda.cdx'
			 index on produto tag produtos to (path_dbf)+'tmp_vda.cdx'
             index on ncaixa tag nccaixa_venda to (path_dbf)+'tmp_vda.cdx'
          endif
          dbclosearea()
       endif
       *----
       a_dbf := {}
       * temp para mostrar os itens vendidos de uma forma mais amigável na tela de vendas
	    if .not. file(path_dbf+'tmp_tela.dbf')
          aadd(a_dbf,{'seq','n',10,0})
          aadd(a_dbf,{'item','c',40,0})
          aadd(a_dbf,{'qtd','n',6,0})
          aadd(a_dbf,{'unitario','n',10,2})
          aadd(a_dbf,{'subtotal','n',12,2})
          dbcreate(path_dbf+'tmp_tela',a_dbf)
          dbclosearea()
       endif
       *----
       a_dbf := {}
       * temp para classificar valor de pizza
	    if .not. file(path_dbf+'tmp_cpz.dbf')
          aadd(a_dbf,{'preco','n',10,2})
          dbcreate(path_dbf+'tmp_cpz',a_dbf)
          dbclosearea()
       endif
       *----
       a_dbf := {}
       * temp para produto - em rede - compartilhado - venda mesas
	    if .not. file(path_dbf+'tmp_prd.dbf')
          aadd(a_dbf,{'id_mesa','c',18,0})
          aadd(a_dbf,{'produto','c',10,0})
          aadd(a_dbf,{'nome','c',30,0})
          aadd(a_dbf,{'qtd','n',04,0})
          aadd(a_dbf,{'unitario','n',10,2})
          aadd(a_dbf,{'subtotal','n',12,2})
          dbcreate(path_dbf+'tmp_prd',a_dbf)
          dbclosearea()
       endif
       if .not. file(path_dbf+'tmp_prd.cdx')
          if open_dbf('tmp_prd','temp_produtos',.F.)
             index on id_mesa tag id to (path_dbf)+'tmp_prd.cdx'
          endif
          dbclosearea()
       endif
       *----
       a_dbf := {}
       * temp para montagem das pizzas
	    if .not. file(path_dbf+'montagem.dbf')
          aadd(a_dbf,{'id','c',10,0})
          aadd(a_dbf,{'nome','c',30,0})
          aadd(a_dbf,{'tamanho','c',20,0})
          aadd(a_dbf,{'id_venda','c',30,0})
          aadd(a_dbf,{'tipo_venda','n',01,0})
          aadd(a_dbf,{'nome_bal','c',30,0})
          aadd(a_dbf,{'telefone','c',12,0})
          aadd(a_dbf,{'nome_cli','c',40,0})
          aadd(a_dbf,{'end_1','c',40,0})
          aadd(a_dbf,{'end_2','c',40,0})
          aadd(a_dbf,{'end_3','c',40,0})
          dbcreate(path_dbf+'montagem',a_dbf)
          dbclosearea()
       endif
       *----
       a_dbf := {}
       * config para determinar como será cobrança do preço da pizza
	    if .not. file(path_dbf+'config.dbf')
          aadd(a_dbf,{'tipo','n',1,0})
          dbcreate(path_dbf+'config',a_dbf)
          dbclosearea()
          if open_dbf('config','config',.T.)
             if add_reg()
                config->tipo := 1
             	config->(dbcommit())
             	config->(dbunlock())
              endif
              dbclosearea()
          endif
       endif


       *----
       
       open_dbf_cdx()

       dbselectarea('empresa')
       empresa->(dbgotop())
       *setproperty('form_main','nome_cliente_001','value',substr(empresa->nome,1,30))

       dbselectarea('config')
       config->(dbgotop())
       _tipo_cobranca := config->tipo

       dbselectarea('tamanhos')
       tamanhos->(dbgotop())
       _tamanho_001 := tamanhos->nome
       _pedaco_001  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_002 := tamanhos->nome
       _pedaco_002  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_003 := tamanhos->nome
       _pedaco_003  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_004 := tamanhos->nome
       _pedaco_004  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_005 := tamanhos->nome
       _pedaco_005  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_006 := tamanhos->nome
       _pedaco_006  := tamanhos->pedacos
       
       aadd(a_tamanho_da_pizza,_tamanho_001)
       aadd(a_tamanho_da_pizza,_tamanho_002)
       aadd(a_tamanho_da_pizza,_tamanho_003)
       aadd(a_tamanho_da_pizza,_tamanho_004)
       aadd(a_tamanho_da_pizza,_tamanho_005)
       aadd(a_tamanho_da_pizza,_tamanho_006)

       return(nil)
*-------------------------------------------------------------------------------
static function open_dbf_cdx()

       use tmprpza alias tmp_pizza_relatorio exclusive new
       use tmpza   alias tmp_pizza exclusive new
       use tmpprod alias tmp_produto exclusive new
       use tmpreaj alias tmp_reajuste exclusive new
       use tmpcpa1 alias tmp_cpa1 exclusive new
       use tmpcpa2 alias tmp_cpa2 exclusive new
       use tmp_txa alias tmp_txa exclusive new
       use tmp_fpg alias tmp_fpg exclusive new
       use tmp_tipo alias tmp_tipo exclusive new
       use tmp_tpr alias tmp_tpr exclusive new
*	   use tempro alias temp_curva exclusive new

       if open_dbf('config','config',.F.)
       endif
       if open_dbf('tmp_tela','tmp_tela',.F.)
       endif
       if open_dbf('tmp_vda','temp_vendas',.F.)
       endif
       if open_dbf('tmp_cpz','temp_cpz',.F.)
       endif
       if open_dbf('montagem','montagem',.F.)
       endif
       if open_dbf('entrega','entrega',.F.)
       endif
       if open_dbf('comissao','comissao',.T.)
       endif
       if open_dbf('com_mesa','comissao_mesa',.T.)
       endif
       if open_dbf('tcompra1','tcompra1',.T.)
       endif
       if open_dbf('tcompra2','tcompra2',.T.)
       endif
       if open_dbf('empresa','empresa',.T.)
       endif
       if open_dbf('conta','conta',.T.)
       endif
       if open_dbf('tamanhos','tamanhos',.T.)
       endif
       if open_dbf('bordas','bordas',.T.)
       endif
       if open_dbf('coberturas','coberturas',.T.)
       endif
       if open_dbf('ccaixa','ccaixa',.T.)
          set index to (path_dbf)+'ccaixa.cdx'
       endif
       if open_dbf('clientes','clientes',.T.)
          set index to (path_dbf)+'clientes.cdx'
       endif
       if open_dbf('fornec','fornecedores',.T.)
          set index to (path_dbf)+'fornec.cdx'
       endif
       if open_dbf('gfornec','grupo_fornecedores',.T.)
          set index to (path_dbf)+'gfornec.cdx'
       endif
       if open_dbf('mprima','materia_prima',.T.)
          set index to (path_dbf)+'mprima.cdx'
       endif
       if open_dbf('catprod','categoria_produtos',.T.)
          set index to (path_dbf)+'catprod.cdx'
       endif
       if open_dbf('scatprod','subcategoria_produtos',.T.)
          set index to (path_dbf)+'scatprod.cdx'
       endif
       if open_dbf('mesas','mesas',.T.)
          set index to (path_dbf)+'mesas.cdx'
       endif
       if open_dbf('balcao','balcao',.T.)
          set index to (path_dbf)+'balcao.cdx'
       endif
       if open_dbf('delivery','delivery',.T.)
          set index to (path_dbf)+'delivery.cdx'
       endif
       if open_dbf('frecebe','formas_recebimento',.T.)
          set index to (path_dbf)+'frecebe.cdx'
       endif
       if open_dbf('fpaga','formas_pagamento',.T.)
          set index to (path_dbf)+'fpaga.cdx'
       endif
       if open_dbf('umedida','unidade_medida',.T.)
          set index to (path_dbf)+'umedida.cdx'
       endif
       if open_dbf('bancos','bancos',.T.)
          set index to (path_dbf)+'bancos.cdx'
       endif
       if open_dbf('impostos','impostos',.T.)
          set index to (path_dbf)+'impostos.cdx'
       endif
       if open_dbf('atende','atendentes',.T.)
          set index to (path_dbf)+'atende.cdx'
       endif
       if open_dbf('motent','motoboys',.T.)
          set index to (path_dbf)+'motent.cdx'
       endif
       if open_dbf('operador','operadores',.T.)
          set index to (path_dbf)+'operador.cdx'
       endif
       if open_dbf('libusu','acesso',.T.)
          set index to (path_dbf)+'libusu.cdx'
       endif
       if open_dbf('produtos','produtos',.T.)
          set index to (path_dbf)+'produtos.cdx'
       endif
       if open_dbf('cli_uc','ultimas_compras',.T.)
          set index to (path_dbf)+'cli_uc.cdx'
       endif
       if open_dbf('cli_dc','detalhamento_compras',.T.)
          set index to (path_dbf)+'cli_dc.cdx'
       endif
       if open_dbf('prodcomp','produto_composto',.T.)
          set index to (path_dbf)+'prodcomp.cdx'
       endif
       if open_dbf('caixa','caixa',.T.)
          set index to (path_dbf)+'caixa.cdx'
       endif
       if open_dbf('movban','movimento_bancario',.T.)
          set index to (path_dbf)+'movban.cdx'
       endif
       if open_dbf('cpag','contas_pagar',.T.)
          set index to (path_dbf)+'cpag.cdx'
       endif
       if open_dbf('crec','contas_receber',.T.)
          set index to (path_dbf)+'crec.cdx'
       endif
       if open_dbf('tmp_pza','temp_pizzas',.T.)
          set index to (path_dbf)+'tmp_pza.cdx'
       endif
       if open_dbf('tmp_prd','temp_produtos',.T.)
          set index to (path_dbf)+'tmp_prd.cdx'
       endif
       if open_dbf('tempro','temp_curva',.F.)
          zap
		  pack
          set index to (path_dbf)+'tempro.cdx'
       endif

        if l_demo
          if date() > _data_limite
             msgstop('O período de avaliação deste programa foi encerrado. Caso tenha gostado e deseje aquirir, por favor ligue para os telefones que estão na tela ou envie e-mail solicitando uma cópia definitiva, com direito a suporte e atualizações, ou então, para manifestar sua opinião, críticas e sugestões serão analisadas. Muito obrigado - equipe de desenvolvimento.','Atenção')
             form_main.release
          endif
       endif
       
       return(nil)
*-------------------------------------------------------------------------------
static function tamanhos_pizza()

       dbselectarea('tamanhos')
       tamanhos->(dbgotop())

       define window form_tamanhos;
              at 000,000;
              width 400;
              height 300;
              title 'Tamanhos de pizza';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              define label info_001
                     parent form_tamanhos
                     col 010
                     row 005
                     value 'Duplo clique ou ENTER altera'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _preto_001
                     transparent .T.
              end label
              define label info_002
                     parent form_tamanhos
                     col 010
                     row 025
                     value 'ESC fecha esta janela'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _vermelho_002
                     transparent .T.
              end label
              @ 005,290 button btn_sair;
                        parent form_tamanhos;
                        caption 'Sair';
                        action (define_nomes(),form_tamanhos.release);
                        width 100;
                        height 030

              @ 045,010 browse browse_tamanhos;
                        of form_tamanhos;
                        width 375;
                        height 210;
                        headers {'Tamanho','Nº pedaços'};
                        widths {200,120};
                        workarea tamanhos;
                        fields {'tamanhos->nome','tamanhos->pedacos'};
                        value 1;
                        font 'verdana';
                        size 010;
                        backcolor _amarelo_001;
                        fontcolor BLUE;
                        on dblclick altera_tamanho()

              on key escape action thiswindow.release

       end window

       form_tamanhos.center
       form_tamanhos.activate

       return(nil)
*-------------------------------------------------------------------------------
static function altera_tamanho()

       local x_nome    := ''
       local x_pedaco  := 0
       local x_sabores := 0
       
       define window form_altera_tamanho;
              at 000,000;
              width 200;
              height 160;
              title 'Alterar';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              x_nome    := tamanhos->nome
              x_pedaco  := tamanhos->pedacos

              @ 005,005 label lbl_001;
                        of form_altera_tamanho;
                        value 'Nome';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 025,005 textbox tbox_001;
                        of form_altera_tamanho;
                        height 027;
                        width 180;
                        value x_nome;
                        maxlength 015;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 055,005 label lbl_002;
                        of form_altera_tamanho;
                        value 'Nº pedaços';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 075,005 textbox tbox_002;
                        of form_altera_tamanho;
                        height 027;
                        width 100;
                        value x_pedaco;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric;
                        on lostfocus grava_tamanho()
                        
              on key escape action thiswindow.release
              
       end window
       
       form_altera_tamanho.center
       form_altera_tamanho.activate

       return(nil)
*-------------------------------------------------------------------------------
static function grava_tamanho()

       local x_nome   := form_altera_tamanho.tbox_001.value
       local x_pedaco := form_altera_tamanho.tbox_002.value

       dbselectarea('tamanhos')
       if lock_reg()
          tamanhos->nome    := x_nome
          tamanhos->pedacos := x_pedaco
          tamanhos->(dbcommit())
       endif

       form_altera_tamanho.release
       form_tamanhos.browse_tamanhos.refresh
       
       return(nil)
*-------------------------------------------------------------------------------
static function define_nomes()

       dbselectarea('tamanhos')
       tamanhos->(dbgotop())
       _tamanho_001 := tamanhos->nome
       _pedaco_001  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_002 := tamanhos->nome
       _pedaco_002  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_003 := tamanhos->nome
       _pedaco_003  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_004 := tamanhos->nome
       _pedaco_004  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_005 := tamanhos->nome
       _pedaco_005  := tamanhos->pedacos
       tamanhos->(dbskip())
       _tamanho_006 := tamanhos->nome
       _pedaco_006  := tamanhos->pedacos

       return(nil)
*-------------------------------------------------------------------------------
static function login()

	   define window form_login;
  				at 0,0;
            width 700;
    		  	height 500;
     	 	  	title 'Tela de Login';
      		icon 'icone';
       		modal;
        	  	noautorelease;
        	  	nosize;
        	  	nosysmenu

			define image img_loginlogo
	 			row 0
			 	col 0
 				height 347
			 	width 700
         			picture 'tela_login'
         			stretch .F.
	  		end image
		/*
 			digitar senha
		*/
          DEFINE LABEL Label_Senha
               COL 270
               ROW 365
               VALUE 'Digite a SENHA e tecle ENTER'
               AUTOSIZE .T.
               fontNAME 'calibri'
               fontSIZE 12
               fontBOLD .T.
               fontCOLOR GRAY
               TRANSPARENT .T.
          END LABEL
              @ 365,485 textbox tbox_senha;
                        of form_login;
                        height 27;
                        width 200;
                        value '';
                        maxlength 100;
                        font 'verdana' size 10;
                        backcolor WHITE;
                        fontcolor {0,0,0};
                        password
            /*
              	botão : acessar
    	      */
			  define buttonex button_acessar
						row form_login.height - 100
		   			col 485
						width 200
  						height 60
		   			picture 'login'
 		   			caption 'Acessar o programa'
  		   			action confirma_entrada()
   		   		vertical .F.
   		   		lefttext .F.
   		   		flat .F.
   		   		fontsize 10
   		   		fontbold .T.
   		   		fontcolor BLACK
			  end buttonex			  		
			  /*
			  	sair
			  */	
			  define buttonex button_sairlogin
						row form_login.height - 100
		   			col 5
						width 200
  						height 60
		   			picture 'exit'
 		   			caption 'Sair do programa'
  		   			action ( form_login.release, form_main.release )
   		   		vertical .F.
   		   		lefttext .F.
   		   		flat .F.
   		   		fontsize 10
   		   		fontbold .T.
   		   		fontcolor BLACK
			  end buttonex			  		

		end window
	
		form_login.center
		form_login.activate

      return(nil)
*-------------------------------------------------------------------------------
static function confirma_entrada()

       local x_senha := form_login.tbox_senha.value

       if empty(x_senha)
          msgalert('Senha não pode ser em branco','Atenção')
          form_login.tbox_senha.setfocus
          return(nil)
       endif
       
       dbselectarea('operadores')
       operadores->(ordsetfocus('senha'))
       operadores->(dbgotop())
       operadores->(dbseek(x_senha))

       if found()
          form_login.release
          form_main.show
          form_main.maximize
          _codigo_usuario_ := operadores->codigo
          _nome_usuario_   := operadores->nome
          dbselectarea('acesso')
          acesso->(ordsetfocus('operador'))
          acesso->(dbgotop())
          acesso->(dbseek(_codigo_usuario_))
          if found()
             _a_001 := acesso->acesso_001
             _a_002 := acesso->acesso_002
             _a_003 := acesso->acesso_003
             _a_004 := acesso->acesso_004
             _a_005 := acesso->acesso_005
             _a_006 := acesso->acesso_006
             _a_007 := acesso->acesso_007
             _a_008 := acesso->acesso_008
             _a_009 := acesso->acesso_009
             _a_010 := acesso->acesso_010
             _a_011 := acesso->acesso_011
             _a_012 := acesso->acesso_012
             _a_013 := acesso->acesso_013
             _a_014 := acesso->acesso_014
             _a_015 := acesso->acesso_015
             _a_016 := acesso->acesso_016
             _a_017 := acesso->acesso_017
             _a_018 := acesso->acesso_018
             _a_019 := acesso->acesso_019
             _a_020 := acesso->acesso_020
             _a_021 := acesso->acesso_021
             _a_022 := acesso->acesso_022
             _a_023 := acesso->acesso_023
             _a_024 := acesso->acesso_024
             _a_025 := acesso->acesso_025
             _a_026 := acesso->acesso_026
             _a_027 := acesso->acesso_027
             _a_028 := acesso->acesso_028
             _a_029 := acesso->acesso_029
             _a_030 := acesso->acesso_030
             _a_031 := acesso->acesso_031
             _a_032 := acesso->acesso_032
             _a_033 := acesso->acesso_033
             _a_034 := acesso->acesso_034
             _a_035 := acesso->acesso_035
             _a_036 := acesso->acesso_036
             _a_037 := acesso->acesso_037
             _a_038 := acesso->acesso_038
             _a_039 := acesso->acesso_039
             _a_040 := acesso->acesso_040
             _a_041 := acesso->acesso_041
             _a_042 := acesso->acesso_042
             _a_043 := acesso->acesso_043
          else
             _a_001 := .F.
             _a_002 := .F.
             _a_003 := .F.
             _a_004 := .F.
             _a_005 := .F.
             _a_006 := .F.
             _a_007 := .F.
             _a_008 := .F.
             _a_009 := .F.
             _a_010 := .F.
             _a_011 := .F.
             _a_012 := .F.
             _a_013 := .F.
             _a_014 := .F.
             _a_015 := .F.
             _a_016 := .F.
             _a_017 := .F.
             _a_018 := .F.
             _a_019 := .T.
             _a_020 := .F.
             _a_021 := .F.
             _a_022 := .F.
             _a_023 := .F.
             _a_024 := .F.
             _a_025 := .F.
             _a_026 := .F.
             _a_027 := .F.
             _a_028 := .F.
             _a_029 := .F.
             _a_030 := .F.
             _a_031 := .F.
             _a_032 := .F.
             _a_033 := .F.
             _a_034 := .F.
             _a_035 := .F.
             _a_036 := .F.
             _a_037 := .F.
             _a_038 := .F.
             _a_039 := .F.
             _a_040 := .F.
             _a_041 := .F.
             _a_042 := .F.
             _a_043 := .F.
          endif
          dbselectarea('empresa')
          empresa->(dbgotop())
          //setproperty('form_main','nome_cliente_001','value',alltrim(empresa->nome))
       else
          msgexclamation('Senha não confere','Atenção')
          form_login.tbox_senha.setfocus
          return(nil)
       endif

       return(nil)
*-------------------------------------------------------------------------------
static function libera(parametro)

       if !parametro
          return(.F.)
       endif

       return(.T.)
*-------------------------------------------------------------------------------
static function configurar_venda()

	   local x_tipo  := 0
	   local a_tipos := {'Calcular pelo MAIOR preço','Calcular pela MÉDIA de preços'}
	   
       dbselectarea('config')
       config->(dbgotop())
       x_tipo := config->tipo
       
	   define window form_configurar;
              at 000,000;
              width 400;
              height 270;
              title 'Configurar Venda de Pizza';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              define label info_001
                     parent form_configurar
                     col 010
                     row 005
                     value 'ESC fecha esta janela'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _vermelho_002
                     transparent .T.
              end label
              define label info_002
                     parent form_configurar
                     col 010
                     row 050
                     value 'Defina de que forma o programa deverá cobrar o valor'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _azul_002
                     transparent .T.
              end label
              define label info_003
                     parent form_configurar
                     col 010
                     row 070
                     value 'das pizzas vendidas, quando for selecionado mais  de'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _azul_002
                     transparent .T.
              end label
              define label info_004
                     parent form_configurar
                     col 010
                     row 090
                     value 'um sabor.'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _azul_002
                     transparent .T.
              end label
     		  define comboboxex cbo_tipo
         	  		 row 120
                     col 010
	              	 width 380
			         height 400
			         items a_tipos
			         value x_tipo
			         fontname 'courier new'
			         fontsize 12
			         fontcolor BLACK
         	  end comboboxex

              @ 005,290 button btn_sair;
                        parent form_configurar;
                        caption 'Sair';
                        action form_configurar.release;
                        width 100;
                        height 030
              @ 200,290 button btn_gravar;
                        parent form_configurar;
                        caption 'Gravar';
                        action gravar_config();
                        width 100;
                        height 030

              on key escape action thiswindow.release

       end window

       form_configurar.center
       form_configurar.activate

       return(nil)
*-------------------------------------------------------------------------------
static function gravar_config()

	   local x_tipo := form_configurar.cbo_tipo.value
	   
       dbselectarea('config')
       config->(dbgotop())
       replace tipo with x_tipo
       commit

       _tipo_cobranca := x_tipo
       
       form_configurar.release
       
   	   return(nil)
*-------------------------------------------------------------------------------
static function bordas_pizza()

       dbselectarea('bordas')
       tamanhos->(dbgotop())

       define window form_bordas;
              at 000,000;
              width 400;
              height 300;
              title 'Bordas de pizza';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              define label info_001
                     parent form_bordas
                     col 010
                     row 005
                     value 'Duplo clique ou ENTER altera'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _preto_001
                     transparent .T.
              end label
              define label info_002
                     parent form_bordas
                     col 010
                     row 025
                     value 'ESC fecha esta janela'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _vermelho_002
                     transparent .T.
              end label
              @ 005,290 button btn_sair;
                        parent form_bordas;
                        caption 'Sair';
                        action form_bordas.release;
                        width 100;
                        height 030

              @ 045,010 browse browse_bordas;
                        of form_bordas;
                        width 375;
                        height 210;
                        headers {'Descrição','Preço R$'};
                        widths {200,120};
                        workarea bordas;
                        fields {'bordas->nome',"trans(bordas->preco,'@E 999,999.99')"};
                        value 1;
                        font 'verdana';
                        size 010;
                        backcolor _amarelo_001;
                        fontcolor BLUE;
                        on dblclick altera_borda()

              on key escape action thiswindow.release

       end window

       form_bordas.center
       form_bordas.activate

       return(nil)
*-------------------------------------------------------------------------------
static function altera_borda()

       local x_nome  := space(15)
       local x_preco := 0

       define window form_altera_borda;
              at 000,000;
              width 200;
              height 160;
              title 'Alterar';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              x_nome  := bordas->nome
              x_preco := bordas->preco

              @ 005,005 label lbl_001;
                        of form_altera_borda;
                        value 'Descrição';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 025,005 textbox tbox_001;
                        of form_altera_borda;
                        height 027;
                        width 180;
                        value x_nome;
                        maxlength 015;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 055,005 label lbl_002;
                        of form_altera_borda;
                        value 'Preço R$';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 075,005 textbox tbox_002;
                        of form_altera_borda;
                        height 027;
                        width 100;
                        value x_preco;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric INPUTMASK "99,999.99";
                        on lostfocus grava_borda()

              on key escape action thiswindow.release

       end window

       form_altera_borda.center
       form_altera_borda.activate

       return(nil)
*-------------------------------------------------------------------------------
static function grava_borda()

       local x_nome  := form_altera_borda.tbox_001.value
       local x_preco := form_altera_borda.tbox_002.value

       dbselectarea('bordas')
       if lock_reg()
          bordas->nome  := x_nome
          bordas->preco := x_preco
          bordas->(dbcommit())
       endif

       form_altera_borda.release
       form_bordas.browse_bordas.refresh

       return(nil)
*-------------------------------------------------------------------------------
static function cobertura_pizza()

       dbselectarea('coberturas')
       tamanhos->(dbgotop())

       define window form_coberturas;
              at 000,000;
              width 400;
              height 300;
              title 'Cobertura Extra Pizzas';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              define label info_001
                     parent form_coberturas
                     col 010
                     row 005
                     value 'Duplo clique ou ENTER altera'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _preto_001
                     transparent .T.
              end label
              define label info_002
                     parent form_coberturas
                     col 010
                     row 025
                     value 'ESC fecha esta janela'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _vermelho_002
                     transparent .T.
              end label
              @ 005,290 button btn_sair;
                        parent form_coberturas;
                        caption 'Sair';
                        action form_coberturas.release;
                        width 100;
                        height 030

              @ 045,010 browse browse_coberturas;
                        of form_coberturas;
                        width 375;
                        height 210;
                        headers {'Descrição','Preço R$'};
                        widths {200,120};
                        workarea coberturas;
                        fields {'coberturas->nome',"trans(coberturas->preco,'@E 999,999.99')"};
                        value 1;
                        font 'verdana';
                        size 010;
                        backcolor _amarelo_001;
                        fontcolor BLUE;
                        on dblclick altera_cobertura()

              on key escape action thiswindow.release

       end window

       form_coberturas.center
       form_coberturas.activate

       return(nil)
*-------------------------------------------------------------------------------
static function altera_cobertura()

       local x_nome  := space(15)
       local x_preco := 0

       define window form_altera_cobertura;
              at 000,000;
              width 200;
              height 160;
              title 'Alterar';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              x_nome  := coberturas->nome
              x_preco := coberturas->preco

              @ 005,005 label lbl_001;
                        of form_altera_cobertura;
                        value 'Descrição';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 025,005 textbox tbox_001;
                        of form_altera_cobertura;
                        height 027;
                        width 180;
                        value x_nome;
                        maxlength 015;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 055,005 label lbl_002;
                        of form_altera_cobertura;
                        value 'Preço R$';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 075,005 textbox tbox_002;
                        of form_altera_cobertura;
                        height 027;
                        width 100;
                        value x_preco;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric INPUTMASK "99,999.99";
                        on lostfocus grava_cobertura()

              on key escape action thiswindow.release

       end window

       form_altera_cobertura.center
       form_altera_cobertura.activate

       return(nil)
*-------------------------------------------------------------------------------
static function grava_cobertura()

       local x_nome  := form_altera_cobertura.tbox_001.value
       local x_preco := form_altera_cobertura.tbox_002.value

       dbselectarea('coberturas')
       if lock_reg()
          coberturas->nome  := x_nome
          coberturas->preco := x_preco
          coberturas->(dbcommit())
       endif

       form_altera_cobertura.release
       form_coberturas.browse_coberturas.refresh

       return(nil)
*-------------------------------------------------------------------------------
static function abre_caixa()

	   local ultima_data
	   
       dbselectarea('ccaixa')
       ordsetfocus('data')
       ccaixa->(dbgobottom())
       ultima_data := ccaixa->data
       
       if ccaixa->situacao == 'A'
          msgalert('O Caixa já foi aberto em '+dtoc(ccaixa->data)+' as '+ccaixa->hora,'Atenção')
          return(nil)
       endif

       define window form_abre_caixa;
              at 000,000;
              width 400;
              height 300;
              title 'Abrir o Caixa';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              define label info_002
                     col 010
                     row 005
                     value 'ESC fecha esta janela'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _vermelho_002
                     transparent .T.
              end label
              @ 005,290 button btn_sair;
                        caption 'Sair';
                        action form_abre_caixa.release;
                        width 100;
                        height 030

              define label info_001
                     col 010
                     row 070
                     value 'Abrir o caixa do dia :'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _preto_001
                     transparent .T.
              end label
           	  @ 090,010 datepicker dp_data;
              			value date();
                        width 150;
                        height 030;
                        font 'verdana' size 014
              define label info_003
                     col 170
                     row 070
                     value 'Abrir o Caixa com R$ :'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _preto_001
                     transparent .T.
              end label
              @ 090,170 getbox tbox_valor;
                        height 030;
                        width 150;
                        value 0;
                        font 'verdana' size 012 bold;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'

              * linha separadora
              define label linha_rodape
                     col 000
                     row form_abre_caixa.height-090
                     value ''
                     width form_abre_caixa.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label

              * botões
              define buttonex button_ok
                     picture path_imagens+'img_gravar.bmp'
                     col form_abre_caixa.width-130
                     row form_abre_caixa.height-085
                     width 120
                     height 050
                     caption 'Ok, gravar'
                     action gravar_abertura_caixa()
                     fontbold .T.
                     flat .F.
                     noxpstyle .T.
              end buttonex

              on key escape action thiswindow.release

       end window

       form_abre_caixa.center
       form_abre_caixa.activate

       return(nil)
*-------------------------------------------------------------------------------
static function gravar_abertura_caixa()

	   *-publicar o numero do caixa para todos os lugares

	   local data  := form_abre_caixa.dp_data.value
	   local valor := form_abre_caixa.tbox_valor.value
       local x_id  := substr(alltrim(str(HB_RANDOM(0001240003,9999999999))),1,10)

       y_dia       :=day(data)
	   y_mes       :=month(data)
	   y_dia	   :=strzero(y_dia,2)
	   y_mes	   :=strzero(y_mes,2)

	   y_ncaixa    := y_dia+y_mes


       dbselectarea('ccaixa')
       ordsetfocus('data')
       ccaixa->(dbseek(dtos(data)))
       if found()
          msgalert('Já foi aberto/fechado Caixa nesse dia, tecle ENTER','Atenção')
          return(nil)
       else
       	  ccaixa->(dbappend())
       	  ccaixa->data     := data
       	  ccaixa->hora     := time()
       	  ccaixa->valor    := valor
       	  ccaixa->situacao := 'A'
          ccaixa->ncaixa   := y_ncaixa
       	  ccaixa->(dbcommit())
       	  dbselectarea('caixa')
       	  caixa->(dbappend())
          caixa->id        := x_id
          caixa->data      := data
          caixa->historico := 'ABERTURA DO CAIXA'
          caixa->entrada   := valor
          caixa->saida     := 0
          caixa->(dbcommit())
       	  msginfo('O Caixa está aberto, tecle ENTER','Mensagem')
       	  form_abre_caixa.release
       endif

	   return(nil)
*-------------------------------------------------------------------------------
static function fecha_caixa()

	   local ultima_data

       dbselectarea('ccaixa')
       ordsetfocus('data')
       ccaixa->(dbgobottom())
       ultima_data := ccaixa->data

       if ccaixa->situacao == 'F'
          msgalert('O Caixa do dia  '+dtoc(ccaixa->data)+' já está fechado','Atenção')
          return(nil)
       endif

       define window form_fecha_caixa;
              at 000,000;
              width 400;
              height 300;
              title 'Fechar o Caixa';
              icon path_imagens+'icone.ico';
              modal;
              nosize

              define label info_002
                     col 010
                     row 005
                     value 'ESC fecha esta janela'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _vermelho_002
                     transparent .T.
              end label
              @ 005,290 button btn_sair;
                        caption 'Sair';
                        action form_fecha_caixa.release;
                        width 100;
                        height 030

              define label info_003
                     col 010
                     row 070
                     value 'Valor da Retirada do Caixa R$ :'
                     autosize .T.
                     fontname 'tahoma'
                     fontsize 010
                     fontbold .T.
                     fontcolor _preto_001
                     transparent .T.
              end label
              @ 090,010 getbox tbox_valor;
                        height 030;
                        width 200;
                        value 0;
                        font 'verdana' size 012 bold;
                        backcolor _fundo_get;
                        fontcolor RED;
                        picture '@E 999,999.99'

              * linha separadora
              define label linha_rodape
                     col 000
                     row form_fecha_caixa.height-090
                     value ''
                     width form_fecha_caixa.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label

              * botões
              define buttonex button_ok
                     col form_fecha_caixa.width-310
                     row form_fecha_caixa.height-085
                     width 300
                     height 050
                     caption 'Clique AQUI para FECHAR o Caixa'
                     action gravar_fechamento_caixa()
                     fontbold .T.
                     fontname 'verdana'
                     fontsize 10
					 fontcolor WHITE
					 backcolor RED
                     flat .F.
                     noxpstyle .T.
              end buttonex

              on key escape action thiswindow.release

       end window

       form_fecha_caixa.center
       form_fecha_caixa.activate

       return(nil)
*-------------------------------------------------------------------------------
static function gravar_fechamento_caixa()

	   local data
	   
	   local valor := form_fecha_caixa.tbox_valor.value
       local x_id  := substr(alltrim(str(HB_RANDOM(0001240003,9999999999))),1,10)

	   if valor == 0
	      msgalert('Valor não pode ser zero, tecle ENTER','Atenção')
	      return(nil)
	   endif
	   
       dbselectarea('ccaixa')
       ccaixa->(dbgobottom())
       data := ccaixa->data
       if lock_reg()
	   	  ccaixa->situacao := 'F'
 	   	  ccaixa->(dbcommit())
          ccaixa->(dbunlock())
	   endif
  	   dbselectarea('caixa')
   	   caixa->(dbappend())
       caixa->id        := x_id
       caixa->data      := data
       caixa->historico := 'FECHAMENTO DO CAIXA'
       caixa->entrada   := 0
       caixa->saida     := valor
       caixa->(dbcommit())
   	   msginfo('O Caixa foi fechado, tecle ENTER','Mensagem')
   	   form_fecha_caixa.release

	   return(nil)
*-------------------------------------------------------------------------------
static function confere_caixa()

	   local ultima_data
	   local situacao

	   dbselectarea('ccaixa')
       ordsetfocus('data')
       ccaixa->(dbgobottom())
       ultima_data := ccaixa->data
       situacao    := ccaixa->situacao

	   if empty(ultima_data) .or. situacao == 'F'
	      msgalert('Não pode ser feita venda sem abrir o Caixa, tecle ENTER','Atenção')
	      return(nil)
	   else
		  vender()
	   endif

	   return(nil)
*-------------------------------------------------------------------------------
function retaguarda()

	DEFINE WINDOW Form_Retaguarda ;
		AT 0, 0 ;
  		WIDTH GetDesktopWidth() ;
    		HEIGHT GetDesktopHeight() ;
      	TITLE 'Retaguarda' ;
       	ICON 'sistema' ;
        	MODAL ;
        	NOCAPTION ;
        	NOSIZE ;
        	BACKCOLOR {216,216,216}
        	/*
        		wallpaper
    		*/
          DEFINE IMAGE Wallpaper
               ROW 0
               COL -2
               HEIGHT GetDesktopHeight()
               WIDTH GetDesktopWidth() + 4
               PICTURE 'fundo_retag'
               STRETCH .T.
          END IMAGE

          /*
          	cabeçalho : menus
         	*/
		DEFINE LABEL Barra_menus
			COL 0
   			ROW 0
      		VALUE ''
        		WIDTH GetDesktopWidth()
          	HEIGHT 50
   			BACKCOLOR WHITE
   			TRANSPARENT .F.
   			CENTERALIGN .F.
   			VCENTERALIGN .T.
		END LABEL
        	/*
        		logo do sistema
    		*/
          DEFINE IMAGE Logo_sistema
               ROW 7
               COL Form_Retaguarda.width - 130
               HEIGHT 35
               WIDTH 125
               PICTURE 'logosis'
               STRETCH .F.
          END IMAGE          		
		/*
		*/
		Menu_Tabelas()
		Menu_Relatorios()
		Menu_Financeiro()
		/*
			botões : metro style
		*/
		/*
			linha 1
		*/
		DEFINE BUTTONEX button_menu_10
  			ROW 80
		   	COL 10
 		   	WIDTH 300
  		   	HEIGHT 150
   		   	PICTURE 'op_001'
    		   	CAPTION 'CLIENTES'+CRLF+'Cadastro completo'
    		   	ACTION clientes()
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR WHITE 
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX
		DEFINE BUTTONEX button_menu_11
  			ROW 80
		   	COL 320
 		   	WIDTH 300
  		   	HEIGHT 150
   		   	PICTURE 'op_004'
    		   	CAPTION 'FORNECEDORES'+CRLF+'Cadastro completo'
    		   	ACTION fornecedores()
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR { 244, 244, 244 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX
		DEFINE BUTTONEX button_menu_12
  			ROW 80
		   	COL 630
 		   	WIDTH 145
  		   	HEIGHT 150
   		   	PICTURE 'op_012'
    		   	CAPTION 'ATENDENTES'+CRLF+'Garçons'
    		   	ACTION iif(libera(_a_017),atendentes(),msgexclamation('Este usuário não possui acesso','Mensagem'))
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR { 244, 244, 244 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX		
		DEFINE BUTTONEX button_menu_13
  			ROW 80
		   	COL 785
 		   	WIDTH 145
  		   	HEIGHT 150  
   		   	PICTURE 'op_013'
    		   	CAPTION 'MOTOBOYS'+CRLF+'Entregadores'
    		   	ACTION iif(libera(_a_018),motoboys_entregadores(),msgexclamation('Este usuário não possui acesso','Mensagem'))
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR { 244, 244, 244 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX		
		/*
			linha 2
		*/
		DEFINE BUTTONEX button_menu_20
  			ROW 240
		   	COL 10
 		   	WIDTH 300
  		   	HEIGHT 150
   		   	PICTURE 'op_002'
    		   	CAPTION 'PRODUTOS'+CRLF+'Cadastro, Estoque e Impostos'
    		   	ACTION produtos()
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR WHITE 
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX
		DEFINE BUTTONEX button_menu_21
  			ROW 240
		   	COL 320
 		   	WIDTH 300
  		   	HEIGHT 150
   		   	PICTURE 'op_005'
    		   	CAPTION 'EMPRESA'+CRLF+'Cadastro da minha empresa'
    		   	ACTION iif(libera(_a_040),empresa(),msgexclamation('Este usuário não possui acesso','Mensagem'))
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR { 244, 244, 244 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX
		DEFINE BUTTONEX button_menu_22
  			ROW 240
		   	COL 630   
 		   	WIDTH 145
  		   	HEIGHT 150
   		   	PICTURE 'op_009'
    		   	CAPTION 'USUÁRIOS'+CRLF+'Operadores'
    		   	ACTION iif(libera(_a_019),operadores(),msgexclamation('Este usuário não possui acesso','Mensagem'))
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR { 244, 244, 244 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX
		/*
			linha 3
		*/
		DEFINE BUTTONEX button_menu_30
  			ROW 400
		   	COL 10
 		   	WIDTH 300
  		   	HEIGHT 150
   		   	PICTURE 'op_003'
    		   	CAPTION 'COMPRAS'+CRLF+'Entrada de Produtos no Estoque'
    		   	ACTION compras()
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR WHITE //{ 232, 232, 232 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX
		DEFINE BUTTONEX button_menu_31
  			ROW 400
		   	COL 320
 		   	WIDTH 145
  		   	HEIGHT 150
   		   	PICTURE 'op_006'
    		   	CAPTION 'RECEBER'+CRLF+'Financeiro'
    		   	ACTION crec()
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR { 244, 244, 244 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX		
		DEFINE BUTTONEX button_menu_32
  			ROW 400
		   	COL 475
 		   	WIDTH 145
  		   	HEIGHT 150
   		   	PICTURE 'op_007'
    		   	CAPTION 'PAGAR'+CRLF+'Financeiro'
    		   	ACTION cpag()
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR { 244, 244, 244 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX		
		DEFINE BUTTONEX button_menu_33
  			ROW 400
		   	COL 630
 		   	WIDTH 145
  		   	HEIGHT 150
   		   	PICTURE 'op_010'
    		   	CAPTION 'CAIXA'+CRLF+'Financeiro'
    		   	ACTION caixa()
    		   	VERTICAL .T.
    		   	LEFTTEXT .F.
    		   	FLAT .F.
    		   	FONTSIZE 12
    		   	FONTBOLD .T.
    		   	FONTCOLOR BLACK
    		   	BACKCOLOR { 244, 244, 244 }
    		   	UPPERTEXT .F.
    		   	NOHOTLIGHT .F.
    		   	NOXPSTYLE .T.
		END BUTTONEX				
          /*
          	rodapé
         	*/
		DEFINE LABEL Rodape
			COL 0
   			ROW GetDesktopHeight() - 60
      		VALUE ''
        		WIDTH GetDesktopWidth()
          	HEIGHT 50
   			BACKCOLOR { 246, 152, 34 }
   			TRANSPARENT .F.
   			CENTERALIGN .F.
   			VCENTERALIGN .T.
		END LABEL
		/*
			texto : rodapé
		*/
      	@ GetDesktopHeight() - 55, 10 LABEL Label_rodape ;
			VALUE 'RETAGUARDA' AUTOSIZE FONT 'calibri' SIZE 20 BOLD FONTCOLOR BLACK TRANSPARENT		   			
          /*
               botão : voltar
          */
          DEFINE BUTTONEX Botao_voltar
               ROW GetDesktopHeight() - 55
               COL GetDesktopWidth() - 360
               WIDTH 350
               HEIGHT 40
               CAPTION 'Clique AQUI ou tecle ESC para VOLTAR'
               ACTION Form_Retaguarda.release
               VERTICAL .T.
               LEFTTEXT .F.
               FLAT .T.
               FONTSIZE 12
               FONTBOLD .T.
               FONTCOLOR WHITE
               BACKCOLOR { 246, 152, 34 }
               UPPERTEXT .F.
               NOHOTLIGHT .F.
               NOXPSTYLE .T.
          END BUTTONEX			
		/*
  			tecla ESC para sair da janela
		*/
		ON KEY ESCAPE ACTION Form_Retaguarda.Release

	END WINDOW
	
	Form_Retaguarda.Activate

	RETURN( Nil )
*-------------------------------------------------------------------------------
FUNCTION Menu_Tabelas()

	LOCAL nI, cItemName, HBtn1DropMenu, cFile, cAction

	@ 0, 5 IMAGE image_menu_1 PICTURE 'menu_tabelas' WIDTH 116 HEIGHT 50 ;
 		STRETCH TRANSPARENT BACKGROUNDCOLOR WHITE ;
 		ACTION { || ShowBtnDropMenu('Form_Retaguarda', This.Name, HBtn1DropMenu ) }

		DEFINE CONTEXT MENU CONTROL image_menu_1
         menuitem 'Fornecedores' action iif(libera(_a_006),fornecedores(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_fornecedores.bmp' font fonte_menu
         menuitem 'Grupo de Fornecedores' action iif(libera(_a_007),grupo_fornecedores(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_grupo_fornecedores.bmp' font fonte_menu
         separator
         menuitem 'Matéria Prima' action iif(libera(_a_008),materia_prima(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_materia_prima.bmp' font fonte_menu
         separator
         menuitem 'Categorias de Produtos' action iif(libera(_a_009),categoria_produtos(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_categorias.bmp' font fonte_menu
         menuitem 'Sub-Categorias de Produtos' action iif(libera(_a_010),subcategoria_produtos(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_subcategorias.bmp' font fonte_menu
         separator
         menuitem 'Formas de Recebimento' action iif(libera(_a_011),formas_recebimento(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_formas_recebimento.bmp' font fonte_menu
         menuitem 'Formas de Pagamento' action iif(libera(_a_012),formas_pagamento(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_formas_pagamento.bmp' font fonte_menu
         separator
         menuitem 'Unidades de Medida' action iif(libera(_a_013),unidades_medida(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_medidas.bmp' font fonte_menu
         menuitem 'Contas Bancárias' action iif(libera(_a_014),contas_bancarias(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_contas_bancarias.bmp' font fonte_menu
         menuitem 'Impostos e Alíquotas' action iif(libera(_a_015),impostos_aliquotas(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_impostos.bmp' font fonte_menu
         separator
         menuitem 'Mesas da Pizzaria' action iif(libera(_a_016),mesas(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'menu_mesa.bmp' font fonte_menu
         menuitem 'Balcão da Pizzaria' action balcao() image path_imagens+'menu_balcao.bmp' font fonte_menu
         menuitem 'Delivery da Pizzaria' action delivery() image path_imagens+'menu_delivery.bmp' font fonte_menu
         separator
         menuitem 'Atendentes ou Garçons' action iif(libera(_a_017),atendentes(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_atendentes.bmp' font fonte_menu
         menuitem 'Motoboys ou Entregadores' action iif(libera(_a_018),motoboys_entregadores(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_motoboys.bmp' font fonte_menu
         menuitem 'Operadores do Programa' action iif(libera(_a_019),operadores(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_operadores.bmp' font fonte_menu
		END MENU

	HBtn1DropMenu := _HMG_xContextMenuHandle
	SET CONTEXT MENU CONTROL image_menu_1 OF Form_Retaguarda OFF

	RETURN( Nil )
*-------------------------------------------------------------------------------
FUNCTION Menu_Relatorios()

	LOCAL nI, cItemName, HBtn2DropMenu, cFile, cAction

	@ 0, 131 IMAGE image_menu_2 PICTURE 'menu_relatorios' WIDTH 151 HEIGHT 50 ;
 		STRETCH TRANSPARENT BACKGROUNDCOLOR WHITE ;
 		ACTION { || ShowBtnDropMenu('Form_Retaguarda', This.Name, HBtn2DropMenu ) }

		DEFINE CONTEXT MENU CONTROL image_menu_2
         menuitem 'Fechamento do dia de trabalho' action iif(libera(_a_020),fechamento_dia(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         separator
         menuitem 'Movimentação do Caixa' action iif(libera(_a_021),movimentacao_caixa(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         menuitem 'Movimentação Bancária' action iif(libera(_a_022),movimentacao_bancaria(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         separator
         menuitem 'Contas a Pagar por período' action iif(libera(_a_023),relatorio_cpag_001(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         menuitem 'Contas a Pagar por fornecedor' action iif(libera(_a_024),relatorio_cpag_002(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         separator
         menuitem 'Contas a Receber por período' action iif(libera(_a_025),relatorio_crec_001(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         menuitem 'Contas a Receber por cliente' action iif(libera(_a_026),relatorio_crec_002(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         separator
         menuitem 'Pizzas mais vendidas' action iif(libera(_a_027),relatorio_pizza_001(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         menuitem 'Produtos mais vendidos' action iif(libera(_a_028),relatorio_produto_001(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         separator
         menuitem 'Relação estoque mínimo' action iif(libera(_a_029),relatorio_estoque_minimo(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         menuitem 'Posição do estoque (produtos)' action iif(libera(_a_030),posicao_estoque(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         menuitem 'Posição do estoque (matéria prima)' action iif(libera(_a_031),posicao_mprima(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         separator
         menuitem 'Comissão Motoboys/Entregadores' action iif(libera(_a_032),relatorio_motoboy(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
         menuitem 'Comissão Atendentes/Garçons' action iif(libera(_a_033),relatorio_garcon(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_relatorios.bmp' font fonte_menu
		END MENU

	HBtn2DropMenu := _HMG_xContextMenuHandle
	SET CONTEXT MENU CONTROL image_menu_2 OF Form_Retaguarda OFF

	RETURN( Nil )	
*-------------------------------------------------------------------------------
FUNCTION Menu_Financeiro()

	LOCAL nI, cItemName, HBtn3DropMenu, cFile, cAction

	@ 0, 292 IMAGE image_menu_3 PICTURE 'menu_financeiro' WIDTH 143 HEIGHT 50 ;
 		STRETCH TRANSPARENT BACKGROUNDCOLOR WHITE ;
 		ACTION { || ShowBtnDropMenu('Form_Retaguarda', This.Name, HBtn3DropMenu ) }

		DEFINE CONTEXT MENU CONTROL image_menu_3
         menuitem 'Movimentação do Caixa' action iif(libera(_a_034),caixa(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_mov_caixa.bmp' font fonte_menu
         menuitem 'Movimentação Bancária' action iif(libera(_a_035),movimento_bancario(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_mov_bancaria.bmp' font fonte_menu
         separator
         menuitem 'Compras / Entrada Estoque' action iif(libera(_a_036),compras(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_compras.bmp' font fonte_menu
         separator
         menuitem 'Contas a Pagar' action iif(libera(_a_037),cpag(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_pagar_receber.bmp' font fonte_menu
         menuitem 'Contas a Receber' action iif(libera(_a_038),crec(),msgexclamation('Este usuário não possui acesso','Mensagem')) image path_imagens+'img_pagar_receber.bmp' font fonte_menu
		END MENU

	HBtn3DropMenu := _HMG_xContextMenuHandle
	SET CONTEXT MENU CONTROL image_menu_3 OF Form_Retaguarda OFF

	RETURN( Nil )	
*-------------------------------------------------------------------------------
#pragma BEGINDUMP

#define HB_OS_WIN_32_USED
#define _WIN32_WINNT 0x0400
#include <windows.h>
#include "hbapi.h"

HB_FUNC (GETDESKTOPREALTOP)
{
	RECT rect;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

	hb_retni(rect.top);

}
HB_FUNC (GETDESKTOPREALLEFT)
{
	RECT rect;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

	hb_retni(rect.left);

}

HB_FUNC (GETDESKTOPREALWIDTH)
{
	RECT rect;
	SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

	hb_retni(rect.right - rect.left);

}

HB_FUNC (GETDESKTOPREALHEIGHT)
{
	RECT rect;
       SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

	hb_retni(rect.bottom - rect.top);
}

#pragma ENDDUMP