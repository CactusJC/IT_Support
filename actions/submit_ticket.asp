<%@ Language=VBScript %>
<!-- #include file="../common/db_conn.asp" -->
<%
Option Explicit

Dim contactNaam, email, afdeling, locatie, omschrijving
Dim sql, cmd, newTicketID

' --- 1. Check for POST request ---
If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    Response.Redirect "../new_ticket.asp?error=InvalidRequest"
    Response.End
End If

' --- 2. Retrieve and Validate Form Data ---
contactNaam  = Request.Form("contactNaam")
email        = Request.Form("email")
afdeling     = Request.Form("afdeling")
locatie      = Request.Form("locatie")
omschrijving = Request.Form("omschrijving")

If contactNaam = "" Or email = "" Or afdeling = "" Or locatie = "" Or omschrijving = "" Then
    Response.Redirect "../new_ticket.asp?error=MissingFields"
    Response.End
End If

' --- 3. Prepare and Execute SQL INSERT Statement ---
' Use ADODB.Command with parameters to prevent SQL injection
Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = conn

cmd.CommandText = "INSERT INTO Tickets (TypeAanvraag, Beschrijving, Status, DatumIngediend, Afdeling, Gebruiker, Contactpersoon, Locatie, Goedkeuringsstatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"

cmd.Parameters.Append cmd.CreateParameter("TypeAanvraag", 200, 1, 50, "Storing") ' adVarChar
cmd.Parameters.Append cmd.CreateParameter("Beschrijving", 201, 1, -1, omschrijving) ' adLongVarChar (Memo)
cmd.Parameters.Append cmd.CreateParameter("Status", 200, 1, 50, "Open")
cmd.Parameters.Append cmd.CreateParameter("DatumIngediend", 7, 1, -1, Now()) ' adDate
cmd.Parameters.Append cmd.CreateParameter("Afdeling", 200, 1, 100, afdeling)
cmd.Parameters.Append cmd.CreateParameter("Gebruiker", 200, 1, 100, contactNaam) ' Using contact name as the user for this ticket
cmd.Parameters.Append cmd.CreateParameter("Contactpersoon", 200, 1, 100, contactNaam & " (" & email & ")")
cmd.Parameters.Append cmd.CreateParameter("Locatie", 200, 1, 255, locatie)
cmd.Parameters.Append cmd.CreateParameter("Goedkeuringsstatus", 200, 1, 50, "Niet vereist")

' Execute the query
On Error Resume Next
cmd.Execute
If Err.Number <> 0 Then
    Response.Write "Er is een fout opgetreden bij het opslaan van het ticket: " & Err.Description
    ' In a real application, log this error
    conn.Close
    Set conn = Nothing
    Response.End
End If
On Error GoTo 0

' --- 4. Retrieve the new Ticket ID ---
' For JET database, SELECT @@IDENTITY retrieves the last inserted identity value.
Dim rs
Set rs = conn.Execute("SELECT @@IDENTITY AS NewID")
If Not rs.EOF Then
    newTicketID = rs("NewID")
Else
    newTicketID = "Onbekend" ' Fallback
End If
rs.Close
Set rs = Nothing

' --- 5. Redirect to Confirmation Page ---
Response.Redirect "../confirmation.asp?ticketID=" & newTicketID

%>
