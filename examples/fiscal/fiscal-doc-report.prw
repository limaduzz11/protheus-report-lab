#include "Protheus.ch"
#include "TOTVS.ch"
#include "REPORT.ch"
#include "TBICONN.CH"

/*--------------------------------------------------------------------*
| Func:  FiscalDocReport()
| Autor: Eduardo Paranhos (clone educacional)
| Data:  10/08/2026
| Desc:  Relatorio de documentos fiscais com agrupamento por CFOP,
|        totais de ICMS, PIS, COFINS e valor contabil
| Obs.:  Exemplo generico — dados ficticios
*---------------------------------------------------------------------*/

User Function FiscalDocReport()

    Local cDe  := DtoS(Date() - 30)
    Local cAte := DtoS(Date())

    Processa({|| BuildFiscal(cDe, cAte) }, "Gerando relatorio fiscal...")

Return

Static Function BuildFiscal(cDe, cAte)

    Local oReport := TReport():New("Fiscal", "Documentos Fiscais", "RelFiscal", ;
                                   {|oReport| PrintFiscal(oReport, cDe, cAte)})

    oReport:SetLandscape()

    TReportSection():New(oReport, "Header", {}, {|oSec| FiscalHeader(oSec, cDe, cAte)})
    TReportSection():New(oReport, "CFOP", {"SF2"}, {|oSec| FiscalCFOP(oSec)})
    TReportSection():New(oReport, "Detail", {"SD2"}, {|oSec| FiscalDetail(oSec)})
    TReportSection():New(oReport, "Total", {}, {|oSec| FiscalTotal(oSec)})

    oReport:PrintDialog()

Return

Static Function FiscalHeader(oSection, cDe, cAte)
    TRCell():New(oSection, "Periodo Fiscal: " + cDe + " a " + cAte, "Title", 1, 1, 1, 8, 750, 30)

    TRCell():New(oSection, "NF", "Header", 3, 1, 1, 1, 80, 25):SetText("NF")
    TRCell():New(oSection, "Emissao", "Header", 3, 2, 1, 1, 80, 25):SetText("Emissão")
    TRCell():New(oSection, "CFOP", "Header", 3, 3, 1, 1, 60, 25):SetText("CFOP")
    TRCell():New(oSection, "Valor", "Header", 3, 4, 1, 1, 120, 25):SetText("Valor Contábil")
    TRCell():New(oSection, "ICMS", "Header", 3, 5, 1, 1, 100, 25):SetText("Base ICMS")
    TRCell():New(oSection, "PIS", "Header", 3, 6, 1, 1, 100, 25):SetText("PIS")
    TRCell():New(oSection, "COFINS", "Header", 3, 7, 1, 1, 100, 25):SetText("COFINS")
    TRCell():New(oSection, "Total", "Header", 3, 8, 1, 1, 110, 25):SetText("Total NF")

Return

Static Function FiscalCFOP(oSection)
    TRCell():New(oSection, "CFOP Grupo", "Group", oSection:nLine, 1, 1, 8, 750, 25):SetText("CFOP: " + SF2->F2_CFOP)
Return

Static Function FiscalDetail(oSection)

    Local nValor   := SF2->F2_VALBRUT
    Local nBaseICMS := nValor * 0.18
    Local nPIS     := nValor * 0.0165
    Local nCOFINS  := nValor * 0.076
    Local nTotal   := nValor + nPIS + nCOFINS

    TRCell():New(oSection, "NF", "Detail", oSection:nLine, 1, 1, 1, 80, 25):SetText(SF2->F2_DOC)
    TRCell():New(oSection, "Emissao", "Detail", oSection:nLine, 2, 1, 1, 80, 25):SetText(DtoC(SF2->F2_EMISSAO))
    TRCell():New(oSection, "CFOP", "Detail", oSection:nLine, 3, 1, 1, 60, 25):SetText(SF2->F2_CFOP)
    TRCell():New(oSection, "Valor", "Detail", oSection:nLine, 4, 1, 1, 120, 25):SetText(Transform(nValor, "@E 999,999.99"))
    TRCell():New(oSection, "ICMS", "Detail", oSection:nLine, 5, 1, 1, 100, 25):SetText(Transform(nBaseICMS, "@E 999,999.99"))
    TRCell():New(oSection, "PIS", "Detail", oSection:nLine, 6, 1, 1, 100, 25):SetText(Transform(nPIS, "@E 999,999.99"))
    TRCell():New(oSection, "COFINS", "Detail", oSection:nLine, 7, 1, 1, 100, 25):SetText(Transform(nCOFINS, "@E 999,999.99"))
    TRCell():New(oSection, "Total", "Detail", oSection:nLine, 8, 1, 1, 110, 25):SetText(Transform(nTotal, "@E 999,999.99"))

Return

Static Function FiscalTotal(oSection)
    TRCell():New(oSection, "Footer", "Total", 1, 1, 1, 8, 750, 30):SetText("Documento fiscal exemplificativo — dados fictícios")
Return
