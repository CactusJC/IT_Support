<!-- #include file="common/header.asp" -->
<%
Dim ticketID
ticketID = Request.QueryString("ticketID")
%>
<div class="form-container">
    <div class="message success">
        <h2>Aanvraag succesvol ingediend!</h2>
        <% If ticketID <> "" AND IsNumeric(ticketID) Then %>
            <p>Uw aanvraag is geregistreerd onder ticketnummer: <strong>#<%= ticketID %></strong></p>
            <p>U ontvangt een bevestiging per e-mail. Bewaar dit nummer voor uw eigen administratie.</p>
        <% Else %>
            <p>Uw aanvraag is succesvol ontvangen. Er kon echter geen ticketnummer worden opgehaald. Neem contact op met de IT-afdeling voor assistentie.</p>
        <% End If %>
    </div>
    <a href="index.asp" class="btn">Terug naar de hoofdpagina</a>
</div>

<!-- #include file="common/footer.asp" -->
