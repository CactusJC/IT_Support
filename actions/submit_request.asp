<%@ Language=VBScript %>
<!-- #include file="../common/db_conn.asp" -->
<%
Option Explicit

' --- 1. Check for POST request ---
If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    Response.Redirect "../new_request.asp?error=InvalidRequest"
    Response.End
End If

' --- 2. Retrieve and Validate Form Data ---
Dim contactNaam, email, gebruiker, afdeling, locatie, productCategorie, productType, motivatie
contactNaam      = Request.Form("contactNaam")
email            = Request.Form("email")
gebruiker        = Request.Form("gebruiker")
afdeling         = Request.Form("afdeling")
locatie          = Request.Form("locatie")
productCategorie = Request.Form("productCategorie")
productType      = Request.Form("productType")
motivatie        = Request.Form("motivatie")

' Basic validation
If contactNaam = "" Or email = "" Or gebruiker = "" Or afdeling = "" Or locatie = "" Or productCategorie = "" Or productType = "" Or motivatie = "" Then
    Response.Redirect "../new_request.asp?error=MissingFields"
    Response.End
End If


' --- 3. Create the main ticket record in the 'Tickets' table ---
Dim cmd, ticketBeschrijving, newTicketID

' Create a short description for the main ticket
ticketBeschrijving = "Aanvraag voor: " & productCategorie & " - " & productType

Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = conn
cmd.CommandText = "INSERT INTO Tickets (TypeAanvraag, Beschrijving, Status, DatumIngediend, Afdeling, Gebruiker, Contactpersoon, Locatie, Goedkeuringsstatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"

cmd.Parameters.Append cmd.CreateParameter("TypeAanvraag", 200, 1, 50, "Hardware/Software")
cmd.Parameters.Append cmd.CreateParameter("Beschrijving", 201, 1, -1, ticketBeschrijving)
cmd.Parameters.Append cmd.CreateParameter("Status", 200, 1, 50, "Nieuw") ' Requests start as 'Nieuw'
cmd.Parameters.Append cmd.CreateParameter("DatumIngediend", 7, 1, -1, Now())
cmd.Parameters.Append cmd.CreateParameter("Afdeling", 200, 1, 100, afdeling)
cmd.Parameters.Append cmd.CreateParameter("Gebruiker", 200, 1, 100, gebruiker)
cmd.Parameters.Append cmd.CreateParameter("Contactpersoon", 200, 1, 100, contactNaam & " (" & email & ")")
cmd.Parameters.Append cmd.CreateParameter("Locatie", 200, 1, 255, locatie)
cmd.Parameters.Append cmd.CreateParameter("Goedkeuringsstatus", 200, 1, 50, "Nieuw") ' Needs approval

On Error Resume Next
cmd.Execute
If Err.Number <> 0 Then
    Response.Write "Fout bij aanmaken van hoofd-ticket: " & Err.Description
    Response.End
End If
On Error GoTo 0


' --- 4. Retrieve the new Ticket ID ---
Dim rs
Set rs = conn.Execute("SELECT @@IDENTITY AS NewID")
If Not rs.EOF Then
    newTicketID = rs("NewID")
Else
    Response.Write "Kritieke fout: kon de nieuwe TicketID niet ophalen."
    Response.End
End If
rs.Close
Set rs = Nothing


' --- 5. Extract Cost and Insert into 'HardwareRequests' table ---
Dim kostenIndicatie, cleanProductType
kostenIndicatie = 0 ' Default to 0
cleanProductType = productType

' Simple function to parse cost from string like "Laptop (€1.600)"
If InStr(productType, "(€") > 0 Then
    Dim priceStr, startPos, endPos
    startPos = InStr(productType, "€") + 1
    endPos = InStr(productType, ")")
    priceStr = Mid(productType, startPos, endPos - startPos)
    priceStr = Replace(priceStr, ".", "") ' For thousands separator
    priceStr = Replace(priceStr, ",", ".") ' For decimal
    If IsNumeric(priceStr) Then
        kostenIndicatie = CCur(priceStr)
    End If
End If

Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = conn
cmd.CommandText = "INSERT INTO HardwareRequests (TicketID, ProductCategorie, ProductType, Motivatie, KostenIndicatie) VALUES (?, ?, ?, ?, ?)"

cmd.Parameters.Append cmd.CreateParameter("TicketID", 3, 1, -1, newTicketID) ' adInteger
cmd.Parameters.Append cmd.CreateParameter("ProductCategorie", 200, 1, 100, productCategorie)
cmd.Parameters.Append cmd.CreateParameter("ProductType", 200, 1, 100, cleanProductType)
cmd.Parameters.Append cmd.CreateParameter("Motivatie", 201, 1, -1, motivatie)
cmd.Parameters.Append cmd.CreateParameter("KostenIndicatie", 6, 1, -1, kostenIndicatie) ' adCurrency

On Error Resume Next
cmd.Execute
If Err.Number <> 0 Then
    ' Ideally, you would delete the previously created ticket here for consistency
    Response.Write "Fout bij opslaan van hardware details: " & Err.Description
    Response.End
End If
On Error GoTo 0


' --- 6. Redirect to Confirmation Page ---
Response.Redirect "../confirmation.asp?ticketID=" & newTicketID

%>
