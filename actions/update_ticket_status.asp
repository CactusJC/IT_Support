<%@ Language=VBScript %>
<!-- #include file="../common/db_conn.asp" -->
<%
Option Explicit

' --- 1. Check for POST request ---
If Request.ServerVariables("REQUEST_METHOD") <> "POST" Then
    Response.Redirect "../view_tickets.asp?error=InvalidRequest"
    Response.End
End If

' --- 2. Retrieve and Validate Form Data ---
Dim ticketID, newStatus, newApprovalStatus
ticketID = Request.Form("ticketID")
newStatus = Request.Form("new_status")
newApprovalStatus = Request.Form("new_approval_status")

If ticketID = "" Or Not IsNumeric(ticketID) Or newStatus = "" Or newApprovalStatus = "" Then
    Response.Redirect "../view_tickets.asp?error=MissingData"
    Response.End
End If

' --- 3. Prepare and Execute SQL UPDATE Statement ---
Dim cmd, sql
Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = conn

' Base SQL statement
sql = "UPDATE Tickets SET Status = ?, Goedkeuringsstatus = ?"

' Add DatumAfgehandeld if status is 'Afgerond'
If newStatus = "Afgerond" Then
    sql = sql & ", DatumAfgehandeld = ?"
End If

sql = sql & " WHERE TicketID = ?"

cmd.CommandText = sql

' Append parameters IN ORDER
cmd.Parameters.Append cmd.CreateParameter("Status", 200, 1, 50, newStatus)
cmd.Parameters.Append cmd.CreateParameter("Goedkeuringsstatus", 200, 1, 50, newApprovalStatus)

If newStatus = "Afgerond" Then
    cmd.Parameters.Append cmd.CreateParameter("DatumAfgehandeld", 7, 1, , Now()) ' adDate
End If

cmd.Parameters.Append cmd.CreateParameter("TicketID", 3, 1, , CLng(ticketID)) ' adInteger

' Execute the query
On Error Resume Next
cmd.Execute
If Err.Number <> 0 Then
    Response.Write "Er is een fout opgetreden bij het updaten van het ticket: " & Err.Description
    Response.End
End If
On Error GoTo 0

' --- 4. Redirect back to the detail page ---
Response.Redirect "../ticket_detail.asp?id=" & ticketID & "&success=updated"

%>
