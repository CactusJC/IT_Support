</div> <!-- End .content -->
    <div class="footer">
        <p>IT Department - Voor support, neem contact op via de portal.</p>
    </div>
</body>
</html>
<%
' Close the database connection
If IsObject(conn) Then
    If conn.State = 1 Then ' adStateOpen
        conn.Close
    End If
    Set conn = Nothing
End If
%>
