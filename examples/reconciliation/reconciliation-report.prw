#include "Protheus.ch"
#include "TOTVS.ch"
#include "REPORT.ch"
#include "TBICONN.CH"

/*--------------------------------------------------------------------*
| Func:  ReconciliationReport()
| Autor: Eduardo Paranhos (clone educacional)
| Data:  10/08/2026
| Desc:  Relatorio de conciliacao entre sistemas — cruzamento de dados
|        integrados com base local para identificar divergencias
| Obs.:  Exemplo generico — tabelas e dados ficticios
*---------------------------------------------------------------------*/

User Function ReconciliationReport()

    Local oReport  := Nil
    Local oSection := Nil
    Local cPeriodo := Space(6)

    // Parametro de periodo
    cPeriodo := "202608" // Exemplo: AAAAMM

    Processa({|| BuildReconciliation(cPeriodo) }, "Gerando conciliacao...")

Return

Static Function BuildReconciliation(cPeriodo)

    Local oReport := TReport():New("Reconcile", "Conciliação de Dados", "RelConcilia", ;
                                   {|oReport| PrintReconciliation(oReport, cPeriodo)})

    oReport:SetLandscape()

    // Secao de cabecalho
    TReportSection():New(oReport, "Header", {}, {|oSec| ReconHeader(oSec, cPeriodo)})

    // Secao de detalhe
    TReportSection():New(oReport, "Detail", {"SE1"}, {|oSec| ReconDetail(oSec)})

    // Secao de totais
    TReportSection():New(oReport, "Total", {}, {|oSec| ReconTotal(oSec)})

    oReport:PrintDialog()

Return

Static Function ReconHeader(oSection, cPeriodo)

    TRCell():New(oSection, "Periodo: " + cPeriodo, "Title", 1, 1, 1, 4, 600, 30)
    TRCell():New(oSection, "Titulo", "Header", 3, 1, 1, 1, 150, 25):SetText("Título")
    TRCell():New(oSection, "Valor Local", "Header", 3, 2, 1, 1, 150, 25):SetText("Valor Local")
    TRCell():New(oSection, "Valor Integrado", "Header", 3, 3, 1, 1, 150, 25):SetText("Valor Integrado")
    TRCell():New(oSection, "Diferença", "Header", 3, 4, 1, 1, 150, 25):SetText("Diferença")

Return

Static Function ReconDetail(oSection)

    Local nLocal := 0.0
    Local nIntegrated := 0.0
    Local nDiff := 0.0

    // Simula dados (em producao, busca do banco)
    nLocal := SE1->E1_VALOR
    nIntegrated := nLocal + (Randomize(-100, 100) / 100) // Simula pequena diferenca
    nDiff := nLocal - nIntegrated

    If Abs(nDiff) > 0.01 // Mostra apenas divergencias
        TRCell():New(oSection, "Titulo", "Detail", oSection:nLine, 1, 1, 1, 150, 25):SetText(SE1->E1_NUM)
        TRCell():New(oSection, "Local", "Detail", oSection:nLine, 2, 1, 1, 150, 25):SetText(Transform(nLocal, "@E 999,999.99"))
        TRCell():New(oSection, "Integ", "Detail", oSection:nLine, 3, 1, 1, 150, 25):SetText(Transform(nIntegrated, "@E 999,999.99"))
        TRCell():New(oSection, "Diff", "Detail", oSection:nLine, 4, 1, 1, 150, 25):SetText(Transform(nDiff, "@E 999,999.99"))
    EndIf

Return

Static Function ReconTotal(oSection)
    TRCell():New(oSection, "Total", "Total", 1, 1, 1, 4, 600, 35):SetText("Fim do relatório de conciliação")
Return
