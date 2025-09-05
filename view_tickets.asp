<!-- #include file="common/header.asp" -->

<h2>Lopende Tickets en Aanvragen</h2>

<%
' --- Logic to fetch tickets ---
Dim sql, rs, statusFilter, searchFilter
statusFilter = Request.QueryString("status")
searchFilter = Request.QueryString("search")

sql = "SELECT TicketID, TypeAanvraag, Beschrijving, Status, DatumIngediend, Gebruiker FROM Tickets"

' --- Build WHERE clause for filtering ---
Dim whereClause
whereClause = ""
If statusFilter <> "" AND statusFilter <> "all" Then
    whereClause = " WHERE Status = '" & SafeSQL(statusFilter) & "'"
End If

If searchFilter <> "" Then
    If whereClause = "" Then
        whereClause = " WHERE "
    Else
        whereClause = whereClause & " AND "
    End If
    whereClause = whereClause & "(Beschrijving LIKE '%" & SafeSQL(searchFilter) & "%' OR Gebruiker LIKE '%" & SafeSQL(searchFilter) & "%' OR TicketID LIKE '%" & SafeSQL(searchFilter) & "%')"
End If

sql = sql & whereClause & " ORDER BY DatumIngediend DESC"

Set rs = conn.Execute(sql)
%>

<div class="form-container">
    <h3>Filter en Zoek</h3>
    <form method="get" action="view_tickets.asp">
        <div style="display: flex; gap: 1rem; align-items: flex-end;">
            <div class="form-group" style="flex: 1;">
                <label for="search">Zoek op trefwoord of Ticket ID</label>
                <input type="text" name="search" id="search" value="<%= Server.HTMLEncode(searchFilter) %>">
            </div>
            <div class="form-group" style="flex: 1;">
                <label for="status">Filter op Status</label>
                <select name="status" id="status">
                    <option value="all" <% If statusFilter = "all" or statusFilter = "" Then Response.Write "selected" End If %>>Alle Statussen</option>
                    <option value="Open" <% If statusFilter = "Open" Then Response.Write "selected" End If %>>Open</option>
                    <option value="In behandeling" <% If statusFilter = "In behandeling" Then Response.Write "selected" End If %>>In behandeling</option>
                    <option value="Goedgekeurd" <% If statusFilter = "Goedgekeurd" Then Response.Write "selected" End If %>>Goedgekeurd</option>
                    <option value="Afgewezen" <% If statusFilter = "Afgewezen" Then Response.Write "selected" End If %>>Afgewezen</option>
                    <option value="Afgerond" <% If statusFilter = "Afgerond" Then Response.Write "selected" End If %>>Afgerond</option>
                </select>
            </div>
            <button type="submit" class="btn">Filter</button>
        </div>
    </form>

    <table class="ticket-table">
        <thead>
            <tr>
                <th>Ticket ID</th>
                <th>Type</th>
                <th>Onderwerp</th>
                <th>Gebruiker</th>
                <th>Ingediend Op</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <% If rs.EOF Then %>
                <tr>
                    <td colspan="6" style="text-align: center;">Geen tickets gevonden die voldoen aan de criteria.</td>
                </tr>
            <% Else %>
                <% While Not rs.EOF %>
                    <tr>
                        <td><a href="ticket_detail.asp?id=<%= rs("TicketID") %>">#<%= rs("TicketID") %></a></td>
                        <td><%= Server.HTMLEncode(rs("TypeAanvraag")) %></td>
                        <td>
                            <%
                            Dim shortDesc
                            shortDesc = Left(rs("Beschrijving"), 70)
                            If Len(rs("Beschrijving")) > 70 Then shortDesc = shortDesc & "..."
                            Response.Write(Server.HTMLEncode(shortDesc))
                            %>
                        </td>
                        <td><%= Server.HTMLEncode(rs("Gebruiker")) %></td>
                        <td><%= FormatDateTime(rs("DatumIngediend"), 2) %></td>
                        <td><span class="status status-<%= Replace(rs("Status"), " ", "-") %>"><%= Server.HTMLEncode(rs("Status")) %></span></td>
                    </tr>
                <%
                rs.MoveNext
                Wend
                %>
            <% End If %>
        </tbody>
    </table>
</div>

<%
rs.Close
Set rs = Nothing
%>

<!-- #include file="common/footer.asp" -->
