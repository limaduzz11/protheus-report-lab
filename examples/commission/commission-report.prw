#include "Protheus.ch"
#include "TOTVS.ch"
#include "REPORT.ch"
#include "TBICONN.CH"

/*--------------------------------------------------------------------*
| Func:  CommissionReport()
| Autor: Eduardo Paranhos (clone educacional)
| Data:  10/08/2026
| Desc:  Relatorio de comissao de vendas por representante
|        Agrupa por vendedor, exibe base de calculo e comissao
| Obs.:  Exemplo generico — dados ficticios
*---------------------------------------------------------------------*/

User Function CommissionReport()

    Local cDe  := DtoS(Date() - 30)
    Local cAte := DtoS(Date())

    Processa({|| BuildCommission(cDe, cAte) }, "Calculando comissoes...")

Return

Static Function BuildCommission(cDe, cAte)

    Local oReport := TReport():New("Comm", "Comissão de Vendas", "RelComissao", ;
                                   {|oReport| PrintCommission(oReport, cDe, cAte)})

    oReport:SetLandscape()

    TReportSection():New(oReport, "Header", {}, {|oSec| CommHeader(oSec, cDe, cAte)})
    TReportSection():New(oReport, "Vendor", {"SA3"}, {|oSec| CommVendor(oSec)})
    TReportSection():New(oReport, "Detail", {"SF2"}, {|oSec| CommDetail(oSec)})
    TReportSection():New(oReport, "SubTotal", {}, {|oSec| CommSubTotal(oSec)})
    TReportSection():New(oReport, "GrandTotal", {}, {|oSec| CommGrandTotal(oSec)})

    oReport:PrintDialog()

Return

Static Function CommHeader(oSection, cDe, cAte)
    TRCell():New(oSection, "Comissao: " + cDe + " a " + cAte, "Title", 1, 1, 1, 6, 700, 30)

    TRCell():New(oSection, "NF", "Header", 2, 1, 1, 1, 80, 25):SetText("NF")
    TRCell():New(oSection, "Cliente", "Header", 2, 2, 1, 1, 200, 25):SetText("Cliente")
    TRCell():New(oSection, "Valor", "Header", 2, 3, 1, 1, 120, 25):SetText("Valor Venda")
    TRCell():New(oSection, "%", "Header", 2, 4, 1, 1, 60, 25):SetText("% Com")
    TRCell():New(oSection, "Comissao", "Header", 2, 5, 1, 1, 120, 25):SetText("Comissão")
    TRCell():New(oSection, "Status", "Header", 2, 6, 1, 1, 100, 25):SetText("Status")

Return

Static Function CommVendor(oSection)
    TRCell():New(oSection, "Vendedor", "Group", oSection:nLine, 1, 1, 6, 700, 30):SetText("Vendedor: " + SA3->A3_NOME + " (" + SA3->A3_COD + ")")
Return

Static Function CommDetail(oSection)

    Local nSaleValue := SF2->F2_VALBRUT
    Local nPct := 3.5 // Percentual de comissao fixo (exemplo)
    Local nComm := nSaleValue * (nPct / 100)
    Local cStatus := Iif(SF2->F2_VALBRUT > 0, "A pagar", "Zerado")

    TRCell():New(oSection, "NF", "Detail", oSection:nLine, 1, 1, 1, 80, 25):SetText(SF2->F2_DOC)
    TRCell():New(oSection, "Cliente", "Detail", oSection:nLine, 2, 1, 1, 200, 25):SetText(SA1->A1_NOME)
    TRCell():New(oSection, "Vlr", "Detail", oSection:nLine, 3, 1, 1, 120, 25):SetText(Transform(nSaleValue, "@E 999,999.99"))
    TRCell():New(oSection, "Pct", "Detail", oSection:nLine, 4, 1, 1, 60, 25):SetText(Transform(nPct, "@E 99.9") + "%")
    TRCell():New(oSection, "Comm", "Detail", oSection:nLine, 5, 1, 1, 120, 25):SetText(Transform(nComm, "@E 999,999.99"))
    TRCell():New(oSection, "St", "Detail", oSection:nLine, 6, 1, 1, 100, 25):SetText(cStatus)

Return

Static Function CommSubTotal(oSection)
    TRCell():New(oSection, "Sub", "SubTotal", oSection:nLine, 1, 1, 6, 700, 28):SetText("--- Subtotal do vendedor ---")
Return

Static Function CommGrandTotal(oSection)
    TRCell():New(oSection, "Footer", "GrandTotal", 1, 1, 1, 6, 700, 35):SetText("Relatório de Comissão — dados exemplificativos")
Return
