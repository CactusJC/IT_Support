<!-- #include file="common/header.asp" -->

<h2>Ticket Details</h2>

<%
Dim ticketID, rsTicket, rsHardware, sql
ticketID = Request.QueryString("id")

If ticketID = "" Or Not IsNumeric(ticketID) Then
    Response.Write "<div class='message error'>Ongeldig Ticket ID.</div>"
    Response.End
End If

' --- Fetch main ticket data ---
Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = conn
cmd.CommandText = "SELECT * FROM Tickets WHERE TicketID = ?"
cmd.Parameters.Append cmd.CreateParameter("TicketID", 3, 1, , CLng(ticketID)) ' adInteger
Set rsTicket = cmd.Execute

If rsTicket.EOF Then
    Response.Write "<div class='message error'>Ticket niet gevonden.</div>"
    Response.End
End If

' --- Fetch hardware request data if applicable ---
If rsTicket("TypeAanvraag") = "Hardware/Software" Then
    Set cmd = Server.CreateObject("ADODB.Command")
    Set cmd.ActiveConnection = conn
    cmd.CommandText = "SELECT * FROM HardwareRequests WHERE TicketID = ?"
    cmd.Parameters.Append cmd.CreateParameter("TicketID", 3, 1, , CLng(ticketID)) ' adInteger
    Set rsHardware = cmd.Execute
End If

%>

<div class="form-container">
    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
        <h2>Details voor Ticket #<%= ticketID %></h2>
        <span class="status status-<%= Replace(rsTicket("Status"), " ", "-") %>"><%= Server.HTMLEncode(rsTicket("Status")) %></span>
    </div>

    <h4>Algemene Informatie</h4>
    <table class="ticket-table">
        <tr><th>Type Aanvraag</th><td><%= Server.HTMLEncode(rsTicket("TypeAanvraag")) %></td></tr>
        <tr><th>Onderwerp/Beschrijving</th><td><%= Server.HTMLEncode(rsTicket("Beschrijving")) %></td></tr>
        <tr><th>Inediend op</th><td><%= rsTicket("DatumIngediend") %></td></tr>
        <tr><th>Afdeling</th><td><%= Server.HTMLEncode(rsTicket("Afdeling")) %></td></tr>
        <tr><th>Aangevraagd voor</th><td><%= Server.HTMLEncode(rsTicket("Gebruiker")) %></td></tr>
        <tr><th>Contactpersoon</th><td><%= Server.HTMLEncode(rsTicket("Contactpersoon")) %></td></tr>
        <tr><th>Locatie</th><td><%= Server.HTMLEncode(rsTicket("Locatie")) %></td></tr>
        <tr><th>Goedkeuringsstatus</th><td><strong><%= Server.HTMLEncode(rsTicket("Goedkeuringsstatus")) %></strong></td></tr>
    </table>

    <% ' --- Display hardware details if they exist ---
    If Not (rsHardware Is Nothing) Then
        If Not rsHardware.EOF Then
    %>
        <h4 style="margin-top: 2rem;">Details Hardware-aanvraag</h4>
        <table class="ticket-table">
            <tr><th>Product Categorie</th><td><%= Server.HTMLEncode(rsHardware("ProductCategorie")) %></td></tr>
            <tr><th>Product Type/Keuze</th><td><%= Server.HTMLEncode(rsHardware("ProductType")) %></td></tr>
            <tr><th>Motivatie</th><td><%= Server.HTMLEncode(rsHardware("Motivatie")) %></td></tr>
            <tr><th>Kostenindicatie</th><td><%= FormatCurrency(rsHardware("KostenIndicatie")) %></td></tr>
        </table>
    <%
        End If
        rsHardware.Close
        Set rsHardware = Nothing
    End If
    %>

    <hr style="margin: 2rem 0;">

    <h4>Status Aanpassen</h4>
    <form action="actions/update_ticket_status.asp" method="post">
        <input type="hidden" name="ticketID" value="<%= ticketID %>">
        <div style="display: flex; gap: 1rem; align-items: flex-end;">
            <div class="form-group" style="flex: 1;">
                <label for="new_status">Nieuwe Ticket Status</label>
                <select name="new_status" id="new_status" class="form-control">
                    <option value="Open" <% If rsTicket("Status")="Open" Then Response.Write "selected" %>>Open</option>
                    <option value="In behandeling" <% If rsTicket("Status")="In behandeling" Then Response.Write "selected" %>>In behandeling</option>
                    <option value="Afgerond" <% If rsTicket("Status")="Afgerond" Then Response.Write "selected" %>>Afgerond</option>
                </select>
            </div>
            <div class="form-group" style="flex: 1;">
                <label for="new_approval_status">Nieuwe Goedkeuringsstatus</label>
                <select name="new_approval_status" id="new_approval_status" class="form-control">
                    <option value="Nieuw" <% If rsTicket("Goedkeuringsstatus")="Nieuw" Then Response.Write "selected" %>>Nieuw</option>
                    <option value="Goedgekeurd" <% If rsTicket("Goedkeuringsstatus")="Goedgekeurd" Then Response.Write "selected" %>>Goedgekeurd</option>
                    <option value="Afgewezen" <% If rsTicket("Goedkeuringsstatus")="Afgewezen" Then Response.Write "selected" %>>Afgewezen</option>
                    <option value="Niet vereist" <% If rsTicket("Goedkeuringsstatus")="Niet vereist" Then Response.Write "selected" %>>Niet vereist</option>
                </select>
            </div>
            <button type="submit" class="btn">Update Status</button>
        </div>
    </form>
</div>

<%
rsTicket.Close
Set rsTicket = Nothing
%>

<!-- #include file="common/footer.asp" -->
