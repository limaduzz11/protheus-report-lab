#include "Protheus.ch"
#include "TOTVS.ch"
#include "REPORT.ch"
#include "TBICONN.CH"

/*--------------------------------------------------------------------*
| Func:  MarginReport()
| Autor: Eduardo Paranhos (clone educacional)
| Data:  10/08/2026
| Desc:  Relatorio de Margem de Contribuicao por produto/grupo
|        Calcula receita - custo = margem, com percentuais
| Obs.:  Exemplo generico — dados ficticios
*---------------------------------------------------------------------*/

User Function MarginReport()

    Local cDe := Space(8)  // Data inicio
    Local cAte := Space(8) // Data fim

    cDe  := DtoS(Date() - 30)
    cAte := DtoS(Date())

    Processa({|| BuildMargin(cDe, cAte) }, "Calculando margem...")

Return

Static Function BuildMargin(cDe, cAte)

    Local oReport := TReport():New("Margin", "Margem de Contribuição", "RelMargem", ;
                                   {|oReport| PrintMargin(oReport, cDe, cAte)})

    oReport:SetLandscape()

    TReportSection():New(oReport, "Header", {}, {|oSec| MarginHeader(oSec, cDe, cAte)})
    TReportSection():New(oReport, "Group", {"SB1"}, {|oSec| MarginGroup(oSec)})
    TReportSection():New(oReport, "Detail", {"SB2"}, {|oSec| MarginDetail(oSec)})
    TReportSection():New(oReport, "Total", {}, {|oSec| MarginTotal(oSec)})

    oReport:PrintDialog()

Return

Static Function MarginHeader(oSection, cDe, cAte)

    TRCell():New(oSection, "Periodo: " + cDe + " a " + cAte, "Title", 1, 1, 1, 6, 700, 30)

    TRCell():New(oSection, "Produto", "Header", 3, 1, 1, 1, 150, 25):SetText("Produto")
    TRCell():New(oSection, "Receita", "Header", 3, 2, 1, 1, 120, 25):SetText("Receita R$")
    TRCell():New(oSection, "Custo", "Header", 3, 3, 1, 1, 120, 25):SetText("Custo R$")
    TRCell():New(oSection, "Margem", "Header", 3, 4, 1, 1, 120, 25):SetText("Margem R$")
    TRCell():New(oSection, "Margem%", "Header", 3, 5, 1, 1, 90, 25):SetText("Margem %")
    TRCell():New(oSection, "Qtd", "Header", 3, 6, 1, 1, 80, 25):SetText("Qtd")

Return

Static Function MarginGroup(oSection)
    TRCell():New(oSection, "Grupo", "Group", oSection:nLine, 1, 1, 6, 700, 30):SetText("Grupo: " + SB1->B1_GRUPO)
Return

Static Function MarginDetail(oSection)

    Local nRevenue := 0.0
    Local nCost := 0.0
    Local nMargin := 0.0
    Local nPct := 0.0

    nRevenue := SB2->B2_PRV1 * 10 // Preco * qtd simulada
    nCost := SB2->B2_CM1 * 10
    nMargin := nRevenue - nCost
    nPct := Iif(nRevenue > 0, (nMargin / nRevenue) * 100, 0)

    TRCell():New(oSection, "Prod", "Detail", oSection:nLine, 1, 1, 1, 150, 25):SetText(SB1->B1_DESC)
    TRCell():New(oSection, "Rec", "Detail", oSection:nLine, 2, 1, 1, 120, 25):SetText(Transform(nRevenue, "@E 999,999.99"))
    TRCell():New(oSection, "Cst", "Detail", oSection:nLine, 3, 1, 1, 120, 25):SetText(Transform(nCost, "@E 999,999.99"))
    TRCell():New(oSection, "Mar", "Detail", oSection:nLine, 4, 1, 1, 120, 25):SetText(Transform(nMargin, "@E 999,999.99"))
    TRCell():New(oSection, "Pct", "Detail", oSection:nLine, 5, 1, 1, 90, 25):SetText(Transform(nPct, "@E 999.9") + "%")
    TRCell():New(oSection, "Qtd", "Detail", oSection:nLine, 6, 1, 1, 80, 25):SetText("10")

Return

Static Function MarginTotal(oSection)
    TRCell():New(oSection, "Footer", "Total", 1, 1, 1, 6, 700, 30):SetText("Relatório de Margem de Contribuição — dados exemplificativos")
Return
